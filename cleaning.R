# Cleaning script

library(plyr)

# Survey *******************************************
survey <- ScriptDatum

survey <- survey[survey$ScriptDatum.InputId != 'bf5df24b-696d-48f0-80df-b7757ca4585a',]

keep_survey <- c('ScriptDatum.ScriptName','ScriptDatum.Response','ScriptDatum.Latitude',
         'ScriptDatum.Longitude','ScriptDatum.DeviceId','ScriptDatum.Timestamp')

survey <- survey[keep_survey]

survey <- rename(survey, c('ScriptDatum.ScriptName' = 'question','ScriptDatum.Response' = 'response',
                 'ScriptDatum.Latitude' = 'lat', 'ScriptDatum.Longitude' = 'long',
                 'ScriptDatum.DeviceId' = 'ID','ScriptDatum.Timestamp' = 'Time'))

survey <- subset(survey, survey$question=='Fatigue and Stress')

stress <- survey[survey$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

stress$stressed <- as.numeric(stress$response >=4)

# Contact Data **********************************
contact <- MicrosoftBandContactDatum

contact <- contact[contact$MicrosoftBandContactDatum.Month == 11,]

keep_contact <- c('MicrosoftBandContactDatum.DeviceId','MicrosoftBandContactDatum.Timestamp',
                  'MicrosoftBandContactDatum.State')

contact <- contact[keep_contact]

contact <- rename(contact, c('MicrosoftBandContactDatum.DeviceId' = 'ID',
                             'MicrosoftBandContactDatum.Timestamp' = 'Time',
                             'MicrosoftBandContactDatum.State' = 'State'))

connected <- subset(contact, State == 2)

connected <- connected[connected$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

# Heart Rate Data ***********************************
heartrate <- MicrosoftBandHeartRateDatum

heartrate <- heartrate[heartrate$MicrosoftBandHeartRateDatum.Month == 11,]

keep_hr <- c('MicrosoftBandHeartRateDatum.HeartRate',
                   'MicrosoftBandHeartRateDatum.Timestamp',
                   'MicrosoftBandHeartRateDatum.DeviceId')

heartrate <- heartrate[keep_hr]

heartrate <- rename(heartrate, c('MicrosoftBandHeartRateDatum.DeviceId' = 'ID',
                             'MicrosoftBandHeartRateDatum.Timestamp' = 'Time',
                             'MicrosoftBandHeartRateDatum.HeartRate' = 'Rate'))


merged_hr <- merge(heartrate, connected, by = c('ID', 'Time'))

merged_hr <- merged_hr[merged_hr$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

# GSR Data **********************************************

gsr <- MicrosoftBandGsrDatum

gsr <- gsr[gsr$MicrosoftBandGsrDatum.Month == 11,]

keep_gsr <- c('MicrosoftBandGsrDatum.Resistance',
             'MicrosoftBandGsrDatum.Timestamp',
             'MicrosoftBandGsrDatum.DeviceId')

gsr <- gsr[keep_gsr]

gsr <- rename(gsr, c('MicrosoftBandGsrDatum.DeviceId' = 'ID',
                     'MicrosoftBandGsrDatum.Timestamp' = 'Time',
                     'MicrosoftBandGsrDatum.Resistance' = 'Rate'))


merged_gsr <- merge(gsr, connected, by = c('ID', 'Time'))

merged_gsr <- merged_gsr[merged_gsr$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

# Accel Data **********************************************

accel <- AccelerometerDatum

accel <- accel[accel$AccelerometerDatum.Month == 11,]

keep_accel <- c('AccelerometerDatum.X',
              'AccelerometerDatum.Y',
              'AccelerometerDatum.Z',
              'AccelerometerDatum.DeviceId',
              'AccelerometerDatum.Timestamp')

accel <- accel[keep_accel]

accel <- rename(accel, c('AccelerometerDatum.X' = 'X',
                       'AccelerometerDatum.Y' = 'Y',
                       'AccelerometerDatum.Z' = 'Z',
                       'AccelerometerDatum.DeviceId' = 'ID',
                       'AccelerometerDatum.Timestamp' = 'Time'))


merged_accel <- merge(accel, connected, by = c('ID', 'Time'))

merged_accel <- merged_accel[merged_accel$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

# Distance Data **********************************************

distance <- MicrosoftBandDistanceDatum

distance <- distance[distance$MicrosoftBandDistanceDatum.Month == 11,]

keep_distance <- c('MicrosoftBandDistanceDatum.TotalDistance',
                   'MicrosoftBandDistanceDatum.MotionType',
                   'MicrosoftBandDistanceDatum.DeviceId',
                   'MicrosoftBandDistanceDatum.Timestamp')

distance <- distance[keep_distance]

distance <- rename(distance, c('MicrosoftBandDistanceDatum.TotalDistance' = 'distance',
                               'MicrosoftBandDistanceDatum.MotionType' = 'type',
                               'MicrosoftBandDistanceDatum.DeviceId' = 'ID',
                               'MicrosoftBandDistanceDatum.Timestamp' = 'Time'))


merged_distance <- merge(distance, connected, by = c('ID', 'Time'))

merged_distance <- merged_distance[merged_distance$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

####Steps Ascended Data *********************************
steps_ascended<- MicrosoftBandStepDatum

steps_ascended <- steps_ascended[steps_ascended$MicrosoftBandStepDatum.Month == 11,]

keep_steps_ascended<- c('MicrosoftBandStepDatum.StepsAscended',
                        'MicrosoftBandStepDatum.Timestamp',
                        'MicrosoftBandStepDatum.DeviceId')

steps_ascended<- steps_ascended[keep_steps_ascended]

steps_ascended<- rename(steps_ascended, c('MicrosoftBandStepDatum.DeviceId' = 'ID',
                                          'MicrosoftBandStepDatum.Timestamp' = 'Time',
                                          'MicrosoftBandStepDatum.StepsAscended' = 'Steps'))

merged_steps_ascended<- merge(steps_ascended, connected, by = c('ID', 'Time'))

merged_steps_ascended <- merged_steps_ascended[merged_steps_ascended$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

###Steps Taken *********************************
total_steps<- MicrosoftBandPedometerDatum

total_steps <- total_steps[total_steps$MicrosoftBandPedometerDatum.Month == 11,]

keep_total_steps<- c('MicrosoftBandPedometerDatum.TotalSteps',
                     'MicrosoftBandPedometerDatum.Timestamp',
                     'MicrosoftBandPedometerDatum.DeviceId')

total_steps<- total_steps[keep_total_steps]

total_steps<- rename(total_steps, c('MicrosoftBandPedometerDatum.DeviceId' = 'ID',
                                    'MicrosoftBandPedometerDatum.Timestamp' = 'Time',
                                    'MicrosoftBandPedometerDatum.TotalSteps' = 'TotalSteps'))
merged_total_steps<- merge(total_steps, connected, by = c('ID', 'Time'))

merged_total_steps <- merged_total_steps[merged_total_steps$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]


###batery life *********************************
battery<- BatteryDatum

battery <- battery[battery$BatteryDatum.Month == 11,]

keep_battery<- c('BatteryDatum.Level',
                 'BatteryDatum.Timestamp',
                 'BatteryDatum.DeviceId')

battery <- battery[keep_battery]

battery<- rename(battery, c('BatteryDatum.DeviceId' = 'ID',
                            'BatteryDatum.Timestamp' = 'Time',
                            'BatteryDatum.Level' = 'Life'))

battery <- battery[battery$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]


### classroom access *********************************
datamining <- PointOfInterestProximityDatum

datamining <- datamining[datamining$PointOfInterestProximityDatum.Month == 11,]

keep_datamining<- c('PointOfInterestProximityDatum.Timestamp',
                    'PointOfInterestProximityDatum.DeviceId')

datamining <- datamining[keep_datamining]

datamining<- rename(datamining, c('PointOfInterestProximityDatum.Timestamp' = 'Time',
                                  'PointOfInterestProximityDatum.DeviceId' = 'ID'))

datamining <- datamining[datamining$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]


### sound data *********************************
sound <- SoundDatum

sound <- sound[sound$SoundDatum.Month == 11,]

keep_sound<- c('SoundDatum.Timestamp',
               'SoundDatum.DeviceId',
               'SoundDatum.Decibels')

sound <- sound[keep_sound]

sound <- rename(sound, c('SoundDatum.Timestamp' = 'Time',
                         'SoundDatum.DeviceId' = 'ID',
                         'SoundDatum.Decibels' = 'Decibels'))

sound <- sound[sound$ID != 'A3D42651-5E3B-4459-AC8A-44B917A9C715',]

### imputing missing values
#save a dataframe in which if GSR data = 0, then make it NA
library(randomForest)
stressGSR = stress
stressGSR$AverageGSR24[stressGSR$AverageGSR24 ==0 ] <- NA
stressGSR$response<- as.factor(stressGSR$response)
stressGSR$question<- NULL

rf.imputed = rfImpute(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour,
                      data = stressGSR)

impute1 <- rf.imputed
impute2 <- rfImpute(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour,
                   data = stressGSR)
list(impute2$AverageGSR24)
list(impute1$AverageGSR24)

impute1.m <- data.matrix(impute1, rownames.force = NA)
my.list <- list()
for(i in 1:100){
  temp.impute <- rfImpute(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour,
                          data = stressGSR)
  temp.impute.m <- data.matrix(temp.impute, rownames.force = NA)
  my.list[[i]] <- temp.impute.m
}
my.list[[1]]

final.impute <- Reduce("+", my.list) / length(my.list)
final.impute.df <- as.data.frame(final.impute)

### Megan's code
final.impute.df$response<- as.factor(final.impute.df$response)
final.impute.df.binary <- final.impute.df
final.impute.df.binary$response==4 | final.impute.df.binary$response==5

set.seed(12)
training.indices = sample(1:nrow(final.impute.df), as.integer(nrow(final.impute.df) * 0.75))
training.set = final.impute.df[training.indices,]
testing.set = final.impute.df[-training.indices,]

rf.fit = randomForest(response ~ steps_ascended_avg_twentyfour + hr_avg_twentyfour + AverageTotalSteps24 + AverageGSR24 +AverageDistance24 +battery_avg_twentyfour, 
                      data = training.set, na.action = na.omit)

# Predict testing data.
predictions = predict(rf.fit, newdata = testing.set)

# Output raw accuracy.
sum(predictions == testing.set[,"response"]) / nrow(testing.set)

# We can also get probabilities.
predict(rf.fit, newdata = testing.set, type = "prob")
