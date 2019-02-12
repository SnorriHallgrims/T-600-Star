
#load_data <- function(){
#  return()
#}

sp=c('0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00')
first=TRUE

for (val in sp){
  filestr=paste('../../../data/summaries/gpv213sp',val,'.minimap.mapping.readsummary',sep='')
  datin <- read.csv(filestr,sep='\t',header = T)
  datin$sp=val
  if (first) {mdata <- datin;first=FALSE} else mdata <- rbind(mdata,datin)
}

bad_reads=readLines('mism.txt',n=-1)

#setwd('C:/Cadence/SPB_Data/T-600-Star/code/R/func')
