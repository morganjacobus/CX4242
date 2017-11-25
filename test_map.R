library(leaflet)
library(geojsonio)
library(geojson)
library(dplyr)
library(spdplyr)

url <- "https://raw.githubusercontent.com/alignedleft/d3-book/master/chapter_14/us-states.json"
states <- geojson_read(url,method = "local",what = "sp")
head(states@data,10)



group.var <- "Age"
desc.var <- "16-19"

df.sum <- df %>% filter(group_name == group.var & description.1 == desc.var) %>% 
  group_by(state_text,group_name,description.1) %>% summarise( median = median(value))

states <- states %>% filter(name %in% df.sum$state_text)

states@data <- merge(states@data,df.sum,by.x="name",by.y="state_text")


pal <- colorNumeric(palette="YlOrRd",domain = df.sum$median)


labels <- sprintf(
  "<strong>%s</strong><br/>%g DAFW",
  states$name, states$median
) %>% lapply(htmltools::HTML)

m <- leaflet(states) %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = "pk.eyJ1IjoibW9yZ2FuamFjb2J1cyIsImEiOiJjamFjbzV6NGcwYzlzMzNwZDhmdmpvdDdlIn0.ZwTyMmjBOX_Qh_mjZ7FeFQ")) %>%
    addPolygons(fillColor = ~pal(median),
                weight = 2,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                highlight = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto"))

m
