library(tidyverse) #obv
library(magrittr) #ceci n'est pas un pipe
library(DBI) #bq connection
library(bigrquery) #bq
library(rjson) # parsing config
library(changepoint) # testing changepoints as detection method
# https://www.youtube.com/watch?v=I7jUBro78RM
library(anomalize) # changepoint detection 
# https://github.com/business-science/anomalize
library(glue) #pasting
library(forecast) #hyndman; https://otexts.com/fpp2/
library(lubridate) #handling dates
library(timeDate) #get holidays
library(cowplot) #multiple plots

## Getting COVID and weather data from BQ
# https://github.com/open-covid-19/data
# `bigquery-public-data.covid19_open_data.covid19_open_data`
# configs
config <- fromJSON(file = "./gcp-config.json")
project <- config$`project-id`
bq_auth(path = config$`data-bot`)

# collect data
if (Reduce("|", "covid_data.RDS" %in% list.files("data/"))) {
    covid_data <- readRDS("data/covid_data.RDS")
} else {
    covid_query <- readChar("covid_query.bq", file.info("covid_query.bq")$size)
    covid_tbl <- bq_project_query(project, covid_query)
    covid_data <- bq_table_download(covid_tbl)
    saveRDS(covid_data, "data/covid_data.RDS")
}

model_data <- covid_data %>%
    filter(date > "2020-05-01", date < "2022-03-10") %>%
    mutate(n_confirmed = ifelse(n_confirmed < 0, 0, n_confirmed),
    n_deaths = ifelse(n_deaths < 0, 0, n_deaths))
summary(model_data$n_confirmed)

# just want to checkout one of these
pa_covid <- covid_data %>%
    filter(state == "Pennsylvania") %>%
    select(date, avg_temp, n_confirmed) %>%
    group_by(date) %>%
    summarize(min_temp = min(avg_temp),
              max_temp = max(avg_temp),
              mean_temp = mean(avg_temp),
              sd_temp = sd(avg_temp, na.rm = TRUE),
              n_obs = n(),
              n_confirmed = sum(n_confirmed, na.rm = TRUE))
View(pa_covid)

pa_covid %>%
    ggplot(aes(y = n_confirmed, x = date)) +
    geom_line()
# might need to test a feature for omnicron later on.
# CDC says omnicron was in most states 2021-12-20
ts_cases <- pa_covid %>%
    select(n_confirmed) %>%
    msts(start = as.numeric(str_sub(min(pa_covid$date), 1, 4)),
    seasonal.periods = c(362.25))

# create quick eval function
ts_eval <- function(fit) {
  #### Evaluation of Time Series Fit ####
  # prints summary and creates residual plots.

  resid <- residuals(fit)

  if (Reduce("|", class(fit) %in% "tbats")) {
    data <- fit$y
  } else {
    data <- fit$x
  }
  p1 <- autoplot(data, series = "Data") +
    autolayer(fitted(fit), series = "Model") +
    xlab("Year") + ylab("Sales")
  p2 <- autoplot(resid) + xlab("Year") + ylab("Residuals")
  p3 <- gghistogram(resid)
  p4 <- ggAcf(resid) + ggtitle("")

  print(summary(fit))
  print(mean(resid))
  print(Box.test(resid
                 # min of 2m or T/5; m = period length; T = length of TS
                 # https://robjhyndman.com/hyndsight/ljung-box-test/
                 , lag = min(2 * 362, round(length(data) / 5))
                 , fitdf = length(fit$coef)
                 , type = "Ljung-Box"
                 )
        )

  plot_grid(p1, p2, p3, p4
            , labels = c("Fitted Trend", "Residual Plot",
                       "Histogram of Residuals", "ACF of Residuals")
            , label_size = 10)
}

stl_cases <- mstl(ts_cases)
autoplot(stl_cases)

fit_stlm <- stlm(ts_cases)
ts_eval(fit_stlm)
