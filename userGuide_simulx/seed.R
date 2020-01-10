#library(mlxR)
theme_set(theme_bw())

## s <- list(seed=123456)}
## res <- simulx( ... , settings=list(seed=s, ...))
myModel = inlineModel("
[LONGITUDINAL]
input =  {a, b, s}
EQUATION:
f = a + b*t
DEFINITION:
y = {distribution=normal, prediction=f, sd=s}
")

res <- simulx(model     = myModel,
              parameter = c(a=10, b=10, s=0.5),
              settings  = list(seed=12345),
              output    = list(name='y',time=(1:5)))
print(res$y)
res <- simulx(model     = myModel,
              parameter = c(a=10, b=10, s=0.5),
              settings  = list(seed=12345),
              output    = list(name='y',time=(1:5)))
print(res$y)


res <- simulx(model     = myModel,
              parameter = c(a=10, b=10, s=0.5),
              settings  = list(seed=54321),
              output    = list(name='y',time=(1:5)))
print(res$y)
res <- simulx(model     = myModel,
              parameter = c(a=10, b=10, s=0.5),
              output    = list(name='y',time=(1:5)))
print(res$y)
