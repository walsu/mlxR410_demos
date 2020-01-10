#library(mlxR)
library(reshape2)
theme_set(theme_bw())

model1 <- inlineModel("
[LONGITUDINAL]
input = {ka, Tk0, V, k}

EQUATION:
D  = 100

if t>Tk0
  f0=D/(V*Tk0*k)*(1-exp(-k*Tk0))*exp(-k*(t-Tk0))
else
  f0=D/(V*Tk0*k)*(1-exp(-k*t))
end

f1 = f0
f2 = D*ka/(V*(ka-k))*(exp(-k*t) - exp(-ka*t))
")
f <- list(name = c('f1','f2'), time = seq(0, 20, 0.1))

p <- c(ka=0.5, Tk0=2, V=10, k=0.2)

r <- simulx(model = model1, parameter = p, output = f)

r <- melt(merge(r$f1,r$f2),  id='time', variable.name='f')
ggplot(r, aes(time,value)) + geom_line(aes(colour = f),size=1) +
  guides(colour=guide_legend(title=NULL)) +theme(legend.position=c(.9, .75))

shiny.app <- shinymlx(model = model1, parameter = p, output = f)
shiny::runApp(shiny.app)


p <- list( ka  = list(widget='slider',  value=0.5,min=0.1,max=1,step=0.1),
           Tk0 = list(widget='numeric', value=2),
           V   = list(widget='none',    value=2),
           k   = list(widget='select',  selected=0.2, choices=c(0.05,0.2,0.4))
)
shiny.app <- shinymlx(model=model1, parameter=p, output=f, style="dashboard1",
                      title="Compare PK models")
shiny::runApp(shiny.app, launch.browser=TRUE)


s <- list(select.x=FALSE, select.log=FALSE)
shiny.app <- shinymlx(model=model1, parameter=p, output=f, style="navbar1", settings=s)
shiny::runApp(shiny.app)

shiny.app <- shinymlx(model=model1, parameter=p, output=f, style="navbar2", settings=s)
shiny::runApp(shiny.app)


myModel <- inlineModel("
[LONGITUDINAL]
input = {ka, V, Cl}
EQUATION:
C = pkmodel(ka, V, Cl)
")

f <- list(name = 'C',
          time = c(0, 25, 0.5))

p <- list( ka = c(0.5,0.25,3,0.25),
           V  = c(5,1,20,1),
           Cl = c(1,0.5,3,.1))

shiny.app <- shinymlx(model     = myModel,
                      data      = 'data/pkdata1.txt',
                      treatment = list(time=c(0,12), amount=c(10,3)),
                      parameter = p,
                      output    = f)
shiny::runApp(shiny.app)


myModel <- inlineModel("
[LONGITUDINAL]
input = {F, ka, V, k}

PK:
depot(type=1, target=Ad, p=F)
depot(type=2, target=Ac)

EQUATION:
ddt_Ad = -ka*Ad
ddt_Ac =  ka*Ad - k*Ac
Cc = Ac/V
")

p    <- c(F=0.7, ka=1, V=10, k=0.1)
Cc   <- list(name="Cc", time=seq(0, 100, by=0.1))

adm1 <- list(
  type   = list(widget="select", selected=1, choices=c(1,2)),
  tfd    = list(widget="slider", value=6,  min=0, max=24, step=2),
  nd     = list(widget="slider", value=3,  min=0, max=10, step=1),
  ii     = list(widget="slider", value=12, min=3, max=24, step=1),
  amount = list(widget="slider", value=40, min=0, max=50, step=5)
)
adm2 <- list(
  type   = list(widget="select", selected=2, choices=c(1,2)),
  tfd    = list(widget="slider", value=12, min=0, max=24, step=2),
  nd     = list(widget="slider", value=2,  min=0, max=10, step=1),
  ii     = list(widget="slider", value=30, min=6, max=60, step=6),
  amount = list(widget="slider", value=20, min=0, max=50, step=5),
  rate   = list(widget="slider", value=5,  min=1, max=10, step=1)
)

shiny.app <- shinymlx(model   = myModel,
                      parameter = p,
                      output    = Cc,
                      treatment = list(adm1,adm2),
                      style     = "navbar1")
shiny::runApp(shiny.app)


PKPDmodel <- inlineModel("
[LONGITUDINAL]
input={ka,V,Cl,ke0,Imax,IC50,S0,kout}

EQUATION:
{Cc, Ce}  = pkmodel(ka, V, Cl, ke0)

Ec = Imax*Cc/(Cc+IC50)
E1 = S0*(1 - Ec)

Ee = Imax*Ce/(Ce+IC50)
E2 = S0*(1 - Ee)

E3_0 = S0
ddt_E3 = kout*((1-Ec)*S0- E3)
")

pk.param <- c(ka=0.5, V=10, Cl=1)
pd.param <- c(ke0=0.1, Imax=0.5, IC50=0.03, S0=100, kout=0.1)

adm <- list(tfd=5, nd=15, ii=12, amount=1)

pk <- list(name = 'Cc',                time = seq(0, 250, by=1))
pd <- list(name = c('E1','E2', 'E3'),  time = seq(0, 250, by=1))

shiny.app <- shinymlx(model     = PKPDmodel,
                      treatment = adm,
                      parameter = list(pk.param, pd.param),
                      output    = list(pk, pd),
                      title     = "PKPD models",
                      style     = "dashboard1",
                      appname   = "demo4")
shiny::runApp(shiny.app)
