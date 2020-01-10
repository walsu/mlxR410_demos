#library(mlxR)
theme_set(theme_bw())

project.file <- 'monolixRuns/theophylline_project.mlxtran'
N <- 30
res1  <- simulx(project = project.file,
                group   = list(size = N))

print(ggplot(data=res1$CONC) + 
        geom_point(aes(x=time, y=CONC, colour=id)) +
        geom_line(aes(x=time, y=CONC, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration") +
        theme(legend.position="none"))
print(res1$treatment)
print(res1$originalId)
res2  <- simulx(project = project.file,
                group   = list(size = N),
                settings  = list(replacement=T))
print(res2$originalId)
N <- 5
res3  <- simulx(project = project.file,
                parameter = "mode",
                group   = list(size = N))
print(res3$originalId)
N 		<- 100
weight <- data.frame(id = (1:N), WEIGHT = rnorm(n=N, mean=70, sd=10))
adm   <- list(time = 1, amount = 500)
out2  <- list(name = 'CONC', time = seq(0, 25, by=2))
outw  <- "WEIGHT"

res4 <- simulx(project = project.file, 
               output = list(outw, out2),
               treatment = adm,
               parameter = weight)

print(head(res4$parameter))

print(ggplot(data=res4$CONC,aes(x=time, y=CONC, by=id)) +  geom_point() +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))

