#### Hierarchical ####

manh_dis <- dist(nflgames.sample, method = "manhattan")
hclust_complete <- hclust(manh_dis,method = "complete")
plot(hclust_complete, cex=0.001)
rect.hclust(hclust_complete, k=2, border="red")

## Plots to understand the main difference between the two biggest clusters

library(reshape)

obs_groups2 <- cutree(hclust_complete,k=2)

nflgames.melt <- melt(nflgames.sample)

nflgames.melt2 <- cbind(nflgames.melt, obs_groups2)

nflgames.melt2$obs_groups2 <- as.factor(nflgames.melt2$obs_groups2)

ggplot(nflgames.melt2, aes(x = value, col = obs_groups2)) + geom_density() +
  facet_wrap( ~ X2, scales = "free")
  
#### K Means ####

allss <- c()
for(k in c(1,2,3,4,5,6,7,8,9,10)){
  temp_k <- kmeans(x = nflgames.sample,centers=k,nstart = 20)
  allss <- c(allss,sum(temp_k$withinss))
}
plot(c(1,2,3,4,5,6,7,8,9,10),allss)

## Plots to understand the main difference between the two biggest clusters

k3 <- kmeans(x = nflgames.sample, centers=2, nstart = 20)

nflgames.melt5 <- cbind(nflgames.melt, clust=k3$cluster)

nflgames.melt5$clust <- as.factor(nflgames.melt5$clust)

ggplot(nflgames.melt5, aes(x = value, col = clust)) + 
  geom_density() + 
  facet_wrap( ~ X2, scales = "free")
