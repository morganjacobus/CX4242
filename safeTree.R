library(csvread)
library(randomForest)
library(party)
set.seed(400)

predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
for (i in 2:(nrow(predictors)-1)) {
  name <- predictors[i,1]
  dataset <- read.csv(paste(c('~/CX4242/project_files/', name, '_toy.csv'), collapse = ''))
  dataset <- dataset[1:nrow(dataset),2:ncol(dataset)]
  rf <- randomForest(value ~ ., data = dataset, importance = TRUE, ntree = 10)
  varImpPlot(rf)
  print(rf)
}



# dataset <- read.csv('~/CX4242/project_files/toy_data.csv')
# dataset <- dataset[1:nrow(dataset),2:ncol(dataset)]
# 
# rf <- randomForest(value ~ dataset$X16.19 + dataset$X20.24 + dataset$X25.34 + dataset$X35.44 + dataset$X45.54 + dataset$X55.64 + dataset$X65.,
#                    data = dataset, importance = TRUE, ntree = 10)
# varImpPlot(rf)
# print(rf)