library(sf)
library(raster)
library(stars)
library(rgdal)
#SCHOOL OPERATIONS HERE
schools <- sf::st_read('school_package.gpkg')

schools <- geoconvert::geom_to_lonlat(schools)
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


#turn into spatial pixels object
gridded(grid) <- TRUE




