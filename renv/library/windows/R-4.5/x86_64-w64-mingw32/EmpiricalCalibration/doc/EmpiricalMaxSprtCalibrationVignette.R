## ----echo = FALSE, message = FALSE, warning = FALSE---------------------------
library(EmpiricalCalibration)
allCvsAndLlrs <- readRDS("allCvsAndLlrs.rds")
set.seed(123)

doEval <- require("Cyclops", quietly = TRUE)
cv <- NA

## ----eval=doEval--------------------------------------------------------------
maxSprtSimulationData <- simulateMaxSprtData(
  n = 10000,
  pExposure = 0.5,
  backgroundHazard = 0.001,
  tar = 10,
  nullMu = 0.2,
  nullSigma = 0.2,
  maxT = 100,
  looks = 10,
  numberOfNegativeControls = 50,
  numberOfPositiveControls = 1,
  positiveControlEffectSize = 4
)
head(maxSprtSimulationData)

## ----warning=FALSE,eval=doEval------------------------------------------------
library(Cyclops)
library(survival)

dataOutcome51 <- maxSprtSimulationData[maxSprtSimulationData$outcomeId == 51, ]
dataOutcome51LookT50 <- dataOutcome51[dataOutcome51$lookTime == 50, ]

cyclopsData <- createCyclopsData(
  Surv(time, outcome) ~ exposure , 
  modelType = "cox", 
  data = dataOutcome51LookT50
)
fit <- fitCyclopsModel(cyclopsData)
coef(fit)

## ----eval=doEval--------------------------------------------------------------
# Maximum log likelihood:
fit$log_likelihood

## ----eval=doEval--------------------------------------------------------------
llNull <- getCyclopsProfileLogLikelihood(
  object = fit,
  parm = "exposureTRUE",
  x = 0
)$value
llNull

## ----eval=doEval--------------------------------------------------------------
if (fit$return_flag == "ILLCONDITIONED" || coef(fit) < 0) {
  llr <- 0
} else {
  llr <- fit$log_likelihood - llNull
}
llr

## ----eval=doEval--------------------------------------------------------------
outcomesPerLook <- aggregate(outcome ~ lookTime, dataOutcome51, sum)
# Need incremental outcomes per look:
outcomesPerLook <- outcomesPerLook$outcome[order(outcomesPerLook$lookTime)]
outcomesPerLook[2:10] <- outcomesPerLook[2:10] - outcomesPerLook[1:9]

exposedTime <- sum(dataOutcome51$time[dataOutcome51$exposure == TRUE & 
                                        dataOutcome51$lookTime == 100])
unexposedTime <- sum(dataOutcome51$time[dataOutcome51$exposure == FALSE & 
                                          dataOutcome51$lookTime == 100])
cv <- computeCvBinomial(
  groupSizes = outcomesPerLook,
  z = unexposedTime / exposedTime,
  minimumEvents = 1,
  alpha = 0.05
)
cv

## ----eval=doEval--------------------------------------------------------------
llr > cv

## ----eval=doEval--------------------------------------------------------------
llProfileOutcome51LookT50 <- getCyclopsProfileLogLikelihood(
  object = fit,
  parm = "exposureTRUE",
  bounds = log(c(0.1, 10))
)
head(llProfileOutcome51LookT50)

## ----eval=doEval--------------------------------------------------------------
library(ggplot2)
ggplot(llProfileOutcome51LookT50, aes(x = point, y = value)) +
  geom_line()

## ----eval=doEval--------------------------------------------------------------
negativeControlProfilesLookT50 <- list()
dataLookT50 <- maxSprtSimulationData[maxSprtSimulationData$lookTime == 50, ]
for (i in 1:50) {
  dataOutcomeIlookT50 <- dataLookT50[dataLookT50$outcomeId == i, ]
  cyclopsData <- createCyclopsData(
    Surv(time, outcome) ~ exposure , 
    modelType = "cox", 
    data = dataOutcomeIlookT50
  )
  fit <- fitCyclopsModel(cyclopsData)
  llProfile <- getCyclopsProfileLogLikelihood(
    object = fit,
    parm = "exposureTRUE",
    bounds = log(c(0.1, 10))
  )
  negativeControlProfilesLookT50[[i]] <- llProfile
}

## ----eval=doEval--------------------------------------------------------------
nullLookT50 <- fitNullNonNormalLl(negativeControlProfilesLookT50)
nullLookT50

## ----eval=doEval--------------------------------------------------------------
calibratedCv <- computeCvBinomial(
  groupSizes = outcomesPerLook,
  z = unexposedTime / exposedTime,
  minimumEvents = 1,
  alpha = 0.05,
  nullMean = nullLookT50[1],
  nullSd = nullLookT50[2]
)
calibratedCv

## ----eval=doEval--------------------------------------------------------------
llr > calibratedCv

## ----eval=FALSE---------------------------------------------------------------
# allCvsAndLlrs <- data.frame()
# for (t in unique(maxSprtSimulationData$lookTime)) {
# 
#   # Compute likelihood profiles and LLR for all negative controls:
#   negativeControlProfilesLookTt <- list()
#   llrsLookTt <- c()
#   dataLookTt <- maxSprtSimulationData[maxSprtSimulationData$lookTime == t, ]
#   for (i in 1:50) {
#     dataOutcomeIlookTt <- dataLookTt[dataLookTt$outcomeId == i, ]
#     cyclopsData <- createCyclopsData(Surv(time, outcome) ~ exposure,
#       modelType = "cox",
#       data = dataOutcomeIlookTt
#     )
#     fit <- fitCyclopsModel(cyclopsData)
# 
#     # likelihood profile:
#     llProfile <- getCyclopsProfileLogLikelihood(
#       object = fit,
#       parm = "exposureTRUE",
#       bounds = log(c(0.1, 10))
#     )
#     negativeControlProfilesLookTt[[i]] <- llProfile
# 
#     # LLR:
#     llNull <- getCyclopsProfileLogLikelihood(
#       object = fit,
#       parm = "exposureTRUE",
#       x = 0
#     )$value
#     if (fit$return_flag == "ILLCONDITIONED" || coef(fit) < 0) {
#       llr <- 0
#     } else {
#       llr <- fit$log_likelihood - llNull
#     }
#     llrsLookTt[i] <- llr
#   }
# 
#   # Fit null distribution:
#   nullLookTt <- fitNullNonNormalLl(negativeControlProfilesLookTt)
# 
#   # Compute calibrated and uncalibrated CV for all negative controls:
#   cvs <- c()
#   calibratedCvsLookT <- c()
#   for (i in 1:50) {
#     dataOutcomeI <- maxSprtSimulationData[maxSprtSimulationData$outcomeId == i, ]
#     outcomesPerLook <- aggregate(outcome ~ lookTime, dataOutcomeI, sum)
#     # Need incremental outcomes per look:
#     outcomesPerLook <- outcomesPerLook$outcome[order(outcomesPerLook$lookTime)]
#     outcomesPerLook[2:10] <- outcomesPerLook[2:10] - outcomesPerLook[1:9]
# 
#     exposedTime <- sum(dataOutcomeI$time[dataOutcomeI$exposure == TRUE &
#                                            dataOutcomeI$lookTime == 100])
#     unexposedTime <- sum(dataOutcomeI$time[dataOutcomeI$exposure == FALSE &
#                                              dataOutcomeI$lookTime == 100])
# 
#     # Note: uncalibrated CV will be same for every t, but computing in loop
#     # over t for clarity of code:
#     cv <- computeCvBinomial(
#       groupSizes = outcomesPerLook,
#       z = unexposedTime / exposedTime,
#       minimumEvents = 1,
#       alpha = 0.05
#     )
#     cvs[i] <- cv
# 
#     calibratedCv <- computeCvBinomial(
#       groupSizes = outcomesPerLook,
#       z = unexposedTime / exposedTime,
#       minimumEvents = 1,
#       alpha = 0.05,
#       nullMean = nullLookTt[1],
#       nullSd = nullLookTt[2]
#     )
#     calibratedCvsLookT[i] <- calibratedCv
#   }
# 
#   # Store in a data frame:
#   allCvsAndLlrs <- rbind(
#     allCvsAndLlrs,
#     data.frame(
#       t = t,
#       outcomeId = 1:50,
#       llr = llrsLookTt,
#       cv = cvs,
#       calibrateCv = calibratedCvsLookT
#     )
#   )
# }

## ----eval=doEval--------------------------------------------------------------
signals <- c()
calibratedSignals <- c()
for (i in 1:50) {
  idx <- allCvsAndLlrs$outcomeId == i
  signals[i] <- any(allCvsAndLlrs$llr[idx] > allCvsAndLlrs$cv[idx])
  calibratedSignals[i] <-  any(allCvsAndLlrs$llr[idx] > allCvsAndLlrs$calibrateCv[idx])
}
# Type 1 error when not calibrated (should be 0.05):
mean(signals)

# Type 2 error when calibrated (should be 0.05):
mean(calibratedSignals)

