# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed sim data
sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# construct statistic and create visualization
sim_dta |>
    mutate( # construct hospital occupancy multiplier statistic
        HOM_GBR = case_when(
            (NPPD1 - NPPD2 < 0) & (NHAPD1 >= NPPD2) ~ NHAPD1 / NPPD2,
            TRUE ~ NHAPD1 / NPPD1
        ),
        HOM_ITA = case_when(
            (NPPD2 - NPPD1 < 0) & (NHAPD2 >= NPPD1) ~ NHAPD2 / NPPD1,
            TRUE ~ NHAPD2 / NPPD2
        )
    ) |>
    select( # select useful variables
        run_id, HOM_GBR, HOM_ITA
    ) |>
    filter( # only use the 10 runs with n = 3650
        !run_id == "lr"
    ) |> # perform needed data transformations to construct E[HOM] sample
    mutate(obs_num = rep(1:3650, 10)) |>
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
    select(iso_code, obs_num, HOM) |>
    group_by(iso_code, obs_num) |>
    summarise(
        y_bar = mean(HOM),
        .groups = "drop"
    ) |>
    mutate(time = obs_num) |>
    select(iso_code, time, y_bar) |>
    ggplot(
        mapping = aes(
            x = time,
            y = y_bar,
            col = factor(iso_code)
        )
    ) +
    geom_point(size = 2, alpha = 0.45) +
    scale_x_continuous(n.breaks = 25) +
    geom_vline(aes(xintercept = 40), size = 1, color = "black", alpha = 0.55) +
    annotate("text", x = 70, y = 25, label = "Days = 40", angle = 90) +
    theme_stata() +
    labs(
        x = "Days (simulation time)",
        y = "E[HOM]",
        title = "E[HOM] Over Time Across 10 Independent Replications"
    )
