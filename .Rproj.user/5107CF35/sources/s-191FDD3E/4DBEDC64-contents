library(dplyr)
library(sf)
library(rgdal)
library(maptools)
library(leaflet)
library(foreign)
setwd("~/Documents/HousingMap/R_data/")


# rent index of Los Angeles County by zipcodes + formatting
rent_index <- read.csv(file= 'ZRI_by_zipcode.csv', stringsAsFactors = FALSE)
rent_index <- filter(rent_index, rent_index$County=="Los Angeles County")
rent_positions <- c(2, 8)
rent_index <- rent_index %>% dplyr::select(rent_positions)
names(rent_index)[1] <- "zipcode"
names(rent_index)[2] <- "rental_average"

zipbounds <- readOGR('ZIPCODES.geojson', stringsAsFactors = FALSE)

#mutate zipbounds zipcode to integer for left_join
zipbounds@data[4] <- lapply(zipbounds@data[4], as.integer)

#adding rental average to geojson file
zipbounds@data <- left_join(zipbounds@data, rent_index)
