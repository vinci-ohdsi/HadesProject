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

