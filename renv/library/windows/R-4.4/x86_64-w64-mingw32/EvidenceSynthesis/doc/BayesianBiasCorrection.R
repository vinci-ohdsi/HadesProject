## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----example profile checkout, message=FALSE----------------------------------
library(EvidenceSynthesis)

data("ncLikelihoods")
data("ooiLikelihoods")

knitr::kable(ncLikelihoods[[1]][[1]])

## ----message=FALSE, results='hide'--------------------------------------------
singleBiasDist <- fitBiasDistribution(ncLikelihoods[[1]],
  seed = 42
)

## ----message=FALSE, results='hide'--------------------------------------------
singleBiasDistRobust <- fitBiasDistribution(ncLikelihoods[[1]],
  robust = TRUE,
  seed = 42
)

## ----message=FALSE, warning=FALSE, results='hide', cache=TRUE-----------------
BiasDistRobust <- sequentialFitBiasDistribution(ncLikelihoods,
  robust = TRUE,
  seed = 1
)

## ----message=FALSE, warning=FALSE---------------------------------------------
plotBiasDistribution(BiasDistRobust, limits = c(-3, 3))

## ----message=FALSE, warning=FALSE, results='hide', cache=TRUE-----------------
# select profile likelihoods for the 5th analysis period
ooiLik5 <- list(ooiLikelihoods[["5"]])
ncLik5 <- list(ncLikelihoods[["5"]])

# specify prior mean and prior standard deviation for the effect size (log RR)
bbcResult5 <- biasCorrectionInference(ooiLik5,
  ncLikelihoodProfiles = ncLik5,
  priorMean = 0,
  priorSd = 4,
  doCorrection = TRUE,
  seed = 42
)

## ----message=FALSE, warning=FALSE, results='hide', cache=TRUE-----------------
# learn bias distribution for the 5th analysis period first
biasDist5 <- fitBiasDistribution(ncLikelihoods[["5"]])

# then recycle the bias distribution
bbcResult5 <- biasCorrectionInference(ooiLik5,
  biasDistributions = biasDist5,
  priorMean = 0,
  priorSd = 4,
  doCorrection = TRUE,
  seed = 42
)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(dplyr)

knitr::kable(bind_rows(
  bbcResult5 |> mutate(biasCorrection = "yes"),
  attr(bbcResult5, "summaryRaw") |>
    mutate(biasCorrection = "no")
) |>
  select(-Id), digits = 4)

## ----message=FALSE, warning=FALSE, results='hide', cache=TRUE-----------------
bbcSequential <- biasCorrectionInference(ooiLikelihoods,
  biasDistributions = BiasDistRobust,
  priorMean = 0,
  priorSd = 4,
  doCorrection = TRUE,
  seed = 42
)

## ----message=FALSE, warning=FALSE---------------------------------------------
knitr::kable(bbcSequential |> select(period = Id, median:p1), digits = 4)

## ----message=FALSE, warning=FALSE, results='hide', fig.height=7---------------
plotBiasCorrectionInference(bbcSequential,
  type = "corrected",
  limits = c(-4, 4)
)

## ----message=FALSE, warning=FALSE, fig.height=4-------------------------------
plotBiasCorrectionInference(bbcSequential,
  type = "compare",
  limits = c(-4, 4),
  ids = as.character(3:12)
)

