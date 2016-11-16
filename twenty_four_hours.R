# Average desired varaibles over a 24 hour window

# Distance
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

# GSR
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

# Total Steps
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

# Steps Ascended
for (i in 1:nrow(stress)) {
  sum = 0
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(merged_steps_ascended)){
    if(merged_steps_ascended$ID[j]==id){
      if(begintime < as.numeric(merged_steps_ascended$Time[j])
         & as.numeric(merged_steps_ascended$Time[j])< endtime){
        sum = sum + merged_steps_ascended$Steps[j]
        count = count + 1
      }
      
    }
  }
  
  stress$steps_ascended_avg_twentyfour[i] = sum / count
}

# Heart Rate
for (i in 1:nrow(stress)) {
  sum = 0
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(merged_hr)){
    if(merged_hr$ID[j]==id){
      if(begintime < as.numeric(merged_hr$Time[j])
         & as.numeric(merged_hr$Time[j])< endtime){
        sum = sum + merged_hr$Rate[j]
        count = count + 1
      }
      
    }
  }
  
  stress$hr_avg_twentyfour[i] = sum / count
}


# Battery
for (i in 1:nrow(stress)) {
  sum = 0
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*24)
  id = stress$ID[i]
  for(j in 1:nrow(battery)){
    if(battery$ID[j]==id){
      if(begintime < as.numeric(battery$Time[j])
         & as.numeric(battery$Time[j])< endtime){
        sum = sum + battery$Life[j]
        count = count + 1
      }
      
    }
    
  }
  
  stress$battery_avg_twentyfour[i] = sum / count
}


# POI - Set to 6 hour window
for (i in 1:nrow(stress)) {
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600 * 6)
  id = stress$ID[i]
  for(j in 1:nrow(datamining)){
    if(datamining$ID[j]==id){
      if(begintime < as.numeric(datamining$Time[j])
         & as.numeric(datamining$Time[j])< endtime){
         count = count + 1
      }
    }
  }
  if (count > 1){
    stress$classroom[i] = TRUE
  }
  else{
    stress$classroom[i] = FALSE
  }
}