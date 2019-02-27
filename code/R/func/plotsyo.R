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

##

p <- ggplot(agg,aes())+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))+
  #geom_smooth(data=agg,aes(x=sp_n,y=nDel,group=1),colour='cornflowerblue',method=loess,se=FALSE,span=1,n=1000)+
  #geom_smooth(data=agg,aes(x=sp_n,y=nIns,group=2),colour='firebrick1',method=loess,se=FALSE,span=1,n=1000)+
  geom_line(data=data.frame(spline(agg[['sp_n']],agg[['nDel']],10000)),aes(x,y,colour='Deletions'))+
  geom_line(data=data.frame(spline(agg[['sp_n']],agg[['nIns']],10000)),aes(x,y,colour='Insertions'))+
  geom_point(data=agg,aes(x=sp_n,y=nDel,colour='Deletions'))+
  geom_point(data=agg,aes(x=sp_n,y=nIns,colour='Insertions'))+
  labs(x='sp',y='Number of Insertions/Deletions')+
  scale_color_manual(name='',values=c('Insertions'='cornflowerblue','Deletions'='firebrick1'))
plot(p)





p <- ggplot(agg,aes())+
  theme_bw()+
  theme(text = element_text(family = "Cambria"))+
  geom_line(data=data.frame(spline(agg[['sp_n']],agg[['nDel']]/agg[['alnLen']],10000)),aes(x,y,colour='Deletions'))+
  geom_line(data=data.frame(spline(agg[['sp_n']],agg[['nIns']]/agg[['alnLen']],10000)),aes(x,y,colour='Insertions'))+
  geom_line(data=data.frame(spline(agg[['sp_n']],agg[['nMis']]/agg[['alnLen']],10000)),aes(x,y,colour='Mismatches'))+
  geom_point(data=agg,aes(x=sp_n,y=nDel/alnLen,colour='Deletions'))+
  geom_point(data=agg,aes(x=sp_n,y=nIns/alnLen,colour='Insertions'))+
  geom_point(data=agg,aes(x=sp_n,y=nMis/alnLen,colour='Mismatches'))+
  #geom_point(data=agg,aes(x=sp_n,y=(nDel+nIns+nMis)/alnLen,colour='Edit distance'))+
  #geom_line(data=data.frame(spline(agg[['sp_n']],(agg[['nMis']]+agg[['nDel']]+agg[['nIns']])/agg[['alnLen']],10000)),aes(x,y,colour='Edit distance'))+
  labs(x='sp',y='Deviances as a fraction')+
  scale_color_manual(name='',values=c('Insertions'='cornflowerblue','Deletions'='firebrick1','Mismatches'='mediumseagreen','Edit distance'='mediumorchid1'))
plot(p)