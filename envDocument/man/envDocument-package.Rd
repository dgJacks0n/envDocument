\name{envDocument-package}
\alias{envDocument-package}
\alias{envDocument}
\docType{package}
\title{
document_environment: R package to print information of the R environment
}
\description{
Prints relevant information on the environment that an R script is running under
for use in reproducing results.  

The report includes system, user, working directory
and included packages with versions.

Version 2.2 adds information on the git status of the script if available: 
last commit hash, tag (if any) and whether the script was modified since last commit.
(Note: requires git2r)

}

\examples{
library(envDocument)
env_doc()
}

\details{
\tabular{ll}{
Package: \tab envDocument\cr
Type: \tab Package\cr
Version: \tab 2.2\cr
Date: \tab 2016-07-25\cr
License: \tab Bristol-Myers Squibb Internal Use\cr
}
}
\author{
Donald Jackson
Bristol-Myers Squibb

donald.jackson@bms.com
}
\references{
}
\keyword{ package
}
\seealso{
}
