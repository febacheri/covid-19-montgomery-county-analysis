# Montgomery County, PA COVID-19 Analysis
This project explores COVID-19 case and death trends in Montgomery County, Pennsylvania, using CDC open data. It demonstrates data cleaning, aggregation, and visualization in R, providing a portfolio-ready example of applied statistics and epidemiology analysis.

## Project Structure
covid19-us-analysis/
data/
- montco_covid_cases.csv        # raw line-list dataset
- covid_cleaned_montco_pa.rds  # cleaned line-list
     monthly_counts_montco_pa.rds # monthly aggregated counts
- scripts/
    01_data_cleaning.R           # cleaning and aggregation
    02_EDA.R                     # exploratory data analysis & plots
- figures/
    monthly_cases_plot.png
    monthly_deaths_plot.png
- README.md

## Workflow
1. Data Cleaning (01_data_cleaning.R)
   - Converted case_month (yyyy-mm) to a proper Date object.
   - Created a numeric death_flag from the death_yn column (Yes = 1, No = 0, Unknown = NA).
   - Derived variables: year, month.
   - Aggregated monthly totals for cases and deaths.
   - Calculated 3-month rolling averages for trends.
   - Saved cleaned line-list and aggregated monthly datasets for further analysis.
2. Exploratory Data Analysis (02.EDA.R)
   - Generated monthly plots of cases and deaths.
   - Plotted bars for raw monthly counts and lines for 3-month rolling averages.
   - Figures are saved in the figures/ for portolio display.
  
## Visualizations
### Monthly COVID-19 Cases
- Bars show total cases per month
- Red line shows the 3-month rolling average trend.

### Monthly COVID-19 Deaths
- Bars show total deaths per month.
- Red line shows the 3-month rolling average trend.

## Summary Statistics
monthly_counts %>%
  summarise(
    total_cases  = sum(new_cases),
    total_deaths = sum(new_deaths)
  )
- This provides a quick overview of the total cases and deaths over the study period.

## Tools & Packages
- R for data cleaning, aggregation, and plotting
- Packages used: tidyverse, lubridate, zoo, here
- Visualizations produced with ggplot2

## Notes
- This project demonstrates handling a line-list dataset, aggregating to monthly counts, and generating portfolio-ready plots.
- Code is robust and reproducible, using here::here() for file paths and rds files for intermediate outputs.
- Rolling averages smooth trends for better visualization of epidemic patterns.
