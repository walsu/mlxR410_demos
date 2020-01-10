#library(mlxR)

w.dir <- getwd()
project.file <- 'monolixRuns/theophylline_project.mlxtran'
r <- monolix2simulx(project = project.file, open=TRUE)
setwd(w.dir)

r <- monolix2simulx(project = project.file, parameter="mode", open=TRUE)
setwd(w.dir)

r <- monolix2simulx(project = project.file, group=list(size=10), open=TRUE)
setwd(w.dir)

r <- monolix2simulx(project = project.file, r.data=FALSE, open=TRUE)
setwd(w.dir)

r <- monolix2simulx(project = project.file, fim="sa", open=TRUE)
setwd(w.dir)

project.file <- 'monolixRuns/warfarin_project.mlxtran'
r <- monolix2simulx(project = project.file, parameter="mode", open=TRUE)
setwd(w.dir)

project.file <- 'monolixRuns/pkcat_project.mlxtran'
r <- monolix2simulx(project = project.file, open=TRUE)
setwd(w.dir)

project.file <- 'monolixRuns/pkrtte_project.mlxtran'
r <- monolix2simulx(project = project.file, open=TRUE)
setwd(w.dir)
