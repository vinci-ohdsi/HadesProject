## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----eval=FALSE, echo = FALSE, message = FALSE, warning = FALSE---------------
# library(PatientLevelPrediction)
# vignetteDataFolder <- "s:/temp/plpVignette"
# # Load all needed data if it exists on this computer:
# if (file.exists(vignetteDataFolder)) {
#   plpModel <- loadPlpModel(vignetteDataFolder, "model")
#   lrResults <- loadPlpModel(file.path(vignetteDataFolder, "results"))
# }

## ----eval=FALSE---------------------------------------------------------------
# set.seed(1234)
# data(simulationProfile)
# sampleSize <- 12000
# plpData <- simulatePlpData(
#   plpDataSimulationProfile,
#   n = sampleSize,
#   seed = 42
# )

## ----eval=FALSE---------------------------------------------------------------
# populationSettings <- createStudyPopulationSettings(
#   binary = TRUE,
#   firstExposureOnly = FALSE,
#   washoutPeriod = 0,
#   removeSubjectsWithPriorOutcome = FALSE,
#   priorOutcomeLookback = 99999,
#   requireTimeAtRisk = FALSE,
#   minTimeAtRisk = 0,
#   riskWindowStart = 0,
#   riskWindowEnd = 365,
#   verbosity = "INFO"
# )

## ----eval=FALSE---------------------------------------------------------------
# # Use LASSO logistic regression
# modelSettings <- setLassoLogisticRegression()

## ----eval = FALSE-------------------------------------------------------------
# splitSettings <- createDefaultSplitSetting(
#   testFraction = 0.2,
#   type = "stratified",
#   splitSeed = 1000
# )
# 
# trainFractions <- seq(0.1, 0.8, 0.1) # Create eight training set fractions

## ----eval=FALSE---------------------------------------------------------------
# learningCurve <- createLearningCurve(
#   plpData = plpData,
#   outcomeId = 2,
#   parallel = TRUE,
#   cores = 4,
#   modelSettings = modelSettings,
#   saveDirectory = file.path(tempdir(), "learningCurve"),
#   analysisId = "learningCurve",
#   populationSettings = populationSettings,
#   splitSettings = splitSettings,
#   trainFractions = trainFractions,
#   trainEvents = NULL,
#   preprocessSettings = createPreprocessSettings(
#     minFraction = 0.001,
#     normalize = TRUE
#   ),
#   executeSettings = createExecuteSettings(
#     runSplitData = TRUE,
#     runSampleData = FALSE,
#     runFeatureEngineering = FALSE,
#     runPreprocessData = TRUE,
#     runModelDevelopment = TRUE,
#     runCovariateSummary = FALSE
#   )
# )

## ----eval=FALSE---------------------------------------------------------------
# plotLearningCurve(
#   learningCurve,
#   metric = "AUROC",
#   abscissa = "events",
#   plotTitle = "Learning Curve",
#   plotSubtitle = "AUROC performance"
# )

## ----eval=FALSE---------------------------------------------------------------
# # Show all demos in our package:
# demo(package = "PatientLevelPrediction")
# 
# # Run the learning curve
# demo("LearningCurveDemo", package = "PatientLevelPrediction")

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

