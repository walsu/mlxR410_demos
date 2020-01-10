#library(mlxR)
library(reshape2)
theme_set(theme_bw())

f <- list(name = 'f1',  time = seq(0, 25, by=0.1))

p <- c(ka = 0.5, V = 10, k = 0.2)

res <- simulx(model     = 'model/analytical.txt', 
              parameter = p, 
              output    = f)
res$f1[1:5,]
res$f1[248:251,]
print(ggplot(data=res$f1) + geom_line(aes(x=time, y=f1))) 
f <- list(name = c('f1','f2'), time = seq(0, 25, by=0.1))

res <- simulx(model     = 'model/analytical.txt', 
              parameter = p, 
              output    = f)

print(ggplot() + geom_line(data=res$f1, aes(x=time, y=f1), color="black") +
                geom_line(data=res$f2, aes(x=time, y=f2), color="red") +
                ylab('concentration'))
r <- merge(res$f1,res$f2)
r <- melt(r ,  id = 'time', variable.name = 'f', value.name="concentration")
r[c(1:4),]
r[c(250:253),]

print(ggplot(r, aes(time,concentration)) + geom_line(aes(colour = f),size=1) +
        guides(colour=guide_legend(title=NULL)) + theme(legend.position=c(.9, .8)))
f1 <- list(name = 'f1', time = seq(0, 15, by=0.1))
f2 <- list(name = 'f2', time = seq(10, 25, by=1))

res <- simulx(model     = 'model/analytical.txt', 
              parameter = p, 
              output    = list(f1,f2))

plot(ggplot() + geom_line(data=res$f1, aes(x=time, y=f1), color="black") +
                geom_line(data=res$f2, aes(x=time, y=f2), color="red") +
                ylab('concentration'))
r <- merge(res$f1,res$f2,all=TRUE)
r <- melt(r ,  id = 'time', variable.name = 'f', value.name="concentration")
r=r[(!is.na(r$concentration)),]
print(ggplot(r, aes(time,concentration)) + geom_line(aes(colour = f),size=1) +
       guides(colour=guide_legend(title=NULL)) + theme(legend.position=c(.9, .8)))
