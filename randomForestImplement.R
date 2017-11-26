library(csvread)
library(party)
occupationalInjuries <- read.csv('~/CX4242/project_files/database/data.csv')
# Create the forest.
age2015 <- occupationalInjuries[occupationalInjuries$group_name=='Age' & occupationalInjuries$year=='2015' & occupationalInjuries$description.1!='not reported',]
nature2015 <- occupationalInjuries[occupationalInjuries$group_name=='Nature' & occupationalInjuries$year=='2015',]
agee <- age2015[age2015$value==58,]
event2015 <- occupationalInjuries[occupationalInjuries$group_name=='Event' & occupationalInjuries$year=='2015',]
train=sample(1:nrow(age2015),300)
train2=sample(1:nrow(nature2015),300)
train3=sample(1:nrow(event2015),300)
oob.err=double(2)
test.err=double(2)
oob.err2 = double(2)
test.err2 = double(2)
oob.err3 = double(2)
test.err3 = double(2)

#mtry is no of Variables randomly chosen at each split
for(mtry in 1:2) 
{
  rf=randomForest(value ~ state_text + description , data = age2015 , subset = train,mtry=mtry,ntree=400)
  rf2=randomForest(value ~ state_text + description , data = nature2015 , subset = train2,mtry=mtry,ntree=400) 
  rf3=randomForest(value ~ state_text + description , data = event2015 , subset = train3,mtry=mtry,ntree=400) 
  oob.err[mtry] = rf$mse[400] #Error of all Trees fitted
  oob.err2[mtry] = rf2$mse[400] #Error of all Trees fitted
  oob.err3[mtry] = rf3$mse[400] #Error of all Trees fitted
  
  pred<-predict(rf,age2015[-train,]) #Predictions on Test Set for each Tree
  pred2<-predict(rf,nature2015[-train2,]) #Predictions on Test Set for each Tree
  pred3<-predict(rf,event2015[-train3,]) #Predictions on Test Set for each Tree
  test.err[mtry]= with(age2015[-train,], mean( (value - pred)^2)) #Mean Squared Test Error
  test.err2[mtry]= with(nature2015[-train2,], mean( (value - pred2)^2)) #Mean Squared Test Error
  test.err3[mtry]= with(event2015[-train3,], mean( (value - pred3)^2)) #Mean Squared Test Error
  
  cat(mtry," ") #printing the output to the console
  
}
