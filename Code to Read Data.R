library(SensusR)

setwd("~/Desktop/sys6018_cs3_data")
folders=list.files(path = '.')

for( i in 1:length(folders)){
  assign(paste0(folders[i]), as.data.frame(sensus.read.json(paste0('./' ,folders[i]))))
}


Stress_response<- ScriptDatum[ScriptDatum$ScriptDatum.ScriptName == 'Fatigue and Stress',]
Stress_response$ScriptDatum.Timestamp<-as.numeric(Stress_response$ScriptDatum.Timestamp)

Stress_response$ScriptDatum.Timestamp[1]
band.contact.filtered = subset(MicrosoftBandContactDatum, MicrosoftBandContactDatum.State ==2)

i = 0
j= 0
count<- []
for (i in 1:nrow(Stress_response)) {
  endtime = Stress_response$ScriptDatum.Timestamp[i]
  begintime = Stress_response$ScriptDatum.Timestamp[i] - 360
}