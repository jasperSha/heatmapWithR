#set working dir to heatmap
setwd("~/Documents/HousingMap/desirableZ/")


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


decade_of_crime.list <- list(crime_2011, crime_2012, crime_2013, crime_2014, crime_2015,
                     crime_2016, crime_2017, crime_2018, crime_2019)

#split POINT into long/lat for heatmap considerations
decade_of_crime.list <- lapply(decade_of_crime.list, geoformattr::geom_to_lonlat)

#filtered for only bodily_crimes
for (i in seq_along(decade_of_crime.list)) {
  decade_of_crime.list[[i]] <- filter(decade_of_crime.list[[i]], grepl(paste(bodily_crime, collapse="|"), crm_cd_desc))
}

#rowbind all years together to one frame
for (i in 2:length(decade_of_crime.list)) {
  x <- rbind(x, decade_of_crime.list[[i]])
}


#separate by property vs bodily
bodily_crime <- c("HOMICIDE", 
                   "AGGRAVATED", 
                   "SEXUAL", 
                   "FORCIBLE", 
                   "RAPE", 
                   "CHILD ABUSE", 
                   "FELONY", 
                   "HUMAN TRAFFICKING", 
                   "LYNCHING"
                   )

property_crime <- c("BURGLARY",
                   "THEFT",
                   "GRAND",
                   "ARSON",
                   "STOLEN",
                   'RECKLESS',
                   'ROBBERY',
                   'DISTURBING THE PEACE',
                   'ILLEGAL DUMPING',
                   'PROPERTY'
                   )

#require dplyr for filter
worst_crime_2011 <- filter(crime_2011, grepl(paste(severe_crimes, collapse="|"), crm_cd_desc))

rest_crimes_2011 <- data.frame(unique(crime_2011$crm_cd_desc[!crime_2011$crm_cd_desc %in% worst_crime_2011$crm_cd_desc]))


#list of every unique crime code
crime_codes <- data.frame(unique(crime_2019$crm_cd_desc))
crime_codes_freq <- sort(table(crime_2019$crm_cd_desc), decreasing=T)






library(leaflet)
library(leaflet.extras)
crime_map_2011 <- leaflet(x) %>%
  addProviderTiles(providers$CartoDB.DarkMatter)%>%
  addWebGLHeatmap(size=100, group="Most Heinous Crimes of 2011")%>%
  fitBounds(bounds[[1]],bounds[[2]],bounds[[3]],bounds[[4]])

crime_map_2011







#zillow data
property_data <- sf::st_read("property.gpkg")

property_data <- geoconvert::geom_to_lonlat(property_data)


#save session data
save.image("~/Documents/HousingMap/R_data/")

