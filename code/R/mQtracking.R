library('ggplot2')
library('dplyr')
library('extrafont')

dropout=subset(mdata,mapQual==-1)
dropout_n=dropout[['qName']]
dropout_n=unique(dropout_n)
dropout_n_sub=dropout_n[401:500]
dropout=subset(mdata,qName %in% dropout_n)
dropout_sub=subset(mdata,qName %in% dropout_n_sub)

p1 <- ggplot(mdata,aes(x=sp,y=mapQual))+
  theme_light()+
  theme(text = element_text(family = "Cambria"))+
  geom_point(data=dropout_sub)#,aes(colour=qName))

plot(p1)