# File generated automatically on 2019-08-30 11:25:08
 

setwd("C:/Users/Marc/OneDrive/mlxtoolbox/mlxR40x/demos/userGuide_mlxR/pkcat_project_simulx") 

# model 
model<-"pkcat_project_simulxModel.txt"

# treatment
trt <- read.csv("treatment.txt") 

# parameters 
originalId<- read.csv('originalId.txt') 
populationParameter <- read.vector('populationParameter.txt') 
individualCovariate <- read.csv(file='individualCovariate.txt') 
list.param <- list(populationParameter,individualCovariate)
# output 
name <- "conc"
time <- read.csv("output1.txt",header=TRUE, sep=',')
out1 <- list(name=name,time=time) 
name <- "level"
time <- read.csv("output2.txt",header=TRUE, sep=',')
out2 <- list(name=name,time=time) 
out<-list(out1,out2)

# call the simulator 
res <- simulx(model=model,treatment=trt,parameter=list.param,output=out)
