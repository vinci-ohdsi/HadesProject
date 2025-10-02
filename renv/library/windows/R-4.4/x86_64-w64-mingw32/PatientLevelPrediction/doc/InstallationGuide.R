## ----echo = TRUE, message = FALSE, warning = FALSE,tidy=FALSE,eval=FALSE------
# install.packages("remotes")
# remotes::install_github("OHDSI/PatientLevelPrediction")

## ----echo = TRUE, message = FALSE, warning = FALSE,tidy=FALSE,eval=FALSE------
# library(PatientLevelPrediction)
# reticulate::install_miniconda()
# configurePython(envname = "r-reticulate", envtype = "conda")

## ----eval=FALSE---------------------------------------------------------------
# usethis::edit_r_profile()

## ----eval=FALSE---------------------------------------------------------------
# Sys.setenv(PATH = paste("your python bin location", Sys.getenv("PATH"), sep = ":"))

## ----eval=FALSE---------------------------------------------------------------
# reticulate::conda_list()

## ----tidy=TRUE,eval=TRUE------------------------------------------------------
citation("PatientLevelPrediction")

