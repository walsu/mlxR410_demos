# File generated automatically on 2019-08-30 11:24:55
 

setwd("C:/Users/Marc/OneDrive/mlxtoolbox/mlxR40x/demos/userGuide_mlxR/theophylline_project_simulx") 

# model 
model<-"theophylline_project_simulxModel.txt"

# treatment
trt <- read.csv("treatment.txt") 

# parameters 
originalId<- read.csv('originalId.txt') 
populationParameter <- read.vector('populationParameter.txt') 
individualCovariate <- read.csv(file='individualCovariate.txt') 
list.param <- list(populationParameter,individualCovariate)
# output 
name <- "y1"
time <- read.csv("output.txt",header=TRUE, sep=',')
out <- list(name=name,time=time) 

# call the simulator 
res <- simulx(model=model,treatment=trt,parameter=list.param,output=out)
