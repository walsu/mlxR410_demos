

## ------------------------------------------------------------------------
add1 <- list(formula=c("ddt_auc = Cc"))

adm <- list(time=seq(0,66,by=12), amount=100)
out1 <- list(name= c("Cc","auc"), time=seq(0,100, by=0.5))
p <- c(V_pop=10, omega_V=0.3, w=50, k=0.2, a=0.2)

res2 <- simulx(model     = "model/newoutput.txt", 
               addlines  = add1,
               output    = out1,
               parameter = p,
               treatment = adm)


## ------------------------------------------------------------------------
names(res2)
head(merge(res2$Cc,res2$auc))


## ------------------------------------------------------------------------
add2  = list(section="[INDIVIDUAL]", block="DEFINITION:", 
                 formula=c("Vn = {distribution=normal, prediction=Vpred, sd=1}"))

out3 <- list(name= c("Vn", "V"))
res3 <- simulx(model     = "model/newoutput.txt", 
               addlines  = list(add1, add2),
               output    = list(out1, out3),
               parameter = p,
               treatment = adm,
               group = list(size=5, level="individual"))
names(res3)
res3$parameter


## ------------------------------------------------------------------------
adm1 <- list(time=seq(0,66,by=6),  amount=50)
adm2 <- list(time=seq(0,66,by=12), amount=100)
p1 <- c(V_pop=10, omega_V=0.3, w=50, k=0.2, a=0.2)
p2 <- c(V_pop=20, omega_V=0.3, w=75, k=0.1, a=0.2)

y1 <- list(name="y", time=c(10,30,60))
y2 <- list(name="y", time=c(20, 50))
outc1  <- list(name = c('Cc','lc'), time=seq(0,100, by=0.5))
outc2  <- list(name = c('Cc','auc'), time=seq(0,100, by=0.5))
V <- list(name="V")

add3 <- list( formula = c("lc = log(Cc)", "ddt_auc=Cc") )

g1 <- list(treatment=adm1, parameter=p1, output=list(y1,outc1), size=3, level='individual')
g2 <- list(treatment=adm2, parameter=p2, output=list(y2,outc2), size=2, level='individual')

res4 <- simulx(model    = "model/newoutput.txt", 
               addlines  = add3,
               output   = V,
               group    = list(g1,g2))

names(res4)


## ------------------------------------------------------------------------
res5  <- simulx(project  = 'monolixRuns/theophylline_project.mlxtran', 
                output   = list(name = c('Cc','auc'), time = seq(0, 30, by=0.1)), 
                addlines = list(formula="ddt_auc = Cc"))

names(res5)
head(merge(res5$Cc,res5$auc))


## ---- message=FALSE, warning=FALSE---------------------------------------
library(gridExtra)

pl1 <- ggplot() +  geom_line(data=res5$Cc, aes(x=time, y=Cc, colour=id)) +
        xlab("time") + ylab("concentration") + theme(legend.position="none")

pl2 <- ggplot() +  geom_line(data=res5$auc, aes(x=time, y=auc, colour=id)) +
        xlab("time") + ylab("area under the curve") + theme(legend.position="none")

grid.arrange(pl1, pl2, ncol=2)

