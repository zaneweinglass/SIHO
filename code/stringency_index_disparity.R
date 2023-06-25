# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych)

# load in processed data
sim_dta <- readr::read_csv(file = "processed_data/processed_data.csv") |>
    as_tibble()

# set the number of sigfigs shown in a tibble to 6
options(pillar.sigfig = 6)

# construct table
sim_dta |>
    select(iso_code, stringency_index) |>
    group_by(iso_code) |>
    summarise(
        Mean = mean(stringency_index, na.rm = TRUE),
        Min = min(stringency_index),
        Max = max(stringency_index),
        .groups = "drop"
    )
