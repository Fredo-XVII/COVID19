# covid eda

# libraries
library(R.COVID.19)
library(tidyverse)
library(sf)

# Load data

cnty_data <- R.COVID.19::us_geo_confirmed_daily()

cnty_data %>% #View()
  dplyr::filter(Province_State %in% c("Minnesota")) %>%
  View()

length(unique(st_data$FIPS))
