# Case Study 3 code

library(SensusR)
library(klaR)
library(MASS)
library(car)
library(caret)
library(e1071)
library(ROCR)
library(pROC)
library(data.table)


band.contact.filtered <- subset(MicrosoftBandContactDatum, MicrosoftBandContactDatum.State ==2)

stress.response <- subset(ScriptDatum, ScriptDatum.ScriptName=='Fatigue and Stress')



names(band.contact.filtered)[names(band.contact.filtered)=="MicrosoftBandContactDatum.DeviceId"] <- "DeviceID"
names(stress.response)[names(stress.response)=="ScriptDatum.DeviceId"] <- "DeviceID"
names(MicrosoftBandGsrDatum)[names(MicrosoftBandGsrDatum)=="MicrosoftBandGsrDatum.DeviceId"] <- "DeviceID"
names(MicrosoftBandCaloriesDatum)[names(MicrosoftBandCaloriesDatum)=="MicrosoftBandCalories.DeviceId"] <- "DeviceID"






band.contact.filtered <- band.contact.filtered[band.contact.filtered$DeviceID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]
stress.response <- stress.response[stress.response$DeviceID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]


# C 

band.contact.filtered <- band.contact.filtered[band.contact.filtered$MicrosoftBandContactDatum.Month == 11,]
band.contact.filtered <- band.contact.filtered[band.contact.filtered$MicrosoftBandContactDatum.Month == 11,]






# Stepwise Selection for LDA

slda <- train(response ~ ., data = final.impute.df,
              method = "stepLDA",
              trControl = trainControl(method = "cv"))



# Final Model
fit <- lda(response ~ steps_ascended_avg_twentyfour + AverageGSR24, data=final.impute.df, CV=TRUE)

test.response <- list()
for(i in 1: nrow(final.impute.df)){
  testing = final.impute.df[i,]

  test.response <- c(test.response, testing$response)
  
}
fit$class
unlist(test.response)

mean.lda <- mean(fit$class==unlist(test.response))

#making confidence interval
n=34
z=1.96

sd <- (sum((as.numeric(fit$class)-unlist(test.response))^2)/n)^0.5

mean.lda + z*sd/(n^0.5) #upper bound of CI is 0.9112308
mean.lda - z*sd/(n^0.5) #lower bound of CI is 0.3828868

### computing accuracy of leave one out
acc.list.lda <- list()
test.response <- list()
predict.response <- list()
for(i in 1: nrow(final.impute.df)){
  testing = final.impute.df[i,]
  training = final.impute.df[-i,]
  fit <- lda(response ~ steps_ascended_avg_twentyfour + AverageGSR24, data=training)
  
  predict.response <- c(predict.response, predict(fit, testing)$class)
  test.response <- c(test.response, testing$response)
  
  
  
}

unlist(predict.response)
unlist(test.response)
mean(unlist(predict.response)==unlist(test.response))
###Accuracy is 0.58823



# calculate total percent correct

ct <- table(final.impute.df$response, fit$class)
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))




# Compute Confusion Matrix

tab <- table(final.impute.df$response, fit$class)
conCV1 <- rbind(tab[1, ]/sum(tab[1, ]), tab[2, ]/sum(tab[2, ]), tab[3, ]/sum(tab[3, ]), tab[4, ]/sum(tab[4, ]))
dimnames(conCV1) <- list(Actual = c("1", "2", "3", "4"), "Predicted (cv)" = c("1","2", "3", "4"))
print(round(conCV1, 3))



oldnames <- c('steps_ascended_avg_twentyfour','AverageGSR24')
newnames <- c('Average_Steps_Ascended', 'Average_GSR')
setnames(final.impute.df, oldnames, newnames)

# Scatter plot with color coding by group

pairs(final.impute.df[c("Average Steps Ascended","Average GSR")], main="Scatter Plot with Color-Coded Response Groups", pch=22, 
      bg=c("red", "yellow", "blue", "pink")[unclass(final.impute.df$response)])
par(xpd=TRUE)
legend(-0.03, 1.01, as.vector(unique(final.impute.df$response)),  
       fill=c("blue", "yellow", "pink", "red"))



# Partition Plot

partimat(response~ Average_Steps_Ascended+ Average_GSR,data=final.impute.df,method="lda", main = "Partition Plot")


dev.off()
