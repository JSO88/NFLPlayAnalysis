#### Stepwise AIC ####

library(MASS)

lm.empty <- lm(yards ~ 1, data = nflgames)
lm.full <- lm(yards ~ ., data = nflgames)

forward.AIC <- stepAIC(lm.empty, scope = formula(lm.full), direction = 'forward')

backward.AIC <- stepAIC(lm.full, scope = formula(lm.full), direction = 'backward')

#### LASSO ####

library(glmnet)

nflgames.matrix <- model.matrix(yards ~ ., data = nflgames)

lasso.cv <- cv.glmnet(x = nflgames.matrix, 
                      y = as.matrix(nflgames$yards), 
                      alpha = 1)

plot(lasso.cv)
