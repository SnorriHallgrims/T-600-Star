
library('ggplot2')
library('plyr')
library('reshape2')
library('gganimate')

# lesa inn gogn 
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
dat.i8$sp=0.75
dat.i9$sp=2.00


dat <- rbind(dat.i1,dat.i2,dat.i3,dat.14,dat.i5,dat.i6,dat.i7,dat.i8,dat.i9)

#plotta 
#ggplot(dat, aes(x=seqLen,y=alnLen))+geom_point(aes(color=mapQual))+geom_abline(slope = 1,color='red')+facet_wrap(~sp)
p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_abline(slope = 1,color='red')+coord_fixed(ratio=1)#+facet_wrap(~sp)
print(p)


l=length(dat.del)
rand=sample.int(l,5)

q1=intersect(dat.ins$qName,dat.del$qName)[rand[1]]
q2=intersect(dat.ins$qName,dat.del$qName)[rand[2]]
q3=intersect(dat.ins$qName,dat.del$qName)[rand[3]]
q4=intersect(dat.ins$qName,dat.del$qName)[rand[4]]
q5=intersect(dat.ins$qName,dat.del$qName)[rand[5]]



p + geom_point(data=subset(dat, qName==q1),color='red')+
  geom_point(data=subset(dat, qName==q2),color='blue')+
  geom_point(data=subset(dat, qName==q3),color='yellow')+
  geom_point(data=subset(dat, qName==q4),color='green')+
  geom_point(data=subset(dat, qName==q5),color='purple')+
  labs(title='', x='nDel',y='nIns')+
  transition_states(sp,transition_length = 2,state_length = 1) +
  ease_aes('linear')+
  enter_fade()+
  exit_shrink()



