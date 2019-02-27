d1=subset(mdata,sp=='1.00')
d125=subset(mdata,sp=='1.25')
d075=subset(mdata,sp=='0.75')
d050=subset(mdata,sp=='0.50')
d025=subset(mdata,sp=='0.25')
d005=subset(mdata,sp=='0.05')
d150=subset(mdata,sp=='1.50')
d175=subset(mdata,sp=='1.75')
d2=subset(mdata,sp=='2.00')
setdiff(d005$qName,d025$qName)
disapp=setdiff(d005$qName,d025$qName)


## Finna Punkta sem birtast aftur
i=c(1:8)
listN=list()

for (val in i)
{
  sp1=sp[val+1]
  sp2=sp[val]
  s1=(subset(mdata,sp==sp1))
  s2=(subset(mdata,sp==sp2))
  setR=list(setdiff(s1$qName,s2$qName))
  listN=append(listN,setR)
}

re="9c577d14-38a5-49ec-9f13-2acd970b0137"

i1=c(9:2)
listN=list()

for (val1 in i1)
{
  i2=c(val1:1)
  for (val in i2)
  {
    sp1=sp[val+1]
    sp2=sp[val]
    s1=(subset(mdata,sp==sp1))
    s2=(subset(mdata,sp==sp2))
    setR=list(setdiff(s1$qName,s2$qName))
    listN=append(listN,setR)
  }
}

agg <- aggregate(mdata,by=list(mdata$sp),mean)
agg <- agg[,colSums(is.na(agg))<nrow(agg)]
colnames(agg)[which(names(agg) == "Group.1")] <- "sp"
Dp=agg['nDel']/agg['alnLen']
Ip=agg['nIns']/agg['alnLen']
names(Dp) <- 'D/len'
names(Ip) <- 'I/len'
cbind(agg,Dp,Ip)

sp_n=c(0.05,0.25,0.50,0.75,1.00,1.25,1.50,1.75,2.00)
agg$sp_n=sp_n