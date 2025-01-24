% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/harmonization.R
\name{harmonize_sumstats_LD}
\alias{harmonize_sumstats_LD}
\title{Harmonize GWAS summary statistics with LD reference}
\usage{
harmonize_sumstats_LD(
  sumstats,
  LD_snp_info,
  strand_flip = TRUE,
  remove_strand_ambig = TRUE
)
}
\arguments{
\item{sumstats}{A data frame of GWAS summary statistics,
including columns "snp" (SNP ID), a0" (reference allele), "a1" (effect allele), "beta", and "zscore".}

\item{LD_snp_info}{a data frame, SNP info for LD reference,
with columns "chrom", "id", "pos", "alt", "ref", "locus" (optional)}

\item{strand_flip}{Whether to flip signs when reverse complement matches? (default is TRUE).}

\item{remove_strand_ambig}{Whether to remove ambiguous alleles (A/T and C/G)? (default is TRUE).}
}
\value{
a data frame of harmonized GWAS summary statistics
}
\description{
Harmonize GWAS summary statistics with LD reference
}
