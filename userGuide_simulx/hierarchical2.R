#library(mlxR)
theme_set(theme_bw())

p <- c(V_pop=10, omega_V=0.1, beta=1, w_pop=70, omega_w=12, k=0.15, a=0.5)

f   <- list(name='f', time=seq(0, 30, by=0.1))
y   <- list(name='y', time=seq(1, 30, by=3))
ind <- list(name=c('w','V'))
out <- list(ind, f, y)

res1 <- simulx(model     = 'model/hierarchical2.txt', 
               parameter = p, 
               output    = out,
               settings  = list(seed = 12345))
print(res1$parameter)

plot(ggplot() + 
  geom_line( data=res1$f, aes(x=time, y=f), colour="black") + 
  geom_point(data=res1$y, aes(x=time, y=y), colour="red"))
g <- list( size  = 5,
           level = 'covariate')

res2 <- simulx(model     = 'model/hierarchical2.txt', 
               parameter = p, 
               output    = out,
               group     = g,
               settings  = list(seed = 12345))

print(res2$parameter)

plot(ggplot() + geom_line(data=res2$f, aes(x=time, y=f, colour=id), size=0.75) + 
       geom_point(data=res2$y, aes(x=time, y=y, colour=id), size=2))
g <- list( size  = c(2,3),
           level = c('covariate','individual'))

res3 <- simulx(model     = 'model/hierarchical2.txt', 
               parameter = p, 
               output    = out,
               group     = g,
               settings  = list(seed = 12345))

print(res3$parameter)
g <- list( size  = c(2,2,2),
           level = c('covariate','individual','longitudinal'))

res4 <- simulx(model     = 'model/hierarchical2.txt', 
               parameter = p, 
               output    = out,
               group     = g,
               settings  = list(seed = 123123))

print(res4$parameter)

plot(ggplot() + geom_line(data=res4$f, aes(x=time, y=f, colour=id), size=0.75) + 
  geom_point(data=res4$y, aes(x=time, y=y, colour=id), size=2))
pa <- c(V_pop=10, omega_V=0.1, w_pop=70, beta=1, k=0.15, a=0.5)
pw <- data.frame(id=1:4, w=c(60,70,80,90))
res5a <- simulx(model     = 'model/hierarchical1b.txt', 
               parameter = list(pa,pw), 
               output    = out,
               settings  = list(seed = 123123))

print(res5a$parameter)
res5b <- simulx(model     = 'model/hierarchical1b.txt', 
               parameter = list(pa,pw), 
               output    = out,
               group     = list(size = 7),
               settings  = list(seed = 1231))

print(res5b$parameter)
res5c <- simulx(model     = 'model/hierarchical1b.txt', 
               parameter = list(pa,pw), 
               output    = out,
               group     = list(size = 2),
               settings  = list(seed = 123123))

print(res5c$parameter)
