# covid eda

# libraries
library(R.COVID.19)
library(tidyverse)
library(sf)

# Load data

cnty_data_shp <- R.COVID.19::pub_hlth_status_by_cnty_shp()

cnty_data <- R.COVID.19::us_geo_confirmed_daily() %>% 
  dplyr::mutate(fips = forcats::as_factor(FIPS))


cnty_shp <- cnty_data %>% 
  dplyr::left_join(cnty_data_shp, by = c("fips" = "fips"))

cnty_shp %>% #View()
  dplyr::filter(Province_State %in% c("Minnesota")) %>%
  View()

length(unique(cnty_shp$fips))
