## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
library(FeatureExtraction)
vignetteFolder <- "s:/temp/vignetteFeatureExtractionCohortBased"

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(SqlRender)
# sql <- readSql("covariateCohorts.sql")
# connection <- connect(connectionDetails)
# renderTranslateExecuteSql(
#   connection = connection,
#   sql = sql,
#   cdm_database_schema = cdmDatabaseSchema,
#   cohort_database_schema = cohortDatabaseSchema,
#   cohort_table = cohortTable
# )

## ----eval=FALSE---------------------------------------------------------------
# sql <- paste(
#   "SELECT cohort_definition_id,
#                 COUNT(*) AS count",
#   "FROM @cohort_database_schema.@cohort_table",
#   "GROUP BY cohort_definition_id"
# )
# renderTranslateQuerySql(
#   connection = connection,
#   sql = sql,
#   cohort_database_schema = cohortDatabaseSchema,
#   cohort_table = cohortTable
# )

## ----echo=FALSE,message=FALSE-------------------------------------------------
data.frame(cohort_concept_id = c(1, 2), count = c(954179, 979874))

## ----eval=FALSE---------------------------------------------------------------
# covariateCohorts <- tibble(
#   cohortId = 2,
#   cohortName = "Type 2 diabetes"
# )
# 
# covariateSettings <- createCohortBasedCovariateSettings(
#   analysisId = 999,
#   covariateCohorts = covariateCohorts,
#   valueType = "binary",
#   startDay = -365,
#   endDay = 0
# )

## ----eval=FALSE---------------------------------------------------------------
# covariateData <- getDbCovariateData(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cohortDatabaseSchema = cohortDatabaseSchema,
#   cohortTable = cohortTable,
#   cohortId = 1,
#   rowIdField = "subject_id",
#   covariateSettings = covariateSettings
# )
# summary(covariateData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covariatesPerPerson"))) {
  covariateData <- loadCovariateData(file.path(vignetteFolder, "covariatesPerPerson"))
  summary(covariateData)
}

## ----eval=FALSE---------------------------------------------------------------
# covariateData$covariateRef

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covariatesPerPerson"))) {
  covariateData$covariateRef
}

## ----eval=FALSE---------------------------------------------------------------
# covariateSettings1 <- createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAgeGroup = TRUE,
#   useDemographicsRace = TRUE,
#   useDemographicsEthnicity = TRUE,
#   useDemographicsIndexYear = TRUE,
#   useDemographicsIndexMonth = TRUE
# )
# 
# covariateCohorts <- tibble(
#   cohortId = 2,
#   cohortName = "Type 2 diabetes"
# )
# 
# covariateSettings2 <- createCohortBasedCovariateSettings(
#   analysisId = 999,
#   covariateCohorts = covariateCohorts,
#   valueType = "binary",
#   startDay = -365,
#   endDay = 0
# )
# 
# covariateSettingsList <- list(covariateSettings1, covariateSettings2)
# 
# covariateData <- getDbCovariateData(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cohortDatabaseSchema = cohortDatabaseSchema,
#   cohortTable = cohortTable,
#   cohortId = 1,
#   rowIdField = "subject_id",
#   covariateSettings = covariateSettingsList,
#   aggregated = TRUE
# )
# summary(covariateData)

## ----echo=FALSE,message=FALSE-------------------------------------------------
if (file.exists(file.path(vignetteFolder, "covariatesAggregated"))) {
  covariateData <- loadCovariateData(file.path(vignetteFolder, "covariatesAggregated"))
  summary(covariateData)
}

