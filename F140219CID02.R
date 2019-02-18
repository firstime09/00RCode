# Test data CIDANAU 15022019
library(openxlsx)
library(readxl)
library(dplyr)
library(e1071)
library(ggplot2)

#---- outlier remove with function
outremove <- function(x){
  ID <- c(1:length(x))
  plot(ID, x)
  outliers <- identify(ID, x)
  x1 <- x[-outliers]
  qqnorm(x1)
  qqline(x1)
  return(x1)
}

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Cidanau/')
#---- Load dataframe
loadDf <- read_xlsx('Data_1048_Yoga.xlsx')
dfx <- loadDf %>% select(Band_2, Band_3, Band_4, Band_5, Band_6, Band_7)
dfB4 <- loadDf$Band_4
dfy <- loadDf$frci
dframeB4 <- data.frame(dfB4, dfy)
dframeB7 <- data.frame(dfx$Band_7, dfy)
plot(dframeB7, pch=16)

#---- remove outlier with lm
plot(dframe$Band_4, dframe$dfy)
lm <- lm(dfy~dfB4)
abline(lm, col = 2, lwd = 3)
outremove(dfB4) #---- outlier remove with function

#---- Support vector regression model
clfSVR1 <- svm(dfx, dfy, scale = TRUE, data = dframe, kernel = "radial") #1
pred1 <- predict(clfSVR, dframe)
plot(clfSVR, dframe, Band)

clfSVR2 <- svm(dfy ~ dfx$Band_7, dframeB7) #2
pred <- predict(clfSVR2, dframeB7)
error <- clfSVR2$residuals
lm_error <- sqrt(mean(error^2))

summary(clfSVR2)
points(dframeB7$dfx.Band_7, pred, col = "blue", pch=4)
