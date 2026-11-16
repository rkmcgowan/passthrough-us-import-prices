
# Exchange Rate Pass-Through to US Import Prices, 2006-2026

Rosaleen McGowan, University of St Andrews, November 2026

This project estimates how much a stronger US dollar is associated with lower US import prices, using monthly FRED data from January 2006 to September 2026. The full write-up is in `McGowan_PassThrough_Memo.pdf`, and a short literature note is in `literature_note.md`.

## Main results

A 1% stronger dollar is associated with US import prices about 0.66% lower across the current month and following six months (standard error 0.15), and about 0.31% lower when petroleum is excluded. Results with 12 lags and before and after 2020 are in the memo and in `output/results_table.csv`. These are associations, not causal estimates.

## How to run

1. Open `passthrough-project.Rproj` in RStudio to set the working directory. 
2. Install the packages once: `install.packages(c("tidyverse", "sandwich", "lmtest"))`
3. Run `source("code/01_pull_and_clean.R")`, then `source("code/02_model.R")`.

The scripts read the raw data in `data/raw/` and write the cleaned data to `data/clean/` and the results table and chart to `output/`. Tested with R 4.6.2.

## Data

Four monthly series from FRED (Federal Reserve Bank of St. Louis): import price index for all commodities (IR), import price index excluding petroleum (IREXPET), Nominal Broad US Dollar Index (DTWEXBGS, averaged to monthly by FRED), and WTI crude oil price (WTISPLC). Download dates, units and cleaning decisions are in `data_log.md`. October 2025 import prices are missing in the source data and are left out of the regressions.

## Method

Monthly percent changes (100 times the log difference) in import prices are regressed on the current and six lagged percent changes in the dollar index, with the percent change in oil prices as a control. The cumulative effect is the sum of the seven dollar coefficients. Standard errors are Newey-West (6 lags; 12 for the 12-lag models). Robustness checks use 12 lags, the ex-petroleum import index, and separate samples before and after 2020.

## Limitations

The results are associations, not causal estimates. The dollar index is a rough measure of pass-through because much trade is invoiced in dollars. The ex-petroleum index still includes other raw materials, and the WTI control may absorb part of the indirect effect of the dollar that works through oil prices. See the memo for details.

## Files

- `code/`: the two R scripts
- `data/raw/`: FRED downloads, `data/clean/`: cleaned dataset
- `output/`: results table and chart
- `data_log.md`: data sources and cleaning notes
- `literature_note.md`: notes on three related papers

