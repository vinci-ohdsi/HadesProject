## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse   = TRUE,
  comment    = "#>",
  warning    = FALSE,
  message    = FALSE,
  out.width  = "95%",  # figures occupy ~95% of document width
  out.height = "auto",
  dpi        = 320,    # ensure figure quality
  fig.width  = 6,      # default aspect ratio (can be overridden per-figure)
  fig.height = 3
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----setup, echo=TRUE, eval=FALSE---------------------------------------------
# # Load necessary packages ----
# library(visOmopResults)
# library(IncidencePrevalence)
# library(CohortCharacteristics)
# library(dplyr)
# library(tidyr)
# library(ggplot2)
# 
# # Load mock results stored in the package ----
# data <- visOmopResults::data
# 
# # Global options ----
# knitr::opts_chunk$set(
#   out.width  = "95%",  # figures occupy ~95% of document width
#   out.height = "auto",
#   dpi        = 320,    # ensure figure quality
#   fig.width  = 6,      # default aspect ratio (can be overridden per-figure)
#   fig.height = 3,
#   results    = "asis"  # enable Markdown produced via cat() inside chunks
# )
# 
# # DARWIN style for visOmopResults plots and tables.
# style <- "darwin"
# tableType <- "flextable"
# plotType  <- "ggplot"
# setGlobalPlotOptions(style = style, type = plotType)
# setGlobalTableOptions(style = style, type = tableType)

## ----echo=FALSE---------------------------------------------------------------
# Load necessary packages ----
library(visOmopResults)
library(IncidencePrevalence)
library(CohortCharacteristics)
library(dplyr)
library(tidyr)
library(ggplot2)

# Load mock results stored in the package ----
reportData <- system.file("mockReportData.RData", package = "visOmopResults")
load(reportData)  # loads an object named `data` containing mock results

# DARWIN style for visOmopResults plots and tables.
style <- "darwin"
tableType <- "flextable"
plotType  <- "ggplot"
setGlobalPlotOptions(style = style, type = plotType) 
setGlobalTableOptions(style = style, type = tableType)

## -----------------------------------------------------------------------------
data$summarised_characteristics |>
  dplyr::filter(variable_name != "Sex") |>
  tableCharacteristics(
    header = c("sex"),
    hide   = c("cdm_name", "cohort_name", "table_name"),
    type   = tableType,
    style = style
  )

## -----------------------------------------------------------------------------
data$summarised_characteristics |>
  dplyr::filter(variable_name != "Sex") |>
  dplyr::mutate(
    variable_name = customiseText(
      variable_name, 
      custom = c(
        "Comorbidities"  = "Comorbidities flag -inf to 0", 
        "Comedications"  = "Comedications flag -180 to 0"
      )
    ),
    variable_level = customiseText(
      variable_level, 
      custom = c("HIV" = "Hiv")
    )
  ) |>
  visOmopTable(
    header = c("sex"),
    estimateName = c(
      "N (%)"               = "<count> (<percentage>%)",
      "N"                   = "<count>",
      "Median [Q25 - Q75]"  = "<median> [<q25> - <q75>]",
      "Mean (SD)"           = "<mean> (<sd>)",
      "Range"               = "<min> to <max>"
    ),
    factor = list(
      "sex" = c("overall", "Male", "Female"),
      "variable_name" = c(
        "Number records", "Number subjects", "Age", "Days in cohort", "Prior observation",
        "Future observation", "Cohort start date", "Cohort end date",
        "Comedications", "Comorbidities"
      ),
      "variable_level" = c(NA, "Asthma", "Depression", "HIV", "Opioids", "Antidiabetes")
    ),
    hide = c("cdm_name", "cohort_name")
  )

## -----------------------------------------------------------------------------
data$summarised_characteristics |>
  dplyr::filter(variable_name %in% c("Number records")) |>
  plotCharacteristics(colour = "sex") +
  themeVisOmop(style = style) +
  coord_flip()

## -----------------------------------------------------------------------------
data$incidence |>
  dplyr::filter(strata_name == "sex") |>
  plotIncidence(colour = "sex", facet = "sex", ribbon = TRUE) +
  themeVisOmop(style = style) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

## ----message=TRUE-------------------------------------------------------------
data$measurement_change

## -----------------------------------------------------------------------------
data$measurement_change |> 
  tidyr::pivot_longer(
    cols      = c("median", "min", "max", "q25", "q75"),
    names_to  = "estimate_name",
    values_to = "estimate_value"
  ) |>
  dplyr::mutate(
    estimate_type = "numeric",
    estimate_value = as.character(estimate_value),
    variable_name  = customiseText(variable_name),
    sex            = customiseText(sex)
  ) |>
  visTable(
    header = "sex",
    estimateName = c(
      "Median [Q25 - Q75]" = "<median> [<q25> - <q75>]",
      "Range"              = "<min> to <max>"
    ),
    hide   = c("cohort_name", "estimate_type"),
    rename = c("Estimate" = "estimate_name", "Variable" = "variable_name")
  )

## -----------------------------------------------------------------------------
data$measurement_change |>  
  dplyr::filter(variable_name %in% c("value_before", "value_after")) |>
  dplyr::mutate(
    variable_name = customiseText(variable_name),
    sex           = customiseText(sex)
  ) |>
  boxPlot(x = "variable_name", facet = "sex", colour = "variable_name") +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  xlab("")

## ----eval=FALSE---------------------------------------------------------------
# num_table <- 1
# cat(paste0(
#   ':::{custom-style="Caption"}\n',
#   '**Table ', num_table, ':** Baseline population characteristics.\n',
#   ':::\n'
# ))
# num_table <- num_table + 1

