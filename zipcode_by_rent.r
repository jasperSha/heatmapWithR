library(dplyr)
library(sf)
library(rgdal)

#zipcode centroids, given rent index by zip codes, assign to layer
setwd("~/Documents/HousingMap/R_data/zipcodes/")
zip_boundaries_with_centroids.shape <- readOGR(dsn=getwd(), layer='geo_export_d764188d-09b1-4f1a-bae8-9a19721aa37d')


setwd("~/Documents/HousingMap/R_data/")
zipbounds <- readOGR('ZIPCODES.geojson')



# rent index of Los Angeles County by zipcodes
rent_index <- read.csv(file= 'ZRI_by_zipcode.csv')
rent_index <- filter(rent_index, rent_index$County=="Los Angeles County")
rent_positions <- c(2, 6, 8)
rent_index <- rent_index %>% select(rent_positions)







#home value index
hood_zri <- read.csv(file='ZRI_Home_Values.csv')

#requires dplyr library in order to preserve data.frame struct
hood_zri <- filter(hood_zri, hood_zri$CountyName=="Los Angeles County")
positions <- c(3, 233:293)

#found the HOME VALUE INDEX of each city in LOS ANGELES COUNTY
hood_zri <- hood_zri %>% select(positions)


