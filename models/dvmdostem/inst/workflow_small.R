#!/usr/bin/env Rscript
#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
library(PEcAn.all)
library(PEcAn.utils)
library(RCurl)
library(PEcAn.dvmdostem)

# make sure always to call status.end
options(warn=1)
options(error=quote({
  PEcAn.utils::status.end("ERROR")
  PEcAn.utils::kill.tunnel(settings)
  if (!interactive()) {
    q()
  }
}))

#options(warning.expression=status.end("ERROR"))



# ----------------------------------------------------------------------
# PEcAn Workflow
# ----------------------------------------------------------------------
# Open and read in settings file for PEcAn run.
args <- commandArgs(trailingOnly = TRUE)
if (is.na(args[1])){
  settings <- PEcAn.settings::read.settings("pecan.xml")
} else {
  settings.file = args[1]
  settings <- PEcAn.settings::read.settings(settings.file)
}

# Check for additional modules that will require adding settings
if("benchmarking" %in% names(settings)){
  library(PEcAn.benchmark)
  settings <- papply(settings, read_settings_RR)
}

if("sitegroup" %in% names(settings)){
  if(is.null(settings$sitegroup$nSite)){
    settings <- PEcAn.settings::createSitegroupMultiSettings(settings, sitegroupId = settings$sitegroup$id)
  } else {
    settings <- PEcAn.settings::createSitegroupMultiSettings(settings, sitegroupId = settings$sitegroup$id,nSite = settings$sitegroup$nSite)
  }
  settings$sitegroup <- NULL ## zero out so don't expand a second time if re-reading
}

# Update/fix/check settings. Will only run the first time it's called, unless force=TRUE
settings <- PEcAn.settings::prepare.settings(settings, force=FALSE)

# Write pecan.CHECKED.xml
PEcAn.settings::write.settings(settings, outputfile = "pecan.CHECKED.xml")

# start from scratch if no continue is passed in
statusFile <- file.path(settings$outdir, "STATUS")
if (length(which(commandArgs() == "--continue")) == 0 && file.exists(statusFile)) {
  file.remove(statusFile)
}
  
# Do conversions
settings <- PEcAn.workflow::do_conversions(settings)

# Query the trait database for data and priors
if (PEcAn.utils::status.check("TRAIT") == 0){
  PEcAn.utils::status.start("TRAIT")
  settings <- PEcAn.workflow::runModule.get.trait.data(settings)
  PEcAn.settings::write.settings(settings, outputfile='pecan.TRAIT.xml')
  PEcAn.utils::status.end()
} else if (file.exists(file.path(settings$outdir, 'pecan.TRAIT.xml'))) {
  settings <- PEcAn.settings::read.settings(file.path(settings$outdir, 'pecan.TRAIT.xml'))
}

  
# Run the PEcAn meta.analysis
if(!is.null(settings$meta.analysis)) {
  if (PEcAn.utils::status.check("META") == 0){
    PEcAn.utils::status.start("META")
    PEcAn.MA::runModule.run.meta.analysis(settings)
    PEcAn.utils::status.end()
  }
}

# Write model specific configs
if (PEcAn.utils::status.check("CONFIG") == 0){
  PEcAn.utils::status.start("CONFIG")
  settings <- PEcAn.workflow::runModule.run.write.configs(settings)
  PEcAn.settings::write.settings(settings, outputfile='pecan.CONFIGS.xml')
  PEcAn.utils::status.end()
} else if (file.exists(file.path(settings$outdir, 'pecan.CONFIGS.xml'))) {
  settings <- PEcAn.settings::read.settings(file.path(settings$outdir, 'pecan.CONFIGS.xml'))
}

if ((length(which(commandArgs() == "--advanced")) != 0) && (PEcAn.utils::status.check("ADVANCED") == 0)) {
  PEcAn.utils::status.start("ADVANCED")
  q();
}

# Start ecosystem model runs
if (PEcAn.utils::status.check("MODEL") == 0) {
  PEcAn.utils::status.start("MODEL")
  PEcAn.utils::runModule.start.model.runs(settings,stop.on.error=FALSE)
  PEcAn.utils::status.end()
}


  
# Pecan workflow complete
if (PEcAn.utils::status.check("FINISHED") == 0) {
  PEcAn.utils::status.start("FINISHED")
  kill.tunnel(settings)
  db.query(paste("UPDATE workflows SET finished_at=NOW() WHERE id=", settings$workflow$id, "AND finished_at IS NULL"), params=settings$database$bety)

  # Send email if configured
  if (!is.null(settings$email) && !is.null(settings$email$to) && (settings$email$to != "")) {
    sendmail(settings$email$from, settings$email$to,
             paste0("Workflow has finished executing at ", base::date()),
             paste0("You can find the results on ", settings$email$url))
  }
  PEcAn.utils::status.end()
}

db.print.connections()
print("---------- PEcAn Workflow Complete ----------")




