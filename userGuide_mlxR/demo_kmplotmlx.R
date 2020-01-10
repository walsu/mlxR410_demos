#library(mlxR)
library(gridExtra)
theme_set(theme_bw())

## kmplotmlx(r, index = 1, level = NULL)
tteModelA <- inlineModel("
[LONGITUDINAL]
input = {beta,lambda}  
EQUATION:
h=(beta/lambda)*(t/lambda)^(beta-1)
DEFINITION:
e = {type=event, maxEventNumber=1, hazard=h}
")

p1   <- c(beta=2.5,lambda=50)
e    <- list(name='e', time=0)
resA1 <- simulx(model     = tteModelA, 
               parameter = p1, 
               output    = e, 
               group     = list(size=100))
plA1a  <- kmplotmlx(resA1$e)
print(plA1a)
plA1b  <- kmplotmlx(resA1$e, level=0.90)
print(plA1b)
plA1c  <- kmplotmlx(resA1$e, time=0:80)
print(plA1c)
kmplotmlx(resA1$e, level=0.90, time=0:80)
p2   <- c(beta=3,lambda=40)
g1   <- list(size=50,  parameter=p1)
g2   <- list(size=100, parameter=p2)
resA2 <- simulx(model    = tteModelA, 
               output   = e, 
               group    = list(g1,g2),
               settings = list(seed=1234))
group.labels <- c("beta=2.5,  lambda=50", "beta=3,  lambda=40")
plA2a  <- kmplotmlx(resA2$e, level=0.80, labels=group.labels)
print(plA2a)
plA2b  <- kmplotmlx(resA2$e, level=0.80, facet=FALSE, labels=group.labels) + theme(legend.title=element_blank())
print(plA2b)
cov <- data.frame(id=(1:150), cov1=c(rep(1,50),rep(2,100)), cov2=rep(c("A","B"),75))
plA2c  <- kmplotmlx(resA2$e, group=cov)
print(plA2c)
plA2d  <- kmplotmlx(resA2$e, group=cov, facet=FALSE)
print(plA2d)
resA3 <- simulx(model    = tteModelA, 
               output   = e, 
               group    = list(g1,g2),
               nrep     = 5,
               settings = list(seed=1234))
plA3a <- kmplotmlx(resA3$e, labels=group.labels)
plot(plA3a)
plA3b <- kmplotmlx(resA3$e, facet=FALSE, labels=group.labels) + theme(legend.title=element_blank())
plot(plA3b)
res1d <- simulx(model     = tteModelA, 
                parameter = p1,
                nrep      = 200,
                group     = list(size=40),
                output    = e)
k1d  <- kmplotmlx(res1d$e, time=0:80, plot=F) 
head(k1d$surv)
prctilemlx(k1d$surv, level=90, number=2 ) 
tteModelB <- inlineModel("
[LONGITUDINAL]
input = {beta,lambda}  
EQUATION:
h=(beta/lambda)*(t/lambda)^(beta-1)
DEFINITION:
e = {type=event, rightCensoringTime=100, hazard=h}
")

resB1 <- simulx(model    = tteModelB, 
               parameter = p1, 
               output    = e, 
               group     = list(size=100))
plB1a <- kmplotmlx(resB1$e, index=3)
print(plB1a)
plB1b <- kmplotmlx(resB1$e, index="numberEvent")
print(plB1b)
tteModelC <- inlineModel("
[LONGITUDINAL]
input = {beta,lambda}  

EQUATION:
  h = (beta/lambda)*(t/lambda)^(beta-1)

DEFINITION:
  e = {type=event, eventType=intervalCensored, 
       intervalLength=10, rightCensoringTime=100,  
       hazard=h}
")

p <- c(beta=1.5,lambda=50)
e <- list(name='e', time=0)
g <- list(size=100)
resC <- simulx(model     = tteModelC, 
               parameter = p, 
               output    = e,
               group     = g)
plC1 <- kmplotmlx(resC$e,level=0.90)
plC2 <- kmplotmlx(resC$e,index="numberEvent")
grid.arrange(plC1, plC2, nrow=1)
