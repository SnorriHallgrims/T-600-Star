
library('ggplot2')
library('plyr')
library('reshape2')
library('gganimate')
library('extrafont')

p1 <- ggplot(mdata,aes(x=alnLen,y=sp))+
  geom_point(data=subset(mdata,type='unaligned'))

plot(p1)