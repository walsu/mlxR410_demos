#library(mlxR)
theme_set(theme_bw())

project.file <- 'monolixRuns/theophylline_project.mlxtran'
res1  <- simulx(project = project.file)
names(res1)
print(res1$treatment)
print(res1$population)
print(ggplot(data=res1$CONC) + 
        geom_point(aes(x=time, y=CONC, colour=id)) +
        geom_line(aes(x=time, y=CONC, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
sim.param <- c(a=0, b=0)
out1  <- list(name = 'Cc', time = seq(0, 25, by=0.1))
outp <- c("ka","V", "Cl","WEIGHT")
res2  <- simulx(project   = project.file,
                output    = list(out1,outp),
                parameter = sim.param)
names(res2)
print(res2$population)
head(res2$parameter)

print(ggplot() + 
        geom_point(data=res2$CONC, aes(x=time, y=CONC, colour=id)) +
        geom_line(data=res2$Cc, aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
out2  <- list(name = 'CONC', time = seq(1, 25, by=2))
res3  <- simulx(project   = project.file,
                output    = list(out1, out2),
                parameter = sim.param)

print(ggplot() + 
        geom_point(data=res3$CONC, aes(x=time, y=CONC, colour=id)) +
        geom_line(data=res3$Cc, aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
out0 <- list(name='CONC', time='none')
res4  <- simulx(project   = project.file,
                output    = list(out1,out0))
names(res4)
sim.param <- list("mode")
res5  <- simulx(project   = project.file,
                output    = out1,
                parameter = sim.param)

print(ggplot() + 
        geom_point(data=res5$CONC, aes(x=time, y=CONC, colour=id)) +
        geom_line(data=res5$Cc, aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
sim.param <- list("mode",c(a=0, b=0))
res6  <- simulx(project   = project.file,
                output    = out1,
                parameter = sim.param)

print(ggplot() + 
        geom_point(data=res6$CONC, aes(x=time, y=CONC, colour=id)) +
        geom_line(data=res6$Cc, aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
res7  <- simulx(project   = project.file,
                settings  = list(out.trt=F))
names(res7)
adm   <- list(time = c(0,6), amount = c(500, 300))

res8 <- simulx(project = project.file, treatment = adm, output = list(out1, out2))

print(ggplot() + 
        geom_point(data=res8$CONC,aes(x=time, y=CONC, colour=id)) +
        geom_line(data=res8$Cc,aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
