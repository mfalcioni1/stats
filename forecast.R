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
config <- 

'SELECT country_name
, date 
, new_confirmed
, new_deceased
, sum(new_confirmed)
OVER (
    PARTITION BY country_name
    ORDER BY date ASC
    ROWS UNBOUNDED PRECEDING
) as cumulative_total_cases
, sum(new_deceased)
OVER (
    PARTITION BY country_name
    ORDER BY date ASC
    ROWS UNBOUNDED PRECEDING
) as cumulative_total_deceased
, avg(new_confirmed)
OVER (
    PARTITION BY country_name
    ORDER BY date ASC
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
) as four_day_mavg_new_cases
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
where date between "2022-03-01" and "2022-03-08"
and aggregation_level = 0
order by country_name, date'