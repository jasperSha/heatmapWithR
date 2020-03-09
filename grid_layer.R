library(sf)
library(raster)
library(stars)
library(rgdal)
library(dplyr)
#SCHOOL OPERATIONS HERE
setwd('~/Documents/HousingMap/R_data/schools/')
schools <- sf::st_read('school_package.gpkg')

schools <- geoformattr::geom_to_lonlat(schools)
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#converting to spatial points dataframe
coordinates(schools) <- ~lon + lat

#establishing extent for interpolation
x_range <- as.numeric(c(-119, -117)) #min/max longitude
y_range <- as.numeric(c(32, 35)) #min/max latitude

#create empty grid using extent ranges
#precision using 3 decimals for about 100 sq meters, about the size of a large field
grid <- expand.grid(x = seq(from = x_range[1],
                            to = x_range[2],
                            by = 0.001),
                    y = seq(from = y_range[1],
                            to = y_range[2],
                            by = 0.001))
#convert grid to spatial points object
coordinates(grid) <- ~x + y

#set CRS
proj4string(grid) <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
crs(schools) <- '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'


#turn into spatial pixels object
gridded(grid) <- TRUE


#library for computing KNN (use the ann function)
library(yaImpute)
library(spatstat)

setwd('~/Documents/HousingMap/R_data/rental/')
zillow <- sf::st_read('property.gpkg')
zillow <- geoformattr::geom_to_lonlat(zillow)

coordinates(zillow) <- ~lon + lat

zipbounds
zipbounds@data$zipcode
zipbounds@data$rental_average

#null_zipcodes list contains all zipcodes with null values
null_zipcodes <- list()
for (i in seq_along(zipbounds@data$rental_average)) {
  if (is.na(zipbounds@data$rental_average[[i]])) {
    null_zipcodes <- c(null_zipcodes, zipbounds@data$zipcode[[i]])
  }
}

null_zipcodes <- t(null_zipcodes)
null_zipcodes

df <- data.frame(matrix(unlist(null_zipcodes), nrow=length(null_zipcodes), byrow=T))
names(df)[1] <- 'zipcode'

#worst_crime_2011 <- filter(crime_2011, grepl(paste(severe_crimes, collapse="|"), crm_cd_desc))

df <- unlist(df)

my_zillow_data <- aggregate(zillow$amount, by=list(Zipcode=zillow$zipcode), FUN=median)

#replaced zipbound null data with zillow data
for (i in seq_along(zipbounds$rental_average)) {
  for (j in seq_along(my_zillow_data)){
    if (is.na(zipbounds$rental_average[[i]])){
      zipbounds$rental_average[[i]] <- my_zillow_data$x[[j]]
    }
  }
}










