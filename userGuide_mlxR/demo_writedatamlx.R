#library(mlxR)

## writeDatamlx(r, result.file = NULL, result.folder = NULL, sep = ",", ext = NULL, digits = 5, app.file = F, app.dir = F)
model1 <- inlineModel("
[LONGITUDINAL]
input = {V, Cl, a1}

EQUATION:
Cc = pkmodel(V, Cl)

DEFINITION:
y1 ={distribution=lognormal, prediction=Cc, sd=a1}
")

adm  <- list(amount=100, time=seq(0,50,by=24))
p <- c(V=10, Cl=1, a1=0.1)
y1 <- list(name='y1', time=seq(5,to=50,by=5))

res1a <- simulx( model     = model1,
                 treatment = adm,
                 parameter = p,
                 output    = y1,
                 group     = list(size=5),
                 settings  = list(seed = 32323))
writeDatamlx(res1a, result.file = "res1a.csv")
head(read.csv("res1a.csv"))
writeDatamlx(res1a, result.file = "res1a.txt", sep="\t")
head(read.table("res1a.txt", header=TRUE, sep="\t"))
writeDatamlx(res1a, result.folder = "res1a")
list.files(path="res1a")
writeDatamlx(res1a, result.file = "res1a.csv",result.folder="res1a")
res1b <- simulx( model         = model1,
                 treatment     = adm,
                 parameter     = p,
                 output        = y1,
                 group         = list(size=5),
                 result.file   ="res1b.csv",
                 result.folder ="res1b",
                 settings      = list(seed = 32323))

head(read.csv("res1b.csv"))
list.files(path="res1b")
g1 = list(size=5, treatment=list(amount=100, time=seq(0,50,by=12)))
g2 = list(size=3, treatment=list(amount=50,  time=seq(0,50,by=12)))
res1c <- simulx( model     = model1,
                 parameter = p,
                 group     = list(g1,g2),
                 nrep      = 10,
                 output    = y1)

writeDatamlx(res1c, result.file = "res1c.csv")
head(read.csv("res1c.csv"))
y1 <- list(name='y1', time=seq(5,to=50,by=5) , lloq=3, limit=0)
res1d <- simulx( model     = model1,
                 treatment = adm,
                 parameter = p,
                 group     = list(size=5),
                 output    = y1)

writeDatamlx(res1d, result.file = "res1d.csv")
head(read.csv("res1d.csv"))
model2 <- inlineModel("
[LONGITUDINAL]
input = {V, Cl, EC50, a1, a2}

EQUATION:
Cc = pkmodel(V, Cl)
E  = 100*Cc/(Cc+EC50)

DEFINITION:
y1 ={distribution=lognormal, prediction=Cc, sd=a1}
y2 ={distribution=normal,    prediction=E,  sd=a2}

[INDIVIDUAL]
input={V_pop,o_V,Cl_pop,o_Cl,EC50_pop,o_EC50}

DEFINITION:
V   ={distribution=lognormal, prediction=V_pop,   sd=o_V}
Cl  ={distribution=lognormal, prediction=Cl_pop,  sd=o_Cl}
EC50={distribution=lognormal, prediction=EC50_pop,sd=o_EC50}
")

p <- c(V_pop=10, o_V=0.1, Cl_pop=1, o_Cl=0.2, EC50_pop=3, o_EC50=0.2, a1=0.1, a2=1)
y2 <- list(name='y2', time=seq(2,to=50,by=6))

res2a <- simulx( model     = model2,
                 treatment = adm,
                 parameter = p,
                 group     = list(size=5, level="individual"),
                 output    = list(y1,y2))
writeDatamlx(res2a, result.file = "res2a.csv")
head(read.csv("res2a.csv"))
writeDatamlx(res2a, result.folder = "res2a")
list.files(path="res2a")

project.file <- 'monolixRuns/theophylline_project.mlxtran'

sim.res1  <- simulx(project = project.file , setting=list(seed=123456))
writeDatamlx(sim.res1, result.file="theosim.csv")  
head(read.csv("theosim.csv"))

writeDatamlx(sim.res1, project=project.file, result.file="theosim.txt")
head(read.table("theosim.txt",header=TRUE))

sim.res1b  <- simulx(project = project.file , result.file="theosimb.csv", setting=list(seed=123456))
head(read.csv("theosimb.csv"))

sim.res1c  <- simulx(project = project.file , result.file="theosimb.txt", setting=list(seed=123456, format.original=TRUE))
head(read.table("theosimb.txt", sep="\t", header=TRUE))


writeDatamlx(sim.res1, project=project.file)  
head(read.table("monolixRuns/theophylline_project/sim_theophylline_data.txt",header=TRUE))
writeDatamlx(sim.res1, project=project.file, result.file="theosim.txt")
head(read.table("theosim.txt",header=TRUE))
writeDatamlx(sim.res1, project=project.file, result.folder="theo")
dir("theo")
