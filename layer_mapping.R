library(leaflet)


pal <- colorNumeric("viridis", NULL)

leaflet(zipbounds) %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.8, fillOpacity = .35,
              fillColor = ~pal(log10(rental_average)),
              label = ~paste0(zipcode, ": ", formatC(rental_average, big.mark = ","))) %>%
  addLegend(pal = pal, values = ~log10(rental_average), opacity = 0.5,
            labFormat = labelFormat(transform = function(x) round(10^x)))




#home value index
hood_zri <- read.csv(file='ZRI_Home_Values.csv')

#requires dplyr library in order to preserve data.frame struct
hood_zri <- filter(hood_zri, hood_zri$CountyName=="Los Angeles County")
positions <- c(3, 233:293)

#found the HOME VALUE INDEX of each city in LOS ANGELES COUNTY
hood_zri <- hood_zri %>% select(positions)









