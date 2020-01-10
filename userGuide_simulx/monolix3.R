#library(mlxR)
theme_set(theme_bw())

project.file <- 'monolixRuns/theophylline_project.mlxtran'
res1  <- simulx(project = project.file)

print(res1$population, digits=3)
res2 <- simulx(project = project.file, 
               nrep    = 4,
               settings=list(seed=123456))
print(res2$population, digits=3)
head(res2$CONC)
print(ggplot(data=res2$CONC,aes(x=time, y=CONC, colour=id)) + 
        geom_point() +  geom_line() + facet_wrap(~ rep, ncol=2))
res3a <- simulx(project = project.file, 
                npop    = 4,
                settings=list(seed=12345))
print(res3a$population, digits=3)
head(res3a$CONC)
print(ggplot(data=res3a$CONC,aes(x=time, y=CONC, colour=id)) + 
        geom_point() +  geom_line() + facet_wrap(~ pop, ncol=2))
res3b <- simulx(project = project.file, 
                npop    = 4,
                fim     = "lin",
                settings=list(seed=12345))
print(res3b$population, digits=3)
pop4 <- simpopmlx(n=4, project=project.file)
print(pop4, digits=3)
res4 <- simulx(project   = project.file, 
               parameter = pop4)
print(res4$population, digits=3)

res5a <- simulx(project = project.file, 
                npop    = 4,
                nrep    = 3,
                group   = list(size=20))
head(res5a$CONC)

res5b <- simulx(project = project.file,
              output = list(name=c("ka", "ka_pop")),
              npop=4,
              #group = list(size=3),
              parameter = c(omega_ka=0.02),
              settings=list(seed=123))
print(res5b$population)
print(res5b$parameter)

res5c <- simulx(project = project.file, 
                npop    = 4,
                nrep    = 3,
                output = list(name=c("ka", "ka_pop")),
                parameter = c(omega_ka=0.02),
                group   = list(size=5),
                settings=list(disp.iter=TRUE))
print(res5c$population)
print(res5c$parameter)

g1 = list(size=100, treatment=list(amount=300, time=0))
g2 = list(size=100, treatment=list(amount=600, time=0))
res5d <- simulx(project = project.file, 
                npop    = 4,
                group   = list(g1, g2),
                result.file = "theo5d.csv")
print(head(read.table("theo5d.csv", header=T, sep=",")))    



