## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(PatientLevelPrediction)

## ----echo = TRUE, eval=FALSE--------------------------------------------------
# attr(param, "settings") <- list(
#   seed = 12,
#   modelName = "Special classifier"
# )

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# setMadeUp <- function(a = c(1, 4, 10), b = 2, seed = NULL) {
#   # add input checks here...
# 
#   param <- split(
#     expand.grid(
#       a = a,
#       b = b
#     ),
#     1:(length(a) * length(b))
#   )
# 
#   attr(param, "settings") <- list(
#     modelName = "Made Up",
#     requiresDenseMatrix = TRUE,
#     seed = seed
#   )
# 
#   # now create list of all combinations:
#   result <- list(
#     fitFunction = "fitMadeUp", # this will be called to train the made up model
#     param = param
#   )
#   class(result) <- "modelSettings"
# 
#   return(result)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# fitMadeUp <- function(trainData, modelSettings, search, analysisId) {
#   param <- modelSettings$param
# 
#   # **************** code to train the model here
#   # trainedModel <- this code should apply each hyper-parameter combination
#   # (param[[i]]) using the specified search (e.g., cross validation)
#   #                 then pick out the best hyper-parameter setting
#   #                 and finally fit a model on the whole train data using the
#   #                 optimal hyper-parameter settings
#   # ****************
# 
#   # **************** code to apply the model to trainData
#   # prediction <- code to apply trainedModel to trainData
#   # ****************
# 
#   # **************** code to get variable importance (if possible)
#   # varImp <- code to get importance of each variable in trainedModel
#   # ****************
# 
# 
#   # construct the standard output for a model:
#   result <- list(
#     model = trainedModel,
#     prediction = prediction, # the train and maybe the cross validation predictions for the trainData
#     preprocessing = list(
#       featureEngineering = attr(trainData$covariateData, "metaData")$featureEngineering,
#       tidyCovariates = attr(trainData$covariateData, "metaData")$tidyCovariateDataSettings,
#       requireDenseMatrix = attr(param, "settings")$requiresDenseMatrix,
#     ),
#     modelDesign = list(
#       outcomeId = attr(trainData, "metaData")$outcomeId,
#       targetId = attr(trainData, "metaData")$targetId,
#       plpDataSettings = attr(trainData, "metaData")$plpDataSettings,
#       covariateSettings = attr(trainData, "metaData")$covariateSettings,
#       populationSettings = attr(trainData, "metaData")$populationSettings,
#       featureEngineeringSettings = attr(trainData$covariateData, "metaData")$featureEngineeringSettings,
#       prerocessSettings = attr(trainData$covariateData, "metaData")$prerocessSettings,
#       modelSettings = list(
#         model = attr(param, "settings")$modelName, # the model name
#         param = param,
#         finalModelParameters = param[[bestInd]], # best hyper-parameters
#         extraSettings = attr(param, "settings")
#       ),
#       splitSettings = attr(trainData, "metaData")$splitSettings,
#       sampleSettings = attr(trainData, "metaData")$sampleSettings
#     ),
#     trainDetails = list(
#       analysisId = analysisId,
#       developmentDatabase = attr(trainData, "metaData")$cdmDatabaseSchema,
#       attrition = attr(trainData, "metaData")$attrition,
#       trainingTime = timeToTrain, # how long it took to train the model
#       trainingDate = Sys.Date(),
#       hyperParamSearch = hyperSummary # the hyper-parameters and performance data.frame
#     ),
#     covariateImportance = merge(trainData$covariateData$covariateRef, varImp, by = "covariateId") # add variable importance to covariateRef if possible
#   )
#   class(result) <- "plpModel"
#   attr(result, "predictionFunction") <- "madeupPrediction"
#   attr(result, "modelType") <- "binary"
#   return(result)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# madeupPrediction <- function(plpModel, data, cohort) {
#   # ************* code to do prediction for each rowId in cohort
#   # predictionValues <- code to do prediction here returning the predicted risk
#   #               (value) for each rowId in cohort
#   #**************
# 
#   prediction <- merge(cohort, predictionValues, by = "rowId")
#   attr(prediction, "metaData") <- list(modelType = attr(plpModel, "modelType"))
#   return(prediction)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# setMadeUp <- function(a = c(1, 4, 6), b = 2, seed = NULL) {
#   # add input checks here...
# 
#   if (is.null(seed)) {
#     seed <- sample(100000, 1)
#   }
# 
#   param <- split(
#     expand.grid(
#       a = a,
#       b = b
#     ),
#     1:(length(a) * length(b))
#   )
# 
#   attr(param, "settings") <- list(
#     modelName = "Made Up",
#     requiresDenseMatrix = TRUE,
#     seed = seed
#   )
# 
#   # now create list of all combinations:
#   result <- list(
#     fitFunction = "fitMadeUp", # this will be called to train the made up model
#     param = param
#   )
#   class(result) <- "modelSettings"
# 
#   return(result)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# fitMadeUp <- function(trainData, modelSettings, search, analysisId) {
#   # set the seed for reproducibility
#   param <- modelSettings$param
#   set.seed(attr(param, "settings")$seed)
# 
#   # add folds to labels:
#   trainData$labels <- merge(trainData$labels, trainData$folds, by = "rowId")
#   # convert data into sparse R Matrix:
#   mappedData <- toSparseM(trainData, map = NULL)
#   matrixData <- mappedData$dataMatrix
#   labels <- mappedData$labels
#   covariateRef <- mappedData$covariateRef
# 
#   # ============= STEP 1 ======================================
#   # pick the best hyper-params and then do final training on all data...
#   writeLines("Cross validation")
#   paramSel <- lapply(
#     param,
#     function(x) {
#       do.call(
#         madeUpModel,
#         list(
#           param = x,
#           final = FALSE,
#           data = matrixData,
#           labels = labels
#         )
#       )
#     }
#   )
#   hyperSummary <- do.call(rbind, lapply(paramSel, function(x) x$hyperSum))
#   hyperSummary <- as.data.frame(hyperSummary)
#   hyperSummary$auc <- unlist(lapply(paramSel, function(x) x$auc))
#   paramSel <- unlist(lapply(paramSel, function(x) x$auc))
#   bestInd <- which.max(paramSel)
# 
#   # get cross val prediction for best hyper-parameters
#   prediction <- param.sel[[bestInd]]$prediction
#   prediction$evaluationType <- "CV"
# 
#   writeLines("final train")
#   finalResult <- do.call(
#     madeUpModel,
#     list(
#       param = param[[bestInd]],
#       final = TRUE,
#       data = matrixData,
#       labels = labels
#     )
#   )
# 
#   trainedModel <- finalResult$model
# 
#   # prediction risk on training data:
#   finalResult$prediction$evaluationType <- "Train"
# 
#   # get CV and train prediction
#   prediction <- rbind(prediction, finalResult$prediction)
# 
#   varImp <- covariateRef %>% dplyr::collect()
#   # no feature importance available
#   vqrImp$covariateValue <- 0
# 
#   timeToTrain <- Sys.time() - start
# 
#   # construct the standard output for a model:
#   result <- list(
#     model = trainedModel,
#     prediction = prediction,
#     preprocessing = list(
#       featureEngineering = attr(trainData$covariateData, "metaData")$featureEngineering,
#       tidyCovariates = attr(trainData$covariateData, "metaData")$tidyCovariateDataSettings,
#       requireDenseMatrix = attr(param, "settings")$requiresDenseMatrix,
#     ),
#     modelDesign = list(
#       outcomeId = attr(trainData, "metaData")$outcomeId,
#       targetId = attr(trainData, "metaData")$targetId,
#       plpDataSettings = attr(trainData, "metaData")$plpDataSettings,
#       covariateSettings = attr(trainData, "metaData")$covariateSettings,
#       populationSettings = attr(trainData, "metaData")$populationSettings,
#       featureEngineeringSettings = attr(trainData$covariateData, "metaData")$featureEngineeringSettings,
#       prerocessSettings = attr(trainData$covariateData, "metaData")$prerocessSettings,
#       modelSettings = list(
#         model = attr(param, "settings")$modelName, # the model name
#         param = param,
#         finalModelParameters = param[[bestInd]], # best hyper-parameters
#         extraSettings = attr(param, "settings")
#       ),
#       splitSettings = attr(trainData, "metaData")$splitSettings,
#       sampleSettings = attr(trainData, "metaData")$sampleSettings
#     ),
#     trainDetails = list(
#       analysisId = analysisId,
#       developmentDatabase = attr(trainData, "metaData")$cdmDatabaseSchema,
#       attrition = attr(trainData, "metaData")$attrition,
#       trainingTime = timeToTrain, # how long it took to train the model
#       trainingDate = Sys.Date(),
#       hyperParamSearch = hyperSummary # the hyper-parameters and performance data.frame
#     ),
#     covariateImportance = merge(trainData$covariateData$covariateRef, varImp, by = "covariateId") # add variable importance to covariateRef if possible
#   )
#   class(result) <- "plpModel"
#   attr(result, "predictionFunction") <- "madeupPrediction"
#   attr(result, "modelType") <- "binary"
#   return(result)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# madeUpModel <- function(param, data, final = FALSE, labels) {
#   if (final == FALSE) {
#     # add value column to store all predictions
#     labels$value <- rep(0, nrow(labels))
#     attr(labels, "metaData") <- list(modelType = "binary")
# 
#     foldPerm <- c() # this holds CV aucs
#     for (index in 1:max(labels$index)) {
#       model <- madeup::model(
#         x = data[labels$index != index, ], # remove left out fold
#         y = labels$outcomeCount[labels$index != index],
#         a = param$a,
#         b = param$b
#       )
# 
#       # predict on left out fold
#       pred <- stats::predict(model, data[labels$index == index, ])
#       labels$value[labels$index == index] <- pred
# 
#       # calculate auc on help out fold
#       aucVal <- computeAuc(labels[labels$index == index, ])
#       foldPerm <- c(foldPerm, aucVal)
#     }
#     auc <- computeAuc(labels) # overal AUC
#   } else {
#     model <- madeup::model(
#       x = data,
#       y = labels$outcomeCount,
#       a = param$a,
#       b = param$b
#     )
# 
#     pred <- stats::predict(model, data)
#     labels$value <- pred
#     attr(labels, "metaData") <- list(modelType = "binary")
#     auc <- computeAuc(labels)
#     foldPerm <- auc
#   }
# 
#   result <- list(
#     model = model,
#     auc = auc,
#     prediction = labels,
#     hyperSum = c(a = a, b = b, fold_auc = foldPerm)
#   )
# 
#   return(result)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# madeupPrediction <- function(plpModel, data, cohort) {
#   if (class(data) == "plpData") {
#     # convert
#     matrixObjects <- toSparseM(
#       plpData = data,
#       cohort = cohort,
#       map = plpModel$covariateImportance %>%
#         dplyr::select("columnId", "covariateId")
#     )
# 
#     newData <- matrixObjects$dataMatrix
#     cohort <- matrixObjects$labels
#   } else {
#     newData <- data
#   }
# 
#   if (class(plpModel) == "plpModel") {
#     model <- plpModel$model
#   } else {
#     model <- plpModel
#   }
# 
#   cohort$value <- stats::predict(model, newData)
# 
#   # fix the rowIds to be the old ones
#   # now use the originalRowId and remove the matrix rowId
#   cohort <- cohort %>%
#     dplyr::select(-"rowId") %>%
#     dplyr::rename(rowId = "originalRowId")
# 
#   attr(cohort, "metaData") <- list(modelType = attr(plpModel, "modelType"))
#   return(cohort)
# }

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

