#This script assumes that the final dataframe is final.imput.df
### dummy model accuracy. 
set.seed(12)
acc.dummy.list <- list()
for(i in 1:100){
  training.indices = sample(1:nrow(final.impute.df), as.integer(nrow(final.impute.df) * 0.75))
  training.set = final.impute.df[training.indices,]
  table(training.set$response)
  acc.dummy <- sum(training.set$response == 3)/nrow(training.set)
  acc.dummy.list <- c(acc.dummy.list, acc.dummy)
}
mean(unlist(acc.dummy.list))

###Random Forest Accuracy with all the variables
##NOTE: There might be errors when you run the the loop due to randomness of the training set
###thus, rerun lines 19-36
final.impute.df$response<- as.factor(final.impute.df$response)
set.seed(12)
rf.acc.list <- list()
for (i in 1:50){
  training.indices = sample(1:nrow(final.impute.df), as.integer(nrow(final.impute.df) * .94))
  training.set = final.impute.df[training.indices,]
  testing.set = final.impute.df[-training.indices,]
  
    rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 
                          + AverageGSR24 +AverageDistance24 + battery_avg_twentyfour + classroom + AverageSound24,
                          data = training.set, na.action = na.omit)
  
  # Predict testing data.
  predictions = predict(rf.fit, newdata = testing.set)
  
  # Output raw accuracy.
  acc <- sum(predictions == testing.set[,"response"]) / nrow(testing.set)
  rf.acc.list <- c(rf.acc.list, acc)
}
mean(unlist(rf.acc.list))

acc.everything <- mean(c(0.446,.433, 0.4933, 0.4733, 0.4))
### Mean is .44912 for everything

### Random Forest Accuracy for only physiological factors
set.seed(12)
rf.acc.list <- list()
for (i in 1:50){
  training.indices = sample(1:nrow(final.impute.df), as.integer(nrow(final.impute.df) * .94))
  training.set = final.impute.df[training.indices,]
  testing.set = final.impute.df[-training.indices,]
  
  rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 
                        + AverageGSR24,
                        data = training.set, na.action = na.omit)
  
  # Predict testing data.
  predictions = predict(rf.fit, newdata = testing.set)
  
  # Output raw accuracy.
  acc <- sum(predictions == testing.set[,"response"]) / nrow(testing.set)
  rf.acc.list <- c(rf.acc.list, acc)
}
mean(unlist(rf.acc.list))

acc.physiological <- mean(c(0.48,.44, 0.513, 0.506, 0.526))
###Mean is .493 for physiological features

### Random Forest Accuracy for stepwise feature selection on LDA model (Hampton's method)
set.seed(12)
rf.acc.list <- list()
for (i in 1:50){
  training.indices = sample(1:nrow(final.impute.df), as.integer(nrow(final.impute.df) * .94))
  training.set = final.impute.df[training.indices,]
  testing.set = final.impute.df[-training.indices,]
  
  rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + AverageGSR24,
                        data = training.set, na.action = na.omit)
  
  # Predict testing data.
  predictions = predict(rf.fit, newdata = testing.set)
  
  # Output raw accuracy.
  acc <- sum(predictions == testing.set[,"response"]) / nrow(testing.set)
  rf.acc.list <- c(rf.acc.list, acc)
}
mean(unlist(rf.acc.list))

acc.subset <- mean(c(0.4733,.5, 0.5133, 0.5, 0.573))
### Mean is .44912 for subsetted features