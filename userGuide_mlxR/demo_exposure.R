#library(mlxR)
library(gridExtra)
theme_set(theme_bw())

## exposure(model, output, group = NULL, treatment = NULL, parameter = NULL, data = NULL, project = NULL, settings = NULL, regressor = NULL, varlevel = NULL)
myModel <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl}
EQUATION:
Cc = pkmodel(ka, V, Cl)
")

p <- c(ka=0.5, V=10, Cl=1)

adm1 <- list(time=0, amount=100)
out1 <- list(name="Cc", time=seq(0, 24, by=0.2))

res1 <- exposure(model=myModel, parameter=p, output=out1, treatment=adm1)
names(res1)
ggplot(data=res1$output$Cc) + geom_line(aes(x=time,y=Cc))
print(res1$Cc)
adm2 <- list(time=seq(0,160,by=8), amount=100)
out2 <- list(name="Cc", time=seq(160, 168, by=0.1))

res2 <- exposure(model=myModel, parameter=p, output=out2, treatment=adm2)
print(res2$Cc)
adm3 <- list(tfd=0, ii=8, amount=100)
out3a <- list(name="Cc", time='steady.state')

res3a <- exposure(model=myModel, parameter=p, output=out3a, treatment=adm3)

ggplot(data=res3a$output$Cc) + geom_line(aes(x=time,y=Cc))
print(res3a$Cc)
out3b <- list(name="Cc", time='steady.state', tol=0.001)
res3b <- exposure(model=myModel, parameter=p, output=out3b, treatment=adm3)
print(res3b$Cc)
p3 <- inlineDataFrame("
 id   ka   V   Cl
  1  0.5  10    1
  2  0.5   8  0.8
")
res3c <- exposure(model=myModel, parameter=p3, output=out3a, treatment=adm3)
print(res3c$Cc)
ggplot(data=res3c$output$Cc) + geom_line(aes(x=time,y=Cc, color=id))
g1 <- list(treatment=list(ii=8, amount=100))
g2 <- list(treatment=list(ii=4, amount=50))
out4 <- list(name="Cc", time='steady.state', tol=0.001)

res4 <- exposure(model=myModel, parameter=p, output=out4, group=list(g1,g2))
print(res4$Cc)
ggplot(data=res4$output$Cc) + geom_line(aes(x=time,y=Cc, color=group))
myModel <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl}

PK:
depot(type=1, target=Ad)
depot(type=2, target=Ac)

EQUATION:
ddt_Ad = -ka*Ad
ddt_Ac =  ka*Ad - (Cl/V)*Ac
Cc = Ac/V
")

p <- c(ka=0.5, V=10, Cl=1)

adm1 <- list(tfd=0, ii=8, amount=100, type=1)
adm2 <- list(tfd=3, ii=12, amount=50, type=2, tinf=1)
adm <- list(adm1, adm2)
out <- list(name="Cc", time='steady.state', ntp=200)

res <- exposure(model=myModel, parameter=p, output=out, treatment=adm)

print(res$Cc)
print(ggplot(data=res$output$Cc) + geom_line(aes(x=time,y=Cc)))

myModel <- inlineModel("
[LONGITUDINAL] 
input={ka,V,k,Imax,S0,IC50,kout}

EQUATION:
Cc  = pkmodel(ka, V, k)
Ec = Imax*Cc/(Cc+IC50)
PCA_0 = S0 
ddt_PCA = kout*((1-Ec)*S0- PCA)  

[INDIVIDUAL]
input={ka_pop,omega_ka,V_pop,omega_V,beta_V,k_pop,omega_k,beta_k,
       Imax_pop,omega_Imax,S0_pop,omega_S0,
       IC50_pop,omega_IC50,kout_pop,omega_kout,w,w_pop}

EQUATION:
V_pred = V_pop*(w/w_pop)^beta_V
k_pred = k_pop*(w/w_pop)^beta_k

DEFINITION:
ka  ={distribution=lognormal, prediction=ka_pop,   sd=omega_ka}
V   ={distribution=lognormal, prediction=V_pred,   sd=omega_V}
k   ={distribution=lognormal, prediction=k_pred,   sd=omega_k}
S0  ={distribution=lognormal, prediction=S0_pop,   sd=omega_S0}
IC50={distribution=lognormal, prediction=IC50_pop, sd=omega_IC50}
kout={distribution=lognormal, prediction=kout_pop, sd=omega_kout}
Imax={distribution=logitnormal, prediction=Imax_pop, sd=omega_Imax}

[COVARIATE]
input={w_pop, omega_w}

DEFINITION:
w={distribution=normal, mean=w_pop, sd=omega_w}
")
p <- c(w_pop=70,     omega_w=10, 
       ka_pop=0.5,   omega_ka=0.2, 
       V_pop=10,     omega_V=0.1,    beta_V= 1,
       k_pop=0.1,    omega_k=0.15,   beta_k=-0.25,
       Imax_pop=0.8, omega_Imax=0.4,
       S0_pop=100,   omega_S0=0, 
       IC50_pop=1,   omega_IC50=0.2,
       kout_pop=0.1, omega_kout=0.1)
N <- 1000
adm1 <- list(ii=24, amount=100)
adm2 <- list(ii=12, amount=50)
out <- list(name=c("Cc","PCA"), time='steady.state')

g1 <- list(treatment=adm1, size=N, level='covariate')
g2 <- list(treatment=adm2, size=N, level='covariate')

res <- exposure(model     = myModel, 
                 parameter = p, 
                 output    = out,
                 group     = list(g1,g2))
b11 <- ggplot(data=res$Cc)+geom_boxplot(aes(x=group,y=auc))
b12 <- ggplot(data=res$Cc)+geom_boxplot(aes(x=group,y=cmax))
grid.arrange(b11,b12,nrow=1)
b21 <- ggplot(data=res$PCA)+geom_boxplot(aes(x=group,y=cmin))
b22 <- ggplot(data=res$PCA)+geom_boxplot(aes(x=group,y=cmax))
grid.arrange(b21,b22,nrow=1)
pl1 <- prctilemlx(res$output$Cc, labels=c("group 1", "group 2"))  +  theme(legend.position="none") 
pl2 <- prctilemlx(res$output$PCA, labels=c("group 1", "group 2"))  +  theme(legend.position="none") 
grid.arrange(pl1,pl2)
## adm1 <- list(time=seq(0, 240, by=24), amount=100)
## adm2 <- list(time=seq(0, 252, by=12), amount=50)
## out <- list(name=c("Cc","PCA"), time=seq(240,264,length=100))
