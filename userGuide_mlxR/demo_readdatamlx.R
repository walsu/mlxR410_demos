#library(mlxR)
theme_set(theme_bw())

head(read.table('data/warfarin_data.txt', header=TRUE, sep="\t"))

warfarin.data <- list(dataFile = 'data/warfarin_data.txt',
                      headerTypes   = c('id','time','amt','y','ytype','cov','cov','cat'))
d <- readDatamlx(data = warfarin.data)
head(d$treatment)
head(d$covariate)
head(d$y1)

# d.2018 <- readDatamlx(datafile = 'data/warfarin_data.txt', 
#                       header   = c('id','time','amount','observation','obstype','contcov','contcov','catcov'))


d <- readDatamlx(datafile = 'data/warfarin_data.txt', 
                 header   = c('id','time','amt','y','ytype','cov','ignore','ignore'))
head(d$covariate)
head(read.table('data/warfarin_data_evid.txt', header=TRUE, sep="\t"))

d <- readDatamlx(datafile = 'data/warfarin_data_evid.txt', 
                 header   = c('id','time','amt','y','ytype','cov','cov','cat','evid'))
head(d$treatment)
head(read.table('data/warfarin_data_mdv.txt', header=TRUE, sep="\t"))

d <- readDatamlx(datafile = 'data/warfarin_data_mdv.txt', 
                 header   = c('id','time','amt','y','ytype','cov','cov','cat','mdv'))
head(d$y1)
head(read.csv('data/dataSS.csv'))
d <- readDatamlx(datafile = "data/dataSS.csv",  
                 header   = c('time','y','amt','ss','ii'))
d$treatment
d <- readDatamlx(datafile = "data/dataSS.csv",  
                 header   = c('time','y','amt','ss','ii'),
                 nbSSDoses  = 5)
d$treatment
head(read.csv('data/dataADDL1.csv'))

d <- readDatamlx(datafile = "data/dataADDL1.csv",  
                 header   = c('time','y','amt','addl','ii'))
d$treatment
head(read.csv('data/dataADDL2.csv'))

d <- readDatamlx(datafile = "data/dataADDL2.csv",  
                 header   = c('time','y','amt','addl','ii'))
d$treatment
project.file <- 'monolixRuns/theophylline_project.mlxtran'
theo.data <- readDatamlx(project = project.file)
names(theo.data)
head(theo.data$y)    
theo.data <- readDatamlx(project = project.file, out.data=TRUE)
names(theo.data)
head(theo.data$data)    #  original data
theo.data$infoProject$datafile #  path & name of the data file
theo.data$infoProject$dataheader # header/keywords used by Monolix
theo.data$infoProject$resultFolder  # result folder
