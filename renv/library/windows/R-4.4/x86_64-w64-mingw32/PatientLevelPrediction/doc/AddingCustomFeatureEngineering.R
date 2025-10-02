## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(PatientLevelPrediction)

## ----echo = TRUE, eval=FALSE--------------------------------------------------
# createAgeSpline <- function(knots = 5) {
#   # create list of inputs to implement function
#   featureEngineeringSettings <- list(
#     knots = knots
#   )
# 
#   # specify the function that will implement the sampling
#   attr(featureEngineeringSettings, "fun") <- "implementAgeSplines"
# 
#   # make sure the object returned is of class "sampleSettings"
#   class(featureEngineeringSettings) <- "featureEngineeringSettings"
#   return(featureEngineeringSettings)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# implementAgeSplines <- function(trainData, featureEngineeringSettings, model = NULL) {
#   # if there is a model, it means this function is called through applyFeatureengineering, meaning it   # should apply the model fitten on training data to the test data
#   if (is.null(model)) {
#     knots <- featureEngineeringSettings$knots
#     ageData <- trainData$labels
#     y <- ageData$outcomeCount
#     X <- ageData$ageYear
#     model <- mgcv::gam(
#       y ~ s(X, bs = "cr", k = knots, m = 2)
#     )
#     newData <- data.frame(
#       rowId = ageData$rowId,
#       covariateId = 2002,
#       covariateValue = model$fitted.values
#     )
#   } else {
#     ageData <- trainData$labels
#     X <- trainData$labels$ageYear
#     y <- ageData$outcomeCount
#     newData <- data.frame(y = y, X = X)
#     yHat <- predict(model, newData)
#     newData <- data.frame(
#       rowId = trainData$labels$rowId,
#       covariateId = 2002,
#       covariateValue = yHat
#     )
#   }
# 
#   # remove existing age if in covariates
#   trainData$covariateData$covariates <- trainData$covariateData$covariates |>
#     dplyr::filter(!.data$covariateId %in% c(1002))
# 
#   # update covRef
#   Andromeda::appendToTable(
#     trainData$covariateData$covariateRef,
#     data.frame(
#       covariateId = 2002,
#       covariateName = "Cubic restricted age splines",
#       analysisId = 2,
#       conceptId = 2002
#     )
#   )
# 
#   # update covariates
#   Andromeda::appendToTable(trainData$covariateData$covariates, newData)
# 
#   featureEngineering <- list(
#     funct = "implementAgeSplines",
#     settings = list(
#       featureEngineeringSettings = featureEngineeringSettings,
#       model = model
#     )
#   )
# 
#   attr(trainData$covariateData, "metaData")$featureEngineering <- listAppend(
#     attr(trainData$covariateData, "metaData")$featureEngineering,
#     featureEngineering
#   )
# 
#   return(trainData)
# }

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

