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
bq_auth(token = config$`data-bot`)

# collect data
if (Reduce("|", "covid_data.RDS" %in% list.files("data/"))) {
    covid_data <- readRDS("data/covid_data.RDS")
} else {
    covid_query <- readChar("covid_query.bq", file.info("covid_query.bq")$size)
    covid_tbl <- bq_project_query(project, covid_query)
    covid_data <- bq_table_download(covid_tbl)
    saveRDS(covid_data, "data/covid_data.RDS")
}
