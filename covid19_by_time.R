# gganimate COVID by Geo by Time

# Libraries
library(R.COVID.19)
library(tidyverse)
library(sf)

# Get Covid19 Data
tidycensus::fips_codes %>% View()

cnty_shp <- tidycensus::county_laea %>% st_as_sf()

cnty_data <- R.COVID.19::us_geo_confirmed_daily() %>% 
  dplyr::mutate(uid = stringr::str_pad(.$UID,8,side = "left" , 0),
                fips = stringr::str_sub(uid, start = 4,end = 8))

cnty_data_shp <- cnty_data %>% 
  dplyr::inner_join(cnty_shp, by = c("fips" = "GEOID"))

cnty_data_shp %>% head() %>% View()

cnty_data_shp$greg_d <- as.Date(cnty_data_shp$greg_d, format = '%m/%d/%y')

cnty_data_shp %>% 
  filter(Province_State == "Minnesota") %>% 
  ggplot()

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
save_animation(last_animation(), file="PATH_FOR_GIF3")