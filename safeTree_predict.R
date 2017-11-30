library(csvread)
library(randomForest)
library(party)
set.seed(400)

safeTree_predict <- function(industryName, predictor, attribute) {
  userChoice <- read.csv(paste(c('~/CX4242/project_files/database/Industry/', industryName, '/', tolower(predictor), '_toy.csv'), collapse = ''))
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

print(safeTree_predict('Accommodation and Food Services', 'Event', 'Falls, slips, trips'))