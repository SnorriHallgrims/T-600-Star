
library('ggplot2')
library('plyr')
library('reshape2')
library('gganimate')
library('extrafont')

# lesa inn gogn ------------------------------------------------------------------------------------------------
myfilter <- function(allreads) {
  # filtera ut leleg read
  subset(allreads, type == 'noSuppl' & supplementary==0  & mapQual>50 )
}

dat.i1 <- myfilter(read.csv('../../data/summaries/gpv213sp0.05.minimap.mapping.readsummary',sep='\t',header = T))
dat.i2 <- myfilter(read.csv('../../data/summaries/gpv213sp0.25.minimap.mapping.readsummary',sep='\t',header = T))
dat.i3 <- myfilter(read.csv('../../data/summaries/gpv213sp0.50.minimap.mapping.readsummary',sep='\t',header = T))
dat.i4 <- myfilter(read.csv('../../data/summaries/gpv213sp0.75.minimap.mapping.readsummary',sep='\t',header = T))
dat.i5 <- myfilter(read.csv('../../data/summaries/gpv213sp1.00.minimap.mapping.readsummary',sep='\t',header = T))
dat.i6 <- myfilter(read.csv('../../data/summaries/gpv213sp1.25.minimap.mapping.readsummary',sep='\t',header = T))
dat.i7 <- myfilter(read.csv('../../data/summaries/gpv213sp1.50.minimap.mapping.readsummary',sep='\t',header = T))
dat.i8 <- myfilter(read.csv('../../data/summaries/gpv213sp1.75.minimap.mapping.readsummary',sep='\t',header = T))
dat.i9 <- myfilter(read.csv('../../data/summaries/gpv213sp2.00.minimap.mapping.readsummary',sep='\t',header = T))
dat.i1$sp=0.05
dat.i2$sp=0.25
dat.i3$sp=0.50
dat.i4$sp=0.75
dat.i5$sp=1.00
dat.i6$sp=1.25
dat.i7$sp=1.50
dat.i8$sp=1.75
dat.i9$sp=2.00


dat <- rbind(dat.i1,dat.i2,dat.i3,dat.i4,dat.i5,dat.i6,dat.i7,dat.i8,dat.i9)

rand=sample.int(3695,5)

q1=intersect(dat.i1$qName,dat.i9$qName)[rand[1]]
q2=intersect(dat.i1$qName,dat.i9$qName)[rand[2]]
q3=intersect(dat.i1$qName,dat.i9$qName)[rand[3]]
q4=intersect(dat.i1$qName,dat.i9$qName)[rand[4]]
q5=intersect(dat.i1$qName,dat.i9$qName)[rand[5]]

#st=c(0.05,0.25,0.50,0.75,1.00,1.25,1.50,1.75,2.00)

# Plot ------------------------------------------------------------------------------------------------------


p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_abline(slope = 1,color='black')+coord_fixed(ratio=1)
print(p)


p + geom_point(data=subset(dat, qName==q1),colour='deepskyblue',size=3)+
  geom_point(data=subset(dat, qName==q2),colour='mediumorchid',size=3)+
  geom_point(data=subset(dat, qName==q3),colour='steelblue',size=3)+
  geom_point(data=subset(dat, qName==q4),colour='violetred',size=3)+
  geom_point(data=subset(dat, qName==q5),colour='magenta',size=3)+
  labs(title='sp: {closest_state}')+
  theme_minimal()+
  theme(text = element_text(family = "Cambria"))+
  transition_states(sp,transition_length = 2.5,state_length = 1) +
  ease_aes('cubic-in-out')
  


#setwd('C:/Cadence/SPB_Data/T-600-Star/code/R')
#enter_fade()+
#exit_shrink()
