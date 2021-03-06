\name{rsf}
\alias{rsf.fit}
\alias{rsf}
\alias{rspf}
\alias{rsf.null}
\title{
Resource Selection (Probability) Functions for Use-Availability Data
}
\description{
  Resource Selection (Probability) Functions for
  use-availability wildlife data as described in
  Lele and Keim (2006) and Lele (2009).
}
\usage{
rsf(formula, data, m, B = 99, inits, method = "Nelder-Mead",
control, model = TRUE, x = FALSE, ...)

rspf(formula, data, m, B = 99, link = "logit", inits,
method = "Nelder-Mead", control, model = TRUE, x = FALSE, ...)

rsf.fit(X, Y, m, link = "logit", B = 99,
inits, method = "Nelder-Mead", control, ...)

rsf.null(Y, m, inits, ...)
}
\arguments{
  \item{formula}{
two sided model formula of the form \code{y ~ x},
where \code{y} is a vector of observations,
\code{x} is the set of covariates.
}
  \item{m}{
argument describing the matching of use and available points, see Details.
}
  \item{data}{
data.
}
  \item{B}{
number of bootstrap iterations to make.
}
  \item{link}{
character, type of link function to be used.
}
  \item{inits}{
initial values, optional.
}
  \item{method}{
method to be used in \code{\link{optim}} for numerical optimization.
}
  \item{control}{
control options for \code{\link{optim}}.
}
  \item{model}{
a logical value indicating whether model frame should be included as a component of the returned value
}
  \item{x}{
logical values indicating whether the model matrix used in the
fitting process should be returned as components of the returned value.
}
\item{Y}{
vector of observations.
}
\item{X}{
covariate matrix.
}
  \item{\dots}{
other arguments passed to the functions.
}
}
\details{
The \code{rsf} function fits the Exponential Resource Selection Function
(RSF) model to presence only data.

The \code{rspf} function fits the Resource Selection Probability Function
(RSPF) model to presence only data Link function \code{"logit"},
\code{"cloglog"}, and \code{"probit"} can be specified via the
\code{link} argument.

The \code{rsf.fit} is the workhorse behind the two functions.
\code{link="log"} leads to Exponential RSF.

The \code{rsf.null} function fits the 'no selection' version
of the Exponential Resource Selection Function (RSF) model to presence only data.

LHS of the \code{formula} data must be binary, ones indicating used locations,
while zeros indicating available location.

All available points are used for each use points if \code{m=0}
(global availability). If \code{m} is a single value, e.g. \code{m=5},
it is assumed that available data points are grouped in batches of 5,
e.g. with IDs \code{c(1,2)} for used point locations and
\code{c(1, 1, 1, 1, 1, 2, 2, 2, 2, 2)} for available locations
(local availability, matched use-available design).
Similarly, a vector of matching IDs can also be provided, e.g.
\code{c(1, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2)} by combining the above two.
This potentially could allow for unbalanced matching
(e.g. \code{c(1, 2, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2)})
and for easier subsetting of the data,
but comes with an increased computing time.
Note, the response in the LHS of the formula
should be coded as \code{c(1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)}
for all of the above examples. When \code{m} is defined as
a mapping vector or the value is 0, the order of course does not matter.
However, ordering matters when \code{m} is constant because that
implies a certain structure.

For model description and estimation details, see Lele and Keim (2006),
Lele (2009), and Solymos and Lele (2016).
}
\value{
A list with class \code{"rsf"}, \code{"rsf.null"}, or \code{"rspf"}
containing the following components:
  \item{call}{the matched call.}
  \item{y}{vector from LHS of the formula.}
  \item{coefficients}{a named vector of coefficients.}
  \item{std.error}{a named vector of standard errors
    for the coefficients.}
  \item{loglik}{the maximized pseudo log-likelihood according to Lele 2009.}
  \item{results}{\code{\link{optim}} results.}
  \item{link}{character, value of the link function used.}
  \item{control}{control parameters for \code{\link{optim}}.}
  \item{inits}{initial values used in optimization.}
  \item{m}{value of the \code{m} argument with possibly matched
    use-available design.}
  \item{np}{number of active parameters.}
  \item{fitted.values}{vector of fitted values. These are relative
    selection values for RSF models, and probability of selection for
    RSPF models.}
  \item{nobs}{number of used locations.}
  \item{bootstrap}{component to store bootstrap results if \code{B}>0.}
  \item{converged}{logical, indicating convergence of the optimization.}
  \item{formula}{the formula supplied.}
  \item{terms}{the \code{\link{terms}} object used.}
  \item{levels}{a record of the levels of the factors used in fitting.}
  \item{contrasts}{the contrasts used.}
  \item{model}{if requested, the model frame.}
  \item{x}{if requested, the model matrix.}
}
\references{
Lele, S.R. (2009)
A new method for estimation of resource selection probability function.
Journal of Wildlife Management 73, 122--127.

Lele, S. R. &  Keim, J. L. (2006)
Weighted distributions and estimation of resource selection probability functions.
Ecology 87, 3021--3028.

Solymos, P. & Lele, S. R. (2016)
Revisiting resource selection probability functions and single-visit methods:
clarification and extensions.
Methods in Ecology and Evolution 7, 196--205.
}
\author{
Subhash R. Lele, Jonah L. Keim, Peter Solymos
}
\examples{
## --- Simulated data example ---

## settings
n.used <- 1000
m <- 10
n <- n.used * m
set.seed(1234)
x <- data.frame(x1=rnorm(n), x2=runif(n))
cfs <- c(1.5,-1,0.5)
## fitting Exponential RSF model
dat1 <- simulateUsedAvail(x, cfs, n.used, m, link="log")
m1 <- rsf(status ~ .-status, dat1, m=0, B=0)
summary(m1)
## fitting Logistic RSPF model
dat2 <- simulateUsedAvail(x, cfs, n.used, m, link="logit")
m2 <- rspf(status ~ .-status, dat2, m=0, B=0)
summary(m2)

## --- Real data analysis from Lele & Keim 2006 ---

\dontrun{
goats$exp.HLI <- exp(goats$HLI)
goats$sin.SLOPE <- sin(pi * goats$SLOPE / 180)
goats$ELEVATION <- scale(goats$ELEVATION)
goats$ET <- scale(goats$ET)
goats$TASP <- scale(goats$TASP)

## Fit two RSPF models:
## global availability (m=0) and bootstrap (B=99)
m1 <- rspf(STATUS ~ TASP + sin.SLOPE + ELEVATION, goats, m=0, B = 99)
m2 <- rspf(STATUS ~ TASP + ELEVATION, goats, m=0, B = 99)

## Inspect the summaries
summary(m1)
summary(m2)

## Compare models: looks like m1 is better supported
CAIC(m1, m2)

## Visualize the relationships
plot(m1)
mep(m1) # marginal effects similar to plot but with CIs
kdepairs(m1) # 2D kernel density estimates
plot(m2)
kdepairs(m2)
mep(m2)

## fit and compare to null RSF model (not available for RSPF)
m3 <- rsf(STATUS ~ TASP + ELEVATION, goats, m=0, B = 0)
m4 <- rsf.null(Y=goats$STATUS, m=0)
CAIC(m3, m4)
}
}
\keyword{ htest }
