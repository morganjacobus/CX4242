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
# Define UI for application that draws a histogram
ui <- fluidPage(
   
  # Application title
  titlePanel("CX4242 Test Project"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(position = "right",
                sidebarPanel(
                  selectInput("Industry",label = "Select Industry",
                              choices = industry),
                  selectInput("Predictor", label = "Select Predictor",
                              choices = predictors)
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                  leafletOutput("map")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  
  
  filteredData <- reactive({df[df$description == input$industry,]
  })
  
  df %>% group_by(state_text) %>% summarise( median = median(value))
  
  output$map <- renderLeaflet({
    
  leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
        options = providerTileOptions(noWrap = TRUE)
  )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

