library(h2o)

h2o.init()

nflgames.h2o <- as.h2o(nflgames, destination_frame = "nflgames.h2o")

h2o.nfl.1 <- h2o.deeplearning(x = names(nflgames)[-17],
                              y = 'yards',
                              training_frame = nflgames.h2o,
                              standardize = TRUE,
                              hidden = c(200,200,100,50,30),
                              nfolds = 10,
                              epochs = 10)

h2o.nfl.2 <- h2o.deeplearning(x = names(nflgames)[-17],
                              y = 'yards',
                              training_frame = nflgames.h2o,
                              standardize = TRUE,
                              hidden = c(50,50,40,30,30),
                              nfolds = 10,
                              epochs = 10)

h2o.nfl.3 <- h2o.deeplearning(x = names(nflgames)[-17],
                              y = 'yards',
                              training_frame = nflgames.h2o,
                              standardize = TRUE,
                              hidden = c(300,50),
                              nfolds = 10,
                              epochs = 10)

rf.nfl <- h2o.randomForest(x = c('play_direction','yardline','yards_to_go',
                                 'pos_team','def_team','down','home',
                                 'quarter','time'),
                           y = 'yards',
                           training_frame = nflgames.h2o,
                           mtries = 3,
                           ntrees = 100,
                           nfolds = 10)
