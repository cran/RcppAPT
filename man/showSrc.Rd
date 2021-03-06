% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{showSrc}
\alias{showSrc}
\title{Display information for given packages}
\usage{
showSrc(regexp = ".")
}
\arguments{
\item{regexp}{A regular expression for the package name(s) with a
default of all (".")}
}
\value{
A boolean is returned indicating whether or not the given
regular expression could be matched to source packages -- but the
function is invoked ' for the side effect of displaying information.
}
\description{
The APT Package Management system uses a data-rich caching
structure. This accessor function displays the information for
a set of packages matching the given regular expression. The
output corresponds to \code{apt-cache showsrc pkgname}.
}
\details{
Note that the package lookup uses regular expressions. If only a
single package is desired, append a single \code{$} to terminate
the expression.  \emph{Ie} \code{r-cran-rcpp$} will \emph{not}
return results for \code{r-cran-rcpparmadillo} and
\code{r-cran-rcppeigen}.
}
\examples{
showSrc("^r-(base|doc)-")
showSrc("r-cran-rcpp")  # also finds RcppEigen and RcppArmadillo
showSrc("r-cran-rcpp$") # just Rcpp
}
\author{
Dirk Eddelbuettel
}
