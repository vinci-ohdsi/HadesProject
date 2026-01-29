## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# library(PatientLevelPrediction)
# library(dplyr)
# outputFolder <- "/ohdsi-gis/copdResultsPM25_NEW"
# saveDirectory <- outputFolder
# ExecutionDateTime <- Sys.time()
# logSettings = createLogSettings(verbosity = "DEBUG", timeStamp = T, logName =
#                                   "runPlp Log")
# analysisName = 'Generic PLP'
# 
# # Details for connecting to the server:
# connectionDetails <- DatabaseConnector::createConnectionDetails(
#         dbms = 'spark',
#         server = '/default',
#         connectionString = '<REDACTED>'
#     )
# # Add the database containing the OMOP CDM data
# cdmDatabaseSchema <- 'gis_syn_dataset_5_4'
# # Add a sharebale name for the database containing the OMOP CDM data
# cdmDatabaseName <- 'TSD-GIS'
# # Add a database with read/write access as this is where the cohorts will be generated
# cohortDatabaseSchema <- 'gis_syn_dataset_5_4'
# tempEmulationSchema <- NULL
# # table name where the cohorts will be generated
# cohortTable <- 'cohort'

## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# databaseDetails <- PatientLevelPrediction::createDatabaseDetails(
#         connectionDetails = connectionDetails,
#         cdmDatabaseSchema = cdmDatabaseSchema,
#         cdmDatabaseName = cdmDatabaseName,
#         tempEmulationSchema = tempEmulationSchema,
#         cohortDatabaseSchema = cohortDatabaseSchema,
#         cohortTable = cohortTable,
#         outcomeDatabaseSchema = cohortDatabaseSchema,
#         outcomeTable = cohortTable,
#         cdmVersion = 5
# )
# 
# 
# # Run very simple LR model against two cohorts created in Atlas. Use model
# # as basis for augmented model with pollutants below
# runMultiplePlp(
#    databaseDetails = databaseDetails,
#    modelDesignList = list(createModelDesign(targetId = 9, outcomeId = 8, modelSettings =
#                                               setLassoLogisticRegression())),
#    onlyFetchData = F,
#    cohortDefinitions = NULL,
#    logSettings = createLogSettings(verbosity = "DEBUG", timeStamp = T, logName =
#                                      "runPlp Log"),
#    saveDirectory = outputFolder,
#    sqliteLocation = file.path(saveDirectory, "sqlite")
#  )

## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# cohortDefinitions <- NULL
# modelDesign <- createModelDesign(targetId = 9, outcomeId = 8, modelSettings = setLassoLogisticRegression())
# populationSettings <- modelDesign$populationSettings
# splitSettings <- modelDesign$splitSettings
# 
# plpData <- loadPlpData("/ohdsi-gis/copdResultsPM25_B/targetId_9_L1")
# 
# mySplit <- splitData (plpData = plpData,
#                       population = createStudyPopulation(plpData, 8, populationSettings),
#                       splitSettings = splitSettings)
# 
# 
# labelTrain <- mySplit$Train$labels
# conn <- DatabaseConnector::connect(connectionDetails)
# pollutants <- DatabaseConnector::querySql(conn, "SELECT person_id as subjectID, CAST(MEAN(value_as_number) AS DOUBLE) AS pmValue FROM gis_syn_dataset_5_4.exposure_occurrence WHERE value_as_number IS NOT NULL GROUP BY person_id;")
# labelTrainPol <- merge(x=labelTrain, y=pollutants, by.x = "subjectId", by.y = "SUBJECTID")
# 
# mySplit$Train$labels <- labelTrainPol
# 
# labelTest <- mySplit$Test$labels
# labelTestPol <- merge(x=labelTest, y=pollutants, by.x = "subjectId", by.y = "SUBJECTID")
# 
# mySplit$Test$labels <- labelTestPol
# 
# trainData <- mySplit$Train
# 
# testData <- mySplit$Test

## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# createPollutants <- function(
#                      method = 'QNCV'
#                      ){
# 
#   # create list of inputs to implement function
#   featureEngineeringSettings <- list(
#     method = method
#     )
# 
#   # specify the function that will implement the sampling
#   attr(featureEngineeringSettings, "fun") <- "implementPollutants"
# 
#   # make sure the object returned is of class "sampleSettings"
#   class(featureEngineeringSettings) <- "featureEngineeringSettings"
#   return(featureEngineeringSettings)
# 
# }
# 
# 
# implementPollutants <- function(trainData, featureEngineeringSettings, model=NULL) {
#   if (is.null(model)) {
#     method <- featureEngineeringSettings$method
#     gisData <- trainData$labels
#     y <- gisData$outcomeCount
#     X <- gisData$PMVALUE
#     model <- mgcv::gam(
#       y ~ s(X, bs='cr', k=5, m=2)
#     )
#     newData <- data.frame(
#       rowId = gisData$rowId,
#       covariateId = 2052499839,
#       covariateValue = model$fitted.values
#     )
#   }
#   else {
#     gisData <- trainData$labels
#     X <- gisData$PMVALUE
#     y <- gisData$outcomeCount
#     newData <- data.frame(y=y, X=X)
#     yHat <- predict(model, newData)
#     newData <- data.frame(
#       rowId = gisData$rowId,
#       covariateId = 2052499839,
#       covariateValue = yHat
#     )
#   }
#   # update covRef
#   Andromeda::appendToTable(trainData$covariateData$covariateRef,
#                            data.frame(covariateId=2052499839,
#                                       covariateName='Average PM2.5 Concentrations',
#                                       analysisId=1,
#                                       conceptId=2052499839))
# 
#   # update covariates
#   Andromeda::appendToTable(trainData$covariateData$covariates, newData)
# 
#   featureEngineering <- list(
#     funct = 'implementPollutants',
#     settings = list(
#       featureEngineeringSettings = featureEngineeringSettings,
#       model = model
#     )
#   )
# 
#   attr(trainData$covariateData, 'metaData')$featureEngineering = listAppend(
#     attr(trainData$covariateData, 'metaData')$featureEngineering,
#     featureEngineering
#   )
# 
#   trainData$model <- model
# 
#   return(trainData)
# }

## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# featureEngineeringSettingsPol <- createPollutants('QNCV')
# trainDataPol <- implementPollutants(trainData, featureEngineeringSettings)
# testDataPol <- implementPollutants(testData, featureEngineeringSettings, trainDataPol$model)

## ----echo=TRUE, message=FALSE, warning=FALSE, eval=FALSE----------------------
# analysisId <- '1'
# analysisPath = file.path(saveDirectory, analysisId)
# 
# settings <- list(
#   trainData = trainDataPol,
#   modelSettings = setLassoLogisticRegression(),
#   analysisId = analysisId,
#   analysisPath = analysisPath
# )
# 
# ParallelLogger::logInfo(sprintf('Training %s model',settings$modelSettings$name))
# model <- tryCatch(
#   {
#     do.call(fitPlp, settings)
#   },
#   error = function(e) { ParallelLogger::logError(e); return(NULL)}
# )
# 
# 
# prediction <- model$prediction
# # remove prediction from model
# model$prediction <- NULL
# 
# #apply to test data if exists:
# if('Test' %in% names(data)){
# predictionTest <- tryCatch(
#   {
# 	predictPlp(
# 	  plpModel = model,
# 	  plpData = testDataPol,
# 	  population = testDataPol$labels
# 	)
#   },
#   error = function(e) { ParallelLogger::logError(e); return(NULL)}
# )
# 
# predictionTest$evaluationType <- 'Test'
# 
# if(!is.null(predictionTest)){
#   prediction <- rbind(predictionTest, prediction[, colnames(prediction)!='index'])
# }
# 
# 
# }
# 

