library(dbscan)
library(readxl)
library(dplyr)
library(e1071)
library(Boruta)
library(caret)
library(raster)
library(dismo)
library(openxlsx)

r2 <- 0
n <- 0
while (r2 <= 0.8) {
  # setwd("C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/Data FRCI Window Area_Malta/")
  setwd("D:/00RCode/Result/Data Sumatera/")
  file = read_excel("FRCI_Line_6.xlsx")
  # file =read.csv("FRCI_Line_6.csv")
  head(file)
  dataall <- file[,-c(3,10)] ## Drop column Band_1 and Band_9 in dataframe
  data<-file[,-c(3,10)] ## Drop column Band_1 and Band_9 in dataframe
  head(data)
  
  number <- data %>% group_by(Class) %>% summarize(n())
  sample <- data %>% group_by(Class) %>% sample_n(min(number$`n()`))
  head(sample)
  sample<-sample[-2] ## For remove column Class
  
  lst <- as.data.frame(lapply(sample, function(x) round(x, 3)))
  head(lst)
  dataSample <- lst
  head(dataSample)
  kNNdistplot(dataSample, k = 5)
  abline(h=0.05, col = "red", lty=2)
  
  res <- dbscan(sample, eps =0.05 , minPts = 5)
  res
  pairs(sample, col = res$cluster + 1L)
  sample$cluster<-res$cluster
  cleanall<-sample %>% filter(cluster > 0)
  par(mfrow=c(1,2))
  #plot(cleanall$Band_4, cleanall$frci)
  #plot(sample$Band_4, sample$frci)
  
  svrdata <- cleanall
  svrdata <- cleanall[-8]
  head(svrdata)
  #library(Boruta)
  # Decide if a variable is important or not using Boruta
  boruta_output <- Boruta(frci ~ ., data=na.omit(svrdata), doTrace=2)  # perform Boruta search
  boruta_signif <- names(boruta_output$finalDecision[boruta_output$finalDecision %in% ("Confirmed")])  # collect Confirmed and Tentative variables
  print(boruta_signif)  # significant variables
  #plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")  # plot variable importance
  
  # Divide data to training and testing ===============================
  set.seed(3033)
  intrain <- createDataPartition(y = svrdata$frci, p= 0.7, list = FALSE)
  training <- svrdata[intrain,]
  testing <- svrdata[-intrain,]
  
  dim(training)
  dim(testing)
  anyNA(svrdata)
  ## RMSE
  rmse <- function(error){
    sqrt(mean(error^2))
  }
  
  # svr model ==============================================
  
  model <- svm(frci ~ . , training)
  predictedY <- predict(model, testing)
  
  error <- testing$frci - predictedY  # 
  svrPredictionRMSE <- rmse(error)  #  
  
  tuneResult <- tune(svm, frci ~ .,  data = training, ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))
  
  # tuneResult <- tune(svm, frci ~ .,  data = training,
  #                    ranges = list(epsilon = 0.01, cost = 10))
  # print(tuneResult) 
  # plot(tuneResult)
  
  tunedModel <- tuneResult$best.model
  tunedModelY <- predict(tunedModel, testing)
  error <- testing$frci - tunedModelY
  tunedModelRMSE <- rmse(error)  # 2.219642
  
  # 1. 'Actual' and 'Predicted' data
  df <- data.frame(testing$frci, tunedModelY)
  
  # 2. R2 Score components
  
  # 2.1. Average of actual data
  avr_y_actual <- mean(df$testing.frci)
  
  # 2.2. Total sum of squares
  ss_total <- sum((df$testing.frci - avr_y_actual)^2)
  
  # 2.3. Regression sum of squares
  ss_regression <- sum((df$tunedModelY - avr_y_actual)^2)
  
  # 2.4. Residual sum of squares
  ss_residuals <- sum((df$testing.frci - df$tunedModelY)^2)
  
  # 3. R2 Score
  r2 <- 1 - ss_residuals / ss_total
  print(r2)
  n <- n + 1
  setwd("D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/")
  filename = sprintf("%f %d Sumatera_Line_6.csv", r2, n)
  # write.xlsx(cleanall, file = filename)
  write.csv(cleanall, file = filename)
  ## Feature Selection
  r2 <- r2 + 0.1
}