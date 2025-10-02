## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

withr::local_envvar(
  R_USER_CACHE_DIR = tempfile(),
  EUNOMIA_DATA_FOLDER = Sys.getenv("EUNOMIA_DATA_FOLDER", unset = tempfile())
)

## ----setup_treatment_patterns, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE), warning=FALSE, error=FALSE----
library(CDMConnector)
library(dplyr)
library(TreatmentPatterns)

cohortSet <- CDMConnector::readCohortSet(
  path = system.file(package = "TreatmentPatterns", "exampleCohorts")
)

con <- DBI::dbConnect(
  drv = duckdb::duckdb(),
  dbdir = CDMConnector::eunomiaDir()
)

cdm <- CDMConnector::cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "main"
)

cdm <- CDMConnector::generateCohortSet(
  cdm = cdm,
  cohortSet = cohortSet,
  name = "cohort_table",
  overwrite = TRUE
)

cohorts <- cohortSet %>%
  # Remove 'cohort' and 'json' columns
  dplyr::select(-"cohort", -"json", -"cohort_name_snakecase") %>%
  dplyr::mutate(
    type = c(
      "event", "event", "event", "event",
      "exit", "event", "event", "target"
    )
  ) %>%
  dplyr::rename(
    cohortId = "cohort_definition_id",
    cohortName = "cohort_name",
  )

outputEnv <- TreatmentPatterns::computePathways(
  cohorts = cohorts,
  cohortTableName = "cohort_table",
  cdm = cdm,
  minEraDuration = 7,
  combinationWindow = 7,
  minPostCombinationDuration = 7,
  concatTargets = FALSE
)

results <- TreatmentPatterns::export(
  andromeda = outputEnv,
  minCellCount = 1,
  nonePaths = TRUE,
  outputPath = tempdir()
)

## ----save, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
# Save to csv-, zip-file
results$saveAsCsv(path = tempdir())
results$saveAsZip(path = tempdir(), name = "tp-results.zip")

# Upload to database
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "sqlite",
  server = file.path(tempdir(), "db.sqlite")
)

results$uploadResultsToDb(
  connectionDetails = connectionDetails,
  schema = "main",
  prefix = "tp_",
  overwrite = TRUE,
  purgeSiteDataBeforeUploading = FALSE
)

## ----readTreatmentPathways, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
head(results$treatment_pathways)

## ----counts, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
head(results$counts_age)
head(results$counts_sex)
head(results$counts_year)

## ----summaryStatsTherapyDuration, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$plotEventDuration()

## ----warning=FALSE, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$plotEventDuration() +
  ggplot2::xlim(0, 100)

## ----warning=FALSE, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$plotEventDuration(minCellCount = 10) +
  ggplot2::xlim(0, 100)

## ----metadata, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$metadata

## ----sunburstPlot, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$plotSunburst()

## ----sankeyDiagram, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
results$plotSankey()

## ----cleanup, include=FALSE, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
# Close Andromeda objects
Andromeda::close(outputEnv)

# Close connection to CDM Reference
DBI::dbDisconnect(conn = con)
rm(defaultSettings, minEra60, splitAcuteTherapy, includeEndDate, con, cdm)

