# libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2)

# load in processed data
owid_dta <- readr::read_csv(file = "processed_data/processed_data.csv") |>
    as_tibble()

# gather key statistics for simulation model assumptions
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
