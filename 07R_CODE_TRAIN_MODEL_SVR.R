library(dbscan)
library(readxl)
library(dplyr)
library(e1071)
library(Boruta)
library(caret)
library(raster)
library(dismo)
library(openxlsx)

# setwd("C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/Data FRCI Window Area_Malta/")
setwd("D:/TIFF DATA/New DataFrame/Sumatera 15052019/SHP/WINDOW AREA/")
file = read_excel("WA_Line_14_15_Sesudah_SMT.xlsx")
# file =read.csv("FRCI_Line_6.csv")
head(file)
# dataall <- file[,-c(3,10)] ## Drop column Band_1 and Band_9 in dataframe
# data <- file[,-c(3,10)] ## Drop column Band_1 and Band_9 in dataframe
# head(data)

number <- file %>% group_by(Class) %>% summarize(n())
sample <- file %>% group_by(Class) %>% sample_n(min(number$`n()`))
head(sample)
sample <- sample[-c(2)] ## For remove column Class and kategori
head(sample)

# lst <- as.data.frame(lapply(sample, function(x) round((x-min(x))/(max(x)-min(x)), 3))) 
lst <- as.data.frame(lapply(sample, function(x) round(x, 3)))
head(lst)
dataSample <- lst
head(dataSample)
kNNdistplot(dataSample, k = 5)

hight_dist <- 0.0375 ##------------------------------------------ Note
abline(h = hight_dist, col = "red", lty = 2)
res <- dbscan(dataSample, eps = hight_dist , minPts = 5)
res
pairs(dataSample, col = res$cluster + 1L)
dataSample$cluster <- res$cluster
cleanall <- dataSample %>% filter(cluster > 0)
par(mfrow=c(1,2))
plot(cleanall$Band_4, cleanall$frci)
plot(dataSample$Band_4, dataSample$frci)

## Feature Selection
svrdata <- cleanall
svrdata <- cleanall[-8]
head(svrdata)
#library(Boruta)
# Decide if a variable is important or not using Boruta
boruta_output <- Boruta(frci5m ~ ., data=na.omit(svrdata), doTrace=2)  # perform Boruta search
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
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# svr model ==============================================

model <- svm(frci5m ~ . , training)
predictedY <- predict(model, testing)


error <- testing$frci - predictedY  # 
svrPredictionRMSE <- rmse(error)  #  


tuneResult <- tune(svm, frci5m ~ .,  data = training,
                   ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))

# tuneResult <- tune(svm, frci ~ .,  data = training,
#                    ranges = list(epsilon = 0.01, cost = 10))
# print(tuneResult) 
# plot(tuneResult)

tunedModel <- tuneResult$best.model
tunedModelY <- predict(tunedModel, testing)

hasilstat <- testing
hasilstat$predict <- tunedModelY
hasilstat

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


# setwd('D:/TIFF DATA/New DataFrame/Cidanau 13052019/') #---------------------- After running
write.xlsx(cleanall, file = "WA_Line_14_15_Sesudah_SMT_HASIL.xlsx")
write.xlsx(hasilstat, file = "WA_Line_14_15_Sesudah_SMT_58_19.xlsx")
# write.csv(cleanall, file = "FRCI_LINE7_78.13.csv")
