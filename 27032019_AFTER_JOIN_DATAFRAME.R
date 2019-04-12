library(dbscan)
library(readxl)
library(dplyr)
library(e1071)
library(Boruta)
library(caret)
library(raster)
library(dismo)
library(openxlsx)

rmse <- function(error)
{
  sqrt(mean(error^2))
}

setwd("D:/00RCode/Result/01042019_JOIN_DF_LINE_1.2/")
file1 = read_excel("CIDANAU_LINE_1_SUMATERA.xlsx")
head(file1)

file1 <- file1[-8]
kNNdistplot(file1, k = 5)
abline(h=0.04, col = "red", lty=2)

res <- dbscan(file1, eps =0.04, minPts = 5)
res
pairs(file1, col = res$cluster + 1L)
file1$cluster <- res$cluster
cleanall <- file1 %>% filter(cluster > 0)
par(mfrow=c(1,2))
plot(cleanall$Band_4, cleanall$frci)
plot(file1$Band_4, file1$frci)

svrdata <- cleanall
svrdata <- cleanall[-8]
head(svrdata)

# Decide if a variable is important or not using Boruta
boruta_output <- Boruta(frci ~ ., data=na.omit(svrdata), doTrace=2)  # perform Boruta search
boruta_signif <- names(boruta_output$finalDecision[boruta_output$finalDecision %in% ("Confirmed")])  # collect Confirmed and Tentative variables
print(boruta_signif)  # significant variables
plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")  # plot variable importance

# Divide data to training and testing ===============================
set.seed(3033)
intrain <- createDataPartition(y = svrdata$frci, p= 0.7, list = FALSE)
training <- svrdata[intrain,]
testing <- svrdata[-intrain,]

dim(training)
dim(testing)
anyNA(svrdata)
## RMSE

# svr model ==============================================
model <- svm(frci ~ . , training)
predictedY <- predict(model, testing)

error <- testing$frci - predictedY  # 
svrPredictionRMSE <- rmse(error)  #  

tuneResult <- tune(svm, frci ~ .,  data = training,
                   ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))

# tuneResult <- tune(svm, frci ~ .,  data = training,
#                    ranges = list(epsilon = 0.01, cost = 10))
# print(tuneResult) 
# plot(tuneResult)

tunedModel <- tuneResult$best.model
tunedModelY <- predict(tunedModel, testing)
error <- testing$frci - tunedModelY
tunedModelRMSE <- rmse(error)

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

setwd('D:/00RCode/Result/01042019_JOIN_DF_LINE_1.2/') #---------------------- After running
write.xlsx(cleanall, file = "CIDANAU_LINE_1_SUMATERA_65_17.xlsx")
# write.csv(cleanall, file = "Cidanau_LINE_6_7_NEW_74.15.csv")
