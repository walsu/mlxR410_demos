#library(mlxR)
library("gridExtra")
theme_set(theme_bw())

project.file <- 'monolixRuns/pkrtte_project.mlxtran'
N=200
out  <- list(name = c('Cc'), time = seq(0,150,by=0.5))
res <- simulx(project=project.file,
              group     = list(size = N),
              output    = out)
plot1 <- ggplot() + 
  geom_line(data=res$Cc, aes(x=time, y=Cc, group=id), colour="black") +
  geom_point(data=res$Concentration, aes(x=time, y=Concentration), colour="red") +
  theme(legend.position="none") + ylab("concentration (mg/l)")
print(plot1)
plot2a <- kmplotmlx(res$Hemorrhaging) + ylim(c(0,1))
plot2b <- kmplotmlx(res$Hemorrhaging, index=2) + ylim(c(0,1))
grid.arrange(plot2a,plot2b,ncol=2)
trt0 <- res$treatment[res$treatment$time==0,c(1,3)]
rh <- merge(res$Hemorrhaging,trt0)
ry <- merge(res$Concentration,trt0)  
rc <- merge(res$Cc,trt0)  
plot3 <- ggplot() + 
  geom_line(data=rc, aes(x=time, y=Cc, group=id, colour=factor(amount))) +
  geom_point(data=ry, aes(x=time, y=Concentration, colour=factor(amount))) +
  theme(legend.position="none") + ylab("concentration (mg/l)")
print(plot3)

plot4a <- kmplotmlx(rh, group="amount", facet=FALSE)  + ylab("Survival (first event)") +
  scale_colour_discrete(name  ="dose")
plot4b <- kmplotmlx(rh, index=2, group="amount", facet=FALSE)  + ylab("Survival (second event)") +
  scale_colour_discrete(name  ="dose")
grid.arrange(plot4a,plot4b,ncol=2)
