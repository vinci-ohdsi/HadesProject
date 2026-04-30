## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  fig.width = 7.2,
  fig.height = 5
)
options(rmarkdown.html_vignette.check_title = FALSE)

library(visOmopResults)

## -----------------------------------------------------------------------------
tableType()

## -----------------------------------------------------------------------------
library(visOmopResults)
library(palmerpenguins)
library(dplyr)
library(tidyr)

x <- penguins |>
  filter(!is.na(sex) & year == 2008) |>
  select(!"body_mass_g") |>
  summarise(across(ends_with("mm"), ~mean(.x)), .by = c("species", "island", "sex"))
head(x)

## -----------------------------------------------------------------------------
visTable(
  result = x,
  groupColumn = c("sex"),
  rename = c(
    "Bill length (mm)" = "bill_length_mm",
    "Bill depth (mm)" = "bill_depth_mm",
    "Flipper length (mm)" = "flipper_length_mm"
  ),
  type = "gt",
  hide = "year"
)

## -----------------------------------------------------------------------------
# Transforming to estimate columns
x <- x |>
  pivot_longer(
    cols = ends_with("_mm"),
    names_to = "estimate_name",
    values_to = "estimate_value"
  ) |>
  mutate(estimate_type = "numeric")

# Use estimateName and header 
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "gt",
  hide = c("year", "estimate_type")
)

## -----------------------------------------------------------------------------
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "flextable",
  hide = c("year", "estimate_type")
)

## -----------------------------------------------------------------------------
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "datatable",
  hide = c("year", "estimate_type")
)

## -----------------------------------------------------------------------------
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("island"),
  groupColumn = c("species", "sex"),
  type = "reactable",
  hide = c("year", "estimate_type")
)

## -----------------------------------------------------------------------------
result <- mockSummarisedResult() |>
  filter(strata_name == "age_group &&& sex")

# A flextable table with a few estimate formats
visOmopTable(
  result = result,
  estimateName = c(
    "N (%)" = "<count> (<percentage>%)",
    "N" = "<count>",
    "Mean (SD)" = "<mean> (<sd>)"
  ),
  header = c("package_name", "age_group"),
  groupColumn = c("cohort_name", "sex"),
  settingsColumn = "package_name",
  type = "flextable"
)

## -----------------------------------------------------------------------------
result |>
  suppress(minCellCount = 1000000) |>
  visOmopTable(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    header = c("group"),
    groupColumn = c("strata"),
    hide = c("cdm_name"),
    showMinCellCount = TRUE,
    type = "flextable"
  )

## -----------------------------------------------------------------------------
tableOptions()

## -----------------------------------------------------------------------------
result <- result |> formatMinCellCount()

## -----------------------------------------------------------------------------
result <- result |>
  formatEstimateValue(
    decimals = c(integer = 0, numeric = 4, percentage = 2),
    decimalMark = ".",
    bigMark = ","
  )

## -----------------------------------------------------------------------------
result <- result |>
  formatEstimateName(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    keepNotFormatted = TRUE,
    useFormatOrder = FALSE
  )

## -----------------------------------------------------------------------------
result <- result |>
  mutate(across(c("strata_name", "strata_level"), ~ gsub("&&&", "and", .x))) |>
  formatHeader(
    header = c("Stratifications", "strata_name", "strata_level"),
    delim = "\n",
    includeHeaderName = FALSE,
    includeHeaderKey = TRUE
  )

## -----------------------------------------------------------------------------
result <- result |>
  splitGroup() |>
  splitAdditional() |>
  select(!c("result_id", "estimate_type", "cdm_name"))

result |>
  formatTable(
    type = "gt",
    delim = "\n",
    na = "-",
    title = "My formatted table!",
    subtitle = "Created with the `visOmopResults` R package.",
    caption = NULL,
    groupColumn = "cohort_name",
    groupAsColumn = FALSE,
    groupOrder = c("cohort2", "cohort1"),
    merge = "variable_name"
  )

