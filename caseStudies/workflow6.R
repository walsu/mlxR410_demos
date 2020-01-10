#library(mlxR)
theme_set(theme_bw())

iov.project <- 'monolixRuns/iov_project.mlxtran'

d <- readDatamlx(project=iov.project)
print(names(d))
head(d$occasion, 13)

head(d$covariate.iiv)
head(d$covariate.iov,12)
res <- simulx(project=iov.project, output= list(name=c("ka","V","Cl","OCC")))
names(res)
print(head(res$parameter.iiv))
print(head(res$parameter.iov))
y1 <- subset(d$y1, id %in% 1:10)
y1$out <- "Original data"
y2 <- subset(res$y1, id %in% 1:10)
y2$out <- "Simulated data"
y <- rbind(y1, y2)

pl <- ggplot(data=y, aes(x=time, y=y1)) + geom_point( aes(colour=id)) + geom_line( aes(colour=id)) +
  facet_wrap(~out) +  theme(legend.position="none") 

print(pl)
