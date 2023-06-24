# libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2)

# source functions needed
source("code/functions/exp_density_func.R")

# load in raw data
owid_dta <- readr::read_csv(file = "raw_data/owid_covid_data.csv") |>
    as_tibble()

# ...
owid_dta <- owid_dta |>
    select(
        iso_code,
        date,
        weekly_hosp_admissions,
        new_deaths,
        total_deaths,
        total_cases,
        new_cases,
        stringency_index
    ) |>
    filter(iso_code == "GBR" | iso_code == "ITA") |>
    filter(date >= "2020-01-31" & date <= "2020-10-13")

# ...
owid_dta |>
    group_by(iso_code) |>
    summarise(
        string_ind = mean(stringency_index, na.rm = T),
        dly_new_cases = mean(new_cases, na.rm = T),
        dly_new_hosp_adms = mean(weekly_hosp_admissions, na.rm = T) / 7,
        dly_new_deaths = mean(new_deaths, na.rm = T)
    ) |>
    mutate(
        hosp_rate = dly_new_hosp_adms / dly_new_cases,
        hosp_death_rate = dly_new_deaths / dly_new_hosp_adms
    ) |>
    select(
        iso_code,
        string_ind,
        dly_new_cases,
        hosp_rate,
        hosp_death_rate
    )

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
    geom_line(aes(x = new_cases, y = exp_func(new_cases, 1 / 1401)), color = "black", lwd = 1) +
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
    geom_line(aes(x = new_cases, y = exp_func(new_cases, 1 / 2469)), color = "black", lwd = 1) +
    theme_classic()
