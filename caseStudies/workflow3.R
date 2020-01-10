#library(mlxR)
library(gridExtra)
theme_set(theme_bw())

project.file <- 'monolixRuns/pkcat_project.mlxtran'
N=100
out  <- list(name = c('conc','level'), time = c(0,2,4,6,seq(12, 180, by=12)))
p <- c(a_1=0, b_1=0)

res <- simulx(project=project.file,
              group     = list(size = N), 
              output    = out)

plot1 <- ggplot(data=res$conc) + geom_point(aes(x=time, y=conc, colour=id)) +
  geom_line(aes(x=time, y=conc, colour=id)) +
  theme(legend.position="none") + ylab("concentration (mg/l)")

plot2 <- catplotmlx(res$level)

grid.arrange(plot1, plot2, ncol=2)
