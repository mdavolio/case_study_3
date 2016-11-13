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

stress <- subset(survey, question == 'Fatigue and Stress')

# Contactact Data **********************************
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


