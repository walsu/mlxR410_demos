#library(mlxR)
theme_set(theme_bw())

stepModel1 <- inlineModel("
[LONGITUDINAL] 
input = {tg}

PK:
depot(target=f)
depot(target=f, Tlag=tg, p=-1)

EQUATION:
ddt_f=0 
")


res <- simulx(model=stepModel1, 
              output=list(name='f', time=seq(0, 100, by=0.1)), 
              treatment=list(amount=10, time=seq(12,78,by=12)), 
              parameter=c(tg=6))

ggplot(res$f) + geom_line(aes(time,f))
stepModel2 <- inlineModel("
[LONGITUDINAL] 
input = {tg,A}

PK:
depot(target=f, p=-A/amtDose)
depot(target=f, Tlag=tg, p=A/amtDose)

EQUATION:
f_0 = A
ddt_f=0 
")


res <- simulx(model=stepModel2, 
              output=list(name='f', time=seq(0, 100, by=0.1)), 
              treatment=list(amount=1, time=seq(12,78,by=12)), 
              parameter=c(tg=6, A=10))

ggplot(res$f) + geom_line(aes(time,f))
stepModel3 <- inlineModel("
[LONGITUDINAL] 

PK:
depot(target=f, p=1,  type=1)
depot(target=f, p=-1, type=2)

EQUATION:
ddt_f=0 
")

adm1 <- list(amount=c(1, 2, 1, 0.5), time=c(10, 20, 40, 55), type=1)
adm2 <- list(amount=c(1, 2, 1, 0.5), time=c(15, 30, 43, 75), type=2)
res <- simulx(model=stepModel3, 
              output=list(name='f', time=seq(0, 100, by=0.1)), 
              treatment=list(adm1, adm2))

ggplot(res$f) + geom_line(aes(time,f))
adm1 <- list(amount=c(1, 2, 1, 0.5), time=c(10, 20, 40, 55), rate=0.5, type=1)
adm2 <- list(amount=c(1, 2, 1, 0.5), time=c(15, 30, 43, 75), rate=0.25, type=2)
res <- simulx(model=stepModel3, 
              output=list(name='f', time=seq(0, 100, by=0.1)), 
              treatment=list(adm1, adm2))

ggplot(res$f) + geom_line(aes(time,f))
