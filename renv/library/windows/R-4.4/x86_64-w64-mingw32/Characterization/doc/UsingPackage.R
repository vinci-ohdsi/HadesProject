## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# remotes::install_github("ohdsi/Characterization")

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
library(Characterization)
library(dplyr)

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
connectionDetails <- Characterization::exampleOmopConnectionDetails()

## ----eval=TRUE----------------------------------------------------------------
exampleTargetIds <- c(1, 2, 4)
exampleOutcomeIds <- 3

## ----eval=TRUE----------------------------------------------------------------
exampleCovariateSettings <- FeatureExtraction::createCovariateSettings(
  useDemographicsGender = T,
  useDemographicsAge = T,
  useCharlsonIndex = T
)

## ----eval=TRUE----------------------------------------------------------------
caseCovariateSettings <- Characterization::createDuringCovariateSettings(
  useConditionGroupEraDuring = T
)

## ----eval=TRUE----------------------------------------------------------------
exampleAggregateCovariateSettings <- createAggregateCovariateSettings(
  targetIds = exampleTargetIds,
  outcomeIds = exampleOutcomeIds,
  riskWindowStart = 1, startAnchor = "cohort start",
  riskWindowEnd = 365, endAnchor = "cohort start",
  outcomeWashoutDays = 9999,
  minPriorObservation = 365,
  covariateSettings = exampleCovariateSettings,
  caseCovariateSettings = caseCovariateSettings,
  casePreTargetDuration = 90,
  casePostOutcomeDuration = 90
)

## ----eval=FALSE,results='hide',error=FALSE,warning=FALSE,message=FALSE--------
# runCharacterizationAnalyses(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = "main",
#   targetDatabaseSchema = "main",
#   targetTable = "cohort",
#   outcomeDatabaseSchema = "main",
#   outcomeTable = "cohort",
#   characterizationSettings = createCharacterizationSettings(
#     aggregateCovariateSettings = exampleAggregateCovariateSettings
#   ),
#   databaseId = "Eunomia",
#   runId = 1,
#   minCharacterizationMean = 0.01,
#   outputDirectory = file.path(tempdir(), "example_char", "results"),
#   executionPath = file.path(tempdir(), "example_char", "execution"),
#   minCellCount = 10,
#   incremental = F,
#   threads = 1
# )

## ----eval=TRUE----------------------------------------------------------------
exampleTargetIds <- c(1, 2, 4)
exampleOutcomeIds <- 3

## ----eval=TRUE----------------------------------------------------------------
exampleDechallengeRechallengeSettings <- createDechallengeRechallengeSettings(
  targetIds = exampleTargetIds,
  outcomeIds = exampleOutcomeIds,
  dechallengeStopInterval = 30,
  dechallengeEvaluationWindow = 31
)

## ----eval=FALSE---------------------------------------------------------------
# dc <- computeDechallengeRechallengeAnalyses(
#   connectionDetails = connectionDetails,
#   targetDatabaseSchema = "main",
#   targetTable = "cohort",
#   settings = exampleDechallengeRechallengeSettings,
#   databaseId = "Eunomia",
#   outcomeFolder = file.path(tempdir(), "example_char", "results"),
#   minCellCount = 5
# )

## ----eval=FALSE---------------------------------------------------------------
# failed <- computeRechallengeFailCaseSeriesAnalyses(
#   connectionDetails = connectionDetails,
#   targetDatabaseSchema = "main",
#   targetTable = "cohort",
#   settings = exampleDechallengeRechallengeSettings,
#   outcomeDatabaseSchema = "main",
#   outcomeTable = "cohort",
#   databaseId = "Eunomia",
#   outcomeFolder = file.path(tempdir(), "example_char", "results"),
#   minCellCount = 5
# )

## ----eval=TRUE----------------------------------------------------------------
exampleTimeToEventSettings <- createTimeToEventSettings(
  targetIds = exampleTargetIds,
  outcomeIds = exampleOutcomeIds
)

## ----eval=FALSE---------------------------------------------------------------
# tte <- computeTimeToEventAnalyses(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = "main",
#   targetDatabaseSchema = "main",
#   targetTable = "cohort",
#   settings = exampleTimeToEventSettings,
#   databaseId = "Eunomia",
#   outcomefolder = file.path(tempdir(), "example_char", "results"),
#   minCellCount = 5
# )

## ----eval=FALSE,results='hide',error=FALSE,warning=FALSE,message=FALSE--------
# characterizationSettings <- createCharacterizationSettings(
#   timeToEventSettings = list(
#     exampleTimeToEventSettings
#   ),
#   dechallengeRechallengeSettings = list(
#     exampleDechallengeRechallengeSettings
#   ),
#   aggregateCovariateSettings = exampleAggregateCovariateSettings
# )
# 
# # save the settings using
# saveCharacterizationSettings(
#   settings = characterizationSettings,
#   saveDirectory = file.path(tempdir(), "saveSettings")
# )
# 
# # the settings can be loaded
# characterizationSettings <- loadCharacterizationSettings(
#   saveDirectory = file.path(tempdir(), "saveSettings")
# )
# 
# runCharacterizationAnalyses(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = "main",
#   targetDatabaseSchema = "main",
#   targetTable = "cohort",
#   outcomeDatabaseSchema = "main",
#   outcomeTable = "cohort",
#   characterizationSettings = characterizationSettings,
#   outputDirectory = file.path(tempdir(), "example", "results"),
#   executionPath = file.path(tempdir(), "example", "execution"),
#   csvFilePrefix = "c_",
#   databaseId = "1",
#   incremental = F,
#   minCharacterizationMean = 0.01,
#   minCellCount = 5
# )

## ----eval=FALSE---------------------------------------------------------------
# viewCharacterization(
#   resultFolder = file.path(tempdir(), "example", "results"),
#   cohortDefinitionSet = NULL
# )

