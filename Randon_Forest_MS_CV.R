library(randomForest)

# Create randomized training/testing sets (75%/25%)
set.seed(12)
training.indices = sample(1:nrow(stress), as.integer(nrow(stress) * 0.75))
training.set = stress[training.indices,]
testing.set = stress[-training.indices,]

# Fit random forest (bagging can be achieved by setting mtry=p)

stress$AverageGSR24[stress$AverageGSR24 == 0]<- NA
#Imputed
stress$response<- as.factor(stress$response)
rf.imputed = rfImpute(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour,
                      data = stress)

set.seed(12)
training.indices = sample(1:nrow(rf.imputed), as.integer(nrow(rf.imputed) * 0.75))
training.set = rf.imputed[training.indices,]
testing.set = rf.imputed[-training.indices,]

rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour, 
                      data = training.set, na.action = na.omit)

# Predict testing data.
predictions = predict(rf.fit, newdata = testing.set)

# Output raw accuracy.
sum(predictions == testing.set[,"response"]) / nrow(testing.set)

# We can also get probabilities.
predict(rf.fit, newdata = testing.set, type = "prob")

#Cross Validation
#Drop unneeded columns from DF:
keep<- c ('response', 'steps_ascended_avg_twentyfour', 'hr_avg_twentyfour',  
           'AverageTotalSteps24', 'AverageGSR24' , 'AverageDistance24', 'battery_avg_twentyfour')
clean<- rf.imputed[keep]
y<- clean$response
x<- clean
x$response<- NULL
rfcv(x,y,cv.fold =5)
importance(rf.fit)
