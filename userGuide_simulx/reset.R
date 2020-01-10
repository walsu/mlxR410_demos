library(gridExtra)
library(ggplot2)
theme_set(theme_bw())

pk.model1 <- inlineModel("
[LONGITUDINAL]
input = {ka, k}

PK:
depot(target=Ad, type=1)
empty(target=Ac, type=2)

EQUATION:
ddt_Ad = -ka*Ad
ddt_Ac = ka*Ad - k*Ac
")

p <- c(ka=0.3,  k=0.1)
out <- list(name=c("Ad", "Ac"), time = seq(0,150,0.1))
trt1 <- list(amt=100, time=seq(10,136,by=24), type=1)
trt2 <- list(         time=seq(28,136,by=48), type=2)
trt <- list(trt1, trt2)
r <- simulx(model=pk.model1, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
grid.arrange(pl1, pl2)


pk.model2 <- inlineModel("
[LONGITUDINAL]
input = {ka, k}

PK:
depot(target=Ad, type=1)
depot(target=Ac, type=2)
empty(target=Ad, type=3)
empty(target=Ac, type=4)
empty(target=all, type=5)

EQUATION:
ddt_Ad = -ka*Ad
ddt_Ac = ka*Ad - k*Ac
")

trt1 <- list(amt=100, time=seq(10,136,by=24), type=1)
trt2 <- list(amt=50,  time=seq(28,136,by=48), type=2)
trt3 <- list(         time=seq(38,136,by=48), type=3)
trt4 <- list(         time=seq(38,136,by=48), type=4)
trt5 <- list(         time=seq(38,136,by=48), type=5)

trt <- list(trt1, trt2, trt3)
r <- simulx(model=pk.model2, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
grid.arrange(pl1, pl2)

trt <- list(trt1, trt2, trt4)
r <- simulx(model=pk.model2, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
grid.arrange(pl1, pl2)

trt <- list(trt1, trt2, trt5)
r <- simulx(model=pk.model2, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
grid.arrange(pl1, pl2)


pkpd.model1 <- inlineModel("
[LONGITUDINAL]
input = {ka, k, E0, IC50, kout}

PK:
depot(target=Ad,  type=1)
empty(target=E,   type=2)
reset(target=E,   type=3)
reset(target=all, type=4)

EQUATION:
E_0 = E0
kin = E0*kout

ddt_Ad = -ka*Ad
ddt_Ac = ka*Ad - k*Ac
ddt_E  = kin * (1 - Ac/(Ac+IC50)) - kout*E
")

p <- c(ka=0.3, k=0.1, E0=100, IC50=20, kout=0.2)
out <- list(name=c("Ad", "Ac", "E"), time = seq(0,150,0.1))
trt1 <- list(amt=100, time=seq(10,136,by=24), type=1)
trt2 <- list(         time=seq(60,136,by=48), type=2)
trt3 <- list(         time=seq(60,136,by=48), type=3)
trt4 <- list(         time=seq(60,136,by=48), type=4)
trt <- list(trt1, trt2)
r <- simulx(model=pkpd.model1, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
pl3 <- ggplot(r$E, aes(time,E)) + geom_line()
grid.arrange(pl1, pl2, pl3)

trt <- list(trt1, trt3)
r <- simulx(model=pkpd.model1, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
pl3 <- ggplot(r$E, aes(time,E)) + geom_line()
grid.arrange(pl1, pl2, pl3)


trt <- list(trt1, trt4)
r <- simulx(model=pkpd.model1, parameter = p, treatment = trt, output = out)
pl1 <- ggplot(r$Ad, aes(time,Ad)) + geom_line()
pl2 <- ggplot(r$Ac, aes(time,Ac)) + geom_line()
pl3 <- ggplot(r$E, aes(time,E)) + geom_line()
grid.arrange(pl1, pl2, pl3)

