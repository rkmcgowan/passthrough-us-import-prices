
# Data log

All series were downloaded from FRED (Federal Reserve Bank of St. Louis, fred.stlouisfed.org) as CSV files.

## IR: Import Price Index (End Use): All Commodities
- Source: U.S. Bureau of Labor Statistics, retrieved from FRED
- Frequency: monthly
- Units: index, 2000=100, not seasonally adjusted
- Coverage used: January 2006 to September 2026
- Downloaded: 14 November 2026

## IREXPET: Import Price Index (End Use): All Imports Excluding Petroleum
- Source: U.S. Bureau of Labor Statistics, retrieved from FRED
- Frequency: monthly
- Units: index, 2000=100, not seasonally adjusted
- Coverage used: January 2006 to September 2026
- Downloaded: 14 November 2026

## DTWEXBGS: Nominal Broad U.S. Dollar Index
- Source: retrieved from FRED
- Frequency: monthly, converted from daily by FRED (average of daily values)
- Units: index, January 2006=100
- Available from January 2006, which sets the start of the sample
- Downloaded: 14 November 2026

## WTISPLC: Spot Crude Oil Price: West Texas Intermediate (WTI)
- Source: retrieved from FRED
- Frequency: monthly
- Units: dollars per barrel
- Downloaded: 14 November 2026

## Cleaning decisions
- Sample restricted to January 2006 through September 2026.
- All series converted to monthly percent changes (100 times the log difference).
- October 2025 import prices are missing in the source data. They are left as missing and dropped from the regressions, which is why the six-lag models use 240 months.
- Import price values before 2006 are patchy and are not used.

## Citation
U.S. Bureau of Labor Statistics, Import Price Index (End Use): All Commodities [IR], retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/IR

