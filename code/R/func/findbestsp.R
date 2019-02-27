library('dplyr')
library('ggplot2')

ndata=mutate(mdata,toterror=nDel+nIns+nMis)
ndata=filter(ndata,mapQual>0)

dmin=ndata %>% group_by(qName) %>% filter(toterror==min(toterror))

p <-ggplot(dmin,aes(x=sp))+
  stat_count()+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))
plot(p)