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


#24 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(merged_distance)){
    if(merged_distance$ID[j]==id){
      if(begintime < as.numeric(merged_distance$Time[j])
         & as.numeric(merged_distance$Time[j])< endtime)
        total = total + merged_distance$distance
      count = count +1
    }
  }
  stress$AverageDistance24[i] = total/count
}



#3 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*3)
  id = stress$ID[i]
  for(j in 1:nrow(merged_distance)){
    if(merged_distance$ID[j]==id){
      if(begintime < as.numeric(merged_distance$Time[j])
         & as.numeric(merged_distance$Time[j])< endtime)
        total = total + merged_distance$distance
      count = count +1
    }
  }
  stress$AverageDistance3[i] = total/count
}

#1 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*1)
  id = stress$ID[i]
  for(j in 1:nrow(merged_distance)){
    if(merged_distance$ID[j]==id){
      if(begintime < as.numeric(merged_distance$Time[j])
         & as.numeric(merged_distance$Time[j])< endtime)
        total = total + merged_distance$distance
      count = count +1
    }
  }
  stress$AverageDistance1[i] = total/count
}



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
