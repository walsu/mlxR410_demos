#library(mlxR)
theme_set(theme_bw())

## group = list(size=c(1,5), level=c('individual','longitudinal'))
## group = list(size=c(5,1), level=c('individual','longitudinal'))
## group = list(size=c(5,3), level=c('individual','longitudinal'))
## group = list(size=5, level='longitudinal')
## group = list(size=c(1,1,5), level=c('covariate','individual','longitudinal'))
## group = list(size=5, level='covariate')
## group = list(size=c(5,1,1), level=c('covariate','individual','longitudinal'))
## group = list(size=c(3,1,2))
## group = list(size=c(3,1,2), level=c('covariate','individual','longitudinal'))
adm <- list(time=seq(0,to=66,by=12), amount=100)
C <- list(name='C', time=seq(0, 100, by=1))
y <- list(name='y', time=seq(0, 100, by=12))
p <- c(V=10, k=0.2, a=0.1)
g <- list(size=5, level='longitudinal')

res1 <- simulx(model     = "model/groupII1.txt",
               treatment = adm,
               parameter = p, 
               output    = list(C,y), 
               group     = g,
               settings  = list(seed = 12345))
names(res1)
names(res1$C)
names(res1$y)
print(ggplot() + geom_line(data=res1$C, aes(x=time, y=C), colour="grey", size=0.75) +
        geom_point(data=res1$y, aes(x=time, y=y, colour=id), size=3))
g <- list(treatment=adm, parameter=p, output=list(C,y), size=5, level='longitudinal')

res3 <- simulx(model     = "model/groupII1.txt",
               group     = g,
               settings  = list(seed = 12345))

print(ggplot() + geom_line(data=res3$C, aes(x=time, y=C), colour="grey", size=0.75) +
        geom_point(data=res3$y, aes(x=time, y=y, colour=id), size=3))
adm1 <- list(time=seq(0,to=66,by=6), amount=50)
adm2 <- list(time=seq(0,to=66,by=12), amount=100)
adm3 <- list(time=seq(0,to=66,by=18), amount=150)
g1 <- list(treatment=adm1, size=2, level='longitudinal')
g2 <- list(treatment=adm2, size=3, level='longitudinal')
g3 <- list(treatment=adm3, size=4, level='longitudinal')

C <- list(name='C', time=seq(0, 100, by=1))
y <- list(name='y', time=seq(0, 100, by=12))
p <- c(V=10, k=0.2, a=0.1)


res4 <- simulx(model     = "model/groupII1.txt", 
               parameter = p, 
               output    = list(C,y), 
               group     = list(g1,g2,g3))

print(ggplot() + geom_line(data=res4$C, aes(x=time, y=C), colour="grey", size=0.75) +
        geom_point(data=res4$y, aes(x=time, y=y, colour=id), size=3)+ 
        facet_grid(. ~ group))
adm <- list(time=seq(0,66,by=12), amount=100)
y <- list(name="y", time=seq(18, 80, by=6))
C <- list(name="C", time=seq(0,100, by=0.5))
V <- list(name="V")
p <- c(V_pop=10, omega_V=0.3, w=50, k=0.2, a=0.2)

g <- list(size  = c(6,1), 
          level = c('individual','longitudinal'))

res5 <- simulx(model    = "model/groupII2.txt", 
              output    = list(C,y,V),
              parameter = p,
              treatment = adm,
              group     = g,
              settings  = list(seed=123456))

print(res5$parameter)

print(ggplot()  +
  geom_line(data=res5$C, aes(x=time, y=C), colour="black", size=0.5) +
  geom_point(data=res5$y, aes(x=time, y=y), colour="red", size=3)+ 
    facet_wrap( ~ id))
adm1 <- list(time=seq(0,66,by=6),  amount=50)
adm2 <- list(time=seq(0,66,by=12), amount=100)
y <- list(name="y", time=seq(30, 90, by=6))
C <- list(name="C", time=seq(0,100, by=0.5))
V <- list(name="V")
p1 <- c(V_pop=10, omega_V=0.3, w=50, k=0.2, a=0.2)
p2 <- c(V_pop=20, omega_V=0.3, w=75, k=0.1, a=0.2)

g1 <- list(treatment = adm1, 
           parameter = p1, 
           size      = c(3,1), 
           level     = c('individual','longitudinal'))
g2 <- list(treatment = adm2, 
           parameter = p2, 
           size      = c(2,1), 
           level     = c('individual','longitudinal'))

res6 <- simulx(model    = "model/groupII2.txt", 
               output   = list(C,y,V),
               group    = list(g1,g2),
               settings = list(seed=123123))

print(res6$parameter)

print(ggplot()  +
        geom_line( data=res6$C, aes(x=time, y=C, colour=id), size=0.5) +
        geom_point(data=res6$y, aes(x=time, y=y, colour=id), size=3) + 
        facet_grid(. ~ group))
