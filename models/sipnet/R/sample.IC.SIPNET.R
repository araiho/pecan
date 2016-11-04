#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

## samples intial conditions for SIPNET
##' @title sample.IC.SIPNET
##' @name  sample.IC.SIPNET
##' @author Mike Dietze and Ann Raiho
##' 
##' @param settings
##' @param ne        number of ensembles
##' @param data      state variables matrix
##' @param year      which year from the day you want ICs from
##' 
##' @description samples intial conditions for SIPNET
##' 
##' @return settings directory that points to initial conditions
##' @export
##' 
sample.IC.SIPNET <- function(settings, ne = 1, data = NULL, year = 1) {
  
  ## Mg C / ha / yr NPP
  NPP <- ifelse(rep("NPP" %in% names(data), ne), 
                data$NPP[1, sample.int(ncol(data$NPP), ne), year], # *.48, ## unit MgC/ha/yr
                runif(ne, 0, 10))  ## prior
  
  # g C * m-2 ground area in wood (above-ground + roots)
  plantWood <- ifelse(rep("AGB" %in% names(data), ne), 
                      data$AGB[1, sample.int(ncol(data$AGB), ne), year] * (1/1000) * (1e+06/1), ## unit KgC/ha -> g C /m^2 
                      runif(ne, 0, 14000))  ## prior
  
  # initial leaf area, m2 leaves * m-2 ground area (multiply by leafCSpWt to
  ## get initial plant leaf C)
  lai <- ifelse(rep("LAI" %in% names(data), ne), 
                data$LAI[1, sample.int(ncol(data$LAI), ne), year], 
                runif(ne, 0, 7))  ## prior
  
  ## g C * m-2 ground area
  litter <- ifelse(rep("litter" %in% names(data), ne), 
                   data$litter[1, sample.int(ncol(data$litter), ne), year], 
                   runif(ne, 0, 1200))  ## prior
  
  ## g C * m-2 ground area
  soil <- ifelse(rep("soil" %in% names(data), ne), 
                 data$soil[1, sample.int(ncol(data$soil), ne), year], 
                 runif(ne, 0, 19000))  ## prior
  
  ## unitless: fraction of litterWHC
  litterWFrac <- ifelse(rep("litterW" %in% names(data), ne), 
                        data$litterW[1, sample.int(ncol(data$litterW), ne), year], 
                        runif(ne))  ## prior
  
  ## unitless: fraction of soilWHC
  soilWFrac <- ifelse(rep("soilW" %in% names(data), ne), 
                      data$soilW[1, sample.int(ncol(data$soilW), ne), year],
                      runif(ne))  ## prior
  
  ## cm water equiv
  snow <- ifelse(rep("snow" %in% names(data), ne), 
                 data$snow[1, sample.int(ncol(data$snow), ne), year], 
                 runif(ne, 0, 1))  ## prior
  
  microbe <- ifelse(rep("microbe" %in% names(data), ne), 
                    data$microbe[1, sample.int(ncol(data$microbe), ne), year], 
                    runif(ne, 0, 1))  ## prior 
  IC <- data.frame(NPP, plantWood, lai, litter,
                  soil, litterWFrac, soilWFrac, snow, microbe)
  
  save(IC, file = paste0(settings$run$inputs$initial_conditions$path,'/IC.Rdata'))
  
  return(settings$run$inputs$initial_conditions) #not sure that this needs to be returned
} # sample.IC.SIPNET
