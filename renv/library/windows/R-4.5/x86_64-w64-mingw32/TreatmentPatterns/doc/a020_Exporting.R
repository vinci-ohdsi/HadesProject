## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

withr::local_envvar(
  R_USER_CACHE_DIR = tempfile(),
  EUNOMIA_DATA_FOLDER = Sys.getenv("EUNOMIA_DATA_FOLDER", unset = tempfile())
)

## ----minCellCount, eval=FALSE-------------------------------------------------
#  results <- export(
#    andromeda = defaultSettings,
#    minCellCount = 5
#  )

## ----censorType_cellCount, eval=FALSE-----------------------------------------
#  resultsA <- export(
#    andromeda = minEra60,
#    minCellCount = 5,
#    censorType = "minCellCount"
#  )

## ----censorType_remove, eval=FALSE--------------------------------------------
#  resultsB <- export(
#    andromeda = minEra60,
#    minCellCount = 5,
#    censorType = "remove"
#  )

## ----censorType_mean, eval=FALSE----------------------------------------------
#  resultsC <- export(
#    andromeda = minEra60,
#    minCellCount = 5,
#    censorType = "mean"
#  )

## ----ageWindow3, eval=FALSE---------------------------------------------------
#  resultsD <- export(
#    andromeda = splitAcuteTherapy,
#    minCellCount = 5,
#    censorType = "mean",
#    ageWindow = 3
#  )

## ----ageWindowMultiple, eval=FALSE--------------------------------------------
#  resultsE <- export(
#    andromeda = splitAcuteTherapy,
#    minCellCount = 5,
#    censorType = "mean",
#    ageWindow = c(0, 18, 25, 30, 40, 50, 60, 150)
#  )

## ----archiveName, eval=FALSE--------------------------------------------------
#  resultsF <- export(
#    andromeda = includeEndDate,
#    minCellCount = 5,
#    censorType = "mean",
#    ageWindow = 3,
#    archiveName = "output.zip"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  exportPatientLevel(
#    andromeda = outputEnv,
#    outputPath = tempdir()
#  )

