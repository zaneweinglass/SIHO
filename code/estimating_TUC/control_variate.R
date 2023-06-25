# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed simulation data
sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# set the number of sigfigs shown in a tibble to 6
options(pillar.sigfig = 6)

## pivot_longer() for NHAPD
tibb_1 <- sim_dta |>
    select(run_id, NHAPD1, NHAPD2) |>
    filter(!run_id == "lr") |>
    pivot_longer(
        cols = NHAPD1:NHAPD2,
        names_to = "iso_code",
        values_to = "NHAPD"
    ) |>
    mutate(
        iso_code = case_when(
            iso_code == "NHAPD1" ~ "GBR",
            TRUE ~ "ITA"
        )
    ) |>
    mutate(row_id = 1:73000)

## pivot_longer() for NPPD
tibb_2 <- sim_dta |>
    select(run_id, NPPD1, NPPD2) |>
    filter(!run_id == "lr") |>
    pivot_longer(
        cols = NPPD1:NPPD2,
        names_to = "iso_code",
        values_to = "NPPD"
    ) |>
    mutate(
        iso_code = case_when(
            iso_code == "NPPD1" ~ "GBR",
            TRUE ~ "ITA"
        )
    ) |>
    mutate(row_id = 1:73000)

# set hospital capacity, alpha, and control variate values
hosp_capacity <- 161328
alpha <- 0.0103
control_variate <- 7

## join and construct table output
tibb_1 |>
    left_join(tibb_2, by = c("row_id")) |>
    mutate(
        run_id = run_id.x,
        iso_code = iso_code.y
    ) |>
    select(run_id, iso_code, NHAPD, NPPD) |>
    mutate(w = NHAPD - NPPD) |>
    group_by(run_id, iso_code) |>
    summarise(
        z = (hosp_capacity * n()) / sum(w + alpha * (NPPD - control_variate)),
        .groups = "drop"
    ) |>
    group_by(iso_code) |>
    summarise(
        z_bar = mean(z),
        se = sd(z) / sqrt(n()),
        .groups = "drop"
    ) |>
    mutate(t_crit_val = qt(p = 0.05 / 2, df = 9, lower.tail = FALSE)) |>
    mutate(
        lcl = z_bar - (t_crit_val * se),
        ucl = z_bar + (t_crit_val * se)
    )
