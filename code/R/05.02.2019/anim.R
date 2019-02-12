library('ggplot2')
library('plyr')
library('reshape2')
library('gganimate')
library('extrafont')
library('RColorBrewer')

sp=c('0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00')
first=TRUE

for (val in sp){
  filestr=paste('../../../../T-600-Star data/ru_snorri/My friend SAM/1.00/sp',val,'_1.00_sum.tsv',sep='')
  datin <- read.csv(filestr,sep=' ',header = T)
  datin$sp=val
  if (first) {mdata <- datin;first=FALSE} else mdata <- rbind(mdata,datin)
}

agg <- aggregate(mdata,by=list(mdata$sp),mean)
agg <- agg[,colSums(is.na(agg))<nrow(agg)]
colnames(agg)[which(names(agg) == "Group.1")] <- "sp"
Dp=agg['D']/agg['len']
Ip=agg['I']/agg['len']
names(Dp) <- 'D/len'
names(Ip) <- 'I/len'
cbind(agg,Dp,Ip)

p <- ggplot(mdata,aes(x=D/len,y=I/len))+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))+
  #geom_point(data=subset(mdata),aes(colour=NM))+
  #scale_x_continuous(limits = c(0, 0.1))+
  #scale_y_continuous(limits = c(0, 0.1))+
  geom_point(data=subset(mdata,MQual>50),colour='cornflowerblue')+
  geom_point(data=agg,colour='firebrick1',size=4)+
  transition_states(sp,transition_length = 3,state_length = 4) +
  labs(title='sp: {closest_state}')+
  ease_aes('cubic-in-out')
print(p)

