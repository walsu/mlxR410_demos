#library(mlxR)
theme_set(theme_bw())

N <- 3

myPKmodel1 <- inlineModel("
[LONGITUDINAL] 
input={Tk0,V,Cl}

EQUATION:
Cc = pkmodel(Tk0, V, Cl)

[INDIVIDUAL]
input={Tk0_pop,V_pop,Cl_pop,omega_Tk0,omega_V,omega_Cl}

DEFINITION:
Tk0   = {distribution=lognormal,   prediction=Tk0_pop,  sd=omega_Tk0}
V     = {distribution=lognormal,   prediction=V_pop,    sd=omega_V}
Cl    = {distribution=lognormal,   prediction=Cl_pop,   sd=omega_Cl}
")

pk.param   <- c(
  Tk0_pop   = 5,    omega_Tk0   = 0.2,
  V_pop     = 10,   omega_V     = 0.5,
  Cl_pop    = 0.5,  omega_Cl    = 0.2
)

out <- list(name="Cc", time=0:300)
tdose <- seq(0,240,by=24)
amtdose <- 100
adm1 <- list(amount=amtdose, time=tdose)
res1 <- simulx(model     = myPKmodel1,
               parameter = pk.param,
               treatment = adm1,
               output    = out,
               group     = list(size=N, level="individual"),
               settings  = list(seed=12345))

pl1 <- ggplot(res1$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl1)
#---- individual dosage regimens  ----------------------
ndose <- length(tdose)
adm2 <- data.frame(id = rep(1:N,each=ndose), 
                   amount=amtdose, 
                   time=rep(tdose,N))
res2 <- simulx(model     = myPKmodel1,
               parameter = pk.param,
               treatment = adm2,
               output    = out,
               settings  = list(seed=12345))
#------  non adherence <=> remove treatment lines  --------------------
adherence.rate <- 0.7
adm3 <- adm2[runif(N*ndose)<adherence.rate,]
res3 <- simulx(model     = myPKmodel1,
               parameter = pk.param,
               treatment = adm3,
               output    = out,
               settings  = list(seed=12345))

pl3 <- ggplot(res3$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl3)
#------- variability on dosing times and amounts ----------------
sd.time <- 3
sd.amount <- 10
adm4 <- adm2
adm4$time <- adm4$time + rnorm(N*ndose)*sd.time
adm4$amount <- adm4$amount + rnorm(N*ndose)*sd.amount
head(adm4)
res4 <- simulx(model     = myPKmodel1,
               parameter = pk.param,
               treatment = adm4,
               output    = out,
               settings  = list(seed=12345))

pl4 <- ggplot(res4$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl4)
myPKmodel2 <- inlineModel("
[LONGITUDINAL] 
input={Tk0,V,Cl,fd}
fd = {use=regressor}

EQUATION:
Cc = pkmodel(Tk0, V, Cl, p=fd)

[INDIVIDUAL]
input={Tk0_pop,V_pop,Cl_pop,omega_Tk0,omega_V,omega_Cl}

DEFINITION:
Tk0   = {distribution=lognormal,   prediction=Tk0_pop,  sd=omega_Tk0}
V     = {distribution=lognormal,   prediction=V_pop,    sd=omega_V}
Cl    = {distribution=lognormal,   prediction=Cl_pop,   sd=omega_Cl}
")
set.seed(123)
ndose <- length(tdose)
fd <- adm2[-2]
fd$fd=as.numeric(runif(N*ndose)<adherence.rate)
head(fd)
res5 <- simulx(model     = myPKmodel2,
               parameter = pk.param,
               treatment = adm1,
               output    = out,
               regressor = fd,
               settings  = list(seed=12345))

pl5 <- ggplot(res5$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl5)
set.seed(123)
fd$fd=adm2$amount*rnorm(ndose,1,0.1)
head(fd)
fd <- data.frame(id = rep(1:N,each=ndose), 
                 time=rep(tdose,N),
                 fd=as.numeric(runif(N*ndose)<adherence.rate))
res6 <- simulx(model     = myPKmodel2,
               parameter = pk.param,
               treatment = adm1,
               output    = out,
               regressor = fd,
               settings  = list(seed=12345))

pl6 <- ggplot(res6$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl6)
myPKmodel3a <- inlineModel("
[LONGITUDINAL] 
input={Tk0,V,Cl,fd}

EQUATION:

Cc = pkmodel(Tk0, V, Cl, p=fd)

[INDIVIDUAL]
input={Tk0_pop,V_pop,Cl_pop,fd_pop,omega_Tk0,omega_V,omega_Cl,gamma_fd}

DEFINITION:
Tk0   = {distribution=lognormal,   prediction=Tk0_pop,  sd=omega_Tk0}
V     = {distribution=lognormal,   prediction=V_pop,    sd=omega_V}
Cl    = {distribution=lognormal,   prediction=Cl_pop,   sd=omega_Cl}
fd    = {distribution=logitnormal,      prediction=fd_pop, varlevel={id, id*occ}, sd={0,gamma_fd}}
")
occ  <- list(time=tdose, name="occ")
fd.param <- c(fd_pop=0.8, gamma_fd=1) 
res7 <- simulx(model     = myPKmodel3a,
               parameter = list(pk.param, fd.param),
               treatment = adm1,
               varlevel  = occ,
               output    = list(out, "fd"),
               group     = list(size=N, level="individual"),
               settings  = list(seed=12345))

head(res7$parameter.iov)
pl7 <- ggplot(res7$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl7)
myPKmodel3b <- inlineModel("
[LONGITUDINAL] 
input={Tk0,V,Cl,z,zlim}

EQUATION:
if z<zlim
  p = 1
else
  p =0
end
Cc = pkmodel(Tk0, V, Cl, p)

[INDIVIDUAL]
input={Tk0_pop,V_pop,Cl_pop,omega_Tk0,omega_V,omega_Cl}

DEFINITION:
Tk0   = {distribution=lognormal,   prediction=Tk0_pop,  sd=omega_Tk0}
V     = {distribution=lognormal,   prediction=V_pop,    sd=omega_V}
Cl    = {distribution=lognormal,   prediction=Cl_pop,   sd=omega_Cl}
z     = {distribution=normal,      prediction=0, varlevel={id, id*occ}, sd={0,1}}
")

adh.param <- c(zlim = qnorm(adherence.rate))
out.p <- list(name=c("p"), time=occ$time)
res8 <- simulx(model     = myPKmodel3b,
               parameter = list(pk.param, adh.param),
               treatment = adm1,
               varlevel  = occ,
               output    = list(out, out.p),
               group     = list(size=N, level="individual"),
               settings  = list(seed=1234))

head(res8$p)
pl8 <- ggplot(res8$Cc) + geom_line(aes(time,Cc,colour=id)) + theme(legend.position = "none")
print(pl8)
