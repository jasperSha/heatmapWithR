library(dplyr)
library(sf)
library(rgdal)
library(ggplot2)
library(maptools)
library(leaflet)

#zipcode centroids, given rent index by zip codes, assign to layer
setwd("~/Documents/HousingMap/R_data/zipcodes/")
zip_boundaries_with_centroids.shape <- readOGR(dsn=getwd(), layer='geo_export_d764188d-09b1-4f1a-bae8-9a19721aa37d')


setwd("~/Documents/HousingMap/R_data/")
zipbounds <- readOGR('ZIPCODES.geojson', stringsAsFactors = FALSE)

library(foreign)
library(maptools)
library(dplyr)
library(leaflet)

#adding rental average to geojson file
zipbounds@data <- left_join(zipbounds@data, rent_index)

#mutate zipbounds zipcode to integer for left_join
zipbounds@data[4] <- lapply(zipbounds@data[4], as.integer)

pal <- colorNumeric("viridis", NULL)

leaflet(zipbounds) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.8, fillOpacity = .35,
              fillColor = ~pal(log10(rental_average)),
              label = ~paste0(zipcode, ": ", formatC(rental_average, big.mark = ","))) %>%
  addLegend(pal = pal, values = ~log10(rental_average), opacity = 0.5,
            labFormat = labelFormat(transform = function(x) round(10^x)))




# rent index of Los Angeles County by zipcodes + formatting
rent_index <- read.csv(file= 'ZRI_by_zipcode.csv', stringsAsFactors = FALSE)
rent_index <- filter(rent_index, rent_index$County=="Los Angeles County")
rent_positions <- c(2, 8)
rent_index <- rent_index %>% select(rent_positions)
names(rent_index)[1] <- "zipcode"
names(rent_index)[2] <- "rental_average"




#home value index
hood_zri <- read.csv(file='ZRI_Home_Values.csv')

#requires dplyr library in order to preserve data.frame struct
hood_zri <- filter(hood_zri, hood_zri$CountyName=="Los Angeles County")
positions <- c(3, 233:293)

#found the HOME VALUE INDEX of each city in LOS ANGELES COUNTY
hood_zri <- hood_zri %>% select(positions)









