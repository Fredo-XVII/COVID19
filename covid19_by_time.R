# gganimate COVID by Geo by Time

# Libraries
library(R.COVID.19)
library(tidyverse)
library(sf)
library(gganimate)

# Get Covid19 Data
tidycensus::fips_codes %>% View()

cnty_shp <- tidycensus::county_laea %>% st_as_sf()

cnty_data <- R.COVID.19::us_geo_confirmed_daily() %>% 
  dplyr::mutate(uid = stringr::str_pad(.$UID,8,side = "left" , 0),
                fips = stringr::str_sub(uid, start = 4,end = 8))

cnty_data_shp <- cnty_data %>% 
  dplyr::inner_join(cnty_shp, by = c("fips" = "GEOID"))

cnty_data_shp %>% tail() %>% View()

cnty_data_shp$greg_d <- as.Date(cnty_data_shp$greg_d, format = '%m/%d/%y')

cnty_data_shp <- cnty_data_shp %>% 
  dplyr::mutate(daily_delta = confirmed_cases - lag(confirmed_cases))

cnty_data_shp <- sf::st_as_sf(cnty_data_shp)

map_base <- cnty_data_shp %>% #filter(greg_d == as.Date('2020-04-24')) %>% 
  filter(Province_State == "Minnesota") %>% 
  ggplot(aes(fill = log2(.data$daily_delta), frame = greg_d)) +
  geom_sf(color = NA) +
  coord_sf(crs = "WGS84") + 
  scale_fill_viridis_c(option = "plasma") 

map_animate <- map_base +
  gganimate::view_follow()

animate(map_animate,end_pause=25, nframes=85,fps=1)
save_animation(last_animation(), file="./test_animation.gif")
gganimate::an

#gganimate example
a3 <- 
  ggplot(data=df3, aes(x=date,y=ratioSA ))+geom_line()+
  view_follow()+
  geom_point(color="red")+
  scale_y_continuous(labels=scales::percent)+
  transition_reveal(ind)+
  theme_minimal()+
  theme(plot.caption=element_text(hjust=0))+
  labs(x="",y="",
       title="Initial Jobless Claims as a % of Labor Force (seasonally adjusted)",
       caption="@lenkiefer Source: U.S. Department of Labor")


animate(a3,end_pause=25, nframes=350,fps=12)
save_animation(gganimate::last_animation(), file="PATH_FOR_GIF3")
