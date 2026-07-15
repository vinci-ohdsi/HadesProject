## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(PatientLevelPrediction)

## ----echo = TRUE, eval=FALSE--------------------------------------------------
# createRandomSampleSettings <- function(n = 10000,
#                                        sampleSeed = sample(10000, 1)) {
#   # add input checks
#   checkIsClass(n, c("numeric", "integer"))
#   checkHigher(n, 0)
#   checkIsClass(sampleSeed, c("numeric", "integer"))
# 
#   # create list of inputs to implement function
#   sampleSettings <- list(
#     n = n,
#     sampleSeed = sampleSeed
#   )
# 
#   # specify the function that will implement the sampling
#   attr(sampleSettings, "fun") <- "implementRandomSampleSettings"
# 
#   # make sure the object returned is of class "sampleSettings"
#   class(sampleSettings) <- "sampleSettings"
#   return(sampleSettings)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# implementRandomSampleSettings <- function(trainData, sampleSettings) {
#   n <- sampleSettings$n
#   sampleSeed <- sampleSettings$sampleSeed
# 
#   if (n > nrow(trainData$labels)) {
#     stop("Sample n bigger than training population")
#   }
# 
#   # set the seed for the randomization
#   set.seed(sampleSeed)
# 
#   # now implement the code to do your desired sampling
# 
#   sampleRowIds <- sample(trainData$labels$rowId, n)
# 
#   sampleTrainData <- list()
# 
#   sampleTrainData$labels <- trainData$labels %>%
#     dplyr::filter(.data$rowId %in% sampleRowIds) %>%
#     dplyr::collect()
# 
#   sampleTrainData$folds <- trainData$folds %>%
#     dplyr::filter(.data$rowId %in% sampleRowIds) %>%
#     dplyr::collect()
# 
#   sampleTrainData$covariateData <- Andromeda::andromeda()
#   sampleTrainData$covariateData$covariateRef <- trainData$covariateData$covariateRef
#   sampleTrainData$covariateData$covariates <- trainData$covariateData$covariates %>% dplyr::filter(.data$rowId %in% sampleRowIds)
# 
#   # update metaData$populationSize
#   metaData <- attr(trainData$covariateData, "metaData")
#   metaData$populationSize <- n
#   attr(sampleTrainData$covariateData, "metaData") <- metaData
# 
#   # make the cocvariateData the correct class
#   class(sampleTrainData$covariateData) <- "CovariateData"
# 
#   # return the updated trainData
#   return(sampleTrainData)
# }

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

