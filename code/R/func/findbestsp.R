library('dplyr')
library('ggplot2')
library('extrafont')

ndata=mutate(mdata,toterror=nDel+nIns+nMis)
ndata=filter(ndata,mapQual>0)

dmin=ndata %>% group_by(qName) %>% filter(toterror==min(toterror))


p <-ggplot(dmin,aes(x=sp))+
  stat_count(fill='cornflowerblue')+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))
plot(p)

undata=filter(mdata,mapQual<0)

p1 <-ggplot(undata,aes(x=sp))+
  stat_count(fill='cornflowerblue')+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))
plot(p1)
