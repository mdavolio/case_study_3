# Case Study 3 code

library(SensusR)

accelerometer = sensus.read.json('./sys6018_cs3_data/AccelerometerDatum')

for (i in 1:length(accelerometer)){
  assign(paste0("accelerometer-", i), as.data.frame(data[i]))
}