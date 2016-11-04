#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

## samples intial conditions for LINKAGES
##' @title sample.IC.LINKAGES
##' @name  sample.IC.LINKAGES
##' @author Ann Raiho
##' 
##' @param settings
##' @param ne        number of ensembles
##' @param data      state variables matrix
##' @param year      which year from the day you want ICs from
##' 
##' @description samples intial conditions for LINKAGES
##' 
##' @return settings directory that points to initial conditions
##' @export
##' 
sample.IC.LINKAGES <- function(settings, ne = 1, data = NULL, year = 1) {

  ##for now LINKAGES can only be given ICs through an .Rdata restart file
  ##so we're punting on sampling ICs until we generalized inits more across pecan 
  return(settings$run$inputs$initial_conditions)
  
  } # sample.IC.LINKAGES
