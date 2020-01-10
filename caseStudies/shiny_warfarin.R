
#library(mlxR)

project <- file.path("monolixRuns","warfarin_project.mlxtran")

# generates the model with both structural and statistical part
r <- monolix2simulx(project)

# pop param
parameter <- read.vector(r$populationParameter)
parameter <- round(parameter, digits=2) # keep only two digits
parameter.pk <- c('Tlag_pop', 'ka_pop', 'V_pop', 'Cl_pop')
parameter.pd <- c('Imax_pop', 'IC50_pop', 'kin_pop', 'kout_pop')
parameter.beta <- grep('beta',names(parameter))
parameter.omega <- grep('omega',names(parameter))
parameter.residual <- c('a1', 'b1','a2')
parameter[parameter.omega] = 0 # set standard deviations to 0


# Output definition
out.time <- seq(0,480,by=1)
out.Cc <- list(name = 'Cc',   time = out.time)
out.E <- list(name = 'E',   time = out.time)


# Treatment definition
trtRef <- list(
  tfd    = list(widget="slider", value=0,  min=0, max=24, step=6),
  nd     = list(widget="slider", value=3,  min=1, max=10, step=1),
  ii     = list(widget="slider", value=48, min=12, max=96, step=12),
  amount = list(widget="slider", value=100, min=0, max=300, step=25)
)

shiny.app <- shinymlx(model = r$model,
                      parameter = list(slider = parameter[parameter.pk],
                                       slider = parameter[parameter.pd],
                                       slider = c(wt=70,parameter[parameter.beta]),
                                       null = parameter[parameter.omega],
                                       null = parameter[parameter.residual]),
                      output = list(out.Cc, out.E),
                      treatment = trtRef,
                      style="dashboard1")

shiny::runApp(shiny.app)


trt1 <- list(
  tfd    = list(widget="slider", value=0,  min=0, max=24, step=6),
  nd     = list(widget="slider", value=3,  min=1, max=10, step=1),
  ii     = list(widget="slider", value=48, min=12, max=96, step=12),
  amount = list(widget="slider", value=100, min=0, max=300, step=25)
)

trt2 <- list(
  tfd    = list(widget="slider", value=3,  min=0, max=24, step=6),
  nd     = list(widget="slider", value=2,  min=1, max=10, step=1),
  ii     = list(widget="slider", value=96, min=12, max=96, step=12),
  amount = list(widget="slider", value=50, min=0, max=300, step=25)
)

shiny.app <- shinymlx(model = r$model,
                      parameter = list(slider = parameter[parameter.pk],
                                       slider = parameter[parameter.pd],
                                       slider = c(wt=70,parameter[parameter.beta]),
                                       null = parameter[parameter.omega],
                                       null = parameter[parameter.residual]),
                      output = list(out.Cc, out.E),
                      treatment = list(trt1, trt2),
                      style="dashboard1")

