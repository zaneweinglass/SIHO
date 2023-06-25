# libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2)

# load in raw data
owid_dta <- readr::read_csv(file = "raw_data/owid_covid_data.csv") |>
    as_tibble()

# clean up data
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

# store processed data
file.create("processed_data/processed_data.csv")
readr::write_csv(owid_dta, file = "processed_data/processed_data.csv")
