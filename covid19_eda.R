# covid eda

# libraries
library(R.COVID.19)
library(tidyverse)
library(sf)

# Parameters
state <- "Minnesota"

# Load data

#cnty_data_shp <- R.COVID.19::pub_hlth_status_by_cnty_shp()
cnty_data_shp <- sf::read_sf("./COVID19_Public_Health_Emergency_Status_by_County.shp")

cnty_data <- R.COVID.19::us_geo_confirmed_daily() %>% 
  dplyr::mutate(uid = stringr::str_pad(.$UID,8,side = "left" , 0),
    fips = stringr::str_sub(uid, start = 4,end = 8))

cnty_shp <- cnty_data %>% 
  dplyr::left_join(cnty_data_shp, by = c("fips" = "fips")) 

cnty_shp %>% dplyr::filter(is.na(.data$objectid) == TRUE) %>% distinct(Province_State) %>% View()

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

tig_st_sf %>% filter(STATEFP == "06") %>%
  ggplot2::ggplot() +
  geom_sf(data = tig_st_sf %>% filter(STATEFP == "06"), aes(x = ALAND),color = NA) + 
  coord_sf(crs = st_crs(tig_st_sf))+ 
  scale_fill_viridis_c(option = "magma") 
  
# Build a map from the shape file
