nflgames <- read.csv("nflgames.txt")

#Remove the remaining errors

nflgames_err <- subset(nflgames, error_id==1)
nflgames_err <- subset(nflgames_err, yards==0)
no_gain_plays <- grep('for no gain',nflgames_err[,20])
names_row <- as.integer(row.names(nflgames_err[-no_gain_plays,]))
nflgames <- nflgames[-names_row,]
str(nflgames)
nflgames$yardline <- as.integer(nflgames$yardline)
nflgames$month <- as.factor(nflgames$month)
nflgames$down <- as.factor(nflgames$down)

#transformations (yardline)

ind_1 <- (nflgames$location=='OPP' & nflgames$yardline==50)

nflgames$location[ind_1] <- 'OWN'

ind_2 <- (nflgames$location=='OPP')

nflgames$yardline[ind_2] <- 100-nflgames$yardline[ind_2]

#~29 erros on ball location, the following code corrects it

ind_3 <- ((110-nflgames$yardline)<(nflgames$yards))

nflgames$yardline[ind_3] <- (100-nflgames$yards[ind_3] )

#transformation start_time

prime <- c("19:00:00-04:00","19:00:00-05:00","19:10:00-04:00","19:20:00-05:00",
           "19:30:00-05:00","20:00:00-05:00","20:20:00-04:00","20:20:00-05:00",
           "20:25:00-04:00","20:25:00-05:00","20:30:00-04:00","20:30:00-05:00",
           "20:40:00-04:00","20:40:00-05:00","21:30:00-04:00","22:15:00-04:00",
           "22:20:00-04:00","23:35:00-04:00")

ind_3 <- (nflgames$start_time %in% prime)

nflgames$game_time <- 'Regular'
nflgames$game_time[ind_3] <- 'Prime'
nflgames$game_time <- as.factor(nflgames$game_time)

# merging pass_id and rush_id and directions

nflgames$pass_direction <- as.character(nflgames$pass_direction)
nflgames$rush_direction <- as.character(nflgames$rush_direction)

ind_4 <- (nflgames$rush_id==1)

nflgames$pass_direction[ind_4] <- nflgames$rush_direction[ind_4] 

ind_5 <- (nflgames$pass_id==1 & nflgames$pass_direction=='N/A')

nflgames$pass_direction[ind_5] <- 'Sack'

ind_6 <- (nflgames$pass_direction=='Sack' & nflgames$yards>0)

nflgames$pass_direction[ind_6] <- 'Unk'

nflgames$pass_direction <- as.factor(nflgames$pass_direction)

nflgames <- subset(nflgames, pass_direction!='Unk')

#remove unnecesary variables (gsis_id, play_id, description, note, error_id, 
#location, start_time, day_of_week, rush_id, rush_direction)

remove_var <- c('gsis_id', 'play_id', 'description', 'note', 'error_id', 
                'location', 'start_time', 'day_of_week', 'rush_id', 'rush_direction')

nflgames <- nflgames[,-which(names(nflgames) %in% remove_var)]

colnames(nflgames)[15] <- 'play_type'

colnames(nflgames)[16] <- 'play_direction'

save(nflgames,file="nflgames.Rda")
