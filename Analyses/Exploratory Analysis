
## Histograms and barplots

library(ggplot2)

load("nflgames.Rda")

nflgames$pos_team <- droplevels(nflgames$pos_team)
nflgames$home <- as.factor(nflgames$home)
nflgames$play_type <- as.factor(nflgames$play_type)


for (i in 1:ncol(nflgames)) {
  if (class(nflgames[, i])=='factor') {
    if(nlevels(nflgames[, i])>10) {
      print(ggplot(nflgames, aes(x=nflgames[,i], y=..count../sum(..count..))) + 
              geom_bar() + 
              xlab(colnames(nflgames)[i]) + 
              ylab('Proportion') + 
              coord_flip())
    } else {
      print(ggplot(nflgames, aes(x=nflgames[,i], y=..count../sum(..count..))) + 
              geom_bar() + 
              xlab(colnames(nflgames)[i]) + 
              ylab('Proportion'))
    }
  } else {
    print(ggplot(nflgames, aes(x=nflgames[,i], y=..count../sum(..count..))) + 
            geom_histogram(col='black', fill='lightgrey') + 
            xlab(colnames(nflgames)[i]) + 
            ylab('Proportion'))
  }
}

## Marginal effects

library(gridExtra)

for (i in 1:ncol(nflgames)){
  if (class(nflgames[,i])=='factor'){
    temp.plot1 <- ggplot(nflgames, 
                         aes_string(x=factor(1), 
                                    y=colnames(nflgames)[17], 
                                    col=colnames(nflgames)[i])) + 
      geom_boxplot() +
      theme(legend.position = "none") + 
      xlab('')
    temp.plot2 <- ggplot(nflgames, 
                         aes_string(x=colnames(nflgames)[17], 
                                    col=colnames(nflgames)[i])) + 
      geom_density()
    
    print(grid.arrange(temp.plot1, temp.plot2, ncol=2))
    
  } else {
    
    print(ggplot(nflgames, aes_string(x = nflgames[,i], y = nflgames[,17])) + geom_point() + xlab(colnames(nflgames)[i]) + ylab('yards'))
    
  }
}

## Correlation matrix

library(corrplot)

numeric.var <- sapply(nflgames, is.numeric)

corrplot(cor(nflgames[,numeric.var]), method = "number", number.cex = 0.7)
