% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_soil_nc.R
\name{extract_soil_gssurgo}
\alias{extract_soil_gssurgo}
\title{Extract soil data from gssurgo}
\usage{
extract_soil_gssurgo(outdir, lat, lon)
}
\arguments{
\item{outdir}{Output directory for writing down the netcdf file}

\item{lat}{Latitude}

\item{lon}{Longitude}
}
\value{
It returns the address for the generated soil netcdf file
}
\description{
Extract soil data from gssurgo
}
\examples{
outdir  <- "~/paleon/envTest"
lat     <- 40
lon     <- -80
\dontrun{
   PEcAn.data.land::extract_soil_gssurgo(outdir,lat,lon)
}
}
\author{
Hamze Dokoohaki
}
