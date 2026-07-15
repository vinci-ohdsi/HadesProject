## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
  , comment = "#>"
  , warning = FALSE
  , message = FALSE
)

## -----------------------------------------------------------------------------
library(lightgbm)

## ----include=FALSE------------------------------------------------------------
# limit number of threads used, to be respectful of CRAN's resources when it checks this vignette
data.table::setDTthreads(1L)
setLGBMthreads(2L)

## -----------------------------------------------------------------------------
data(bank, package = "lightgbm")

bank[1L:5L, c("y", "age", "balance")]

# Distribution of the response
table(bank$y)

## -----------------------------------------------------------------------------
# Numeric response and feature matrix
y <- as.numeric(bank$y == "yes")
X <- data.matrix(bank[, c("age", "balance")])

# Train
fit <- lightgbm(
  data = X
  , label = y
  , params = list(
    num_leaves = 4L
    , learning_rate = 1.0
    , objective = "binary"
  )
  , nrounds = 10L
  , verbose = -1L
)

# Result
summary(predict(fit, X))

## -----------------------------------------------------------------------------
# Data interface
dtrain <- lgb.Dataset(X, label = y)

# Parameters
params <- list(
  objective = "binary"
  , num_leaves = 4L
  , learning_rate = 1.0
)

# Train
fit <- lgb.train(
  params
  , data = dtrain
  , nrounds = 10L
  , verbose = -1L
)

## ----echo = FALSE, results = "hide"-------------------------------------------
# Cleanup
if (file.exists("lightgbm.model")) {
  file.remove("lightgbm.model")
}

