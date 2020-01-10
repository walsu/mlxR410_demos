#library(mlxR)
library(gridExtra)
theme_set(theme_bw())

adm.time <- seq(0,200,by=12)
trt1 <- list(time=adm.time, amount=  0)
trt2 <- list(time=adm.time, amount= 25)
trt3 <- list(time=adm.time, amount= 50)
trt4 <- list(time=adm.time, amount=100)
g1   <- list(treatment = trt1)
g2   <- list(treatment = trt2)
g3   <- list(treatment = trt3)
g4   <- list(treatment = trt4)
ppk  <- c(Tk0   = 3,   V    = 10,  Cl   = 1)
ppd  <- c(Imax  = 0.8, E0   = 100, IC50 = 4, kout = 0.1) 
ptte <- c(alpha = 0.5, beta = 0.02)
f <- list(name = c('Cc','E','S'), 
          time = seq(0,200,by=1))
res <- simulx(model     = "model/cts2I.txt",
              group     = list(g1,g2,g3,g4),
              parameter = list(ppk, ppd, ptte),
              output    = f)
names(res)

plot1 <- ggplot(data=res$Cc, aes(x=time, y=Cc, colour=id)) + 
         geom_line(size=1) + xlab("time (h)") + ylab("Cc")
plot2 <- ggplot(data=res$E,  aes(x=time, y=E,  colour=id)) +  
         geom_line(size=1) + xlab("time (h)") + ylab("E") 
plot3 <- ggplot(data=res$S,  aes(x=time, y=S,  colour=id)) +  
         geom_line(size=1) + xlab("time (h)") + ylab("S") 
grid.arrange(plot1, plot2, plot3, ncol=1)
