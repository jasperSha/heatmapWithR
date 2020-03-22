#rent/zillow data
library(raster)
library(dplyr)
library(ggmap)
library(magrittr)
library(leaflet)
library(DescTools)
library(geoformattr)
library(ggplot2)

library(sf)
#GIS data dir
setwd("~/Documents/HousingMap/R_data/crimes/")
crime_2011 <- sf::st_read('2011_crime.gpkg')
crime_2012 <- sf::st_read('2012_crime.gpkg')
crime_2013 <- sf::st_read('2013_crime.gpkg')
crime_2014 <- sf::st_read('2014_crime.gpkg')
crime_2015 <- sf::st_read('2015_crime.gpkg')
crime_2016 <- sf::st_read('2016_crime.gpkg')
crime_2017 <- sf::st_read('2017_crime.gpkg')
crime_2018 <- sf::st_read('2018_crime.gpkg')
crime_2019 <- sf::st_read('2019_crime.gpkg')

#aggregate full decade of crimes
crime_2011_to_2019 <- rbind(crime_2011, crime_2012, crime_2013, crime_2014, crime_2015, crime_2016,
                            crime_2017, crime_2018, crime_2019)
crime_2011_to_2019 <- geoformattr::geom_to_lonlat(crime_2011_to_2019)
coordinates(crime_2011_to_2019) <- ~lon + lat
proj4string(crime_2011_to_2019) <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')

#list of every unique crime code
crime_codes <- data.frame(unique(crime_2011_to_2019@data$crm_cd_desc))

#separate by property vs bodily
bodily_crime <- c("HOMICIDE", 
                   "AGGRAVATED", 
                   "SEXUAL", 
                   "FORCIBLE", 
                   "RAPE", 
                   "CHILD ABUSE", 
                   "FELONY", 
                   "HUMAN TRAFFICKING", 
                   "LYNCHING",
                   "CHILD"
                   )

nonviolent_crime <- c("BURGLARY",
                   "THEFT",
                   "GRAND",
                   "ARSON",
                   "STOLEN",
                   'RECKLESS',
                   'ROBBERY',
                   'DISTURBING THE PEACE',
                   'ILLEGAL DUMPING',
                   'PROPERTY',
                   "VANDALISM"
                   )

rm(crime_2011, crime_2012, crime_2013, crime_2014, crime_2015, crime_2016, crime_2017, crime_2018, crime_2019)

#cannot apply filter directly to spatial points dataframe
#solution: subset the data using subset(spdf, spdf@data$column=="choose value here to match")
#x are the bodily crimes
body_crimes <- crime_2011_to_2019[grep(paste(bodily_crime, collapse="|"), crime_2011_to_2019@data$crm_cd_desc), ]
#y are the property crimes
nonviolent_crimes <- crime_2011_to_2019[grep(paste(nonviolent_crime, collapse="|"), crime_2011_to_2019@data$crm_cd_desc), ]


bbox_frame <- data.frame(longitude=coordinates(body_crimes)[,1], latitude=coordinates(body_crimes)[,2])

max_lon <- max(bbox_frame[,1][bbox_frame[,1]<0])
min_lon <- min(bbox_frame[,1])
min_lat <- min(bbox_frame[,2][bbox_frame[,2]>0])
max_lat <- max(bbox_frame[,2])

bbox <- c(min_lon, min_lat, max_lon, max_lat)

library(leaflet)
library(leaflet.extras)
crime_map <- leaflet(body_crimes) %>%
  addProviderTiles(providers$CartoDB.DarkMatter)%>%
  addWebGLHeatmap(size=100, group="Most Heinous Crimes of 2011")%>%
  fitBounds(bbox[[1]],bbox[[2]],bbox[[3]],bbox[[4]])

crime_map







setwd("~/Documents/HousingMap/lasd_crime_stats/")




#zillow data
property_data <- sf::st_read("property.gpkg")

property_data <- geoconvert::geom_to_lonlat(property_data)


#save session data
save.image("~/Documents/HousingMap/R_data/")

