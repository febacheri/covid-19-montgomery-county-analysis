##############################################
# 01_data_cleaning.R
#
# Purpose:
#   Clean Montgomery County, PA COVID-19 line-list data
#   Prepare it for monthly time-series analysis and plotting
#
# Input:
#   data/montco_covid_cases.csv  (1 row per case, case_month in yyyy-mm format)
#
# Output:
#   data/covid_cleaned_montco_pa.rds     (cleaned line-list)
#   data/monthly_counts_montco_pa.rds    (aggregated monthly counts with rolling averages)
##############################################

# ---- Load packages ----
library(tidyverse)
library(lubridate)
library(zoo)
library(here)

# ---- File paths ----
raw_data_path     <- here("data", "montco_covid_cases.csv")
clean_data_path   <- here("data", "covid_cleaned_montco_pa.rds")
monthly_path      <- here("data", "monthly_counts_montco_pa.rds")

# ---- Read raw line-list data ----
covid_raw <- read_csv(raw_data_path, show_col_types = FALSE)

# ---- Inspect raw data ----
glimpse(covid_raw)
names(covid_raw)

# ---- Convert yyyy-mm to Date object (first day of month) ----
covid_clean <- covid_raw %>%
    mutate(
        case_month = as.Date(paste0(case_month, "-01"))
    ) %>%
    filter(!is.na(case_month))  # drop rows with no date

# ---- Create derived variables ----
covid_clean <- covid_clean %>%
    mutate(
        year  = year(case_month),
        month = month(case_month, label = TRUE, abbr = TRUE),
        # Convert death_yn to numeric flag
        death_flag = case_when(
            death_yn == "Yes"       ~ 1,
            death_yn == "No"       ~ 0,
            death_yn == "Unknown" ~ NA_real_
        )
    )

# ---- Save cleaned line-list ----
saveRDS(covid_clean, clean_data_path)

# ---- Aggregate monthly counts ----
monthly_counts <- covid_clean %>%
    group_by(case_month) %>%
    summarise(
        new_cases  = n(),
        new_deaths = sum(death_flag, na.rm = TRUE),
        .groups = "drop"
    ) %>%
    arrange(case_month) %>%
    mutate(
        # 3-month rolling averages for smoothing trends
        cases_3month_avg  = zoo::rollmean(new_cases, 3, fill = NA, align = "right"),
        deaths_3month_avg = zoo::rollmean(new_deaths, 3, fill = NA, align = "right")
    )

# ---- Save monthly counts ----
saveRDS(monthly_counts, monthly_path)

# ---- Final sanity checks ----
summary(covid_clean)
summary(monthly_counts)

# ---- End of script ----
