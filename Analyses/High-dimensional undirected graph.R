library(huge)

nflgames.huge <- nflgames[,-17]

for (i in 1:ncol(nflgames.huge)){
  if (class(nflgames.huge[,i])=='factor'){
    nflgames.huge[,i] <- as.numeric(nflgames.huge[,i])
  }
  
}

h.nfl <- huge(as.matrix(nflgames.huge))
plot.huge(h.nfl)

h.nfl1 <- huge(as.matrix(nflgames.huge), lambda = 0.438)
h.nfl1$path[[1]]

h.nfl2 <- huge(as.matrix(nflgames.huge), lambda = 0.00001)
huge.plot(h.nfl2$path[[1]])
