#library(mlxR)
library("gridExtra")
theme_set(theme_bw())

joint.model1 <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl, IC50, kin, kout, a1, a2}  

EQUATION:
C     = pkmodel(ka, V, Cl)
t0    = 0
E_0   = kin/kout
ddt_E = kin*(1 - C/(IC50+C)) - kout*E

DEFINITION:
Concentration = {distribution = lognormal, 
                 prediction   = C, 
                 sd           = a1}

Effect = {distribution = normal, 
          prediction   = E, 
          sd           = a2}
")
p <- c(ka=0.5, V=8, Cl=1.5, IC50=0.5, kin=10, kout=0.1, a1=0.1, a2=5)

a <- list(amount = 10, time = seq(2,120,by=12))

f <- list(name = c('C', 'E'),     time = seq(0,100,by=1))
c <- list(name = 'Concentration', time = seq(4,100,by=12))
e <- list(name = 'Effect',        time = seq(5,100,by=10))

res <- simulx(model     = 'model/joint1.txt',
              treatment = a,
              parameter = p,
              output    = list(f, c, e),
              settings  = list(seed = 1234))
names(res)
plot1 = ggplot() + geom_line(data=res$C, aes(x=time, y=C)) +
        geom_point(data=res$Concentration, aes(x=time, y=Concentration),colour="red") 
plot2 = ggplot() + geom_line(data=res$E, aes(x=time, y=E)) +
        geom_point(data=res$Effect, aes(x=time, y=Effect),colour="red") 
grid.arrange(plot1, plot2, ncol=2)
joint.model2 <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl, u, v, a1}  

EQUATION:
C = pkmodel(ka, V, Cl)
h = u*exp(v*C)

DEFINITION:
Concentration = {distribution = lognormal, 
                 prediction   = C, 
                 sd           = a1}

Hemorrhaging  = {type               = event, 
                 rightCensoringTime = 100,  
                 hazard             = h}
")
p <- c(ka=0.5, V=8, Cl=1.5, u=0.003, v=3, a1=0.05)

a <- list(amount = 10, time = seq(2,120,by=12))

f <- list(name = c('C', 'h'),     time = seq(0,100,by=1))
c <- list(name = 'Concentration', time = seq(4,100,by=12))
e <- list(name = 'Hemorrhaging',  time = 0)

res1 <- simulx(model     = joint.model2,
               treatment = a,
               parameter = p,
               output    = list(f, c, e),
               settings  = list(seed = 12345))
print(res1$Hemorrhaging)
plot1 = ggplot() + geom_line(data=res1$C, aes(x=time, y=C)) +
        geom_point(data=res1$Concentration, aes(x=time, y=Concentration),colour="red") 
plot2 = ggplot() + geom_line(data=res1$h, aes(x=time, y=h)) +
        ylab("hazard")  + theme(legend.position="none")
grid.arrange(plot1, plot2, ncol=2)
N   <- 20
res2 <- simulx(model     = joint.model2,
               treatment = a,
               parameter = p,
               output    = list(f, c, e),
               group     = list(size = N, level='longitudinal'),
               settings  = list(seed = 121212))
plot3 = ggplot() + geom_line(data=res2$C, aes(x=time, y=C, group=id)) +
  geom_point(data=res2$Concentration, aes(x=time, y=Concentration),colour="red") 
plot(plot3)
h1    = res2$Hemorrhaging[res2$Hemorrhaging[,3]==1,]
plot4 = ggplot()+geom_point(data=h1, aes(x=time,y=id), size=3) + 
        xlab("event time") + ylab("replicate")  + theme(legend.position="none")
plot(plot4)
