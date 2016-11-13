source(cleaning.R)
#Checking number of non-contacts within a prior 1-hour window of stress survey

for (i in 1:nrow(stress)) {
  sum=0
  count = 0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - 3600
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
  
  stress$steps_ascended_avg_one[i] = sum / count
}


#49/71 non-contacts with window = 1 hour


#Checking number of non-contacts within a prior 3-hour window of stress survey

for (i in 1:nrow(stress)) {
  sum = 0
  count=0
  endtime = as.numeric(stress$Time[i])
  begintime = as.numeric(stress$Time[i]) - (3600*3)
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
  
  stress$steps_ascended_avg_three[i] = sum / count
}
#45/71 zeros with window = 3 hours

#Checking number of non-contacts within a prior 24-hour window of stress survey

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


#41/71 zeros with window = 24 hours 