library('ggplot2')
library('extrafont')

## Reappear-ing gaurinn

re="9c577d14-38a5-49ec-9f13-2acd970b0137"
re_point=subset(mdata,qName==re)

p <- ggplot(mdata,aes(x=D/len,y=I/len))+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))+
  scale_color_brewer(palette="Set1")+
  geom_point(data=subset(mdata,sp=='2.00'))
plot(p)