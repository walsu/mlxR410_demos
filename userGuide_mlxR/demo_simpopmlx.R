#library(mlxR)
theme_set(theme_bw())

## simpopmlx(n = 1, project = NULL, fim = "needed", parameter = NULL, corr = NULL, kw.max = 100)
project.file <- 'monolixRuns/warfarinPK1_project.mlxtran'  
pop1a <- simpopmlx(n=3, project=project.file)
print(pop1a, digits=3)
pop1b <- simpopmlx(n=3, project=project.file, fim="sa")
print(pop1b, digits=3)
project.file <- 'monolixRuns/warfarinPK2_project.mlxtran'  
pop2 <- simpopmlx(n=3, project=project.file)
print(pop2, digits=3)
project.file <- 'monolixRuns/warfarinPK3_project.mlxtran'  
pop3 <- simpopmlx(n=3, project=project.file)
print(pop3, digits=3)
param <- data.frame(pop.param=c(1.5, 0.5, 0.02, 0.4, 0.15, 0.2, 0.7),
                    sd=c(0.2, 0.05, 0.004, 0.05, 0.02, 0.02, 0.05),
                    trans=c('N','N','N','L','L','L','N'))
pop4a <- simpopmlx(n=3, parameter=param)
print(pop4a, digits=3)
param$sd=c(0.2, 0.05, 0., 0.05, 0.02, 0.02, 0.0)
pop4b <- simpopmlx(n=3, parameter=param)
print(pop4b, digits=3)


param <- data.frame(pop.param=c(1.5, 0.5, 0.02, 0.4, 0.15, 0.2, 0.7),
                    sd=c(0.2, 0.5, 0.004, 0.05, 0.02, 0.02, 0.05),
                    trans=c('N','G','N','L','L','L','N'))
pop5a <- simpopmlx(n=3, parameter=param)
print(pop5a, digits=3)
param$lim.a <- c(NaN, 0.2, NaN, NaN, NaN, NaN, NaN)
param$lim.b <- c(NaN, 0.7, NaN, NaN, NaN, NaN, NaN)
pop5b <- simpopmlx(n=3, parameter=param)
print(pop5b, digits=3)
