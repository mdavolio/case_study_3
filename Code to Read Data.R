library(SensusR)

setwd("~/Desktop/sys6018_cs3_data")
folders=list.files(path = '.')

for( i in 1:length(folders)){
  assign(paste0(folders[i]), as.data.frame(sensus.read.json(paste0('./' ,folders[i]))))
}


