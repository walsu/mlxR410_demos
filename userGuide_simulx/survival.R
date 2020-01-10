#library(mlxR)
theme_set(theme_bw())

p <- c(beta = 1.5, lambda=20)
h <- list(name='h', time=seq(0, 60, by=0.2))
e <- list(name='e', time=0)

res <- simulx(model     = 'model/survival1.txt', 
              settings  = list(seed=123),
              parameter = p, 
              output    = list(h, e))
print(res$e)
hazard  <- res$h
plot(x=hazard$time, y=hazard$h, type='l', xlab="time", ylab="hazard")
N <- 100
res <- simulx(model     = 'model/survival1.txt', 
              settings  = list(seed=1234),
              parameter = p, 
              output    = list(h, e), 
              group     = list(size = N))
print(res$e[1:10,])
pl1  <- kmplotmlx(res$e, level=0.9)
print(pl1)
res <- simulx(model     = 'model/survival2.txt', 
              settings  = list(seed=123),
              parameter = p, 
              output    = list(e)) 
print(res$e)
res <- simulx(model     = 'model/survival2.txt', 
              settings  = list(seed=123),
              parameter = p, 
              output    = list(e), 
              group     = list(size=N))


pl2  <- kmplotmlx(res$e, level=0.9)
print(pl2)
tteModel1 <- inlineModel("
[LONGITUDINAL]
input = {beta, lambda, rct}  
  
EQUATION:
h=(beta/lambda)*(t/lambda)^(beta-1)

DEFINITION:
e = {type=event, maxEventNumber=1, rightCensoringTime=rct, hazard=h}
")

N <- 100
p1   <- c(beta=2.5,lambda=50)
rct  <- data.frame(id=1:N, rct=c(rep(50,N/4),rep(60,N/4),rep(70,N/2))) 
e    <- list(name='e', time=0)
res1a <- simulx(model     = tteModel1, 
                parameter = list(p1, rct),
                output    = e,
                settings  = list(seed=12345))
print(res1a$e[c(1:4,69:72,173:176),])
kmplotmlx(res1a$e)
g1   <- list(size=50,  parameter=c(beta=2.5,lambda=50, rct=60))
g2   <- list(size=100, parameter=c(beta=1,lambda=40, rct=70))
res1b <- simulx(model    = tteModel1, 
                output   = e, 
                group    = list(g1,g2),
                settings = list(seed=12345))
kmplotmlx(res1b$e)
tteModel1b <- inlineModel("
[LONGITUDINAL]
input = {beta, lambda, men}  
  
EQUATION:
h=(beta/lambda)*(t/lambda)^(beta-1)

DEFINITION:
e = {type=event, maxEventNumber=men, rightCensoringTime=100, hazard=h}
")

N <- 3
p1   <- c(beta=2.5,lambda=50)
men  <- data.frame(id=1:3, men=c(1,2,3)) # individual maximum number of events
e    <- list(name='e', time=0)
res1a <- simulx(model     = tteModel1b, 
                parameter = list(p1, men),
                output    = e,
                settings  = list(seed=12345))
print(res1a$e)
