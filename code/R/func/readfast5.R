library('ggplot2')
library('rhdf5')

trainreads <- read.csv('trainingreads.txt',header = F)
trainreads$V1 <- substr(trainreads$V1,6,41)


first=TRUE
lentrain=c(1:length(trainreads$V1))
for (ii in lentrain)
{
  rawsign <- h5read('training.fast5',paste('/read_',trainreads$V1[ii],'/Raw/Signal',sep=''))
  rawsign=as.numeric(rawsign)
  temp <- data.frame('qName'=trainreads$V1[ii])
  temp$signal <- list(rawsign)
  if(first){trainsignals=temp;first=FALSE}
  else{trainsignals=rbind(trainsignals,temp)}
  
  #if (first){trainsignals <- data.frame('qName'=trainreads$V1[ii],'signal'=list(rawsign));first=FALSE}
  #else{rbind(trainsignals,data.frame('qName'=trainreads$V1[ii],'signal'=list(rawsign)))}
}

##################################

testreads <- read.csv('testingreads.txt',header = F)
testreads$V1 <- substr(testreads$V1,6,41)


first=TRUE
lentest=c(1:length(testreads$V1))
for (ii in lentest)
{
  rawsign <- h5read('testing.fast5',paste('/read_',testreads$V1[ii],'/Raw/Signal',sep=''))
  rawsign=as.numeric(rawsign)
  temp <- data.frame('qName'=testreads$V1[ii])
  temp$signal <- list(rawsign)
  if(first){testsignals=temp;first=FALSE}
  else{testsignals=rbind(testsignals,temp)}
  
}