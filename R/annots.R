
#' @title Make genomic annotations from a GTF file
#' @description
#' Make genomic annotations (genes, exons, introns, UTRs, promoters)
#' from a GTF file.
#'
#' @param gtf_file Path to the GTF file
#' @param promoter.dist Bases (default: 2000) upstream of transcription start site as promoter regions
#' @import GenomicRanges
#' @return A list of GRanges objects of genomic annotations
#' @export
make_genomic_annots <- function(gtf_file,
                                promoter.dist = 2000L) {

  cat('Loading gtf file ...\n')
  gtf.gr <- rtracklayer::import(con = gtf_file, format = 'gtf')
  GenomeInfoDb::seqlevels(gtf.gr, pruning.mode = 'coarse') <- paste0('chr',1:22)

  # Keep only protein coding genes
  cat('Keep only protein coding genes ...\n')
  gtf.protein.coding.gr <- gtf.gr[which(gtf.gr$gene_type=='protein_coding'),]
  genes.gr <- gtf.protein.coding.gr[gtf.protein.coding.gr$type=='gene',]

  cat('Keep only canonical transcripts ...\n')
  canonical.transcripts <- gtf.protein.coding.gr %>%
    tibble::as_tibble() %>%
    dplyr::filter(type == 'transcript') %>%
    dplyr::group_by(gene_id) %>%
    dplyr::mutate(transLength = abs(end - start)) %>%
    dplyr::arrange(-transLength) %>%
    dplyr::slice(1)

  # keep only canonical transcripts
  gtf.canonical.gr <- gtf.protein.coding.gr[gtf.protein.coding.gr$transcript_id %in% canonical.transcripts$transcript_id,]
  exons.gr <- gtf.canonical.gr[gtf.canonical.gr$type=='exon',]
  UTRs.gr <- gtf.canonical.gr[gtf.canonical.gr$type=='UTR',]

  # get introns
  introns.gr <- GenomicRanges::setdiff(genes.gr, exons.gr)
  introns.gene.overlap <- GenomicRanges::findOverlaps(genes.gr, introns.gr)
  introns.gr <- introns.gr[subjectHits(introns.gene.overlap),]
  introns.gr$gene_name <- genes.gr$gene_name[queryHits(introns.gene.overlap)]

  # get promoters
  genes.plus.gr <- genes.gr[strand(genes.gr)=='+',]
  genes.neg.gr <- genes.gr[strand(genes.gr)=='-',]
  promoters.plus.gr <- GRanges(seqnames(genes.plus.gr),
                               ranges = IRanges(start = start(genes.plus.gr) - promoter.dist,
                                                end = start(genes.plus.gr)),
                               strand = strand(genes.plus.gr))
  promoters.neg.gr <- GRanges(seqnames(genes.neg.gr),
                              ranges = IRanges(start = end(genes.neg.gr),
                                               end = end(genes.neg.gr) + promoter.dist),
                              strand = strand(genes.neg.gr))
  promoters.gr <- c(promoters.plus.gr, promoters.neg.gr)
  promoters.gr$gene_name <- c(genes.plus.gr$gene_name, genes.neg.gr$gene_name)

  genomic.annots <- list(
    exons = exons.gr,
    introns = introns.gr,
    UTRs = UTRs.gr,
    promoters = promoters.gr,
    genes = genes.gr
  )

  return(genomic.annots)
}
