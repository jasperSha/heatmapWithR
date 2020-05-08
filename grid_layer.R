library(sf)
library(raster)
library(stars)
library(rgdal)
library(dplyr)

#library for computing KNN (use the ann function)
library(yaImpute)
library(spatstat)

#zillow data from postgresql database
setwd('~/Documents/HousingMap/R_data/rental/')
zillow <- sf::st_read('property_distr.gpkg')
zillow <- geoformattr::geom_to_lonlat(zillow)
#convert to spatial points dataframe
coordinates(zillow) <- ~lon + lat

#aggregates all my property information by zipcode, finds median of their rent costs by zipcode
my_zillow_data <- aggregate(zillow$amount, by=list(Zipcode=zillow$zipcode), FUN=median)

#replaced zipbound null data with zillow data
for (i in seq_along(zipbounds$rental_average)) {
  for (j in seq_along(my_zillow_data)){
    if (is.na(zipbounds$rental_average[[i]])){
      zipbounds$rental_average[[i]] <- my_zillow_data$x[[j]]
    }
  }
}

#normalizes the rental average, sets mean to 0, and data ranges [-1, 1]
zVar <- data.frame(zipbounds$zipcode,(zipbounds$rental_average - mean(zipbounds$rental_average))/sd(zipbounds$rental_average))
names(zVar)[1] <- 'zipcode'

names(zVar)[2] <- 'zNorm'

#need to use @data to ensure spatial points structure
zipbounds@data <- left_join(zipbounds@data, zVar)

sapply(zipbounds@data, sd)

#std deviation of rent costs of all zipcodes
rental_std <- 529.597

#compare zillow with zipbounds rental averages. if they fall outside of rental_std, mark them.
str(zillow@data)





#SCHOOL OPERATIONS HERE
setwd('~/Documents/HousingMap/R_data/schools/')
schools <- sf::st_read('schools_distr.gpkg')

school_districts <- data.frame(unique(schools$DISTRICT))
names(school_districts)[1] <- 'districts'

schools <- geoformattr::geom_to_lonlat(schools)
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#converting to spatial points dataframe
coordinates(schools) <- ~lon + lat


#aggregates all my property information by zipcode, finds median of their school rating by zipcode
school_dist <- aggregate(schools$gsRating, by=list(DISTRICT=schools$DISTRICT), FUN=median, na.rm=TRUE)

#merges and tidies up names/ratings
zillow <- cbind(zillow, school_dist)
names(school_dist)[2] <- 'District Rating'
full_schools <- merge(schools, school_dist, by='DISTRICT')
full_schools <- full_schools[c(2, 4, 3, 5, 1, 6, 7)]


#convert to SpatialPointsDataFrame (this is for rgdal's writeOGR format only)
full_schools_sp <- as(full_schools, 'Spatial')

#for st_write, requires the geom column with c('lon', 'lat') format only (original full_schools format)
st_write(full_schools, 'full_schools.gpkg', driver='gpkg')






