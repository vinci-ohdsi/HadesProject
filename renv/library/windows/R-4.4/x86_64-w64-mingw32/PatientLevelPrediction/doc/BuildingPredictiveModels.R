## ----echo=FALSE,message=FALSE,warning=FALSE,eval=TRUE-------------------------
library(PatientLevelPrediction)
vignetteDataFolder <- "s:/temp/plpVignette"
# Load all needed data if it exists on this computer:
if (file.exists(vignetteDataFolder)) {
  plpModel <- loadPlpModel(file.path(vignetteDataFolder, "model"))
  lrResults <- loadPlpModel(file.path(vignetteDataFolder, "results"))
}

## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(PatientLevelPrediction)

## ----table2, echo=FALSE, message=FALSE, warnings=FALSE, results='asis'--------
tabl <- "
| Algorihm | Description | Hyper-parameters |
| ----------| ---------------------------------------------------| ----------------------- |
| Regularized Logistic Regression | Lasso logistic regression belongs to the family of generalized linear models, where a linear combination of the variables is learned and finally a logistic function maps the linear combination to a value between 0 and 1.  The lasso regularization adds a cost based on model complexity to the objective function when training the model.  This cost is the sum of the absolute values of the linear combination of the coefficients.  The model automatically performs feature selection by minimizing this cost. We use the Cyclic coordinate descent for logistic, Poisson and survival analysis (Cyclops) package to perform large-scale regularized logistic regression: https://github.com/OHDSI/Cyclops | var  (starting  variance), seed |
| Gradient boosting machines | Gradient boosting machines is a boosting ensemble technique and in our framework it combines multiple decision trees.  Boosting works by iteratively adding decision trees but adds more weight to the data-points that are misclassified by prior decision trees in the cost function when training the next tree.  We use Extreme Gradient Boosting, which is an efficient implementation of the gradient boosting framework implemented in the xgboost R package available from CRAN. | ntree (number of trees), max depth (max levels in tree), min rows (minimum data points in in node), learning rate, balance (balance class labels), seed  |
| Random forest | Random forest is a bagging ensemble technique that combines multiple decision trees.  The idea behind bagging is to reduce the likelihood of overfitting, by using weak classifiers, but combining multiple diverse weak classifiers into a strong classifier.  Random forest accomplishes this by training multiple decision trees but only using a subset of the variables in each tree and the subset of variables differ between trees. Our packages uses the sklearn learn implementation of Random Forest in python. | mtry  (number  of  features  in  each  tree),ntree (number of trees), maxDepth (max levels in tree), minRows (minimum data points in in node),balance (balance class labels), seed  |
| Naive Bayes | The Naive Bayes algorithm applies the Bayes theorem with the 'naive' assumption of conditional independence between every pair of features given the value of the class variable. Based on the likelihood the data belongs to a class and the prior distribution of the class, a posterior distribution is obtained.  | none |
| AdaBoost | AdaBoost is a boosting ensemble technique. Boosting works by iteratively adding classifiers but adds more weight to the data-points that are misclassified by prior classifiers in the cost function when training the next classifier. We use the sklearn 'AdaboostClassifier' implementation in Python. | nEstimators (the maximum number of estimators at which boosting is terminated), learningRate (learning rate shrinks the contribution of each classifier by learning_rate. There is a trade-off between learningRate and nEstimators) |
| Decision Tree | A decision tree is a classifier that partitions the variable space using individual tests selected using a greedy approach.  It aims to find partitions that have the highest information gain to separate the classes.  The decision tree can easily overfit by enabling a large number of partitions (tree depth) and often needs some regularization (e.g., pruning or specifying hyper-parameters that limit the complexity of the model). We use the sklearn 'DecisionTreeClassifier' implementation in Python. | maxDepth (the maximum depth of the tree), minSamplesSplit,minSamplesLeaf, minImpuritySplit (threshold for early stopping in tree growth. A node will split if its impurity is above the threshold, otherwise it is a leaf.), seed,classWeight ('Balance' or 'None') |
| Multilayer Perception | Neural networks contain multiple layers that weight their inputs using a non-linear function.  The first layer is the input layer, the last layer is the output layer the between are the hidden layers.  Neural networks are generally trained using feed forward back-propagation.  This is when you go through the network with a data-point and calculate the error between the true label and predicted label, then go backwards through the network and update the linear function weights based on the error.  | size (the number of hidden nodes), alpha (the l2 regularisation), seed |
| Deep Learning (now in seperate DeepPatientLevelPrediction R package) | Deep learning such as deep nets, convolutional neural networks or recurrent neural networks are similar to a neural network but have multiple hidden layers that aim to learn latent representations useful for prediction. | see: https://github.com/OHDSI/DeepPatientLevelPrediction|
"
cat(tabl) # output the table in a format good for HTML/PDF/docx conversion

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(DatabaseConnector)
# connectionDetails <- createConnectionDetails(
#   dbms = "postgresql",
#   server = "localhost/ohdsi",
#   user = "joe",
#   password = "supersecret"
# )
# 
# cdmDatabaseSchema <- "cdm"
# cohortsDatabaseSchema <- "cohorts"
# cdmVersion <- "5"

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(SqlRender)
# sql <- readSql("AfStrokeCohorts.sql")
# sql <- render(sql,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cohortsDatabaseSchema = cohortsDatabaseSchema
# )
# sql <- translate(sql, targetDialect = connectionDetails$dbms)
# 
# connection <- connect(connectionDetails)
# executeSql(connection, sql)

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# sql <- paste(
#   "SELECT cohort_definition_id, COUNT(*) AS count",
#   "FROM @cohortsDatabaseSchema.AFibStrokeCohort",
#   "GROUP BY cohort_definition_id"
# )
# sql <- render(sql, cohortsDatabaseSchema = cohortsDatabaseSchema)
# sql <- translate(sql, targetDialect = connectionDetails$dbms)
# 
# querySql(connection, sql)

## ----echo=FALSE,message=FALSE-------------------------------------------------
data.frame(cohort_definition_id = c(1, 2), count = c(527616, 221555))

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(FeatureExtraction)
# covariateSettings <- createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAge = TRUE,
#   useConditionGroupEraLongTerm = TRUE,
#   useConditionGroupEraAnyTimePrior = TRUE,
#   useDrugGroupEraLongTerm = TRUE,
#   useDrugGroupEraAnyTimePrior = TRUE,
#   useVisitConceptCountLongTerm = TRUE,
#   longTermStartDays = -365,
#   endDays = -1
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(PatientLevelPrediction)
# databaseDetails <- createDatabaseDetails(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cdmDatabaseName = "",
#   cohortDatabaseSchema = cohortsDatabaseSchema,
#   cohortTable = "AFibStrokeCohort",
#   targetId = 1,
#   outcomeDatabaseSchema = cohortsDatabaseSchema,
#   outcomeTable = "AFibStrokeCohort",
#   outcomeIds = 2,
#   cdmVersion = 5
# )
# 
# # here you can define whether you want to sample the target cohort and add any
# # restrictions based on minimum prior observation, index date restrictions
# # or restricting to first index date (if people can be in target cohort multiple times)
# restrictPlpDataSettings <- createRestrictPlpDataSettings(sampleSize = 10000)
# 
# plpData <- getPlpData(
#   databaseDetails = databaseDetails,
#   covariateSettings = covariateSettings,
#   restrictPlpDataSettings = restrictPlpDataSettings
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpData(plpData, "stroke_in_af_data")

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# populationSettings <- createStudyPopulationSettings(
#   washoutPeriod = 1095,
#   firstExposureOnly = FALSE,
#   removeSubjectsWithPriorOutcome = FALSE,
#   priorOutcomeLookback = 1,
#   riskWindowStart = 1,
#   riskWindowEnd = 365,
#   startAnchor = "cohort start",
#   endAnchor = "cohort start",
#   minTimeAtRisk = 364,
#   requireTimeAtRisk = TRUE,
#   includeAllOutcomes = TRUE
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# splitSettings <- createDefaultSplitSetting(
#   trainFraction = 0.75,
#   testFraction = 0.25,
#   type = "stratified",
#   nfold = 2,
#   splitSeed = 1234
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# sampleSettings <- createSampleSettings()

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# featureEngineeringSettings <- createFeatureEngineeringSettings()

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# preprocessSettingsSettings <- createPreprocessSettings(
#   minFraction = 0.01,
#   normalize = TRUE,
#   removeRedundancy = TRUE
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# lrModel <- setLassoLogisticRegression()

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# lrResults <- runPlp(
#   plpData = plpData,
#   outcomeId = 2,
#   analysisId = "singleDemo",
#   analysisName = "Demonstration of runPlp for training single PLP models",
#   populationSettings = populationSettings,
#   splitSettings = splitSettings,
#   sampleSettings = sampleSettings,
#   featureEngineeringSettings = featureEngineeringSettings,
#   preprocessSettings = preprocessSettings,
#   modelSettings = lrModel,
#   logSettings = createLogSettings(),
#   executeSettings = createExecuteSettings(
#     runSplitData = TRUE,
#     runSampleData = TRUE,
#     runFeatureEngineering = TRUE,
#     runPreprocessData = TRUE,
#     runModelDevelopment = TRUE,
#     runCovariateSummary = TRUE
#   ),
#   saveDirectory = file.path(tempdir(), "singlePlp")
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpModel(lrResults$model, dirPath = file.path(tempdir(), "model"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# plpModel <- loadPlpModel(file.path(tempdir(), "model"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpResult(lrResults, location = file.path(tempdir(), "lr"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# lrResults <- loadPlpResult(file.path(tempdir(), "lr"))

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# connectionDetails <- createConnectionDetails(
#   dbms = "postgresql",
#   server = "localhost/ohdsi",
#   user = "joe",
#   password = "supersecret"
# )
# 
# cdmDatabaseSchema <- "my_cdm_data"
# cohortsDatabaseSchema <- "my_results"
# cdmVersion <- "5"

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# library(SqlRender)
# sql <- readSql("AceAngioCohorts.sql")
# sql <- render(sql,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cohortsDatabaseSchema = cohortsDatabaseSchema
# )
# sql <- translate(sql, targetDialect = connectionDetails$dbms)
# 
# connection <- connect(connectionDetails)
# executeSql(connection, sql)

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# sql <- paste(
#   "SELECT cohort_definition_id, COUNT(*) AS count",
#   "FROM @cohortsDatabaseSchema.AceAngioCohort",
#   "GROUP BY cohort_definition_id"
# )
# sql <- render(sql, cohortsDatabaseSchema = cohortsDatabaseSchema)
# sql <- translate(sql, targetDialect = connectionDetails$dbms)
# 
# querySql(connection, sql)

## ----echo=FALSE,message=FALSE-------------------------------------------------
data.frame(cohort_definition_id = c(1, 2), count = c(0, 0))

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# covariateSettings <- createCovariateSettings(
#   useDemographicsGender = TRUE,
#   useDemographicsAge = TRUE,
#   useConditionGroupEraLongTerm = TRUE,
#   useConditionGroupEraAnyTimePrior = TRUE,
#   useDrugGroupEraLongTerm = TRUE,
#   useDrugGroupEraAnyTimePrior = TRUE,
#   useVisitConceptCountLongTerm = TRUE,
#   longTermStartDays = -365,
#   endDays = -1
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# databaseDetails <- createDatabaseDetails(
#   connectionDetails = connectionDetails,
#   cdmDatabaseSchema = cdmDatabaseSchema,
#   cohortDatabaseSchema = resultsDatabaseSchema,
#   cohortTable = "AceAngioCohort",
#   cohortId = 1,
#   outcomeDatabaseSchema = resultsDatabaseSchema,
#   outcomeTable = "AceAngioCohort",
#   outcomeIds = 2
# )
# 
# restrictPlpDataSettings <- createRestrictPlpDataSettings(
#   sampleSize = 10000
# )
# 
# plpData <- getPlpData(
#   databaseDetails = databaseDetails,
#   covariateSettings = covariateSettings,
#   restrictPlpDataSettings = restrictPlpDataSettings
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpData(plpData, "angio_in_ace_data")

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# populationSettings <- createStudyPopulationSettings(
#   washoutPeriod = 364,
#   firstExposureOnly = FALSE,
#   removeSubjectsWithPriorOutcome = TRUE,
#   priorOutcomeLookback = 9999,
#   riskWindowStart = 1,
#   riskWindowEnd = 365,
#   minTimeAtRisk = 364,
#   startAnchor = "cohort start",
#   endAnchor = "cohort start",
#   requireTimeAtRisk = TRUE,
#   includeAllOutcomes = TRUE
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# splitSettings <- createDefaultSplitSetting(
#   trainFraction = 0.75,
#   testFraction = 0.25,
#   type = "stratified",
#   nfold = 2,
#   splitSeed = 1234
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# sampleSettings <- createSampleSettings()

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# featureEngineeringSettings <- createFeatureEngineeringSettings()

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# preprocessSettingsSettings <- createPreprocessSettings(
#   minFraction = 0.01,
#   normalize = TRUE,
#   removeRedundancy = TRUE
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# gbmModel <- setGradientBoostingMachine(
#   ntrees = 5000,
#   maxDepth = c(4, 7, 10),
#   learnRate = c(0.001, 0.01, 0.1, 0.9)
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# gbmResults <- runPlp(
#   plpData = plpData,
#   outcomeId = 2,
#   analysisId = "singleDemo2",
#   analysisName = "Demonstration of runPlp for training single PLP models",
#   populationSettings = populationSettings,
#   splitSettings = splitSettings,
#   sampleSettings = sampleSettings,
#   featureEngineeringSettings = featureEngineeringSettings,
#   preprocessSettings = preprocessSettings,
#   modelSettings = gbmModel,
#   logSettings = createLogSettings(),
#   executeSettings = createExecuteSettings(
#     runSplitData = TRUE,
#     runSampleData = TRUE,
#     runFeatureEngineering = TRUE,
#     runPreprocessData = TRUE,
#     runModelDevelopment = TRUE,
#     runCovariateSummary = TRUE
#   ),
#   saveDirectory = file.path(tempdir(), "singlePlpExample2")
# )

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpModel(gbmResults$model, dirPath = file.path(tempdir(), "model"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# plpModel <- loadPlpModel(file.path(tempdir(), "model"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# savePlpResult(gbmResults, location = file.path(tempdir(), "gbm"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# gbmResults <- loadPlpResult(file.path(file.path(tempdir(), "gbm"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# plotPlp(lrResults, dirPath = file.path(tempdir(), "plots"))

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# plotSmoothCalibration(lrResults)

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# precision <- Tp / (Tp + Fp)

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# recall <- Tp / (Tp + Fn)

## ----tidy=TRUE,eval=FALSE-----------------------------------------------------
# f1Score <- 2 * P * R / (P + R)

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# # load the trained model
# plpModel <- loadPlpModel(file.path(tempdir(), "model"), "model")
# 
# # add details of new database
# validationDatabaseDetails <- createDatabaseDetails()
# 
# # to externally validate the model and perform recalibration run:
# externalValidateDbPlp(
#   plpModel = plpModel,
#   validationDatabaseDetails = validationDatabaseDetails,
#   validationRestrictPlpDataSettings = plpModel$settings$plpDataSettings,
#   settings = createValidationSettings(
#     recalibrate = "weakRecalibration"
#   ),
#   outputFolder = file.path(tempdir(), "validation")
# )

## ----eval=FALSE---------------------------------------------------------------
# # Show all demos in our package:
# demo(package = "PatientLevelPrediction")
# 
# # For example, to run the SingleModelDemo that runs Lasso and shows you how to run the Shiny App use this call
# demo("SingleModelDemo", package = "PatientLevelPrediction")

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("Cyclops")

