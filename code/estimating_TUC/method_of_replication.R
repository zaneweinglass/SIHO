# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed simulation data
sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# set the number of sigfigs shown in a tibble to 6
options(pillar.sigfig = 6)

sim_dta |>
    select(run_id, HOCC1PD, HOCC2PD) |>
    filter(!run_id == "lr") |>
    pivot_longer(
        cols = HOCC1PD:HOCC2PD,
        names_to = "iso_code",
        values_to = "HOCCPD"
    ) |>
    mutate(
        iso_code = case_when(
            iso_code == "HOCC1PD" ~ "GBR",
            TRUE ~ "ITA"
        )
    ) |>
    group_by(iso_code, run_id) |>
    summarise(
        x = sum(HOCCPD < 161328),
        .groups = "drop"
    ) |>
    group_by(iso_code) |>
    summarise(
        x_bar = mean(x),
        se = sd(x) / sqrt(n()),
        .groups = "drop"
    ) |>
    mutate(t_crit_val = qt(p = 0.05 / 2, df = 9, lower.tail = FALSE)) |>
    mutate(
        lcl = x_bar - (t_crit_val * se),
        ucl = x_bar + (t_crit_val * se)
    )
