## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
5^5
factorial(5)

## ----echo=FALSE, eval=FALSE---------------------------------------------------
#  # library(DiagrammeR)
#  #
#  # g <- grViz("digraph {
#  #   graph [layout = dot, rankdir = TB, splines = line]
#  #
#  #   A [label = 'A@_{1}']
#  #   B [label = 'B@_{1}']
#  #   C [label = 'C@_{1}']
#  #   D [label = 'D@_{1}']
#  #
#  #   AB [label = 'AB@_{2}']
#  #   AC [label = 'AC@_{2}']
#  #   AD [label = 'AD@_{2}']
#  #   BC [label = 'BC@_{2}']
#  #   BD [label = 'BD@_{2}']
#  #   CD [label = 'CD@_{2}']
#  #
#  #   ABC [label = 'ABC@_{3}']
#  #   ABD [label = 'ABD@_{3}']
#  #   ACD [label = 'ACD@_{3}']
#  #   BCD [label = 'BCD@_{3}']
#  #
#  #   ABCD [label = 'ABCD@_{4}']
#  #
#  #   subgraph cluster1 {
#  #     A -> AB -> ABC -> ABCD
#  #          AB -> ABD
#  #     A -> AC
#  #          AC -> ACD
#  #     A -> AD
#  #   }
#  #
#  #   subgraph cluster2 {
#  #     B -> BC -> BCD
#  #     B -> BD
#  #   }
#  #
#  #   subgraph cluster3 {
#  #     C -> CD
#  #   }
#  #
#  #   subgraph cluster4 {
#  #     D
#  #   }
#  # }")
#  #
#  # g |>
#  #   DiagrammeRsvg::export_svg() |>
#  #   charToRaw() |>
#  #   rsvg::rsvg_png(file = "./figures/a000_graph.png")

## -----------------------------------------------------------------------------
2^1
2^2
2^3
2^4

## -----------------------------------------------------------------------------
2^0
2^1
2^2
2^3

## -----------------------------------------------------------------------------
sum(c(2^0, 2^1, 2^2, 2^3))

# Or:
n <- 4
sum(2^(0:(n - 1)))

f_1 <- function(n) {
  sum(2^(0:(n - 1)))
}

## -----------------------------------------------------------------------------
n <- 1:25
f_1_events <- unlist(lapply(n, f_1))

data.frame(
  n = n,
  f_1 = f_1_events
)

## -----------------------------------------------------------------------------
f_2 <- function(n) {
  2^n - 1
}

n <- 1:25
f_1_events <- unlist(lapply(n, f_1))
f_2_events <- unlist(lapply(n, f_2))

data.frame(
  n = n,
  f_1 = f_1_events,
  f_2 = f_2_events
)

## -----------------------------------------------------------------------------
n <- 5
totalEvents <- 2^n - 1
combinationEvents <- totalEvents - n

sprintf("monoEvents: %s", n)
sprintf("totalEvents: %s", totalEvents)
sprintf("combinationEvents: %s", combinationEvents)

## ----message=FALSE------------------------------------------------------------
library(dplyr)

cohort_table <- tribble(
  ~cohort_definition_id, ~subject_id, ~cohort_start_date,    ~cohort_end_date,
  1,                     1,           as.Date("2020-01-01"), as.Date("2021-01-01"),
  2,                     1,           as.Date("2020-01-01"), as.Date("2020-01-20"),
  3,                     1,           as.Date("2020-01-22"), as.Date("2020-02-28"),
  4,                     1,           as.Date("2020-02-20"), as.Date("2020-03-3")
)

cohort_table

## -----------------------------------------------------------------------------
cohort_table <- cohort_table %>%
  mutate(duration = as.numeric(cohort_end_date - cohort_start_date))

cohort_table

## -----------------------------------------------------------------------------
cohort_table <- cohort_table %>%
  # Filter out target cohort
  filter(cohort_definition_id != 1) %>%
  mutate(overlap = case_when(
    # If the result of the next cohort_end_date is NA, set 0
    is.na(lead(cohort_end_date)) ~ 0,
    # Compute duration of cohort_end_date - next cohort_start_date
    # 2020-02-28 - 2020-02-20 = -8
    .default = as.numeric(cohort_end_date - lead(cohort_start_date))))

cohort_table

