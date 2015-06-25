\name{env_doc}
\alias{env_doc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
env_doc: function to easily document the R working environment
}
\description{
Reports out relevant information ablut the script environment including: system version and user; R version; versions of all included packages; working directory.  Results are returned as a list of data frames and echoed to the console (use output="return" to suppress printing)

Note: any packages included AFTER this function is called won't be listed.
}
\usage{
env_doc() 
env_doc(system = TRUE, version = TRUE, packages = TRUE, directory = TRUE)
}
\arguments{
  \item{system}{
  TRUE = include system information
}
  \item{version}{
}
  \item{packages}{
}
  \item{directory}{
}
  \item{output}{
  "print" (default) to print results (also returns as a list of data frames); "return" to suppress printing
  }
}
\details{
}
\value{
}
\references{
}
\author{
Donald Jackson
Bristol-Myers Squibb

donald.jackson@bms.com
}
\note{
}


\seealso{
}
\examples{
env_doc()
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
