# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed simulation data
sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# set the number of sigfigs shown in a tibble to 6
options(pillar.sigfig = 6)

sim_dta |>
    filter( # only use the 10 runs with n = 3650
        !run_id == "lr"
    ) |>
    mutate( # construct hospital occupancy multiplier statistic
        HOM_GBR = NHAPD1 / NPPD1,
        HOM_ITA = NHAPD2 / NPPD2
    ) |>
    select( # select useful variables
        run_id, HOM_GBR, HOM_ITA
    ) |>
    mutate(obs_num = rep(1:3650, 10)) |>
    filter( # truncate first 40 obs of each run
        obs_num > 40
    ) |> # transform and tidy data
    pivot_longer(
        cols = HOM_GBR:HOM_ITA,
        names_to = "iso_code",
        values_to = "HOM"
    ) |>
    mutate(
        iso_code = case_when(
            iso_code == "HOM_GBR" ~ "GBR",
            TRUE ~ "ITA"
        )
    ) |>
    select(iso_code, run_id, obs_num, HOM) |> # construct confidence interval
    group_by(iso_code, run_id) |>
    summarise(y_bar = mean(HOM), .groups = "drop") |>
    group_by(iso_code) |>
    summarise(
        z_bar = mean(y_bar),
        se = sd(y_bar) / sqrt(n()),
        .groups = "drop"
    ) |>
    mutate(t_crit_val = qt(p = 0.05 / 2, df = 9, lower.tail = FALSE)) |>
    mutate(
        lcl = z_bar - (t_crit_val * se),
        ucl = z_bar + (t_crit_val * se)
    )
