#library(mlxR)
library(plyr, warn.conflicts = FALSE)
theme_set(theme_bw())

project.file <- 'monolixRuns/theophylline_project.mlxtran'
sim.res1  <- simulx(project = project.file)
print(ggplot(data=sim.res1$y1) + 
        geom_point(aes(x=time, y=y1, colour=id)) +
        geom_line(aes(x=time, y=y1, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))

sim.param <- c(b=0)
out  <- list(name = 'Cc', time = seq(0, 25, by=0.1))
sim.res2  <- simulx(project   = project.file,
                    output    = out,
                    parameter = sim.param)

print(ggplot() + 
        geom_point(data=sim.res2$y1, aes(x=time, y=y1, colour=id)) +
        geom_line(data=sim.res2$Cc, aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
N <- 50
sim.res3  <- simulx(project = project.file,
                    group   = list(size = N))

print(ggplot(data=sim.res3$y1) + 
        geom_point(aes(x=time, y=y1, colour=id)) +
        geom_line(aes(x=time, y=y1, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration") +
        theme(legend.position="none"))

out  <- list(name = 'y1', time = (0:12))

sim.res4  <- simulx(project = project.file,
                    output = out)

print(ggplot(data=sim.res4$y1) + 
        geom_point(aes(x=time, y=y1, colour=id)) +
        geom_line(aes(x=time, y=y1, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
out1  <- list(name = 'y1', time = seq(0, 24, by=2))
out2  <- list(name = 'Cc', time = seq(0, 24, by=0.1))
out3  <- list(name = c('V', 'Cl', 'WEIGHT'))

sim.res5  <- simulx(project = project.file,
                    output  = list(out1, out2, out3))

print(sim.res5$parameter)

print(ggplot() + 
        geom_point(data=sim.res5$y1,aes(x=time, y=y1, colour=id)) +
        geom_line(data=sim.res5$Cc,aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
adm   <- list(time = c(0,6), amount = c(320, 320))

sim.res6  <- simulx(project   = project.file,
                    treatment = adm,
                    output    = list(out1, out2))

print(ggplot() + 
        geom_point(data=sim.res6$y1,aes(x=time, y=y1, colour=id)) +
        geom_line(data=sim.res6$Cc,aes(x=time, y=Cc, colour=id)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))
N   	<- 100
weight <- list( name     = 'WEIGHT', 
                colNames = c('id', 'WEIGHT'),
                value    = cbind(c(1:N),c(rep(50, N/2), rep(90, N/2))))

adm   <- list(time = 0, amount = 500)

sim.res7 <- simulx(project = project.file, 
                   output = list(out1, out2),
                   treatment = adm,
                   parameter = weight)

sim.res7$Cc$weight <- 50
sim.res7$Cc$weight[as.numeric(sim.res7$Cc$id)>N/2] <-90
sim.res7$Cc$weight <- as.factor(sim.res7$Cc$weight)

print(ggplot() + 
        geom_line(data=sim.res7$Cc,aes(x=time, y=Cc, group=id, colour=weight)) +
        scale_x_continuous("Time") + scale_y_continuous("Concentration"))

#-- Define the number of patients to simulate
N <- 100

#-- Generate individual weights by sampling a lognormal distribution
sim.weight <- list( name     = 'WEIGHT', 
                    colNames = c('id', 'WEIGHT'),
                    value    = cbind(c(1:N),rlnorm(N, log(70), 0.2)))

outy  <- list(name = c('y1'), time = seq(0, 140, by=6))
outi  <- c('WEIGHT', 'ka', 'V', 'Cl')

Dose.amount <- c(50, 100, 250, 500, 1000)
Dose.times  <- seq(from = 0, to = 120, by = 12)

#-- Use the same patients for each of the dose levels
s  <- list(seed = 123456)

#-- run simulx with each dose level
sim.data <- NULL
for(n.c in 1:length(Dose.amount)){
  adm   <- list(time = Dose.times, amount = Dose.amount[n.c])

	tmp <- simulx(project   = project.file,
	              output    = list(outy, outi),
	              treatment = adm,
	              parameter = sim.weight,
	              settings  = s)
	
	tmp2 			<- tmp$y1
	tmp2['Dose'] 	<- Dose.amount[n.c]
	sim.data <- rbind(sim.data, tmp2)
}

#-- Compute statistics

sim.data.stat <- ddply(sim.data, .(time, Dose), summarize,
	median = median(y1),
	p05  = quantile(y1, 0.05),
	p95  = quantile(y1, 0.95),
	Dose = Dose[1]
)

sim.data.stat.ss <- sim.data.stat[sim.data.stat$time == 120, ] 

print(ggplot(data=sim.data.stat.ss) +
  geom_line(aes(x=Dose, y=median)) +
  geom_point(aes(x=Dose, y=median)) +
  geom_ribbon(aes(x=Dose, ymin=p05, ymax=p95), alpha = 0.3) +
  scale_x_continuous("Dose") + scale_y_continuous("Concentration"))
out  <- list(name = c('y1'), time = seq(0, 120, by=12))

Dose.amount <- 300
Dose.times  <- seq(from = 0, to = 120, by = 12)

#-- Define number of trial simulations
N.trial <- 50

#-- Generate seeds for each trial simulation
seed = 123456 + seq(from=1, to=N.trial)

#-- Define the number of patients to simulate
N <- c(10, 30, 50, 100)

sim.data <- NULL
for(n.p in 1:length(N)){
  #-- Generate individual weights
  sim.weight <- list(name     = 'WEIGHT', 
	                   colNames = c('id', 'WEIGHT'),
	                   value    = cbind(c(1:N[n.p]),rlnorm(N[n.p], log(70), 0.2)))

	for(n.c in 1:length(Dose.amount)){	
		adm   <- list(time = Dose.times, amount = Dose.amount[n.c])

		#-- Here we create and pre-load the design to run the simulations faster
		s <- list(data.in=TRUE, load.design=TRUE)

		dataIn <- simulx(project   = project.file,
					           output    = out,
					           treatment = adm,
					           parameter = list(sim.weight),
					           settings  = s)

		for(n.t in 1:N.trial){
		  s <- list(seed=seed[n.t])
		  
		  #-- Run simulation with created and loaded design
		  tmp1  <- simulx(data = dataIn, setting=s)
		  tmp2 <- tmp1$y1
		  tmp2['Dose'] 	    <- Dose.amount[n.c]
		  tmp2['Trial.rep'] <- n.t
		  tmp2['N.patients']<- N[n.p]
		  
		  sim.data <- rbind(sim.data, tmp2)
		}
	}
}

#--- Compute statistics
#
sim.data.stat <- ddply(sim.data, .(time, Dose, Trial.rep, N.patients), summarize,
	median = median(y1),
	p05 = quantile(y1, 0.05),
	p95 = quantile(y1, 0.95),
	Dose = Dose.amount[1]
)

sim.data.stat.ss <- sim.data.stat[sim.data.stat$time == 120, ] 

print(ggplot(data=sim.data.stat.ss) +
	geom_point(aes(x=N.patients, y=median)))
