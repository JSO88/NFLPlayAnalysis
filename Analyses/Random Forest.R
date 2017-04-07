library(tree)
library(caret)

nflfolds <- createFolds(seq(1, nrow(nflgames),by =1), k=10)

errors.vec <- rep(0,10)
class(temp.tree.nflgames)
for (i in 1:10) {
  temp_train <- nflgames[-nflfolds[[i]],]
  temp_test <- nflgames[nflfolds[[i]],]
  
  temp.tree.nflgames <- tree::tree(yards ~ ., 
                        data = temp_train)
  
  temp.pred <- predict(temp.tree.nflgames, temp_test)
  
  errors.vec[i] <- mean((temp_test$yards-temp.pred)^2)
}

mean(errors.vec)
