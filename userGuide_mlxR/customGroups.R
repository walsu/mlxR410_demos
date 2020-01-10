#library(mlxR)
theme_set(theme_bw())

jointModel <- inlineModel("
[LONGITUDINAL] 
input={Tk0, V, Cl, alpha, beta, a}

EQUATION:
C = pkmodel(Tk0, V, Cl)
h = exp(-alpha - beta*C)
H_0 = 0
ddt_H = h
S = exp(-H)
                          
DEFINITION:
y = {distribution=lognormal, prediction=C, sd=a}
e = {type=event, maxEventNumber=1, rightCensoringTime=200, hazard=h}
                          
[INDIVIDUAL]
input={Tk0_pop,V_pop,Cl_pop,alpha_pop,omega_Tk0,omega_V,omega_Cl,omega_alpha,a}

DEFINITION:
Tk0   = {distribution=lognormal,   prediction=Tk0_pop,  sd=omega_Tk0}
V     = {distribution=lognormal,   prediction=V_pop,    sd=omega_V}
Cl    = {distribution=lognormal,   prediction=Cl_pop,   sd=omega_Cl}
alpha = {distribution=lognormal,   prediction=alpha_pop,sd=omega_alpha}
")

#-----------------------------------------------
N=100
t.time <- seq(24,120,by=24)
g1 <- list(size=N, level='individual', treatment=list(time=t.time, amount=0))
g2 <- list(size=N, level='individual', treatment=list(time=t.time, amount=25))
g3 <- list(size=N, level='individual', treatment=list(time=t.time, amount=50))

pop.param   <- c(
  Tk0_pop   = 3,    omega_Tk0   = 0.3,
  V_pop     = 10,   omega_V     = 0.3,
  Cl_pop    = 1,    omega_Cl    = 0.3,
  alpha_pop = 6,    omega_alpha = 0.01,
  beta      = 0.4,  a           = 0.1
)

f <- list(name=c('C','S'), time=seq(0,to=180,by=3))
e <- list(name="e", time=0)

res1 <- simulx(model     = jointModel,
               parameter = pop.param,
               group     = list(g1, g2, g3),
               output    = list(f,e))
print(prctilemlx(res1$S))
print(prctilemlx(res1$S, facet=FALSE))
plot.prediction.intervals <- function(r, plot.median=TRUE, level=90, labels=NULL, 
                                      legend.title=NULL, colors=NULL) {
  P <- prctilemlx(r, number=1, level=level, plot=FALSE)
  if (is.null(labels))  labels <- levels(r$group)
  if (is.null(legend.title))  legend.title <- "group"
  names(P$y)[2:4] <- c("p.min","p50","p.max")
  pp <- ggplot(data=P$y)+ylab(NULL)+ 
    geom_ribbon(aes(x=time,ymin=p.min, ymax=p.max,fill=group),alpha=.5) 
  if (plot.median)
    pp <- pp + geom_line(aes(x=time,y=p50,colour=group))
  
  if (is.null(colors)) {
    pp <- pp + scale_fill_discrete(name=legend.title,
                                   breaks=levels(r$group),
                                   labels=labels)
    pp <- pp + scale_colour_discrete(name=legend.title,
                                     breaks=levels(r$group),
                                     labels=labels, 
                                     guide=FALSE)
  } else {
    pp <- pp + scale_fill_manual(name=legend.title,
                                 breaks=levels(r$group),
                                 labels=labels,
                                 values=colors)
    pp <- pp + scale_colour_manual(name=legend.title,
                                   breaks=levels(r$group),
                                   labels=labels,
                                   guide=FALSE,values=colors)
  }  
  return(pp)
}
plot.S1 <- plot.prediction.intervals(res1$S, 
                                    labels       = c("placebo","25 mg","50mg"), 
                                    legend.title = "arm")
plot.S1 <- plot.S1  + ylab("Survival prediction interval") + theme(legend.position=c(0.9,0.8))
print(plot.S1)
plot.S2 <- plot.prediction.intervals(res1$S, 
                                     labels       = c("placebo","25 mg","50mg"), 
                                     legend.title = "arm",
                                     plot.median  = FALSE)
plot.S2 <- plot.S2  + ylab("Survival prediction interval") + theme(legend.position=c(0.9,0.8))
print(plot.S2)
plot.S3 <- plot.prediction.intervals(res1$S, 
                                     labels       = c("placebo","25 mg","50mg"), 
                                     legend.title = "arm",
                                     colors       = c('#01b7a5', '#c17b01', '#a00159'))
plot.S3 <- plot.S3  + ylab("Survival prediction interval") + theme(legend.position=c(0.9,0.8))
print(plot.S3)
