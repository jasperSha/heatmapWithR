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
                            crime_2017, crime_2018, crime_2019, lasd_crime)

#dont need individual years anymore
rm(crime_2011, crime_2012, crime_2013, crime_2014, crime_2015, crime_2016, crime_2017, crime_2018, crime_2019, lasd_crime)

st_write(crime_2011_to_2019, 'crime_sf.gpkg', driver='gpkg')

#for kde plot, rewriting package to separate lat/long cols
crime_sf <- sf::st_read('crime_sf.gpkg')
crime_sf <- geoformattr::geom_to_lonlat(crime_sf)

crime_sf_geom <- sf::st_read('crime_sf.gpkg')
geom <- data.frame(crime_sf_geom$geom)
crime_sf_bound <- bind_cols(crime_sf, geom)
st_write(crime_sf_bound, 'crime_sf_latlng.gpkg', driver='gpkg')




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
crime_map <- leaflet(crime_data_2017) %>%
  addProviderTiles(providers$CartoDB.DarkMatter)%>%
  addWebGLHeatmap(size=100, group="Most Heinous Crimes of 2011")

crime_map

qmap(location=c(lon=-118.284225, lat=34.158186), zoom= 9, maptype='toner')


%>%
   fitBounds(bbox[[1]],bbox[[2]],bbox[[3]],bbox[[4]])




setwd("~/Documents/HousingMap/lasd_crime_stats/")
lasd_crime_2005 <- sf::st_read('year2005.gpkg')
lasd_crime_2006 <- sf::st_read('year2006.gpkg')
lasd_crime_2007 <- sf::st_read('year2007.gpkg')
lasd_crime_2008 <- sf::st_read('year2008.gpkg')
lasd_crime_2009 <- sf::st_read('year2009.gpkg')
lasd_crime_2010 <- sf::st_read('year2010.gpkg')
lasd_crime_2011 <- sf::st_read('year2011.gpkg')
lasd_crime_2012 <- sf::st_read('year2012.gpkg')
lasd_crime_2013 <- sf::st_read('year2013.gpkg')
lasd_crime_2014 <- sf::st_read('year2014.gpkg')
lasd_crime_2015 <- sf::st_read('year2015.gpkg')
lasd_crime_2016 <- sf::st_read('year2016.gpkg')
lasd_crime_2017 <- sf::st_read('year2017.gpkg')
lasd_crime_2018 <- sf::st_read('year2018.gpkg')


lasd_crime <- rbind(lasd_crime_2005, lasd_crime_2006, lasd_crime_2007, lasd_crime_2008,
                    lasd_crime_2009, lasd_crime_2010, lasd_crime_2011, lasd_crime_2012,
                    lasd_crime_2013, lasd_crime_2014, lasd_crime_2015, lasd_crime_2016,
                    lasd_crime_2017, lasd_crime_2018)

rm(lasd_crime_2005, lasd_crime_2006, lasd_crime_2007, lasd_crime_2008,
   lasd_crime_2009, lasd_crime_2010, lasd_crime_2011, lasd_crime_2012,
   lasd_crime_2013, lasd_crime_2014, lasd_crime_2015, lasd_crime_2016,
   lasd_crime_2017, lasd_crime_2018)

lasd_crime <- lasd_crime[!sf::st_is_empty(lasd_crime),]

names(lasd_crime)[2] <- "crm_cd_desc"
names(lasd_crime)[1] <- 'date_occ'

lasd_crime[,c('STREET', 'CITY')] <- list(NULL)

#zillow data
property_data <- sf::st_read("property.gpkg")

property_data <- geoconvert::geom_to_lonlat(property_data)

#truncating crime data to only the past two years
crime_data <- sf::st_read('crime_sf.gpkg')
crime_data$date_occ <- as.Date(crime_data$date_occ, format='%Y-%m-%j')

crime_data_2017 <- crime_data[crime_data$date_occ > as.Date("2018-01-01"),]
crime_data_2017 <- na.omit(crime_data_2017)
st_write(crime_data_2017, 'crime_2017_onwards.gpkg', driver='gpkg')

crime_codes <- data.frame(unique(crime_data_2017$crm_cd_desc))


#save session data
save.image("~/Documents/HousingMap/R_data/")

