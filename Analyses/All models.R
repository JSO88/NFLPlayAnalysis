library(mgcv)
library(gamclass)

lm.null <- glm(yards ~ 1, data = nflgames)

cv.glm(nflgames, lm.null, K = 10)$delta[1]

lm.0 <- glm(yards~., data = nflgames)
summary(lm.0)

cv.glm(nflgames, lm.0, K = 10)$delta[1]

lm.1 <- glm(yards ~ play_direction + yardline + yards_to_go + 
             pos_team + def_team + home + quarter + time + down, 
           data = nflgames)

cv.glm(nflgames, lm.1, K = 10)$delta[1]

lm.2 <- glm(yards ~ play_direction + yardline + yards_to_go*down + 
              pos_team + def_team + home + quarter + time , 
            data=nflgames)

cv.glm(nflgames, lm.2, K = 10)$delta[1]

lm.3 <- glm(yards ~ play_direction + yardline + yardline:down + yards_to_go*down + 
              pos_team + def_team + home + quarter + time , 
            data=nflgames)

cv.glm(nflgames, lm.3, K = 10)$delta[1]

lm.4 <- glm(yards ~ play_direction + yardline + yardline:down + yards_to_go*down + 
              pos_team + def_team + home + quarter + time + time:yardline , 
            data=nflgames)

cv.glm(nflgames, lm.4, K = 10)$delta[1]

lm.5 <- glm(yards ~ play_direction + yardline + yards_to_go + down + 
              pos_team + pos_team:play_direction + def_team + home + quarter + time, 
            data=nflgames)

cv.glm(nflgames, lm.5, K = 10)$delta[1]


lm.6 <- glm(yards ~ play_direction + yardline + yards_to_go + down + 
              pos_team + play_direction + def_team + home + 
              quarter + time + month:play_direction + month, 
            data=nflgames)

cv.glm(nflgames, lm.6, K = 10)$delta[1]

lm.7 <- glm(yards ~ play_direction + yardline + yards_to_go + down + 
              pos_team + def_team + home + yardline:yards_to_go + 
              yardline:time + time:yards_to_go + 
              quarter + time, 
            data=nflgames)

cv.glm(nflgames, lm.7, K = 10)$delta[1]

lm.8 <- glm(yards ~ play_direction + yardline + yards_to_go + 
              pos_team + def_team + home + quarter + time + down + 
              play_direction:pos_team, 
            data = nflgames)

cv.glm(nflgames, lm.8, K = 10)$delta[1]

poly.0 <- glm(yards ~ play_direction + poly(yardline,3) + 
                poly(yards_to_go,3) + pos_team + def_team + 
                home + quarter + poly(time,3) + down, data = nflgames)

cv.glm(nflgames, poly.0, K = 10)$delta[1]

f <- as.formula(yards ~ play_direction + s(yardline) + 
                  s(yards_to_go) + pos_team + def_team + 
                  home + quarter + s(time) + down)

gam.0 <- gam(yards ~ play_direction + s(yardline) + 
               s(yards_to_go) + pos_team + def_team + 
               home + quarter + s(time) + down, family = gaussian, data = nflgames)

gam.0.cv <- CVgam(f, data=nflgames, nfold = 10)

f <- as.formula(yards ~ play_direction + 
                  s(yards_to_go, yardline, time) + pos_team + def_team + 
                  home + quarter + down)

gam.1 <- gam(f, family = gaussian ,data = nflgames)

gam.1.cv <- CVgam(f, data=nflgames, nfold = 10)

nflgames.transformed <- mutate(nflgames, logyards = log(yards + 1 - min(yards)))

own.cv.log <- function(y, x, kf=10){
  
  temp.folds <- createFolds(seq(from = 1, to = nrow(x), by = 1), 
                            k=kf, 
                            list = TRUE, 
                            returnTrain = FALSE)
  
  mse.vec <- rep(0,kf)
  
  for (i in 1:kf){
    temp_train <- x[-temp.folds[[i]],]
    temp_test <- x[temp.folds[[i]],]
    
    temp.fit <- lm(formula(y), data = temp_train)
    temp.pred <-exp(predict(temp.fit, temp_test))-1+min(temp_train$yards)
    mse.vec[i] <- mean((temp_test$yards - temp.pred)^2)
  }
  
  return(mean(mse.vec))
  
}

loglm.0 <- lm(logyards ~ play_direction + yardline + yards_to_go + 
                pos_team + def_team + home + quarter + time + down, 
              data = nflgames.transformed)

own.cv.log(loglm.0, nflgames.transformed, kf=10)

lassolm.0 <- glm(yards ~ play_direction + yards_to_go + yardline, 
                data=nflgames )

cv.glm(nflgames, lassolm.0, K = 10)$delta[1]

lassolm.1 <- glm(yards ~ play_direction*yardline + 
                   yards_to_go + yardline:yards_to_go + 
                   yards_to_go:play_direction, 
                 data=nflgames )

cv.glm(nflgames, lassolm.1, K = 10)$delta[1]

lassolm.2 <- gam(yards ~ play_direction:yardline + 
                   s(yards_to_go) + s(yardline) + yardline:yards_to_go + 
                   yards_to_go:play_direction, 
                 family = gaussian,
                 data=nflgames )

lassolm.2 <- CVgam(yards ~ play_direction + play_direction:yardline + 
                     s(yards_to_go) + s(yardline) + yardline:yards_to_go + 
                     yards_to_go:play_direction, nflgames, nfold = 10)

lassolm.3 <- gam(yards ~ play_direction + play_direction:yardline + 
                   s(yards_to_go, yardline) + yards_to_go:play_direction, 
                 family = gaussian,
                 data=nflgames )

lassolm.3.cv <- CVgam(yards ~ play_direction + play_direction:yardline + 
                     s(yards_to_go, yardline) + yards_to_go:play_direction, 
                     nflgames, 
                     nfold = 10)
