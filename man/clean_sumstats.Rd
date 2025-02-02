% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gwas.R
\name{clean_sumstats}
\alias{clean_sumstats}
\title{Cleans summary statistics}
\usage{
clean_sumstats(
  sumstats,
  chr = "chr",
  pos = "pos",
  beta = "beta",
  se = "se",
  a0 = "a0",
  a1 = "a1",
  snp = "snp",
  pval = "pval",
  remove_indels = TRUE
)
}
\arguments{
\item{sumstats}{A data frame of GWAS summary statistics.
It is required to have the following columns:
chr, position, beta, se, a0, a1, SNP ID (rs), p-value.}

\item{chr}{Name of the chromosome column in summary statistics.}

\item{pos}{Name of the position column (base pair position).}

\item{beta}{Name of beta column (if you have Odds Ratio,
you will need to transform it to log(Odds Ratio)).}

\item{se}{Name of the standard error (se) column.}

\item{a0}{Column name of the reference allele.}

\item{a1}{Column name of the association/effect allele.}

\item{snp}{Name of the SNP ID (rsID) column.}

\item{pval}{Name of the p-value column.}
}
\value{
A data frame of cleaned summary statistics,
sort by chromosome and position.
}
\description{
It will extract the required columns from summary statistics,
check chromosomes, remove X, Y chromosomes, compute z-scores,
convert alleles to upper case, remove indels,
and sort by chromosome and position.
}
