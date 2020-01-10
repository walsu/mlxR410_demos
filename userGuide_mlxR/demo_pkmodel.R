#library(mlxR)
library("reshape2")
theme_set(theme_bw())

## pkmodel(time, treatment, parameter)
adm <- list(time=c(2,14,20), amount=40)
t   <- seq(0, 30, by=0.1)
param   <- c(V=10, k=0.05, k12=0.3, k21=0.2)

res   <- pkmodel(time = t, treatment = adm, parameter = param)

print(ggplot(data=res, aes(x=time, y=cc)) + geom_line(size=1) +
  xlab("time (h)") + ylab("concentration (mg/L)"))
param   <- c(V=10, Cl=0.5, Q2=3, V2=15)
res   <- pkmodel(time = t, treatment = adm, parameter = param)
print(ggplot(data=res, aes(x=time, y=cc)) + geom_line(size=1) +
  xlab("time (h)") + ylab("concentration (mg/L)"))
adm <- list(time = c(1,23,37,45), amount = c(1,0.5,2,0.3))
param <- c(Mtt=5, Ktr=1, ka=0.5, V=10, Vm=1, Km=0.6, p=0.5)
t <- seq(0, 80, by=0.1)

res <- pkmodel(t,adm,param)

print(ggplot(data=res, aes(x=time, y=cc)) + geom_line(size=1) +
  xlab("time (h)") + ylab("concentration (mg/L)"))
adm <- list( time = 2, amount = 40)

param <- inlineDataFrame("
id   ka   V    Cl
1   0.5   4     1
2     1   6     1
3   1.5   6   1.5
")

t <- seq(0, 30, by=0.1)

res <- pkmodel(t,adm,param)

print(ggplot(data=res, aes(x=time, y=cc, colour=id)) + geom_line(size=1) +
  xlab("time (h)") + ylab("concentration (mg/L)"))

adm <- list(time=seq(2, 100, by=24), amount=40, rate=5)
param <- c(V=8, Cl=0.5, k12=0.3, k21=0.2, ke0=0.2)
t <- seq(0, 50, by=0.1)

res <- pkmodel(t,adm,param)

r <- melt(res, id='time', variable.name='c')
print(ggplot(r, aes(time,value)) + geom_line(aes(colour = c),size=1) +
        ylab('concentration') + guides(colour=guide_legend(title=NULL)) +
        theme(legend.position=c(.9, .8)))

