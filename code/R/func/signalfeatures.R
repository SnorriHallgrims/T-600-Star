  
trainsignals$tdmin <- 0
for (ii in lentrain)
  {trainsignals[ii,]$tdmin <- min(unlist(trainsignals[ii,]$signal))}

trainsignals$tdmax <- 0
for (ii in lentrain)
  {trainsignals[ii,]$tdmax <- max(unlist(trainsignals[ii,]$signal))}

trainsignals$tdmean <- 0
for (ii in lentrain)
{trainsignals[ii,]$tdmean <- mean(unlist(trainsignals[ii,]$signal))}

trainsignals$std <- 0
for (ii in lentrain)
{trainsignals[ii,]$std <- sd(unlist(trainsignals[ii,]$signal))}

trainsignals$len <- 0
for (ii in lentrain)
{trainsignals[ii,]$len <- length(unlist(trainsignals[ii,]$signal))}

trainsignals$fft <- 0
for (ii in lentrain)
{trainsignals[ii,]$fft <- list(quantile(fft((unlist(trainsignals[ii,]$signal)))))}


##################################################################################


testsignals$tdmin <- 0
for (ii in lentest)
{testsignals[ii,]$tdmin <- min(unlist(testsignals[ii,]$signal))}

testsignals$tdmax <- 0
for (ii in lentest)
{testsignals[ii,]$tdmax <- max(unlist(testsignals[ii,]$signal))}

testsignals$tdmean <- 0
for (ii in lentest)
{testsignals[ii,]$tdmean <- mean(unlist(testsignals[ii,]$signal))}

testsignals$std <- 0
for (ii in lentest)
{testsignals[ii,]$std <- sd(unlist(testsignals[ii,]$signal))}

testsignals$len <- 0
for (ii in lentest)
{testsignals[ii,]$len <- length(unlist(testsignals[ii,]$signal))}

testsignals$fft <- 0
for (ii in lentest)
{testsignals[ii,]$fft <- list(quantile(fft((unlist(testsignals[ii,]$signal)))))}
