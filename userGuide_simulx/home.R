#library(mlxR)
theme_set(theme_bw())

## f <- list(name='f', time=seq(0, 30, by=0.1))
## y <- list(name='y', time=seq(0, 30, by=2))
## 
## res <- simulx(model     = 'model/home.txt',
##               parameter = c(A=100, k_pop=6, omega=0.3, c=10, a=1),
##               output    = list(f,y),
##               group     = list(size=4, level='individual'))
## 
## ggplot() + geom_line(data=res$f, aes(x=time, y=f, color=id)) + geom_point(data=res$y, aes(x=time, y=y, color=id))
f <- list(name='f', time=seq(0, 30, by=0.1))
y <- list(name='y', time=seq(0, 30, by=2))

res <- simulx(model     = 'model/home.txt', 
              parameter = c(A=100, k_pop=5, omega=0.3, c=10, a=3), 
              output    = list(f,y),
              group     = list(size=4, level='individual'),
              settings  = list(seed=123))

ggplot() + geom_line(data=res$f, aes(x=time, y=f, color=id)) + geom_point(data=res$y, aes(x=time, y=y, color=id))
