% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/units_are_equivalent.R
\name{units_are_equivalent}
\alias{units_are_equivalent}
\title{Check if two unit strings are equivalent}
\usage{
units_are_equivalent(x, y)
}
\arguments{
\item{x}{A unit string, as character}

\item{y}{Another unit string for comparison, as character}
}
\value{
`TRUE` if equivalent, `FALSE` otherwise
}
\description{
This is to allow multiple forms of the same unit to work, such as
`m/s` vs. `m s-1` or `K` and `Kelvin`.
}
\author{
Alexey Shiklomanov
}
