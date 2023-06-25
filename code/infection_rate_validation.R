# libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2)

# source functions needed
source("code/functions/exp_density_func.R")

# load in processed data
owid_dta <- readr::read_csv(file = "processed_data/processed_data.csv") |>
    as_tibble()

# hist ITA
owid_dta |>
    filter(iso_code == "ITA") |>
    select(new_cases) |>
    ggplot(mapping = aes(x = new_cases, y = ..density..)) +
    geom_histogram(
        color = "blue",
        fill = "light blue",
        bins = 17
    ) +
    geom_line(aes(x = new_cases, y = exp_func(new_cases, 1 / 1401)),
        color = "black", lwd = 1
    ) +
    theme_classic()

# hist GBR
owid_dta |>
    filter(iso_code == "GBR") |>
    select(new_cases) |>
    ggplot(mapping = aes(x = new_cases, y = ..density..)) +
    geom_histogram(
        color = "blue",
        fill = "light blue",
        bins = 22
    ) +
    geom_line(aes(x = new_cases, y = exp_func(new_cases, 1 / 2469)),
        color = "black", lwd = 1
    ) +
    theme_classic()
