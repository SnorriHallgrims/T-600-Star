library('ggplot2')
library('dplyr')
library('extrafont')

dropout=subset(mdata,mapQual==-1)
dropout_n=dropout[['qName']]
dropout_n=unique(dropout_n)
dropout_n_sub=dropout_n[401:500]
dropout=subset(mdata,qName %in% dropout_n)
dropout_sub=subset(mdata,qName %in% dropout_n_sub)

dropout_p=list()
counter=0
for (i in dropout_n)
{
  counter=counter+1
  subsp=subset(mdata,qName==i)
  sum1=sum(subsp[['mapQual']])
  if (sum1!=(length(subsp[['mapQual']])*(-1))){dropout_p=append(dropout_p,i)}
}

dropoutq=subset(dropout,mapQual>50)
dropoutq=dropoutq[['qName']]
dropoutq=unique(dropoutq)

p1 <- ggplot(mdata,aes(x=sp,y=mapQual))+
  theme_light()+
  theme(text = element_text(family = "Cambria"))+
  geom_point(data=subset(mdata,qName %in% dropoutq[1:4]),aes(colour=qName))

plot(p1)