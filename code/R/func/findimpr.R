library('randomForest')
library('e1071')
library('DMwR')


d2=subset(ndata,sp=='2.00')
d2id=subset(dmin,sp=='2.00')
d2nonid=subset(d2,!(qName %in% d2id[['qName']]))


newdf=d2['qName']
newdf['mapQual'] <- d2['mapQual']
newdf['nMis'] <- d2['nMis']
newdf['nIns'] <- d2['nIns']
newdf['nDel'] <- d2['nDel']
newdf['alnLen'] <- d2['alnLen']
newdf['seqLen'] <- d2['seqLen']
newdf['toterror'] <-d2$toterror

tempdf=dmin['qName']
tempdf['spideal'] <- as.factor(dmin[['sp']])

tempdf075=subset(ndata,sp=='0.75')

tempdf075e=tempdf075['qName']
tempdf075e['toterror0.75'] <- tempdf075['toterror']

testdf=merge(newdf,tempdf,by='qName')
testdf=merge(testdf,tempdf075e,by='qName')

testdf$imp075 <- as.factor(testdf$toterror0.75 < testdf$nMis+testdf$nIns+testdf$nDel)

rftestdf=testdf[,2:7]
rftestdf$toterror <- testdf$toterror
rftestdf$imp <- testdf[['imp075']]
test.forest=randomForest(imp ~ ., data=rftestdf,importance=TRUE)
print(test.forest)

test.forest=randomForest(imp075 ~ seqLen+alnLen+nDel+nIns+nMis+mapQual, data=testdf,importance=TRUE,ntree=500)
print(test.forest)


traindf=rftestdf[1:3500,]

testsvm <- svm(imp ~ ., data=traindf,cross=10,kernel='linear')
print(testsvm)
predsvm <- predict(testsvm,traindf)
sum(predsvm==traindf[['imp']])/length(predsvm)


knntest <- kNN(imp ~ ., traindf,rftestdf[3501:4416,],k=3)
sum(knntest==rftestdf[3501:4416,][['imp']])/length(knntest)
