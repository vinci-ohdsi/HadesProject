## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  fig.width=7.2, 
  fig.height=5
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----setup--------------------------------------------------------------------
library(visOmopResults)

## -----------------------------------------------------------------------------
library(PatientProfiles)
library(palmerpenguins)
library(dplyr)

summariseIsland <- function(island) {
  penguins |>
    filter(.data$island == .env$island) |>
    summariseResult(
      group = "species",
      includeOverallGroup = TRUE,
      strata = list("year", "sex", c("year", "sex")),
      variables = c(
        "bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", 
        "sex"),
      estimates = c(
        "median", "q25", "q75", "min", "max", "count_missing", "count", 
        "percentage", "density")
    ) |>
    suppressMessages() |>
    mutate(cdm_name = island)
}

penguinsSummary <- bind(
  summariseIsland("Torgersen"), 
  summariseIsland("Biscoe"), 
  summariseIsland("Dream")
)

penguinsSummary |> glimpse()

## -----------------------------------------------------------------------------
tidyColumns(penguinsSummary)

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "bill_depth_mm") |>
  filterStrata(year != "overall", sex == "overall") |>
  scatterPlot(
    x = "year", 
    y = "median",
    line = TRUE, 
    point = TRUE,
    ribbon = FALSE,
    facet = "cdm_name",
    colour = "species"
  )

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name %in% c("bill_length_mm", "bill_depth_mm"))|>
  filterStrata(year == "overall", sex == "overall") |>
  filterGroup(species != "overall") |>
  scatterPlot(
    x = "density_x", 
    y = "density_y",
    line = TRUE, 
    point = FALSE,
    ribbon = FALSE,
    facet = cdm_name ~ variable_name,
    colour = "species",
    style = "darwin"
  ) 

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "flipper_length_mm") |>
  filterStrata(year != "overall", sex %in% c("female", "male")) |>
  scatterPlot(
    x = c("year", "sex"), 
    y = "median",
    ymin = "q25",
    ymax = "q75",
    line = FALSE, 
    point = TRUE,
    ribbon = FALSE,
    facet = cdm_name ~ species,
    colour = "sex",
    group = c("year", "sex")
  )  +
  themeVisOmop(fontsizeRef = 13) +
  ggplot2::coord_flip() +
  ggplot2::labs(y = "Flipper length (mm)") + 
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(
    variable_name %in% c("flipper_length_mm", "bill_length_mm", "bill_depth_mm")
  ) |>
  filterStrata(sex == "overall") |>
  scatterPlot(
    x = "year", 
    y = "median",
    ymin = "min",
    ymax = "max",
    line = FALSE, 
    point = TRUE,
    ribbon = TRUE,
    facet = cdm_name ~ species,
    colour = "variable_name",
    group = c("variable_name")
  ) +
  themeVisOmop(style = "darwin", fontsizeRef = 12) + 
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "number records") |>
  filterGroup(species != "overall") |>
  filterStrata(sex != "overall", year != "overall") |>
  barPlot(
    x = "year",
    y = "count",
    colour = "sex",
    facet = cdm_name ~ species
  ) +
  themeVisOmop(fontsizeRef = 12)

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "body_mass_g") |>
  boxPlot(x = "year", facet = species ~ cdm_name, colour = "sex", style = "default")

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "body_mass_g") |>
  filterGroup(species != "overall") |>
  filterStrata(sex %in% c("female", "male"), year != "overall") |>
  boxPlot(x = "cdm_name", facet = c("sex", "species"), colour = "year") +
  themeVisOmop(fontsizeRef = 11)

## -----------------------------------------------------------------------------
penguinsTidy <- penguinsSummary |>
  filter(!estimate_name %in% c("density_x", "density_y")) |> # remove density for simplicity
  tidy()
penguinsTidy |> glimpse()

## -----------------------------------------------------------------------------
penguinsTidy |>
  filter(
    variable_name == "body_mass_g",
    species != "overall",
    sex %in% c("female", "male"),
    year != "overall"
  ) |>
  boxPlot(x = "cdm_name", facet = sex ~ species, colour = "year", style = "darwin")

## -----------------------------------------------------------------------------
library(ggplot2)
penguinsSummary |>
  filter(variable_name == "number records") |>
  tidy() |>
  ggplot(aes(x = year, y = sex, fill = count, label = count)) +
  themeVisOmop() +
  geom_tile() +
  scale_fill_viridis_c(trans = "log") + 
  geom_text() +
  facet_grid(cdm_name ~ species) + 
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(
    group_level != "overall",
    strata_name == "year &&& sex",
    !grepl("NA", strata_level),
    variable_name == "body_mass_g") |>
  boxPlot(x = "species", facet = cdm_name ~ sex, colour = "year") +
  themeVisOmop(fontsizeRef = 12) +
  ylim(c(0, 6500)) +
  labs(x = "My custom x label")

## ----eval=FALSE---------------------------------------------------------------
# ggsave(
#   "figure8.png", plot = last_plot(), device = "png", width = 15, height = 12,
#   units = "cm", dpi = 300)

## ----eval=FALSE---------------------------------------------------------------
# penguinsSummary |>
#   filter(
#     group_level != "overall",
#     strata_name == "year &&& sex",
#     !grepl("NA", strata_level),
#     variable_name == "body_mass_g") |>
#   boxPlot(x = "species", facet = cdm_name ~ sex, colour = "year", type = "plotly") +
#   ylim(c(0, 6500)) +
#   labs(x = "My custom x label")

