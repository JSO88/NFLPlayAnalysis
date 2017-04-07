load("nflgames.sample.Rda")

for (i in 1:ncol(nflgames.sample)){
  if (class(nflgames.sample[,i])=='factor'){
    nflgames.sample[,i] <- as.integer(nflgames.sample[,i])
  }
}

nflgames.sample <- scale(nflgames.sample)

pc_fit <- princomp(nflgames.sample, cor = TRUE)

plot(pc_fit, type = "lines")

biplot(pc_fit, cex=0.5)
