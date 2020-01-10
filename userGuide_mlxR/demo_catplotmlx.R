#library(mlxR)
theme_set(theme_bw())

## catplotmlx(r, breaks = NULL)
catModel <- inlineModel("
[LONGITUDINAL]
input =  {a,b}
EQUATION:
lp1=a-b*t
lp2=a-b*t/2

p1 = 1/(1+exp(-lp1))
p2 = 1/(1+exp(-lp2)) - p1
DEFINITION:
y = {type=categorical, categories={1, 2, 3}, 
     P(y=1)=p1, P(y=2)=p2}
")

out  <- list(name='y', time=seq(0, 100, by=4))

Ng  <- 1000
g1 <- list(size=Ng, parameter=c(a=6,b=0.2))
res <- simulx(model=catModel, output=out, group=g1)
plot1 <- catplotmlx(res$y)
print(plot1)
plot2 <- catplotmlx(res$y, breaks=seq(-2,102,by=8), color="purple") 
print(plot2)
plot3 <- catplotmlx(res$y,breaks=5, color="#490917") 
print(plot3)
cat.out <- catplotmlx(res$y, color="#490917", breaks=5, plot=FALSE)
print(cat.out)
g2 <- list(size=Ng, parameter=c(a=10,b=0.2))
res <- simulx(model=catModel, output=out, group=list(g1,g2))
plot4 <- catplotmlx(res$y) 
print(plot4)
g3 <- list(size=Ng, parameter=c(a=6,b=0.4))
g4 <- list(size=Ng, parameter=c(a=10,b=0.4))
res <- simulx(model=catModel, output=out, group=list(g1,g2,g3,g4))
group.labels <- c("a=6,  b=0.2", "a=10,  b=0.2", "a=6,  b=0.4", "a=10,  b=0.4")
plot5 <- catplotmlx(res$y, labels=group.labels) 
print(plot5)
plot6 <- catplotmlx(res$y, group="none") 
print(plot6)
cov <- data.frame(id=levels(res$y$id), a=rep(c(6,10,6,10), each=Ng), b=rep(c(0.2,0.2,0.4,0.4), each=Ng) )
plot7 <- catplotmlx(res$y, group=cov) 
print(plot7)
