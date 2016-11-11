# Case Study 3 code

library(SensusR)

data = sensus.read.json('./sample')

for (i in 1:length(data)){
  assign(paste0("dataframe-", i), as.data.frame(data[i]))
}