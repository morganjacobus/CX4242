library(leaflet)
library(geojsonio)
library(geojson)
library(dplyr)

url <- "http://leafletjs.com/examples/choropleth/us-states.js"

# read as text file
doc <- readLines(url)

# remove the javascript assignment at the front 
doc2 <- gsub("var statesData = ", "", doc)

# write out as a temp file and read
write(doc2, file = "tempgeo.json")
states <- geojson_read("tempgeo.json", what = "sp")

pal <- colorNumeric(palette="magma",domain = df$values)


m <- leaflet(states) %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = "pk.eyJ1IjoibW9yZ2FuamFjb2J1cyIsImEiOiJjamFjbzV6NGcwYzlzMzNwZDhmdmpvdDdlIn0.ZwTyMmjBOX_Qh_mjZ7FeFQ")) %>%
    addPolygons()

m
