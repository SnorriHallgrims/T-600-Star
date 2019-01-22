
library('ggplot2')
library('plyr')
library('reshape2')

# lesa inn gogn 
myfilter <- function(allreads) {
  # filtera ut leleg read
  subset(allreads, type == 'noSuppl' & supplementary==0  & mapQual>50 )
}

dat.ins <- myfilter(read.csv('../../data/summaries/gpv213sp0.05.minimap.mapping.readsummary',sep='\t',header = T))
dat.del <- myfilter(read.csv('../../data/summaries/gpv213sp2.00.minimap.mapping.readsummary',sep='\t',header = T))
dat.unb <- myfilter(read.csv('../../data/summaries/gpv213sp0.50.minimap.mapping.readsummary',sep='\t',header = T))
dat.ins$sp=0.05
dat.del$sp=2.00
dat.unb$sp=0.50
dat <- rbind(dat.ins,dat.del,dat.unb)

#plotta 
ggplot(dat, aes(x=seqLen,y=alnLen))+geom_point(aes(color=mapQual))+geom_abline(slope = 1,color='red')+facet_wrap(~sp)
p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_point()+geom_abline(slope = 1,color='red')+coord_fixed(ratio=1)+facet_wrap(~sp)
print(p)
l=length(dat.del)
rand=sample.int(l,5)

q1=intersect(dat.ins$qName,dat.del$qName)[rand[1]]
q2=intersect(dat.ins$qName,dat.del$qName)[rand[2]]
q3=intersect(dat.ins$qName,dat.del$qName)[rand[3]]
q4=intersect(dat.ins$qName,dat.del$qName)[rand[4]]
q5=intersect(dat.ins$qName,dat.del$qName)[rand[5]]



p + geom_point(data=subset(dat, qName==q1),color='red')+geom_point(data=subset(dat, qName==q2),color='blue')+geom_point(data=subset(dat, qName==q3),color='yellow')+geom_point(data=subset(dat, qName==q4),color='green')+geom_point(data=subset(dat, qName==q5),color='purple')+labs(title='', x='nDel',y='nIns')
#p + labs(title='', x='nDel',y='nIns')
