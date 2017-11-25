library(leaflet)
library(geojsonio)
library(geojson)
library(dplyr)


url <- "https://raw.githubusercontent.com/alignedleft/d3-book/master/chapter_14/us-states.json"
states <- geojson_read(url2,method = "local",what = "sp")


group.var <- "Age"
desc.var <- "16-19"

df.sum <- df %>% filter(group_name == group.var & description.1 == desc.var) %>% 
  group_by(state_text,group_name,description.1) %>% summarise( median = median(value))

pal <- colorNumeric(palette="YlOrRd",domain = df.sum$median)


m <- leaflet(states) %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = "pk.eyJ1IjoibW9yZ2FuamFjb2J1cyIsImEiOiJjamFjbzV6NGcwYzlzMzNwZDhmdmpvdDdlIn0.ZwTyMmjBOX_Qh_mjZ7FeFQ")) %>%
    addPolygons(fillColor = ~pal(df.sum$median),
                weight = 2,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7)

m
