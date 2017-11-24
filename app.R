#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(geojsonio)
library(dplyr)
library(sp)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
  # Application title
  titlePanel("CX4242 Test Project"),
  
  tabsetPanel(
    tabPanel("National Median Days Away From Work",
        fluidRow(leafletOutput("map"),
                wellPanel(
                  selectInput("Industry",label = "Select Industry",
                              choices = industry),
                  selectInput("Predictor", label = "Select Predictor",
                              choices = predictors)
                )
      )
   )
))

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  
  
  filteredData <- reactive({df[df$description == input$industry,]
  })
  
  pal <- colorNumeric(palette="magma",domain = df$values)
  
  df %>% group_by(state_text,group_name,description.1) %>% summarise( median = median(value))
  
  output$map <- renderLeaflet({
    
  leaflet(states) %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                  color = ~pal(df$values))
  
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

