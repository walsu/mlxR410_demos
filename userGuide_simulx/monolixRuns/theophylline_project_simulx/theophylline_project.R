# File generated automatically on 2018-02-24 18:35:01
 

setwd("F:/mlxtoolbox/mlxR33x/demos/userGuide_simulx/monolixRuns/theophylline_project_simulx") 

# model 
model<-"theophylline_project_simulxModel.txt"

# treatment
trt <- read.table("treatment.txt", header = TRUE) 

# parameters 
originalId<- read.table('originalId.txt', header=TRUE) 
populationParameter<- read.vector('populationParameter.txt') 
individualCovariate <- read.table('individualCovariate.txt', header = TRUE) 
list.param <- list(populationParameter,individualCovariate)
# output 
name<-"CONC"
time<-read.table("output.txt",header=TRUE)
out<-list(name=name,time=time) 

# call the simulator 
res <- simulx(model=model,treatment=trt,parameter=list.param,output=out)
