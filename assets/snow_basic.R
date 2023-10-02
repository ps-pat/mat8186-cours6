library(snow)

cl <- makeCluster(4)

parLapply(cl, list(a = 1:10, b = 11:20, c = 21:30, d =  31:40), mean)

stopCluster(cl)
