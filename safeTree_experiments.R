library(csvread)
library(ggRandomForests)
library(randomForestSRC)
library(party)
library(rfPermute)
set.seed(400)


industries <- read.csv('~/CX4242/project_files/database/industries.csv', stringsAsFactors = FALSE)
#windows()

predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
industry <- as.character(industries[6,1])
predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
name <- predictors[1,1]
dataset <- read.csv(paste(c('~/CX4242/project_files/database/Industry/', industry, '/', tolower(name), '_toy.csv'), collapse = ''))
dataset <- dataset[1:nrow(dataset),2:ncol(dataset)]
rowend <- floor(2*nrow(dataset)/3)
train <- dataset[1:rowend,1:ncol(dataset)]
test <- dataset[(rowend+1):nrow(dataset),1:ncol(dataset)]
rf <- rfsrc(value ~ . - value, data = train, importance = TRUE, nsplit = 2)
err  <- gg_error(rf)
plot(rf)
predictions <- predict.rfsrc(rf, test)
test.err <- with(test, mean( (value - predictions)^2)) 
# oob.err = rf$mse # to account for number of predictors
# # prediction <- predict(rf, test)
# print(table(prediction, test$value))
#test.err = with(dataset[-train,], mean( (value - prediction)^2)) # to account for number of predictors
#     # print(prediction)
#     # plot(varImpPlot(rf)
#     # print(rf$oob.times)
#     # print(getTree(rf))
#     # print(importance(rf))
# main_oob.err[i-1] <- main_oob.err[i-1] + oob.err[i-1]
# main_test.err[i-1] <- main_test.err[i-1] + test.err[i-1]
# print(oob.err)
# print(test.err)

