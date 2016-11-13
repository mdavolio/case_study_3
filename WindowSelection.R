source(cleaning.R)
#Checking number of non-contacts within a prior 1-hour window of stress survey
count.list = list()
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - 3600
  id = stress$ID[i]
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
  id = stress$ID[i]
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
  id = stress$ID[i]
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
  id = stress$ID[i]
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

#24 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(merged_gsr)){
    if(merged_gsr$ID[j]==id){
      if(begintime < as.numeric(merged_gsr$Time[j])
         & as.numeric(merged_gsr$Time[j])< endtime)
        total = total + merged_gsr$Rate
        count = count +1
    }
  }
  stress$AverageGSR24[i] = total/count
}

#3 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*3)
  id = stress$ID[i]
  for(j in 1:nrow(merged_gsr)){
    if(merged_gsr$ID[j]==id){
      if(begintime < as.numeric(merged_gsr$Time[j])
         & as.numeric(merged_gsr$Time[j])< endtime)
        total = total + merged_gsr$Rate
      count = count +1
    }
  }
  stress$AverageGSR3[i] = total/count
}

#1 Hour Window GSR

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*1)
  id = stress$ID[i]
  for(j in 1:nrow(merged_gsr)){
    if(merged_gsr$ID[j]==id){
      if(begintime < as.numeric(merged_gsr$Time[j])
         & as.numeric(merged_gsr$Time[j])< endtime)
        total = total + merged_gsr$Rate
      count = count +1
    }
  }
  stress$AverageGSR1[i] = total/count
}

#24 Hour Window Total Steps

for (i in 1:nrow(stress)) {
  count=0
  total = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(merged_total_steps)){
    if(merged_total_steps$ID[j]==id){
      if(begintime < as.numeric(merged_total_steps$Time[j])
         & as.numeric(merged_total_steps$Time[j])< endtime)
        total = total + merged_total_steps$TotalSteps
      count = count +1
    }
  }
  stress$AverageTotalSteps24[i] = total/count
}