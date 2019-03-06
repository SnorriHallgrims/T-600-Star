library('ggplot2')
library('rhdf5')

rawdata <- h5read('testing.fast5','/ALL/Raw/')

raw1 <- h5read('training.fast5','/read_2fcbf042-96ab-4441-8bdd-aa023c619049/Raw/Signal')
raw2 <- h5read('training.fast5','/read_2faeddba-ee33-428d-9ee4-e7169e6afc93/Raw/Signal')
raw3 <- h5read('training.fast5','/read_2f72adf8-0f49-4a63-ab69-30030c566350/Raw/Signal')

x1 <- 1:length(raw1)
x2 <- 1:length(raw2)
x3 <- 1:length(raw3)

qplot(x=x3,y=raw3,geom='line')


p <- ggplot(data.frame(raw1),aes())+
  geom_freqpoly()
print(p)