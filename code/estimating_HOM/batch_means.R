# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in processed simulation data
sim_dta <- readr::read_csv(file = "processed_data/processed_sim_data.csv") |>
    as_tibble()

# set the number of sigfigs shown in a tibble to 6
options(pillar.sigfig = 6)

# construct 95% confidence interval for HOM
sim_dta |>
    filter( # only use the long run with n = 36500
        run_id == "lr"
    ) |>
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
    mutate(obs_num = 1:36500) |>
    filter( # truncate first 40 obs of the run
        obs_num > 40
    ) |>
    mutate(obs_num = 1:36460) |>
    select(-run_id) |> # transform and tidy data
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
    mutate( # create 5 batches each size 7292 per iso_code
        batch = case_when(
            obs_num <= 7292 ~ 1,
            obs_num > 7292 & obs_num <= 14584 ~ 2,
            obs_num > 14584 & obs_num <= 21876 ~ 3,
            obs_num > 21876 & obs_num <= 29168 ~ 4,
            TRUE ~ 5
        )
    ) |>
    select(iso_code, batch, HOM) |> # construct confidence interval
    group_by(iso_code, batch) |>
    summarise(y_bar = mean(HOM), .groups = "drop") |>
    group_by(iso_code) |>
    summarise(
        z_bar = mean(y_bar),
        se = sd(y_bar) / sqrt(n()),
        .groups = "drop"
    ) |>
    mutate(t_crit_val = qt(p = 0.05 / 2, df = 4, lower.tail = FALSE)) |>
    mutate(
        lcl = z_bar - (t_crit_val * se),
        ucl = z_bar + (t_crit_val * se)
    )
