## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----Capr, eval=FALSE---------------------------------------------------------
#  library(Capr)
#  
#  viralSinusitis <- cs(
#    descendants(40481087),
#    name = "viralSinusitis",
#    id = "Viral Sinusitis"
#  )
#  
#  viralSinusitisCohort <- cohort(
#    entry = entry(
#      conditionOccurrence(viralSinusitis),
#      primaryCriteriaLimit = "First"
#    ),
#    exit = exit(
#      endStrategy = observationExit()
#    )
#  )
#  
#  cohortSet <- list(ViralSinusitis = viralSinusitisCohort)

## -----------------------------------------------------------------------------
list.files(
  system.file(package = "TreatmentPatterns", "exampleCohorts"),
  full.names = TRUE
)

