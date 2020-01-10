#library(mlxR)
theme_set(theme_bw())

N=400
adm.time <- seq(0,200,by=12)
trt1 <- list(time=adm.time, amount=  0)
trt2 <- list(time=adm.time, amount= 25)
trt3 <- list(time=adm.time, amount= 50)
trt4 <- list(time=adm.time, amount=100)
g1   <- list(treatment = trt1, size=N, level='individual')
g2   <- list(treatment = trt2, size=N, level='individual')
g3   <- list(treatment = trt3, size=N, level='individual')
g4   <- list(treatment = trt4, size=N, level='individual')
pop.param   <- c(
  Tk0_pop   = 3,    omega_Tk0   = 0.2,
  V_pop     = 10,   omega_V     = 0.2,
  Cl_pop    = 1,    omega_Cl    = 0.2,
  Imax_pop  = 0.8,  omega_Imax  = 0.5,
  E0_pop    = 100,  omega_E0    = 0.1,
  IC50_pop  = 4,    omega_IC50  = 0.1,
  kout_pop  = 0.1,  omega_kout  = 0.1,
  alpha_pop = 0.5,  omega_alpha = 0.2,
  beta_pop  = 0.02, omega_beta  = 0
)
f <- list(name = c('C','E','S'), 
          time = seq(0,200,by=2))
res <- simulx(model     = "model/cts2II.txt",
              parameter = pop.param,
              group     = list(g1,g2,g3,g4),
              output    = f)
labels <- c("0 mg", "25 mg", "50 mg", "100 mg")
prctilemlx(res$C, number=2, level=90, labels=labels) + theme(legend.position = "none")
prctilemlx(res$E, number=2, level=90, labels=labels) + theme(legend.position = "none")
prctilemlx(res$S, number=2, level=90, labels=labels) + theme(legend.position = "none")
