#library(mlxR)
theme_set(theme_bw())

mymodel <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl} 
EQUATION:
Cc = pkmodel(ka, V, Cl)

[INDIVIDUAL]
input = {ka_pop, omega_ka, V_pop, omega_V, Cl_pop, omega_Cl, gamma_Cl}
DEFINITION:
ka = {distribution=lognormal, reference=ka_pop, sd=omega_ka}
V  = {distribution=lognormal, reference=V_pop,  sd=omega_V}
Cl = {distribution=lognormal, reference=Cl_pop, varlevel={id, id*occ}, sd={omega_Cl,gamma_Cl}}
")
occ <- list(name="occ", time=c(0,12,24))
param <- c(ka_pop=1, omega_ka=0.05, V_pop=10, omega_V=0.05, Cl_pop=5, omega_Cl=0.3, gamma_Cl=0.2)
trt <- list(time=c(0,12,24), amount=100)

out.cc <- list(name= 'Cc', time=seq(0,36,by=0.1))
out.param <- list(name=c( 'ka', 'V', 'Cl'))
res <-simulx(model     = mymodel,
             parameter = param,
             treatment = trt,
             varlevel  = occ,
             output    = list(out.cc, out.param),
             group     = list(size=3, level='individual'),
             settings  = list(seed=123123))

print(names(res))
print(res$occasion)
print(res$parameter.iiv)
print(res$parameter.iov)
print(ggplot(res$Cc) +geom_line(aes(x=time,y=Cc,color=id)))
occ <- inlineDataFrame("
id time occ
1   0    1
1   12   2
1   24   3
2   0    1
2   24   2
3   0    1
")

res <-simulx(model     = mymodel,
             parameter = param,
             treatment = trt,
             varlevel  = occ,
             output    = list(out.cc, out.param),
             settings  = list(seed=123))

print(res$parameter.iov)

print(ggplot(res$Cc) +geom_line(aes(x=time,y=Cc,color=id)))
mymodel <- inlineModel("
[LONGITUDINAL]
input = {F, ka, V, Cl} 

EQUATION:
Cc = pkmodel(p=F, ka, V, Cl)


[INDIVIDUAL]
input = {wt, age, wt_pop, age_pop}
input = {F_pop, omega_F, gamma_F, beta_F_age, ka_pop, omega_ka, beta_ka_wt,
         V_pop, omega_V, Cl_pop, omega_Cl, gamma_Cl, beta_Cl_wt, beta_Cl_age}

EQUATION:
lwt = log(wt/wt_pop)
lage = log(age/age_pop)

DEFINITION:
F  = {distribution=logitnormal, reference=F_pop, covariate=lage, coefficient=beta_F_age, 
      varlevel={id, id*occ}, sd={omega_F,gamma_F}}
ka = {distribution=lognormal, reference=ka_pop, covariate=lwt, coefficient=beta_ka_wt, sd=omega_ka}
V  = {distribution=lognormal, reference=V_pop,  sd=omega_V}
Cl = {distribution=lognormal, reference=Cl_pop, 
      covariate={lwt, lage}, coefficient={beta_Cl_wt,beta_Cl_age}, 
      varlevel={id, id*occ}, sd={omega_Cl,gamma_Cl}}


[COVARIATE]
input = {wt_pop, omega_wt, gamma_wt, age_pop, omega_age}

DEFINITION:
wt  = {distribution=normal, reference=wt_pop, varlevel={id, id*occ}, sd={omega_wt,gamma_wt}}
age = {distribution=normal, reference=age_pop, sd=omega_age}
")
occ <- list(name="occ", time=c(0,12,24))
param <- c(F_pop=0.8, omega_F=0.5, gamma_F=0.4, ka_pop=1, omega_ka=0.2, 
           V_pop=10, omega_V=0.2, Cl_pop=5, omega_Cl=0.2, gamma_Cl=0.2,
           wt_pop=70, omega_wt=10, gamma_wt=0.1, age_pop=45, omega_age=5,
           beta_F_age=0.5, beta_Cl_wt=1, beta_ka_wt=1, beta_Cl_age=0.4)

trt <- list(time=c(0,12,24), amount=100)

out.cc <- list(name= 'Cc', time=seq(0,36,by=0.1))
out.param <- list(name=c( 'ka', 'V', 'Cl'))
out.cov <- list(name=c('wt', 'age'))

res <-simulx(model     = mymodel,
             parameter = param,
             treatment = trt,
             varlevel  = occ,
             output    = list(out.cc, out.param, out.cov),
             group     = list(size=3, level='covariate'),
             settings  = list(seed=12345))

print(names(res))
print(res$parameter.iiv)
print(res$parameter.iov)

print(ggplot(res$Cc) +geom_line(aes(x=time,y=Cc,color=id)))
mymodel <- inlineModel("
[LONGITUDINAL]
input = {F, ka, V, Cl} 

EQUATION:
Cc = pkmodel(p=F, ka, V, Cl)


[INDIVIDUAL]
input = {wt, age, wt_pop, age_pop}
input = {F_pop, omega_F, gamma_F, beta_F_age, ka_pop, omega_ka, beta_ka_wt,
         V_pop, omega_V, Cl_pop, omega_Cl, gamma_Cl, beta_Cl_wt, beta_Cl_age}

EQUATION:
lwt = log(wt/wt_pop)
lage = log(age/age_pop)

DEFINITION:
F  = {distribution=logitnormal, reference=F_pop, covariate=lage, coefficient=beta_F_age, 
      varlevel={id, id*occ}, sd={omega_F,gamma_F}}
ka = {distribution=lognormal, reference=ka_pop, covariate=lwt, coefficient=beta_ka_wt, sd=omega_ka}
V  = {distribution=lognormal, reference=V_pop,  sd=omega_V}
Cl = {distribution=lognormal, reference=Cl_pop, 
      covariate={lwt, lage}, coefficient={beta_Cl_wt,beta_Cl_age}, 
      varlevel={id, id*occ}, sd={omega_Cl,gamma_Cl}}
")
covariate <- inlineDataFrame("
id time  wt  age  
1   0    60   50  
1   12   65   50  
1   24   70   50 
2   0    75   60  
2   18   75   60  
3   0    80   55  
3   24   90   55  
")
occ <- inlineDataFrame("
id time occ
1   0    1
1   12   2
1   24   3
2   0    1
2   18   2
3   0    1
3   24   3
")
res <-simulx(model     = mymodel,
             parameter = list(param,covariate),
             treatment = trt,
             varlevel  = occ,
             output    = list(out.cc, out.param, out.cov),
             settings  = list(seed=12345))

print(res$parameter.iiv)
print(res$parameter.iov)
