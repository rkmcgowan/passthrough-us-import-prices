
# 01_pull_and_clean.R
# Reads the raw FRED downloads in data/raw/ and writes data/clean/monthly.csv
library(tidyverse)

if (!file.exists("data/raw/IR.csv")) {
  stop("Open passthrough-project.Rproj in RStudio first, so the working directory is the project folder.")
}

ir  <- read_csv("data/raw/IR.csv")
irx <- read_csv("data/raw/IREXPET.csv")
usd <- read_csv("data/raw/DTWEXBGS.csv")   # monthly average, converted by FRED
oil <- read_csv("data/raw/WTISPLC.csv")    # monthly WTI

df <- ir %>%
  left_join(irx, by = "observation_date") %>%
  left_join(usd, by = "observation_date") %>%
  left_join(oil, by = "observation_date") %>%
  rename(date = observation_date, import = IR, import_xpet = IREXPET,
         dollar = DTWEXBGS, oil = WTISPLC) %>%
  filter(date >= as.Date("2006-01-01")) %>%
  arrange(date)

# Monthly percent changes (100 x log difference)
df <- df %>%
  mutate(d_import      = 100 * (log(import)      - lag(log(import))),
         d_import_xpet = 100 * (log(import_xpet) - lag(log(import_xpet))),
         d_dollar      = 100 * (log(dollar)      - lag(log(dollar))),
         d_oil         = 100 * (log(oil)         - lag(log(oil))))

# October 2025 import prices are missing in the source data; left as NA and
# dropped automatically by lm().
write_csv(df, "data/clean/monthly.csv")

