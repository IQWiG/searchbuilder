% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/z_scores.R
\name{z_scores}
\alias{z_scores}
\title{Create z-scores for every token in the testset provided}
\usage{
z_scores(
  risfile = NULL,
  references = NULL,
  risfile_population,
  load_popset = TRUE,
  dev_set = FALSE,
  seed = NULL
)
}
\arguments{
\item{risfile}{a ris-format file to be imported}

\item{references}{an object created with create_testset() to be used fo analysis instead of a raw ris file}

\item{risfile_population}{a risfile from Endnote containing a population set}

\item{load_popset}{logical, should internal population set be applied (default) or should a customized population set be calculated}

\item{dev_set}{logical, if TRUE a random development set (2/3 imported references) will be created}

\item{seed}{option to set a random seed, only works with dev_set = TRUE}
}
\value{
a list
}
\description{
Create z-scores for every token in the testset provided
}
\examples{
ris <- c("TY  - JOUR",
         "AU  - Kapp",
         "TI  - Titles",
         "PY  - 2023",
         "JOUR  - IQWiG Journal",
         "KW  - Systematic Reviews as Topic",
         "ER  -")

tmp <- tempfile(fileext = ".txt")
writeLines(ris, tmp)
z_scores(tmp)

}
