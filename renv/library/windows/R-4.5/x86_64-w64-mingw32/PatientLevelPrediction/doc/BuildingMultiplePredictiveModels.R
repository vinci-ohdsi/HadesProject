## ----echo = FALSE, results ='asis'--------------------------------------------
library(knitr)
kable(
  data.frame(
  input = c(
    "targetId",
    "outcomeId",
    "restrictPlpDataSettings",
    "populationSettings",
    "covariateSettings",
    "sampleSettings",
    "featureEngineeringSettings",
    "preprocessSettings",
    "modelSettings"
  ),
  
  Description = c(
    "The id for the target cohort",
    "The id for the outcome",
    "The settings used to restrict the target population, created with createRestrictPlpDataSettings()",
    "The settings used to restrict the target population and create the outcome labels, created with createStudyPopulationSettings()",
    "The settings used to define the covariates, created with FeatureExtraction::createDefaultCovariateSettings()",
    "The settings used to define any under/over sampling, created with createSampleSettings()",
    "The settings used to define any feature engineering, created with createFeatureEngineeringSettings()",
    "The settings used to define any preprocessing, created with createPreprocessSettings()",
    "The settings used to define the model fitting settings, such as setLassoLogisticRegression()"
  )
  
  ), 
  caption = "The inputs for the model design"
  )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# 
# # Model 1 is only using data between 2018-2020:
# restrictPlpDataSettings <- createRestrictPlpDataSettings(
#   studyStartDate = "20180101",
#   studyEndDate = "20191231"
#   )
# 
# # predict outcome within 1 to 180 days after index
# # remove people with outcome prior and with < 365 days observation
# populationSettings <- createStudyPopulationSettings(
#   binary = TRUE,
#   firstExposureOnly = TRUE,
#   washoutPeriod = 365,
#   removeSubjectsWithPriorOutcome = TRUE,
#   priorOutcomeLookback = 9999,
#   requireTimeAtRisk = FALSE,
#   riskWindowStart = 1,
#   riskWindowEnd = 180
# )
# 
# # use age/gender in groups and condition groups as features
# covariateSettings <- FeatureExtraction::createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAgeGroup = TRUE,
#   useConditionGroupEraAnyTimePrior = TRUE
# )
# 
# modelDesign1 <- createModelDesign(
#   targetId = 1,
#   outcomeId = 2,
#   restrictPlpDataSettings = restrictPlpDataSettings,
#   populationSettings = populationSettings,
#   covariateSettings = covariateSettings,
#   featureEngineeringSettings = createFeatureEngineeringSettings(),
#   sampleSettings = createSampleSettings(),
#   splitSettings = createDefaultSplitSetting(),
#   preprocessSettings = createPreprocessSettings(),
#   modelSettings = setLassoLogisticRegression()
#   )
# 

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# 
# # Model 2 has no restrictions when extracting data
# restrictPlpDataSettings <- createRestrictPlpDataSettings(
#   )
# 
# # predict outcome within 1 to 730 days after index
# # remove people with outcome prior and with < 365 days observation
# populationSettings <- createStudyPopulationSettings(
#   binary = TRUE,
#   firstExposureOnly = TRUE,
#   washoutPeriod = 365,
#   removeSubjectsWithPriorOutcome = TRUE,
#   priorOutcomeLookback = 9999,
#   requireTimeAtRisk = FALSE,
#   riskWindowStart = 1,
#   riskWindowEnd = 730
# )
# 
# # use age/gender in groups and condition/drug groups as features
# covariateSettings <- FeatureExtraction::createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAgeGroup = TRUE,
#   useConditionGroupEraAnyTimePrior = TRUE,
#   useDrugGroupEraAnyTimePrior = TRUE
# )
# 
# modelDesign2 <- createModelDesign(
#   targetId = 1,
#   outcomeId = 2,
#   restrictPlpDataSettings = restrictPlpDataSettings,
#   populationSettings = populationSettings,
#   covariateSettings = covariateSettings,
#   featureEngineeringSettings = createRandomForestFeatureSelection(ntrees = 500, maxDepth = 7),
#   sampleSettings = createSampleSettings(),
#   splitSettings = createDefaultSplitSetting(),
#   preprocessSettings = createPreprocessSettings(),
#   modelSettings = setRandomForest()
#   )
# 

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# 
# # Model 3 has no restrictions when extracting data
# restrictPlpDataSettings <- createRestrictPlpDataSettings(
#   )
# 
# # predict outcome during target cohort start/end
# # remove people with  < 365 days observation
# populationSettings <- createStudyPopulationSettings(
#   binary = TRUE,
#   firstExposureOnly = TRUE,
#   washoutPeriod = 365,
#   removeSubjectsWithPriorOutcome = FALSE,
#   requireTimeAtRisk = FALSE,
#   riskWindowStart = 0,
#   startAnchor =  "cohort start",
#   riskWindowEnd = 0,
#   endAnchor = "cohort end"
# )
# 
# # use age/gender in groups and measurement indicators as features
# covariateSettings <- FeatureExtraction::createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAgeGroup = TRUE,
#   useMeasurementAnyTimePrior = TRUE,
#   endDays = -1
# )
# 
# modelDesign3 <- createModelDesign(
#   targetId = 1,
#   outcomeId = 5,
#   restrictPlpDataSettings = restrictPlpDataSettings,
#   populationSettings = populationSettings,
#   covariateSettings = covariateSettings,
#   featureEngineeringSettings = createFeatureEngineeringSettings(),
#   sampleSettings = createSampleSettings(),
#   splitSettings = createDefaultSplitSetting(),
#   preprocessSettings = createPreprocessSettings(),
#   modelSettings = setGradientBoostingMachine()
#   )
# 

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# 
# dbms <- "your dbms"
# user <- "your username"
# pw <- "your password"
# server <- "your server"
# port <- "your port"
# 
# connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
#                                                                 server = server,
#                                                                 user = user,
#                                                                 password = pw,
#                                                                 port = port)
# 

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# cdmDatabaseSchema <- "your cdmDatabaseSchema"
# workDatabaseSchema <- "your workDatabaseSchema"
# cdmDatabaseName <- "your cdmDatabaseName"
# cohortTable <- "your cohort table"
# 
# databaseDetails <- createDatabaseDetails(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cdmDatabaseName = cdmDatabaseName,
#   cohortDatabaseSchema = workDatabaseSchema,
#   cohortTable = cohortTable,
#   outcomeDatabaseSchema = workDatabaseSchema,
#   outcomeTable = cohortTable,
#   cdmVersion = 5
#     )
# 

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# results <- runMultiplePlp(
#   databaseDetails = databaseDetails,
#   modelDesignList = list(
#     modelDesign1,
#     modelDesign2,
#     modelDesign3
#   ),
#   onlyFetchData = FALSE,
#   logSettings = createLogSettings(),
#   saveDirectory = "./PlpMultiOutput"
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# validationDatabaseDetails <- createDatabaseDetails(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = "new cdm schema",
#   cdmDatabaseName = "validation database",
#   cohortDatabaseSchema = workDatabaseSchema,
#   cohortTable = cohortTable,
#   outcomeDatabaseSchema = workDatabaseSchema,
#   outcomeTable = cohortTable,
#   cdmVersion = 5
# )
# 
# val <- validateMultiplePlp(
#   analysesLocation = "./PlpMultiOutput",
#   valdiationDatabaseDetails = validationDatabaseDetails,
#   validationRestrictPlpDataSettings = createRestrictPlpDataSettings(),
#   recalibrate = NULL,
#   saveDirectory = "./PlpMultiOutput/Validation"
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# viewMultiplePlp(analysesLocation = "./PlpMultiOutput")

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

