
library('ggplot2')
library('plyr')
library('reshape2')

# lesa inn gogn 
myfilter <- function(allreads) {
  # filtera ut leleg read
  subset(allreads, type == 'noSuppl' & supplementary==0  & mapQual>50 )
}

dat.ins <- myfilter(read.csv('data/summaries/gpv213sp0.05.minimap.mapping.readsummary',sep='\t',header = T))
dat.del <- myfilter(read.csv('data/summaries/gpv213sp2.00.minimap.mapping.readsummary',sep='\t',header = T))
dat.unb <- myfilter(read.csv('data/summaries/gpv213sp0.50.minimap.mapping.readsummary',sep='\t',header = T))
dat.ins$sp=0.05
dat.del$sp=2.00
dat.unb$sp=0.50
dat <- rbind(dat.ins,dat.del,dat.unb)

#plotta 
ggplot(dat, aes(x=seqLen,y=alnLen))+geom_point(aes(color=mapQual))+geom_abline(slope = 1,color='red')+facet_wrap(~sp)
p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_point()+geom_abline(slope = 1,color='red')+coord_fixed(ratio=1)+facet_wrap(~sp)
print(p)
q=intersect(dat.ins$qName,dat.del$qName)[1]
p + geom_point(data=subset(dat, qName==q),color='red')