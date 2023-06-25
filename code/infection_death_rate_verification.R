# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed data and processed simulation data
owid_dta <- readr::read_csv(file = "processed_data/processed_data.csv") |>
    as_tibble()

sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# welch's t-test for infection rate verification
t.test(
    owid_dta |> filter(iso_code == "GBR") |> pull(new_cases),
    sim_dta |> filter(run_id == "lr") |> pull(NIPD1)
)

t.test(
    owid_dta |> filter(iso_code == "ITA") |> pull(new_cases),
    sim_dta |> filter(run_id == "lr") |> pull(NIPD2)
)

# welch's t-test for death rate verification
t.test(
    owid_dta |> filter(iso_code == "GBR") |> pull(new_deaths),
    sim_dta |> filter(run_id == "lr") |> pull(NDPD1)
)

t.test(
    owid_dta |> filter(iso_code == "ITA") |> pull(new_deaths),
    sim_dta |> filter(run_id == "lr") |> pull(NDPD2)
)
