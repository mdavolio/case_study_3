# Case Study 3 code

library(SensusR)
library(klaR)
library(MASS)
library(car)
library(caret)
library(e1071)
library(ROCR)
library(pROC)


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




# calculate total percent correct

ct <- table(final.impute.df$response, fit$class)
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))




# Compute Confusion Matrix

tab <- table(final.impute.df$response, fit$class)
conCV1 <- rbind(tab[1, ]/sum(tab[1, ]), tab[2, ]/sum(tab[2, ]), tab[3, ]/sum(tab[3, ]), tab[4, ]/sum(tab[4, ]))
dimnames(conCV1) <- list(Actual = c("1", "2", "3", "4"), "Predicted (cv)" = c("1","2", "3", "4"))
print(round(conCV1, 3))




# Scatter plot with color coding by group

pairs(final.impute.df[c("steps_ascended_avg_twentyfour","AverageGSR24")], main="My Title ", pch=22, 
      bg=c("red", "yellow", "blue", "pink")[unclass(final.impute.df$response)])



# Partition Plot

partimat(response~ steps_ascended_avg_twentyfour+ AverageGSR24,data=final.impute.df,method="lda")

