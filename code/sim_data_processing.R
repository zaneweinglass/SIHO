# load libraries needed
pacman::p_load(readr, dplyr, tidyverse, psych, ggplot2, ggthemes, forecast)

# load in raw simulation generated data and perform some data manipulation
sr_1 <- readr::read_csv(file = "generated_data/sr_1.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_1")
sr_2 <- readr::read_csv(file = "generated_data/sr_2.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_2")
sr_3 <- readr::read_csv(file = "generated_data/sr_3.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_3")
sr_4 <- readr::read_csv(file = "generated_data/sr_4.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_4")
sr_5 <- readr::read_csv(file = "generated_data/sr_5.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_5")
sr_6 <- readr::read_csv(file = "generated_data/sr_6.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_6")
sr_7 <- readr::read_csv(file = "generated_data/sr_7.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_7")
sr_8 <- readr::read_csv(file = "generated_data/sr_8.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_8")
sr_9 <- readr::read_csv(file = "generated_data/sr_9.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_9")
sr_10 <- readr::read_csv(file = "generated_data/sr_10.csv") |>
    as_tibble() |>
    mutate(run_id = "sr_10")
lr <- readr::read_csv(file = "generated_data/lr.csv") |>
    as_tibble() |>
    mutate(run_id = "lr")

# create one big run data frame and tidy data
run_dta <- rbind(
    sr_1,
    sr_2,
    sr_3,
    sr_4,
    sr_5,
    sr_6,
    sr_7,
    sr_8,
    sr_9,
    sr_10,
    lr
) |>
    as_tibble() |>
    filter(!NPPD1 == 0) |>
    select(-`...1`)
rm(sr_1, sr_2, sr_3, sr_4, sr_5, sr_6, sr_7, sr_8, sr_9, sr_10, lr)

# store processed simulation data
file.create("processed_data/processed_sim_data.csv")
readr::write_csv(run_dta, file = "processed_data/processed_sim_data.csv")
