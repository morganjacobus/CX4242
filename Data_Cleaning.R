library(csvread)
library(randomForest)
library(party)
library(xgboost)
set.seed(400)


#industries <- read.csv('~/CX4242/project_files/database/industries.csv', stringsAsFactors = FALSE)
predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
#windows()
#for (i in 2:(nrow(industries))) {
df <- read.csv('~/CX4242/project_files/database/data.csv')
for (i in 2:(nrow(predictors)-1)) {
  name <- predictors[i,1]
  df_toy <- subset(df,description=='Accommodation and Food Services' & group_name == name,select= description:value)
  df_toy_cleaned <- subset(df_toy, description.1 != "not reported")
  df_toy_cleaned$indicator <- 1
  groups <- unique(df_toy_cleaned["description.1"])
  
  industry <- unique(df$description)
  predictors <- unique(df$group_name)
  
  colnames.1 <-  as.vector(groups[["description.1"]])
  colnames.2 <- c("value")
  colnames.3 <- c(colnames.1,colnames.2)
  
  df.new = data.frame(matrix(ncol = length(colnames.3),nrow=nrow(df_toy_cleaned)))
  colnames(df.new) <- colnames.3
  
  for (row in 1:nrow(df_toy_cleaned)) {
    temp <- df_toy_cleaned[row,"description.1"]
    dafw <- df_toy_cleaned[row,"value"]
    ind <- df_toy_cleaned[row,'indicator']
    row.vals <- vector(mode='numeric',length = length(df.new))
    names(row.vals) <- colnames.3
    for (i in 1:length(colnames.3)) {
      if (temp == colnames.3[i]) {
        row.vals[i] <- 1
      } else {row.vals[i] <- 0}
    }
    
    row.vals[length(colnames.3)] <- dafw
    df.new[row,] <- row.vals
  } 
  write.csv(df.new, file = paste(c('~/CX4242/project_files/', predictors[i,1], '_toy.csv'), collapse = ''))
}











# #convert to lower case to be able to match files
# predictors_lower <- mutate_all(predictors, funs(tolower))
# oob.err=double(nrow(predictors) - 1)
# test.err=double(nrow(predictors) - 1)
# for (i in 2:nrow(predictors)) {
#   category <- predictors[i,1]
#   category_lower <- predictors_lower[i, 1]
#   categories <- read.csv(paste(c('~/CX4242/project_files/database/',category_lower, '_split.csv'), collapse = ''))
#   dataset <- occupationalInjuries[occupationalInjuries$group_name==category,]
#   train=sample(1:nrow(dataset),700)
#   rf <- randomForest(value ~ state_text  + description, data = dataset, subset = train, mtry = i, ntree = 10)
#   oob.err[i-1] = rf$mse[400]
#   prediction <- predict(rf, dataset[-train,])
#   test.err[i-1] = with(dataset[-train,], mean( (value - prediction)^2))
# }
# # oob.err=double(length(predictors) - 1)
# # test.err=double(length(predictors) - 1)
# # for(i in 1:length(predictors)) {
# #   train <- occupationalInjuries[occupationalInjuries$group_name==predictors[i],]
# #   print(train)
# #   rf <- randomForest(value ~ state_text + description.1, data = train, importance = TRUE, ntree = 200)
# #   varImpPlot(rf)
# # }