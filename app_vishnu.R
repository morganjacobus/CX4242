#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(plotly)
library(csvread)
library(randomForest)
library(party)
set.seed(400)

safeTree_predict <- function(industryName, predictor, attribute) {
  userChoice <- read.csv(paste(c('~/CX4242/project_files/database/Industry/', industryName, '/', tolower(predictor), '_toy.csv'), collapse = ''))
  print(ncol(userChoice))
  rf <- randomForest(value ~ ., data = userChoice, importance = TRUE, mtry= ncol(userChoice), ntree = 1000)
  userChoice <- userChoice[1,]
  for (i in 1:length(colnames(userChoice))) {
    if (attribute == colnames(userChoice)[i]) {
      userChoice[1,i] <- 1
    }
    else {
      userChoice[1,i] <- 0
    }
  }
  userPrediction <- predict(rf, userChoice)
  return(userPrediction)
}

df <- read.csv("~/CX4242/project_files/data_grouped.csv")
df$state_code <- state.abb[match(df$state_name,state.name)]
industry <- unique(df$industry)
predictors <- unique(df$predictor)
#df.group <- df %>% group_by(state_text,state_code,description,group_name,description.1) %>% summarise( median = median(value))
df$hover <- with(df, paste(df$state_name, '<br>', df$predictor, df$attribute, "<br>",
                           "Median DAFW", df$average))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("CX4242 Test Project"),
  
  tabsetPanel(
    tabPanel("National Median Days Away From Work",
             sidebarLayout(position = "right",
                           sidebarPanel(
                             selectInput("Industry",label = "Select Industry",
                                         choices = industry),
                             selectInput("Predictor", label = "Select Predictor",
                                         choices = predictors),
                             uiOutput("valueSelection")
                           ),
                           mainPanel(plotlyOutput("map"))
             )
    ),
    tabPanel("Days away from Work prediction model",
             sidebarLayout(position = "left",
                           sidebarPanel(
                             selectInput("Industry",label = "Select Industry",
                                         choices = industry),
                             selectInput("Predictor", label = "Select Predictor",
                                         choices = predictors),
                             uiOutput("valueSelectionRF")
                           ),
                           mainPanel(safeTree_predict('Accommodation and Food Services', 'Event', 'Falls, slips, trips'))
             )
    )
  ))


server <- function(input, output) {
  
  #Update Value select box
   output$valueSelection <- renderUI({
     selectInput("Value","Select value",choices = unique(df[df$industry == input$Industry & df$predictor == input$Predictor,]$attribute))
   })
   
   filteredData <- reactive({
     df.filter <-  df %>% filter(industry == input$Industry, predictor == input$Predictor,attribute == input$Value) #%>%
  
  })
   
  
  
  # output$values <- renderTable({
  #   filteredData()
  # })
  
  # 
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
      layout(
        title = 'Median DAFW By State<br>(Hover for breakdown)',
        geo = g
      )

  })
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)