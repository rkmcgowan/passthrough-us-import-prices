
# 02_model.R
# Estimates cumulative pass-through and robustness checks; writes results to output/
library(tidyverse)
library(sandwich)
library(lmtest)

df <- read_csv("data/clean/monthly.csv")

for (k in 1:12) df[[paste0("lag", k)]] <- lag(df$d_dollar, k)

lags6  <- c("d_dollar", paste0("lag", 1:6))
lags12 <- c("d_dollar", paste0("lag", 1:12))
f6 <- d_import ~ d_dollar + lag1 + lag2 + lag3 + lag4 + lag5 + lag6 + d_oil

# Cumulative pass-through = sum of the dollar coefficients, with a
# Newey-West standard error for the sum
cum_pt <- function(model, vars, L = 6) {
  V   <- NeweyWest(model, lag = L, prewhite = FALSE)
  est <- sum(coef(model)[vars])
  se  <- sqrt(sum(V[vars, vars]))
  c(cumulative = est, std_error = se, t_stat = est / se, n = nobs(model))
}

m    <- lm(f6, data = df)
m2   <- lm(d_import_xpet ~ d_dollar + lag1 + lag2 + lag3 + lag4 + lag5 + lag6 + d_oil, data = df)
m12  <- lm(d_import ~ d_dollar + lag1 + lag2 + lag3 + lag4 + lag5 + lag6 +
             lag7 + lag8 + lag9 + lag10 + lag11 + lag12 + d_oil, data = df)
m12x <- lm(d_import_xpet ~ d_dollar + lag1 + lag2 + lag3 + lag4 + lag5 + lag6 +
             lag7 + lag8 + lag9 + lag10 + lag11 + lag12 + d_oil, data = df)

pre  <- df %>% filter(date <  as.Date("2020-01-01"))
post <- df %>% filter(date >= as.Date("2020-01-01"))

print(coeftest(m, vcov = NeweyWest(m, lag = 6, prewhite = FALSE)))

res <- bind_rows(
  as_tibble_row(cum_pt(m,    lags6))          %>% mutate(spec = "Baseline (6 lags)"),
  as_tibble_row(cum_pt(m2,   lags6))          %>% mutate(spec = "Ex-petroleum (6 lags)"),
  as_tibble_row(cum_pt(m12,  lags12, L = 12)) %>% mutate(spec = "12 lags"),
  as_tibble_row(cum_pt(m12x, lags12, L = 12)) %>% mutate(spec = "Ex-petroleum (12 lags)"),
  as_tibble_row(cum_pt(lm(f6, data = pre),  lags6)) %>% mutate(spec = "Before 2020"),
  as_tibble_row(cum_pt(lm(f6, data = post), lags6)) %>% mutate(spec = "2020 onward")
) %>% select(spec, everything())
write_csv(res, "output/results_table.csv")
print(res)

coefs <- tibble(lag = 0:6, est = unname(coef(m)[lags6]))
p <- ggplot(coefs, aes(lag, est)) +
  geom_col(fill = "grey30", width = 0.7) +
  scale_x_continuous(breaks = 0:6) +
  labs(x = "Months after the dollar change", y = "Effect on import prices (%)") +
  theme_minimal(base_size = 12)
print(p)
ggsave("output/lag_coefficients.png", plot = p, width = 6, height = 3.5)

