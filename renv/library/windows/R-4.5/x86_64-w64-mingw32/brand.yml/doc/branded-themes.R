## ----setup--------------------------------------------------------------------
library(brand.yml)

## ----setup-knitr, include=FALSE-----------------------------------------------
knitr::opts_chunk$set(fig.width = 7, fig.height = 3.5)

## ----brand--------------------------------------------------------------------
brand <- as_brand_yml(
  '
color:
  palette:
    black: "#1A1A1A"
    white: "#F9F9F9"
    orange: "#FF6F20"
    purple: "#A500B5"
    pink: "#FF3D7F"
    blue: "#007BFF"
    green: "#28A745"
  foreground: black
  background: white
  primary: orange
  danger: pink
'
)

## ----ggplot2------------------------------------------------------------------
library(ggplot2)

ggplot(mtcars, aes(mpg, wt)) +
  geom_point(size = 2, aes(color = factor(cyl))) +
  geom_smooth(method = "lm", formula = y ~ x) +
  scale_colour_manual(
    values = c(
      brand_color_pluck(brand, "blue"),
      brand_color_pluck(brand, "purple"),
      brand_color_pluck(brand, "green")
    )
  ) +
  labs(
    title = "Motor Trend Car Road Tests",
    subtitle = "1974 Motor Trend US magazine",
    caption = "Data from the 1974 Motor Trend US magazine",
    x = "Miles per Gallon",
    y = "Weight (1,000 lbs)",
    colour = "Cylinders"
  ) +
  theme_brand_ggplot2(brand)

## ----thematic-----------------------------------------------------------------
library(ggplot2)
library(patchwork)
library(thematic)

# Use thematic_with_theme to apply the theme temporarily
thematic_with_theme(theme_brand_thematic(brand, foreground = "purple"), {
  # Generate three scatterplots
  plot1 <- ggplot(mtcars, aes(mpg, wt)) +
    geom_point()

  plot2 <- ggplot(mtcars, aes(mpg, disp)) +
    geom_point()

  plot3 <- ggplot(mtcars, aes(mpg, hp)) +
    geom_point()

  # Display all three scatterplots in same graphic
  plot1 + plot2 + plot3
})

## ----ggiraph------------------------------------------------------------------
library(ggplot2)
library(ggiraph)

cars <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point_interactive(aes(
    colour = factor(cyl),
    tooltip = rownames(mtcars)
  )) +
  scale_colour_manual(
    values = c(
      brand_color_pluck(brand, "orange"),
      brand_color_pluck(brand, "purple"),
      brand_color_pluck(brand, "green")
    )
  ) +
  theme_brand_ggplot2(brand)

girafe(ggobj = cars)

## ----plotly-------------------------------------------------------------------
library(plotly)

p <- plot_ly(
  iris,
  x = ~Species,
  y = ~Sepal.Width,
  type = "violin",
  box = list(visible = TRUE),
  meanline = list(visible = TRUE),
  points = "all"
)

theme_brand_plotly(p, brand, accent = "pink")

## ----gt-----------------------------------------------------------------------
library(gt)

islands_tbl <- dplyr::tibble(name = names(islands), size = islands)
islands_tbl <- dplyr::slice_max(islands_tbl, size, n = 10)

theme_brand_gt(
  gt(islands_tbl),
  brand,
  background = "green",
  foreground = "white"
)

## ----flextable----------------------------------------------------------------
library(flextable)

ft <- flextable(airquality[sample.int(10), ])
ft <- add_header_row(ft, colwidths = c(4, 2), values = c("Air quality", "Time"))
ft <- theme_vanilla(ft)
ft <- add_footer_lines(
  ft,
  "Daily air quality measurements in New York, May to September 1973."
)
ft <- set_caption(ft, caption = "New York Air Quality Measurements")

theme_brand_flextable(ft, brand)

