# covid eda

# libraries
library(R.COVID.19)
library(tidyverse)
library(sf)

# Parameters
state <- "California"

# Load data

cnty_data_shp <- R.COVID.19::pub_hlth_status_by_cnty_shp()

cnty_data <- R.COVID.19::us_geo_confirmed_daily() %>% 
  dplyr::mutate(fips = forcats::as_factor(FIPS))

cnty_shp <- cnty_data %>% 
  dplyr::left_join(cnty_data_shp, by = c("fips" = "fips")) 

cnty_shp <- sf::st_as_sf(cnty_shp)

cnty_shp %>% #View()
  dplyr::filter(Province_State %in% c("California")) %>%
  View()

class(cnty_shp)
attr(cnty_shp, "sf_column")
st_crs(cnty_shp)

# Validation

us_map <- sf::st_union(cnty_shp$geometry) # No california, colorado, arizona, arkansa, mississippi

cnty_data_shp %>% filter(state_name == "Colorado") %>% View()
cnty_data %>% filter(Province_State == "Colorado") %>% View()

tig_ca <- tigris::counties("California", cb = TRUE)
tig_ca_sf <- sf::st_as_sf(tig_ca)
head(tig_ca_sf) %>% head() %>% View()
str(tig_ca_sf)
plot(tig_ca_sf)

tigris_states <- function(state) {
  geo_df <- tigris::counties(state, cb = TRUE) %>% 
    sf::st_as_sf(.)
}
  
tig_ca_sf_2 <- tigris_states(state = state) 

tig_st_sf <- purrr::map_dfr(state.name, tigris_states) 
str(tig_st_sf)
# Build a map from the shape file
