## ----eval=TRUE,echo=FALSE-----------------------------------------------------
set.seed(1)

## ----eval=TRUE, warning=FALSE, message=FALSE----------------------------------
library(EvidenceSynthesis)
simulationSettings <- createSimulationSettings(
  nSites = 5,
  n = 10000,
  treatedFraction = 0.75,
  nStrata = 5,
  hazardRatio = 2,
  randomEffectSd = 0.5
)
populations <- simulatePopulations(simulationSettings)

## ----eval=TRUE----------------------------------------------------------------
library(Cyclops)
# Assume we are at site 1:
population <- populations[[1]]

cyclopsData <- createCyclopsData(Surv(time, y) ~ x + strata(stratumId),
  data = population,
  modelType = "cox"
)
cyclopsFit <- fitCyclopsModel(cyclopsData)

## ----eval=TRUE----------------------------------------------------------------
# Hazard ratio:
exp(coef(cyclopsFit))

# 95% confidence interval:
exp(confint(cyclopsFit, parm = "x")[2:3])

## ----eval=TRUE----------------------------------------------------------------
approximation <- approximateLikelihood(
  cyclopsFit = cyclopsFit,
  parameter = "x",
  approximation = "grid with gradients"
)
approximation

## ----eval=TRUE----------------------------------------------------------------
plotLikelihoodFit(
  approximation = approximation,
  cyclopsFit = cyclopsFit,
  parameter = "x"
)

## ----eval=TRUE----------------------------------------------------------------
fitModelInDatabase <- function(population) {
  cyclopsData <- createCyclopsData(Surv(time, y) ~ x + strata(stratumId),
    data = population,
    modelType = "cox"
  )
  cyclopsFit <- fitCyclopsModel(cyclopsData)
  approximation <- approximateLikelihood(cyclopsFit,
    parameter = "x",
    approximation = "grid with gradients"
  )
  return(approximation)
}
approximations <- lapply(populations, fitModelInDatabase)

## ----eval=TRUE, message=FALSE-------------------------------------------------
estimate <- computeFixedEffectMetaAnalysis(approximations)
estimate

## ----eval=TRUE, message=FALSE-------------------------------------------------
estimate <- computeBayesianMetaAnalysis(approximations)
exp(estimate[1:3])

## ----eval=TRUE, message=FALSE-------------------------------------------------
plotPosterior(estimate)

## ----eval=TRUE, message=FALSE-------------------------------------------------
plotMcmcTrace(estimate)

## ----eval=TRUE, message=FALSE-------------------------------------------------
estimate2 <- computeBayesianMetaAnalysis(approximations, priorSd = c(2, 0.1))
exp(estimate2[1:3])

## ----eval=TRUE, message=FALSE-------------------------------------------------
# Make up some data site labels:
labels <- paste("Data site", LETTERS[1:length(populations)])

plotMetaAnalysisForest(
  data = approximations,
  labels = labels,
  estimate = estimate,
  xLabel = "Hazard Ratio",
  showLikelihood = TRUE
)

