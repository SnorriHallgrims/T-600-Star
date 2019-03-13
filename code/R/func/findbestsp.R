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

#################################

ntd <- merge(trainsignals,tempdf,by='qName',all.x=T)
ntd$fft0 <- 0
ntd$fft25 <- 0
vec <- 1:length(ntd)
for (ii in vec)
{tempf=unname(unlist(ntd$fft[ii]))
ntd$fft0[ii] <- tempf[1]
ntd$fft25[ii] <- tempf[2]}

ntd$fft0 <- abs(ntd$fft0)
ntd$fft25 <- abs(ntd$fft25)

ntd$spideal <- addNA(ntd$spideal)

##################################

testdata <- merge(testsignals,tempdf,by='qName',all.x=T)
testdata$fft0 <- 0
testdata$fft25 <- 0

vec <- 1:length(testdata$qName)
for (ii in vec)
{tempf=unname(unlist(testdata$fft[ii]))
testdata$fft0[ii] <- tempf[1]
testdata$fft25[ii] <- tempf[2]}

testdata$fft0 <- abs(testdata$fft0)
testdata$fft25 <- abs(testdata$fft25)

testdata$spideal <- addNA(testdata$spideal)

#################################


svmV1 <- svm(spideal ~ tdmin+tdmax+tdmean+std+len+fft0+fft25, data=ntd,cross=10,kernel='linear')

print(svmV1)
predsvm <- predict(svmV1,testdata)
predsvm <- addNA(predsvm)
sum(predsvm==testdata$spideal)/length(testdata$qName)

predsvm <- predict(svmV1,ntd)
predsvm <- addNA(predsvm)
sum(predsvm==ntd$spideal)/length(ntd$qName)