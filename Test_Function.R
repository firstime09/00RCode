
Std_DF <- function(d){
  return(sd(d))
}

Mean_DF <- function(d){
  return(mean(d))
}

ZScore <- function(a){
  proses1 <- length(a) - mean(a)
  proses2 <- (proses1/sd(a))
  return(proses2)
}

DFX1 <- c(1,4,3,1)
DFX2 <- c(2,3,1,1)
DFX3 <- c(3,1,1,1)
DFX4 <- c(1,2,1,2)

dframe <- data.frame(X1 = DFX1, X2 = DFX2, X3 = DFX3, X4 = DFX4)
summary(dframe)
print(Mean_DF(dframe$X1))

