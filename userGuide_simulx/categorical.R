#library(mlxR)
library(gridExtra)
library(reshape2)
theme_set(theme_bw())

seed <- 12345 
p    <- c(a=8,b=0.2)
pr   <- list(name=c('p1','p2','p3'), time=0:100)
y    <- list(name='y', time=seq(0, 100, by=2))
res  <- simulx(model     = 'model/categoricalA.txt', 
               parameter = p, 
               output    = list(pr, y),
               settings  = list(seed=seed))
plot1=ggplot() + ylab("probabilities") +
  geom_line(data=res$p1, aes(x=time, y=p1, colour="p1"),size=1) +
  geom_line(data=res$p2, aes(x=time, y=p2, colour="p2"),size=1) +
  geom_line(data=res$p3, aes(x=time, y=p3, colour="p3"),size=1) +
  theme(legend.position=c(0.1,0.5),legend.title=element_blank()) 
plot2=ggplot() + geom_point(aes(x=time, y=y), data=res$y) 
grid.arrange(plot1, plot2, ncol=2)
lpr  <- list(name=c('lp1','lp2'), time=0:100)
res  <- simulx(model     = 'model/categoricalB.txt', 
               parameter = p, 
               output    = list(y,lpr),
               settings  = list(seed=seed))
p1 <- 1/(1+exp(-res$lp1$lp1))
p2 <- 1/(1+exp(-res$lp2$lp2))-p1
p3 <- 1-p1-p2
pr <- data.frame(time=0:100,p1,p2,p3)
pr <- melt(pr ,  id = 'time', variable.name = 'proba')
# pr is a data frame with columns "id", "proba" and "value"
plot1=ggplot(pr, aes(time,value)) + geom_line(aes(colour = proba),size=1) +
  ylab('probabilities') + theme(legend.position=c(.1, .5))
plot2=ggplot() + geom_point(aes(x=time, y=y), data=res$y) 
grid.arrange(plot1, plot2, ncol=2)
g <- list(size=1000)
res <- simulx(model     = 'model/categoricalA.txt', 
              parameter = p, 
              output    = y, 
              group     = g)
plot3 <- catplotmlx(res$y, breaks=25)
print(plot3)
