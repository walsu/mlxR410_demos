#library(mlxR)
theme_set(theme_bw())

## myModel <- inlineModel("
## [LONGITUDINAL]
## ...
## ")
## res <- simulx( model=myModel, ... )
myModel1 <- inlineModel("
[LONGITUDINAL]
input = {ka, V, k, a}

EQUATION:
D = 100
f = D*ka/(V*(ka-k))*(exp(-k*t) - exp(-ka*t))

DEFINITION:
y = {distribution=normal, prediction=f, sd=a}
")

print(myModel1)
f <- list(name='f', time=seq(0, 30, by=0.1))
y <- list(name='y', time=seq(0, 30, by=2))

res <- simulx(model     = myModel1, 
              parameter = c(ka=0.5, V=10, k=0.2, a=0.3), 
              output    = list(f, y))

plot(ggplot(data=res$f, aes(x=time, y=f)) + geom_line(size=0.5) +
  geom_point(data=res$y, aes(x=time, y=y), colour="red")) 
myModel2 <- inlineModel("
[LONGITUDINAL]
input = {ka, V, k, a}

EQUATION:
f = 100*ka/(V*(ka-k))*(exp(-k*t) - exp(-ka*t))

DEFINITION:
y = {distribution=normal, prediction=f, sd=a}
", filename="random")

print(myModel2)

res <- simulx(model     = myModel2, 
              parameter = c(ka=0.5, V=10, k=0.2, a=0.3), 
              output    = list(f, y))
model.str <- "
[LONGITUDINAL]
input = {ka, V, k, a}

EQUATION:
f = 100*ka/(V*(ka-k))*(exp(-k*t) - exp(-ka*t))

DEFINITION:
y = {distribution=normal, prediction=f, sd=a}
"

write(model.str,"pk_model.txt")


res <- simulx(model     = "pk_model.txt", 
              parameter = c(ka=0.5, V=10, k=0.2, a=0.3), 
              output    = list(f, y))
