#library(mlxR)
theme_set(theme_bw())

## prctilemlx(r, band=list(number=8,level=80),y.lim=NULL,plot=TRUE)
myModel <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl}
EQUATION:
C = pkmodel(ka,V,Cl)

[INDIVIDUAL]
input = {ka_pop, V_pop, Cl_pop, omega_ka, omega_V, omega_Cl}
DEFINITION:
ka = {distribution=lognormal, reference=ka_pop, sd=omega_ka}
V  = {distribution=lognormal, reference=V_pop,  sd=omega_V }
Cl = {distribution=lognormal, reference=Cl_pop, sd=omega_Cl}
")

N=2000

pop.param   <- c(
  ka_pop  = 1,    omega_ka  = 0.5,
  V_pop   = 10,   omega_V   = 0.4,
  Cl_pop  = 1,    omega_Cl  = 0.3)
  
res <- simulx(model     = myModel,
              parameter = pop.param,
              treatment = list(time=0, amount=100),
              group     = list(size=N, level='individual'),
              output    = list(name='C', time=seq(0,24,by=0.5)))
res$C[1:10,]
p1   <- prctilemlx(res$C)
print(p1)
p2 <- prctilemlx(res$C, band=list(number=2, level=50))
print(p2)
p3 <- prctilemlx(res$C, band=list(number=1, level=90))
print(p3)
p4 <- prctilemlx(res$C, band=list(number=75, level=90))
print(p4)
p5 <- prctilemlx(res$C, band=list(number=4, level=80), plot=FALSE)
print(names(p5))
print(p5$proba)
print(p5$color)
print(p5$y[1:5,])
Ng=400
g1 <- list(size=Ng, level='individual', treatment = list(time=0, amount=60))
g2 <- list(size=Ng, level='individual', treatment = list(time=0, amount=100))
g3 <- list(size=Ng, level='individual', treatment = list(time=3, amount=60))
g4 <- list(size=Ng, level='individual', treatment = list(time=3, amount=100))

t.out <- seq(0,24,by=0.5)
res <- simulx(model     = myModel,
              parameter = pop.param,
              group     = list(g1, g2, g3, g4),
              output    = list(name='C', time=t.out))
labels <- c("60 mg - 0h ", "100 mg - 0h", "60 mg - 3h ", "100 mg - 3h")
resC <- res$C
prctilemlx(resC, label=labels) + theme(legend.position = "none")
prctilemlx(resC, label=labels) + theme(legend.position = "none")  + facet_wrap(~ group, nrow=1)
prctilemlx(resC, group="none") 
resC$doseTime <- 0
resC$doseTime[res$C$group %in% c(3,4)] <- 3
resC$doseAmount <- 60
resC$doseAmount[res$C$group %in% c(2,4)] <- 100
prctilemlx(resC, group="doseAmount", labels=c("60 mg", "100 mg"))   + theme(legend.position = "none") 
prctilemlx(resC, group="doseTime", labels=c("0 h", "3 h"))  + 
  theme(legend.position = "none") 
prctilemlx(resC, group="doseTime", facet=FALSE)  + theme(legend.position = "none") 
prctilemlx(resC, group=c("doseTime", "doseAmount"), labels=list(c("0 h", "3 h"),c("60 mg", "100 mg"))) + theme(legend.position = "none") 
prctilemlx(resC, group=c("doseTime", "doseAmount"), labels=list(c("0 h", "3 h"),c("60 mg", "100 mg"))) +
  facet_grid(doseAmount~doseTime) + theme(legend.position = "none") 
N <- nlevels(res$C$id)
dose.time <- rep(c(0,3),each=N/2)
cov <- data.frame(id=levels(res$C$id), doseTime=dose.time)
head(cov)
prctilemlx(res$C, group=cov[c("id","doseTime")], labels=c("0 h", "3 h")) + theme(legend.position = "none") 
gender.sim <- c("M","F")[sample(2,size=N,replace = TRUE)]
cov$gender <- gender.sim
head(cov)
prctilemlx(res$C, group=cov, labels=list(c("0 h", "3 h"),c("Male", "Female"))) + theme(legend.position = "none") 
resC$gender <- rep(cov$gender,each=length(t.out))
prctilemlx(resC, group= c("gender","doseTime"), labels=list(c("0 h", "3 h"),c("Male", "Female")))  + theme(legend.position = "none") 
