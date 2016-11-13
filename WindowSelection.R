source(cleaning.R)
#Checking number of non-contacts within a prior 1-hour window of stress survey
count.list = list()
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - 3600
  id = stress$ScriptDatum.DeviceId[i]
  for(j in 1:nrow(connected)){
    if(connected$ID[j]==id){
      if(begintime < as.numeric(connected$Time[j])
         & as.numeric(connected$Time[j])< endtime)
        count= count+1
    }
  }
  count.list = c(count.list, count)
}

sum(count.list==0) 
#49/71 non-contacts with window = 1 hour

#Checking number of non-contacts within a prior 2-hour window of stress survey
count.list = list()
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*2)
  id = stress$ScriptDatum.DeviceId[i]
  for(j in 1:nrow(connected)){
    if(connected$ID[j]==id){
      if(begintime < as.numeric(connected$Time[j])
         & as.numeric(connected$Time[j])< endtime)
        count= count+1
    }
  }
  count.list = c(count.list, count)
}

sum(count.list==0) 
#47/71 non-contacts with window =  2 hours

#Checking number of non-contacts within a prior 3-hour window of stress survey
count.list = list()
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*3)
  id = stress$ScriptDatum.DeviceId[i]
  for(j in 1:nrow(connected)){
    if(connected$ID[j]==id){
      if(begintime < as.numeric(connected$Time[j])
         & as.numeric(connected$Time[j])< endtime)
        count= count+1
    }
  }
  count.list = c(count.list, count)
}

sum(count.list==0) 
#45/71 zeros with window = 3 hours

#Checking number of non-contacts within a prior 24-hour window of stress survey
count.list = list()
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ScriptDatum.DeviceId[i]
  for(j in 1:nrow(connected)){
    if(connected$ID[j]==id){
      if(begintime < as.numeric(connected$Time[j])
         & as.numeric(connected$Time[j])< endtime)
        count= count+1
    }
  }
  count.list = c(count.list, count)
}

sum(count.list==0) 
#41/71 zeros with window = 24 hours 