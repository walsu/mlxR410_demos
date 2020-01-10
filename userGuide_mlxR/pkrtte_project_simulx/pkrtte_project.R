# File generated automatically on 2019-08-30 11:25:19
 

setwd("C:/Users/Marc/OneDrive/mlxtoolbox/mlxR40x/demos/userGuide_mlxR/pkrtte_project_simulx") 

# model 
model<-"pkrtte_project_simulxModel.txt"

# treatment
trt <- read.csv("treatment.txt") 

# parameters 
originalId<- read.csv('originalId.txt') 
populationParameter <- read.vector('populationParameter.txt') 
list.param <- list(populationParameter)
# output 
name <- "Concentration"
time <- read.csv("output1.txt",header=TRUE, sep=',')
out1 <- list(name=name,time=time) 
name <- "Hemorrhaging"
time <- read.csv("output2.txt",header=TRUE, sep=',')
out2 <- list(name=name,time=time) 
out<-list(out1,out2)

# call the simulator 
res <- simulx(model=model,treatment=trt,parameter=list.param,output=out)
