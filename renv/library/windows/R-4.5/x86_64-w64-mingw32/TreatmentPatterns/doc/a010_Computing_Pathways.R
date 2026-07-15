## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

withr::local_envvar(
  R_USER_CACHE_DIR = tempfile(),
  EUNOMIA_DATA_FOLDER = Sys.getenv("EUNOMIA_DATA_FOLDER", unset = tempfile())
)

## ----message=FALSE, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
library(dplyr)
library(CDMConnector)

cohortSet <- readCohortSet(
  path = system.file(package = "TreatmentPatterns", "exampleCohorts")
)

cohorts <- cohortSet %>%
  # Remove 'cohort' and 'json' columns
  select(-"cohort", -"json", -"cohort_name_snakecase") %>%
  mutate(type = c("event", "event", "event", "event", "exit", "event", "event", "target")) %>%
  rename(
    cohortId = "cohort_definition_id",
    cohortName = "cohort_name",
  )

cohorts

## ----eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)----
library(DBI)
library(duckdb)
con <- dbConnect(
  drv = duckdb(),
  dbdir = eunomiaDir()
)

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "main"
)

cdm <- generateCohortSet(
  cdm = cdm,
  cohortSet = cohortSet,
  name = "cohort_table",
  overwrite = TRUE
)

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm
#  )

## ----eval=FALSE---------------------------------------------------------------
#  library(DatabaseConnector)
#  
#  connectionDetails <- createConnectionDetails(
#    dbms = "postgres",
#    user = "user",
#    password = "password",
#    server = "some-server.database.net",
#    port = 1337,
#    pathToDriver = "./path/to/jdbc/"
#  )
#  
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    connectionDetails = connectionDetails,
#    cdmSchema = "main",
#    resultSchema = "main",
#    tempEmulationSchema = NULL,
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    analysisId = 1,
#    description = "My First Treatment Patterns Analysis"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    minEraDuration = 30,
#    eraCollapseSize = 30,
#    filterTreatments = "First"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    combinationWindow = 30,
#    minPostCombinationDuration = 30
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    overlapMethod = "truncate"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    overlapMethod = "keep"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    splitEventCohorts = c(1, 2),
#    splitTime = 30
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    startAnchor = "startDate",
#    windowStart = 0,
#    endAnchor = "endDate",
#    windowEnd = 0
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    startAnchor = "startDate",
#    windowStart = -30,
#    endAnchor = "endDate",
#    windowEnd = 30
#  )

## ----eval=FALSE---------------------------------------------------------------
#  outputEnv <- computePathways(
#    cohorts = cohorts,
#    cohortTableName = "cohort_table",
#    cdm = cdm,
#    startAnchor = "startDate",
#    windowStart = -30,
#    endAnchor = "startDate",
#    windowEnd = 0
#  )

## ----setup_analysis, eval=require("CDMConnector", quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE), warning=FALSE, error=FALSE----
library(TreatmentPatterns)

# Computing pathways
outputEnv <- computePathways(
  cohorts = cohorts,
  cohortTableName = "cohort_table",
  cdm = cdm,
  analysisId = 1,
  description = "My Treatment Pathway analysis",

  # Window
  startAnchor = "startDate",
  windowStart = 0,
  endAnchor = "endDate",
  windowEnd = 0,

  # Acute / Therapy
  splitEventCohorts = NULL,
  splitTime = NULL,

  # Events
  minEraDuration = 7,
  filterTreatments = "All",
  eraCollapseSize = 3,

  # Combinations
  combinationWindow = 7,
  minPostCombinationDuration = 7,
  overlapMethod = "truncate",

  # Pathways
  maxPathLength = 10,
  concatTargets = FALSE
)

