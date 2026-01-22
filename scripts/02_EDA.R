##############################################
# 02_EDA.R
#
# Purpose:
#   Perform exploratory data analysis on Montgomery County COVID-19 monthly counts
#   Generate plots of cases, deaths, and rolling averages for portfolio/README
#
# Input:
#   data/monthly_counts_montco_pa.rds
#
# Output:
#   figures/monthly_cases_plot.png
#   figures/monthly_deaths_plot.png
##############################################

# ---- Load packages ----
library(tidyverse)
library(here)
library(scales)

# ---- File paths ----
monthly_path <- here("data", "monthly_counts_montco_pa.rds")
figures_dir  <- here("figures")

# ---- Create figures folder if it doesn't exist ----
if(!dir.exists(figures_dir)) dir.create(figures_dir)

# ---- Load monthly data ----
monthly_counts <- readRDS(monthly_path)

# ---- Inspect data ----
glimpse(monthly_counts)

# ---- Plot 1: Monthly New Cases ----
cases_plot <- monthly_counts %>%
  ggplot(aes(x = case_month)) +
  geom_col(aes(y = new_cases), fill = "steelblue") +
  geom_line(aes(y = cases_3month_avg), color = "darkred", linewidth = 1.2) +
  labs(
    title = "Monthly COVID-19 Cases in Montgomery County, PA",
    subtitle = "Bars = monthly cases, line = 3-month rolling average",
    x = "Month",
    y = "Number of Cases",
    caption = "Data: Montgomery County, PA"
  ) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save plot
ggsave(filename = here("figures", "monthly_cases_plot.png"),
       plot = cases_plot, width = 10, height = 6)

# ---- Plot 2: Monthly New Deaths ----
deaths_plot <- monthly_counts %>%
  ggplot(aes(x = case_month)) +
  geom_col(aes(y = new_deaths), fill = "darkgrey") +
  geom_line(aes(y = deaths_3month_avg), color = "darkred", linewidth = 1.2) +
  labs(
    title = "Monthly COVID-19 Deaths in Montgomery County, PA",
    subtitle = "Bars = monthly deaths, line = 3-month rolling average",
    x = "Month",
    y = "Number of Deaths",
    caption = "Data: Montgomery County, PA"
  ) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save plot
ggsave(filename = here("figures", "monthly_deaths_plot.png"),
       plot = deaths_plot, width = 10, height = 6)

# ---- Optional: Quick summary table ----
monthly_summary <- monthly_counts %>%
  summarise(
    total_cases  = sum(new_cases),
    total_deaths = sum(new_deaths)
  )
print(monthly_summary)

# ---- End of script ----
