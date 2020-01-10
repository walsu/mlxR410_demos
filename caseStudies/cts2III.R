#library(mlxR)
library(reshape2)
theme_set(theme_bw())

M  <- 1000
vN <- c(25, 50, 100)
adm.amount <- c(0, 25, 50, 100)
adm.time   <- seq(0, 200, by=12)
e <- list(name='e', time=0, surv.time=c(100,200))
pop.param   <- c(
  Tk0_pop   = 3,    omega_Tk0   = 0.2,
  V_pop     = 10,   omega_V     = 0.2,
  Cl_pop    = 1,    omega_Cl    = 0.2,
  Imax_pop  = 0.8,  omega_Imax  = 0.5,
  E0_pop    = 100,  omega_E0    = 0.1,
  IC50_pop  = 4,    omega_IC50  = 0.1,
  kout_pop  = 0.1,  omega_kout  = 0.1,
  alpha_pop = 0.5,  omega_alpha = 0.1,
  beta_pop  = 0.02, omega_beta  = 0,
  b         = 0.1
)
labels.arm <- c("placebo", "25 mg", "50 mg", "100mg")
labels.N   <- c("N = 25", "N = 50", "N = 100")

R <- NULL
ptm <- proc.time()
for (k in seq(1,length(adm.amount))){
  adm <- list(time=adm.time, amount=adm.amount[k])
  for (l in seq(1,length(vN))){
  g <- list(size=vN[l], level='individual'); 
    res <- simulx(model     = "model/cts2III.txt",
                  parameter = pop.param,
                  treatment = adm,
                  output    = e, 
                  group     = g,
                  nrep      = M,
                  settings  = list(out.trt = F))
    res$e$nbEv.mean <- NULL
    R <- rbind(R, cbind(res$e, N=labels.N[l], arm=labels.arm[k]))
  }
} 
computational.time <- proc.time() - ptm
rm <- melt(R,  id = c('N','arm','rep'), value.name="Survival", variable.name="time")
rm$time <- factor(rm$time, labels = c("T = 100", "T = 200"))

print(ggplot(rm, aes(arm,Survival)) + geom_boxplot(aes(fill = arm)) + 
        facet_grid(time ~N) + theme(legend.position="none"))
S <- 0.1

R.p <- R[R$arm=="placebo","S200.mean"]
R.t <- R[R$arm!="placebo",]
R.t$dS <- (R.t$S200.mean-rep(R.p,3) > S)
R.t$S200.mean <- NULL
print(acast(R.t,arm~N,mean, value.var="dS"))
print(computational.time)
