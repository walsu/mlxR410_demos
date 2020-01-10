#library(mlxR)
## library(gridExtra)
library(gridExtra)
theme_set(theme_bw())

## 
## p <- c(
## kel  = 0.024, # Elimination of ligand (1/day)
## kep  = 0.201, # Elimination of complex (1/day)
## kout = 0.823, # Elimination of receptor (1/day)
## koff = 0.9,   # Dissociation rate (1/day)
## kon  = 0.592, # Binding rate (1/(nMday))
## R0   = 2.688,  # inital concentration of receptor  in central compartment (nM)
## Vc   = 0.04  # volume of central compartment (L/kg)
## )
## 
## # Dosing Regimen
## Dosemg <- c(0.05, 2)
## adm1   <- list(amount=Dosemg[1], time=0)
## adm2   <- list(amount=Dosemg[2], time=0)
## g1     <- list(treatment = adm1)
## g2     <- list(treatment = adm2)
## 
## # Observations
## tobs <- seq(0,100,by=1)
## out  <- list(name = c('L', 'R', 'P'), time = tobs)
## 
## # Run Simulx
## res <- simulx(model    = "model/tmdd1.txt",
##                parameter= p,
##                output   = out,
##                group    = list(g1, g2))
## 
## # Plot results
## pl1 <- ggplot(data=res$L) + geom_line(aes(x=time, y=L, colour=group), size=0.5) +
##   theme(legend.position="none") + scale_y_log10()
## pl2 <- ggplot(data=res$R) + geom_line(aes(x=time, y=R, colour=group), size=0.5) +
##   scale_colour_discrete(name="Dose\n(mg/kg)", breaks=c("1","2"),labels=Dosemg) +
##    theme(legend.title=element_text(size=10), legend.position=c(0.8,0.2))  + scale_y_log10()
## pl3 <- ggplot(data=res$P) + geom_line(aes(x=time, y=P, colour=group), size=0.5) +
##    theme(legend.position="none") + scale_y_log10()
## 
## grid.arrange(pl1,pl2,pl3, nrow=1)

p <- c(
kel  = 0.024, # Elimination of ligand (1/day)
kep  = 0.201, # Elimination of complex (1/day)
kout = 0.823, # Elimination of receptor (1/day)
koff = 0.9,   # Dissociation rate (1/day)
kon  = 0.592, # Binding rate (1/(nMday))
R0   = 2.688,  # inital concentration of receptor  in central compartment (nM)
Vc   = 0.04  # volume of central compartment (L/kg)
)

# Dosing Regimen
Dosemg <- c(0.05, 2)
adm1   <- list(amount=Dosemg[1], time=0)
adm2   <- list(amount=Dosemg[2], time=0)
g1     <- list(treatment = adm1)
g2     <- list(treatment = adm2)

# Observations
tobs <- seq(0,100,by=1)
out  <- list(name = c('L', 'R', 'P'), time = tobs)

# Run Simulx
res <- simulx(model    = "model/tmdd1.txt",
               parameter= p,
               output   = out,
               group    = list(g1, g2))

# Plot results
pl1 <- ggplot(data=res$L) + geom_line(aes(x=time, y=L, colour=group), size=0.5) + 
  theme(legend.position="none") + scale_y_log10() 
pl2 <- ggplot(data=res$R) + geom_line(aes(x=time, y=R, colour=group), size=0.5) + 
  scale_colour_discrete(name="Dose\n(mg/kg)", breaks=c("1","2"),labels=Dosemg) +
   theme(legend.title=element_text(size=10), legend.position=c(0.8,0.2))  + scale_y_log10() 
pl3 <- ggplot(data=res$P) + geom_line(aes(x=time, y=P, colour=group), size=0.5) + 
   theme(legend.position="none") + scale_y_log10() 
grid.arrange(pl1,pl2,pl3, nrow=1)

## adm <- list(
##   tfd    = list(widget="slider", value=0,  min=0,  max=24, step=2),
##   nd     = list(widget="slider", value=1,  min=1,  max=10, step=1),
##   ii     = list(widget="slider", value=12, min=4,  max=24, step=2),
##   amount = list(widget="slider", value=1,  min=.1, max=2,  step=.1)
## )
## 
## out1 <- list(name = 'L', time = tobs)
## out2 <- list(name = 'R', time = tobs)
## out3 <- list(name = 'P', time = tobs)
## 
## shiny.app <- shinymlx(model     = "model/tmdd1.txt",
##                       parameter = list(p[1:4],p[5:7]),
##                       output    = list(out1, out2, out3),
##                       treatment = adm,
##                        style     = "navbar2",
##                        title     = "TMDD - Model 1")
## 
## shiny::runApp(shiny.app)
