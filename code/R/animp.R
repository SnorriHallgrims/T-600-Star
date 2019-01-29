
r=c(2619, 3244, 3138, 1358, 1587)

qq1=intersect(dat.i1$qName,dat.i9$qName)[r[1]]
qq2=intersect(dat.i1$qName,dat.i9$qName)[r[2]]
qq3=intersect(dat.i1$qName,dat.i9$qName)[r[3]]
qq4=intersect(dat.i1$qName,dat.i9$qName)[r[4]]
qq5=intersect(dat.i1$qName,dat.i9$qName)[r[5]]

#st=c(0.05,0.25,0.50,0.75,1.00,1.25,1.50,1.75,2.00)

# Plot ------------------------------------------------------------------------------------------------------


p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_abline(slope = 1,color='black')+coord_fixed(ratio=1)
print(p)


p + geom_point(data=subset(dat, qName==qq1),colour='deepskyblue',size=3)+
  geom_point(data=subset(dat, qName==qq2),colour='mediumorchid',size=3)+
  geom_point(data=subset(dat, qName==qq3),colour='steelblue',size=3)+
  geom_point(data=subset(dat, qName==qq4),colour='violetred',size=3)+
  geom_point(data=subset(dat, qName==qq5),colour='magenta',size=3)+
  labs(title='sp: {closest_state}')+
  theme_minimal()+
  theme(text = element_text(family = "Cambria"))+
  transition_states(sp,transition_length = 2.5,state_length = 1) +
  ease_aes('cubic-in-out')