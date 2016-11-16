library(randomForest)

# Create randomized training/testing sets (75%/25%)
set.seed(14)
training.indices = sample(1:nrow(stress), as.integer(nrow(stress) * 0.75))
training.set = stress[training.indices,]
testing.set = stress[-training.indices,]

# Fit random forest (bagging can be achieved by setting mtry=p)

# stress$AverageGSR24[stress$AverageGSR24 == 0]<- NA
stress$classroom[stress$classroom == T] <- 1
stress$classroom[stress$classroom == F] <- 0
#Imputed
stress$response<- as.factor(stress$response)
rf.imputed = rfImpute(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + 
                      AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +
                      battery_avg_twentyfour + classroom + AverageSound24,
                      data = stress)

training.indices = sample(1:nrow(rf.imputed), as.integer(nrow(rf.imputed) * 0.75))
training.set = rf.imputed[training.indices,]
testing.set = rf.imputed[-training.indices,]

rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour 
                      + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 
                      +battery_avg_twentyfour + classroom + AverageSound24, 
                      data = training.set, na.action = na.omit)

# Predict testing data.
predictions = predict(rf.fit, newdata = testing.set)

# Output raw accuracy.
sum(predictions == testing.set[,"response"]) / nrow(testing.set)

# We can also get probabilities.
predict(rf.fit, newdata = testing.set, type = "prob")
