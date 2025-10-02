## ----setup, include = FALSE---------------------------------------------------
library(EvidenceSynthesis)

## -----------------------------------------------------------------------------
simulationSettings <- createSimulationSettings(
  nSites = 10,
  n = 10000,
  treatedFraction = 0.8,
  nStrata = 5,
  hazardRatio = 2,
  randomEffectSd = 0.5
)
set.seed(1)
populations <- simulatePopulations(simulationSettings)

head(populations[[1]])
table(populations[[1]][, c("x", "y")])

## ----message = FALSE----------------------------------------------------------
library(Cyclops)

population <- populations[[1]]

cyclopsData <- createCyclopsData(Surv(time, y) ~ x + strata(stratumId),
  data = population,
  modelType = "cox"
)
cyclopsFit <- fitCyclopsModel(cyclopsData)

# Hazard ratio:
exp(coef(cyclopsFit))

# 95% confidence interval:
exp(confint(cyclopsFit, parm = "x")[2:3])

## -----------------------------------------------------------------------------
normalApproximation <- approximateLikelihood(
  cyclopsFit = cyclopsFit,
  parameter = "x",
  approximation = "normal"
)
normalApproximation

plotLikelihoodFit(
  approximation = normalApproximation,
  cyclopsFit = cyclopsFit,
  parameter = "x"
)

## -----------------------------------------------------------------------------
approximation <- approximateLikelihood(
  cyclopsFit = cyclopsFit,
  parameter = "x",
  approximation = "adaptive grid",
  bounds = c(log(0.1), log(10))
)
head(approximation)

plotLikelihoodFit(
  approximation = approximation,
  cyclopsFit = cyclopsFit,
  parameter = "x"
)

## -----------------------------------------------------------------------------
fitModelInDatabase <- function(population, approximation) {
  cyclopsData <- createCyclopsData(Surv(time, y) ~ x + strata(stratumId),
    data = population,
    modelType = "cox"
  )
  cyclopsFit <- fitCyclopsModel(cyclopsData)
  approximation <- approximateLikelihood(cyclopsFit,
    parameter = "x",
    approximation = approximation
  )
  return(approximation)
}
adaptiveGridApproximations <- lapply(
  X = populations,
  FUN = fitModelInDatabase,
  approximation = "adaptive grid"
)
normalApproximations <- lapply(
  X = populations,
  FUN = fitModelInDatabase,
  approximation = "normal"
)
normalApproximations <- do.call(rbind, (normalApproximations))

## ----message = FALSE----------------------------------------------------------
fixedFxPooled <- computeFixedEffectMetaAnalysis(populations)
fixedFxPooled

## ----message = FALSE----------------------------------------------------------
fixedFxNormal <- computeFixedEffectMetaAnalysis(normalApproximations)
fixedFxNormal

## ----message = FALSE----------------------------------------------------------
fixedFxAdaptiveGrid <- computeFixedEffectMetaAnalysis(adaptiveGridApproximations)
fixedFxAdaptiveGrid

## ----message = FALSE, warning = FALSE, fig.width = 9, fig.height = 5----------
plotMetaAnalysisForest(
  data = normalApproximations,
  labels = paste("Site", 1:10),
  estimate = fixedFxNormal,
  xLabel = "Hazard Ratio"
)

## ----message = FALSE, warning = FALSE, fig.width = 9, fig.height = 5----------
plotMetaAnalysisForest(
  data = adaptiveGridApproximations,
  labels = paste("Site", 1:10),
  estimate = fixedFxAdaptiveGrid,
  xLabel = "Hazard Ratio"
)

## ----eval = FALSE-------------------------------------------------------------
# randomFxPooled <- computeBayesianMetaAnalysis(populations)
# exp(randomFxPooled[, 1:3])

## ----echo = FALSE,message = FALSE---------------------------------------------
# randomFxPooled <- computeBayesianMetaAnalysis(populations)
# attr(randomFxPooled, "traces") <- NULL
# saveRDS(randomFxPooled, "randomFxPooled.rds")
randomFxPooled <- readRDS("randomFxPooled.rds")
exp(randomFxPooled[, 1:3])

## ----message = FALSE----------------------------------------------------------
randomFxNormal <- computeBayesianMetaAnalysis(normalApproximations)
exp(randomFxNormal[, 1:3])

## ----message = FALSE----------------------------------------------------------
randomFxAdaptiveGrid <- computeBayesianMetaAnalysis(adaptiveGridApproximations)
exp(randomFxAdaptiveGrid[, 1:3])

## ----message = FALSE, warning = FALSE, fig.width = 8, fig.height = 5----------
plotMetaAnalysisForest(
  data = normalApproximations,
  labels = paste("Site", 1:10),
  estimate = randomFxNormal,
  xLabel = "Hazard Ratio"
)

## ----message = FALSE, warning = FALSE, fig.width = 8, fig.height = 5----------
plotMetaAnalysisForest(
  data = adaptiveGridApproximations,
  labels = paste("Site", 1:10),
  estimate = randomFxAdaptiveGrid,
  xLabel = "Hazard Ratio"
)

