#set working dir to heatmap
setwd("~/Documents/HousingMap/desirableZ/")

#accessing r environ
R.home()

ggmap::register_google(google_cloud_key)


#GOOGLE_CLOUD_API
#MAPBOX_API
google_cloud_key <- Sys.getenv("GOOGLE_CLOUD_API")
mapbox_key <- Sys.getenv("MAPBOX_API")

#rent/zillow data
setwd("~/Documents/HousingMap/R_data/")

library(raster)
library(dplyr)
library(ggmap)
library(magrittr)
library(leaflet)
library(sf)
library(DescTools)
library(geoformattr)

mapbox_endpoint <- "https://api.mapbox.com"



library(sf)
#GIS data dir
crime_2011 <- sf::st_read('2011_crime.gpkg')
crime_2012 <- sf::st_read('2012_crime.gpkg')
crime_2013 <- sf::st_read('2013_crime.gpkg')
crime_2014 <- sf::st_read('2014_crime.gpkg')
crime_2015 <- sf::st_read('2015_crime.gpkg')
crime_2016 <- sf::st_read('2016_crime.gpkg')
crime_2017 <- sf::st_read('2017_crime.gpkg')
crime_2018 <- sf::st_read('2018_crime.gpkg')
crime_2019 <- sf::st_read('2019_crime.gpkg')


#split POINT into long/lat for heatmap considerations
crime_2011 <- geom_to_lonlat(crime_2011)
crime_2018 <- geoformattr::geom_to_lonlat(crime_2018)
crime_2019 <- geoformattr::geom_to_lonlat(crime_2019)


severe_crimes <- c("HOMICIDE", "AGGRAVATED", "SEXUAL", "FORCIBLE", "RAPE", "CHILD ABUSE", "BURGLARY", "FELONY", "HUMAN TRAFFICKING", "LYNCHING", "GRAND")
#require dplyr for filter
worst_crime_2011 <- filter(crime_2011, grepl(paste(severe_crimes, collapse="|"), crm_cd_desc))
worst_crime_2018 <- filter(crime_2018, grepl(paste(severe_crimes, collapse="|"), crm_cd_desc))
worst_crime_2019 <- filter(crime_2019, grepl(paste(severe_crimes, collapse="|"), crm_cd_desc))

rest_crimes_2011 <- data.frame(unique(crime_2011$crm_cd_desc[!crime_2011$crm_cd_desc %in% worst_crime_2011$crm_cd_desc]))
rest_crimes_2018 <- data.frame(unique(crime_2018$crm_cd_desc[!crime_2018$crm_cd_desc %in% worst_crime_2018$crm_cd_desc]))
rest_crimes_2019 <- data.frame(unique(crime_2019$crm_cd_desc[!crime_2019$crm_cd_desc %in% worst_crime_2019$crm_cd_desc]))



#list of every unique crime code
crime_codes <- data.frame(unique(crime_2019$crm_cd_desc))



crime_codes_freq <- sort(table(crime_2019$crm_cd_desc), decreasing=T)







crime_map_2011 <- leaflet(worst_crime_2011) %>%
  addProviderTiles(providers$CartoDB.DarkMatter)%>%
  addWebGLHeatmap(size=100, group="Most Heinous Crimes of 2011")

leaflet(worst_crime_2011) %>%
  addWebGLHeatmap(map=base_map,size=500, group="Most Heinous Crimes of 2011")

#fitbounds(lng1, lat1, lng2, lat2)
crime_map_2011 %>% fitBounds(~min(worst_crime_2011$lon), ~min(worst_crime_2011$lat), ~max(worst_crime_2011$lon), ~max(worst_crime_2011$lat))

crime_map_2011





#zillow data
property_data <- sf::st_read("property.gpkg")

property_data <- geoconvert::geom_to_lonlat(property_data)


#save session data
save.image("~/Documents/HousingMap/R_data/")

