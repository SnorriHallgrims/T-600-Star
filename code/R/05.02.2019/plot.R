library('ggplot2')
library('plyr')
library('reshape2')
library('gganimate')
library('extrafont')
library('RColorBrewer')

sp=c('0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00')
first=TRUE

for (val in sp){
  filestr=paste('../../../T-600-Star data/ru_snorri/My friend SAM/1.00/sp',val,'_1.00_sum.tsv',sep='')
  datin <- read.csv(filestr,sep=' ',header = T)
  datin$sp=val
  if (first) {mdata <- datin;first=FALSE} else mdata <- rbind(mdata,datin)
}

p <- ggplot(mdata,aes(x=D/len,y=I/len))+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))+
  scale_color_brewer(palette="Set1")+
  geom_point(data=subset(mdata,sp=='2.00'))
plot(p)