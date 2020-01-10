#library(mlxR)
theme_set(theme_bw())

pkmodel1 <- inlineModel("
[LONGITUDINAL]
input = {V, k, w}
EQUATION:
Cc = pkmodel(V, k, p=w)

;----------------------------------------------
[COVARIATE]
input = {w_pop, omega_w}
DEFINITION:
w = {distribution = normal, mean = w_pop, sd = omega_w}
")

p   <- c(w_pop=70, omega_w=12, k=0.1, V=10)
dosePerKg <- 2
trtPerKg <- list(amt=dosePerKg, time=c(0, 12, 24))
Cc  <- list(name='Cc', time=seq(0, 36, by=1))
w   <- list(name='w')

res <- simulx(model     = pkmodel1, 
              parameter = p, 
              treatment = trtPerKg,
              output    = list(Cc,w),
              group     = list(size=3, level="covariate"),
              settings  = list(seed=123))

print(res$parameter)
print(res$Cc[res$Cc$time==0,])

print(ggplot(data=res$Cc) + geom_line(aes(x=time, y=Cc, colour=id)) +
  theme(legend.position=c(.9, .8)))
pkmodel2 <- inlineModel("
[LONGITUDINAL]
input = {V, k, w}
EQUATION:
Cc = pkmodel(V, k, p=w)
")

weight <- data.frame(id=(1:3), w=c(60,80,90))

res <- simulx(model     = pkmodel2, 
              parameter = list(p, weight),
              treatment = trtPerKg,
              output    = Cc)

print(res$Cc[res$Cc$time==0,])

print(ggplot(data=res$Cc) + geom_line(aes(x=time, y=Cc, colour=id)) +
  theme(legend.position=c(.9, .8)))
pkmodel3 <- inlineModel("
[LONGITUDINAL]
input = {V, k}
EQUATION:
Cc = pkmodel(V, k)
")

w <- c(60,80,90)
N <- length(w)
times <- c(0, 12, 24)
nbTimes <- length(times)
trt <- data.frame(id     = rep(1:N,each=nbTimes),
                  time   = rep(times,N),
                  amount = rep(dosePerKg*w,each=nbTimes))

res <- simulx(model     = pkmodel3, 
              parameter = p, 
              treatment = trt,
              output    = Cc)

print(res$Cc[res$Cc$time==0,])

print(ggplot(data=res$Cc) + geom_line(aes(x=time, y=Cc, colour=id)) +
  theme(legend.position=c(.9, .8)))
pkmodel4 <- inlineModel("
[LONGITUDINAL]
input = {V, k, w}

PK:
depot(target=Ac, p=w)
EQUATION:
ddt_Ac = -k*Ac
Cc = Ac/V
")

res <- simulx(model     = pkmodel4, 
              parameter = list(p, weight),
              treatment = trtPerKg,
              output    = list(Cc))

print(res$Cc[res$Cc$time==0,])

print(ggplot(data=res$Cc) + geom_line(aes(x=time, y=Cc, colour=id)) +
  theme(legend.position=c(.9, .8)))
