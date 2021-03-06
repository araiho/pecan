ll.monod <- function(params,x,y){
##   x<-HV_signal
##   y<-wlef_abg$ABG_biomass
  k<-params[1]
  HVmax<-params[2]  
  sd<-params[3]
  HVpred<-HVmax*(x/(x+k))

  LL<- -sum(dnorm(y,HVpred,sd,log=TRUE))
  return(LL)
}

ll.monod2 <- function(params,x,y){
  ##   x<-HV_signal
  ##   y<-wlef_abg$ABG_biomass
  k<-params[1]
  HVmax<-params[2]
  int <- params[3]
  sd<-params[4]
  HVpred<-HVmax*(x/(x+k))+int
  
  LL<- -sum(dnorm(y,HVpred,sd,log=TRUE))
  return(LL)
}

ll.micmen <- function(params,x,y){
  ##   x<-HV_signal
  ##   y<-wlef_abg$ABG_biomass
  a<-params[1]
  b<-params[2]  
  sd<-params[3]
  HVpred<-(a*x)/(b+x)
  
  LL<- -sum(dnorm(y,HVpred,sd,log=TRUE))
  return(LL)
}

ll.holling3 <- function(params,x,y){
  ##   x<-HV_signal
  ##   y<-wlef_abg$ABG_biomass
  a<-params[1]
  b<-params[2]  
  sd<-params[3]
  HVpred<-(a*x^2)/(b^2+x^2)
  
  LL<- -sum(dnorm(y,HVpred,sd,log=TRUE))
  return(LL)
}

ll.holling4 <- function(params,x,y){
  ##   x<-HV_signal
  ##   y<-wlef_abg$ABG_biomass
  a<-params[1]
  b<-params[2]
  c<-params[3]
  sd<-params[4]
  HVpred<-(a*x^2)/(b+ c*x+x^2)
  
  LL<- -sum(dnorm(y,HVpred,sd,log=TRUE))
  return(LL)
}
