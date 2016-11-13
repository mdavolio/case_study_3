# Cleaning script

library(plyr)

# Survey *******************************************
survey <- ScriptDatum

keep_survey <- c('ScriptDatum.ScriptName','ScriptDatum.Response','ScriptDatum.Latitude',
         'ScriptDatum.Longitude','ScriptDatum.DeviceId','ScriptDatum.Timestamp')
survey <- survey[keep_survey]

survey <- rename(survey, c('ScriptDatum.ScriptName' = 'question','ScriptDatum.Response' = 'response',
                 'ScriptDatum.Latitude' = 'lat', 'ScriptDatum.Longitude' = 'long',
                 'ScriptDatum.DeviceId' = 'ID','ScriptDatum.Timestamp' = 'Time'))

stress <- subset(survey, question == 'Fatigue and Stress', 'ID' != 'A3D42651-5E3B-4459-AC8A-44B917A9C715')

# Contact Data **********************************
contact <- MicrosoftBandContactDatum

keep_contact <- c('MicrosoftBandContactDatum.DeviceId','MicrosoftBandContactDatum.Timestamp',
                  'MicrosoftBandContactDatum.State')

contact <- contact[keep_contact]

contact <- rename(contact, c('MicrosoftBandContactDatum.DeviceId' = 'ID',
                             'MicrosoftBandContactDatum.Timestamp' = 'Time',
                             'MicrosoftBandContactDatum.State' = 'State'))

connected <- subset(contact, State == 2)

# Heart Rate Data ***********************************
heartrate <- MicrosoftBandHeartRateDatum

keep_hr <- c('MicrosoftBandHeartRateDatum.HeartRate',
                   'MicrosoftBandHeartRateDatum.Timestamp',
                   'MicrosoftBandHeartRateDatum.DeviceId')

heartrate <- heartrate[keep_hr]

heartrate <- rename(heartrate, c('MicrosoftBandHeartRateDatum.DeviceId' = 'ID',
                             'MicrosoftBandHeartRateDatum.Timestamp' = 'Time',
                             'MicrosoftBandHeartRateDatum.HeartRate' = 'Rate'))


merged_hr <- merge(heartrate, connected, by = c('ID', 'Time'))

# GSR Data **********************************************

gsr <- MicrosoftBandGsrDatum

keep_gsr <- c('MicrosoftBandGsrDatum.Resistance',
             'MicrosoftBandGsrDatum.Timestamp',
             'MicrosoftBandGsrDatum.DeviceId')

gsr <- gsr[keep_gsr]

gsr <- rename(gsr, c('MicrosoftBandGsrDatum.DeviceId' = 'ID',
                     'MicrosoftBandGsrDatum.Timestamp' = 'Time',
                     'MicrosoftBandGsrDatum.Resistance' = 'Rate'))


merged_gsr <- merge(gsr, connected, by = c('ID', 'Time'))

# Accel Data **********************************************

accel <- MicrosoftBandAccelerometerDatum

keep_accel <- c('MicrosoftBandAccelerometerDatum.X',
              'MicrosoftBandAccelerometerDatum.Y',
              'MicrosoftBandAccelerometerDatum.Z',
              'MicrosoftBandAccelerometerDatum.DeviceId',
              'MicrosoftBandAccelerometerDatum.Timestamp')

accel <- accel[keep_accel]

accel <- rename(accel, c('MicrosoftBandAccelerometerDatum.X' = 'X',
                       'MicrosoftBandAccelerometerDatum.Y' = 'Y',
                       'MicrosoftBandAccelerometerDatum.Z' = 'Z',
                       'MicrosoftBandAccelerometerDatum.DeviceId' = 'ID',
                       'MicrosoftBandAccelerometerDatum.Timestamp' = 'Time'))


merged_accel <- merge(accel, connected, by = c('ID', 'Time'))

# Distance Data **********************************************

distance <- MicrosoftBandDistanceDatum

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
