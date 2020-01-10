#library(mlxR)
theme_set(theme_bw())

p <- c(Vs=10, gV=0.1, ws=70, gw=10, omega_w=12, omega_V=0.15, beta=1, k=0.15, a=0.5)
f <- list(name='f', time=seq(0, 30, by=0.1))
y <- list(name='y', time=seq(1, 30, by=3))
ind <- list(name=c('w','V'))
pop <- list(name=c('w_pop','V_pop'))

res <- simulx(model     = 'model/hierarchical3.txt', 
              parameter = p, 
              output    = list(pop, ind, f, y),
              settings  = list(seed = 123456))

print(res$parameter)

print(ggplot() + geom_line(data=res$f, aes(x=time, y=f), size=1) + 
geom_point(data=res$y, aes(x=time, y=y), colour='red'))
g <- list(size=c(2,3),
          level=c('population','covariate'))

res <- simulx(model     = 'model/hierarchical3.txt', 
              parameter = p, 
              output    = list(pop, ind, f, y),
              group     = g,
              settings  = list(seed = 123456))

print(res$parameter)

print(ggplot() + geom_line(data=res$f, aes(x=time, y=f, colour=id), size=1) + 
geom_point(data=res$y, aes(x=time, y=y, colour=id)))
g <- list(size=c(2,3),
          level=c('population','individual'))

res <- simulx(model     = 'model/hierarchical3.txt', 
              parameter = p, 
              output    = list(pop, ind, f, y),
              group     = g,
              settings  = list(seed = 123456))

print(res$parameter)

