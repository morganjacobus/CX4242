library(shiny)
library(dplyr)
library(plotly)
library(csvread)
library(randomForest)
library(party)
set.seed(400)

source("random_forest.R")



df <- read.csv("~/Georgia Tech/CX4242/project_files/application/final_app/data_grouped.csv",header = TRUE,
               colClasses = c("integer", "character","character","character","character","character","numeric","character"))
#df$state_code <- state.abb[match(df$state_name,state.name)]
industry <- unique(df$industry)
predictors <- unique(df$predictor)
#df.group <- df %>% group_by(state_text,state_code,description,group_name,description.1) %>% summarise( median = median(value))
#df$hover <- with(df, paste(df$state_name, '<br>', df$predictor, df$attribute, "<br>",
 #                          "Median DAFW", df$average))


ui <- fluidPage(theme = "bootstrap.css",
  
  # Application title
  titlePanel("CX4242 Test Project"),
  
  tabsetPanel(
    tabPanel("National Median Days Away From Work",
             sidebarLayout(position = "right",
                           sidebarPanel(tags$head(tags$style(type="text/css", "#loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #CCFF66;
               z-index: 105;
             }
          ")),
                             selectInput("Industry",label = "Select Industry",
                                         choices = industry,
                                         selected = "Accommodation and Food Services"),
                             selectInput("Predictor", label = "Select Predictor",
                                         choices = predictors,
                                         selected = "Age"),
                             uiOutput("valueSelection"),
                             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                              tags$div("Loading...",id="loadmessage"))
                           ),
                             mainPanel(plotlyOutput("map"))
                           #tableOutput("values")
             )
    ),
    tabPanel("Days Away From Work Prediction Tool",
             sidebarLayout(position = "left",
                           sidebarPanel(
                             selectInput("Industry2",label = "Select Industry",
                                         choices = industry,
                                         selected = "Accommodation and Food Services"),
                             selectInput("Predictor2", label = "Select Predictor",
                                         choices = predictors,
                                         selected = "Age"),
                             uiOutput("valueSelection2"),
                             sliderInput("ntrees","Select Number of Trees",min = 10,max = 100,
                                         value = 10,step = 10)
                           ),
                           mainPanel(plotOutput("error_plot"))
             )
    )
  ))


server <- function(input, output) {
  
  #Update Value select box
  output$valueSelection <- renderUI({
    selectInput("Value","Select Attribute",choices = unique(df[df$industry == input$Industry & df$predictor == input$Predictor,]$attribute),
                selected = "16-19")
  })
  
  output$valueSelection2 <- renderUI({
    selectInput("Value2","Select Attribute",choices = unique(df[df$industry == input$Industry2 & df$predictor == input$Predictor2,]$attribute),
                selected = "16-19")
  })
  
  filteredData <- reactive({
    df.filter <-  df %>% filter(industry == input$Industry, predictor == input$Predictor,attribute == input$Value) #%>%
    
  })
  
  rf_output <- reactive({safeTree_predict(input$Industry2, input$Predictor2, input$Value2)})
  
  output$error_plot <- renderPlot({plot(rf_output()$rf)})
  
  output$values <- renderTable({
     filteredData()
   })
  
    
  output$map <- renderPlotly({
    
    l <- list(color = toRGB("white"), width = 2)
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    plot_geo(filteredData(), locationmode = 'USA-states') %>%
      add_trace(
        z = ~average, text = ~hover, locations = ~state_code,
        color = ~average, colors = 'YlOrRd'
      ) %>%
      colorbar(title = "Days") %>%
      layout(margin = list(t=105),
        title = 'Median DAFW By State<br>(Hover for breakdown)',
        geo = g
      )
    
  })
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

