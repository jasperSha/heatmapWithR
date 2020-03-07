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
x_range <- as.numeric(c(-118.9447, -117.6464)) #min/max longitude
y_range <- as.numeric(c(32.7952, 34.8233)) #min/max latitude



plot(schools)




#raster layer off zipcode boundaries
r <- raster(zipbounds)
dim(r) <- c(1000, 1000)

zip_spdf <- as(zipbounds,'SpatialLinesDataFrame')

r <- raster(nrow=1000, ncols = 1000, ext=extent(zip_spdf))
r <- rasterize(zip_spdf, r)

extent(zipbounds)

s <- raster(nrow=1000, ncols = 1000, ext=extent(zipbounds))
res(s)
extent(s)
