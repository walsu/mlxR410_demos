library("mlxR")
library("gridExtra")
source("shinymlxTools.R")
load("data.RData")

f <- list(name='Cc', time=seq(0,100,by=0.1))
f <- list(f)
nf <- length(f)
info <- info_res(f)

server <- function(input, output) {
  ref <- reactive({
    input$butref
    p <- list(name  = c('F', 'ka', 'V', 'k'),
              value = isolate(c(input$F, input$ka, input$V, input$k)))
    t1 <- isolate(input$tfd1)
    t2 <- isolate(input$ii1)*(isolate(input$nd1)-1)+t1
    t.dose <- seq(t1,t2,by=isolate(input$ii1))
    adm1 <- list(time=t.dose, type=isolate(as.numeric(input$type1)),amount=isolate(as.numeric(input$amount1)))
    t1 <- isolate(input$tfd2)
    t2 <- isolate(input$ii2)*(isolate(input$nd2)-1)+t1
    t.dose <- seq(t1,t2,by=isolate(input$ii2))
    adm2 <- list(time=t.dose, type=isolate(as.numeric(input$type2)),amount=isolate(as.numeric(input$amount2)),rate=isolate(as.numeric(input$rate2)))
    adm <- list(adm1, adm2)
    r <- simulx( model     = 'model.txt',
                 treatment = adm,
                 parameter = p,
                 regressor = regressor,
                 group     = group,
                 output    = f)

    ref <- merge_res(r,f)
    return(ref)
  })
  
  res <- reactive({
    p <- list(name  = c('F', 'ka', 'V', 'k'),
              value = c(input$F, input$ka, input$V, input$k))
    t1 <- input$tfd1
    t2 <- input$ii1*(input$nd1-1)+t1
    t.dose <- seq(t1,t2,by=input$ii1)
    adm1 <- list(time=t.dose, type=as.numeric(input$type1),amount=as.numeric(input$amount1))
    t1 <- input$tfd2
    t2 <- input$ii2*(input$nd2-1)+t1
    t.dose <- seq(t1,t2,by=input$ii2)
    adm2 <- list(time=t.dose, type=as.numeric(input$type2),amount=as.numeric(input$amount2),rate=as.numeric(input$rate2))
    adm <- list(adm1, adm2)                     
    r <- simulx( model     = 'model.txt',
                 treatment = adm,
                 parameter = p,
                 regressor = regressor,
                 group     = group,
                 output    = f)
                     
    res <- merge_res(r,f)
    return(res)
  })  
  
  output$plot <- renderPlot({
    res=res()
   ref=ref()    
    gr.txt <- "grid.arrange("
    for (j in (1:length(f))){
      xj <- "time"
      fj <- f[[j]]
      name.fj <- fj$name

   eval(parse(text=paste0("inputyj=input$out",j)))  
  i.plot=FALSE
  if (!is.null(inputyj)){
    ij <- which(name.fj %in% inputyj)
    if (length(ij>0)){
      eval(parse(text=paste0("inputxj=input$x",j)))
      if (!is.null(inputxj))
        xj <- inputxj
    }
    i.plot=TRUE
  }
  else if (is.null(inputyj) & length(f)==1){
    ij=1
    i.plot=TRUE
  }
  if (i.plot){
    pl <- ggplotmlx()
    nfj <- length(name.fj)
    for (k in (1:nfj)){
      if (k %in% ij){
           if (input$boxref==TRUE){
      pj <- paste0('pl <- pl + geom_path(data=ref[[j]], aes(x=time,y=',name.fj[k],'),colour="grey",size=0.75)')
      eval(parse(text=pj))
    }
       pj <- paste0('pl <- pl + geom_path(data=res[[j]], aes(x=time,y=',name.fj[k],',colour="',info[[j]]$colour[k],'"),size=0.75)')
       eval(parse(text=pj))
      }  
    }
    pl <- pl + scale_colour_manual(values=info[[j]]$values, labels=info[[j]]$labels)
    print(pl)
    if (length(ij)>1){
      if (!is.null(input$legend) && input$legend==FALSE)
        pl <- pl + theme(legend.position="none")
      else
        pl <- pl + guides(colour=guide_legend(title=NULL)) + theme(legend.position=c(.9, .8))
      pl <- pl + ylab("")
    }else{
      pl <- pl + theme(legend.position="none")
    }
  
      if (input$ilog==TRUE)
       pl=pl + scale_y_log10()
    eval(parse(text=paste0("pl",j," <- pl")))
    gr.txt <- paste0(gr.txt,"pl",j,",")
  }
    }
    gr.txt <- paste0(gr.txt,"ncol=1)")
    eval(parse(text=gr.txt))
  }, height = 500)
}

