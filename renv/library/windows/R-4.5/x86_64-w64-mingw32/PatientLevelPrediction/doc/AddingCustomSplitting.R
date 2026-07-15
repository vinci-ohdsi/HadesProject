## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(PatientLevelPrediction)

## ----echo = TRUE, eval=FALSE--------------------------------------------------
# createGenderSplit <- function(nfold) {
#   # create list of inputs to implement function
#   splitSettings <- list(nfold = nfold)
# 
#   # specify the function that will implement the sampling
#   attr(splitSettings, "fun") <- "implementGenderSplit"
# 
#   # make sure the object returned is of class "sampleSettings"
#   class(splitSettings) <- "splitSettings"
#   return(splitSettings)
# }

## ----tidy=FALSE,eval=FALSE----------------------------------------------------
# implementGenderSplit <- function(population, splitSettings) {
#   # find the people who are male:
#   males <- population$rowId[population$gender == 8507]
#   females <- population$rowId[population$gender == 8532]
# 
#   splitIds <- data.frame(
#     rowId = c(males, females),
#     index = c(
#       rep(-1, length(males)),
#       sample(1:splitSettings$nfold, length(females), replace = TRUE)
#     )
#   )
# 
#   # return the updated trainData
#   return(splitIds)
# }

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

