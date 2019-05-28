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

setwd("D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/")
load_data <- read_excel('Cidanau_Join_LINE6_61.18.xlsx')
head(load_data)
data <- load_data[-8]
head(data)

# model <- svm(frci ~ . , data)
# predictedY <- predict(model, testing)

error <- testing$frci - predictedY  # 
svrPredictionRMSE <- rmse(error)  #  

tuneResult <- tune(svm, frci ~ .,  data = data, epsilon = 0.5, cost = 64)

# tuneResult <- tune(svm, frci ~ .,  data = data,
#                    ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))

# print(tuneResult)
# plot(tuneResult)

# Load data for predict
setwd("D:/TIFF DATA/SUMATERA/GEE_WA_SUMSEL/Data Latihan/L8_SMT_1_6_SEBELUM/")
df <- read_excel("WA_Line_14_15_Sebelum_SMT.xlsx")
number <- df %>% group_by(Class) %>% summarize(n())
sample <- df %>% group_by(Class) %>% sample_n(min(number$`n()`))
sample <- sample[-2]
head(sample)
#
tunedModel <- tuneResult$best.model
tunedModelY <- predict(tunedModel, sample)
head(tunedModel)

hasilstat <- sample
hasilstat$predict <- tunedModelY
hasilstat

error <- sample$frci5m - tunedModelY
tunedModelRMSE <- rmse(error)

df <- data.frame(sample$frci5m, tunedModelY)
avr_y_actual <- mean(df$sample.frci5m)

ss_total <- sum((df$sample.frci5m - avr_y_actual)^2)

ss_regression <- sum((df$tunedModelY - avr_y_actual)^2)

ss_residuals <- sum((df$sample.frci5m - df$tunedModelY)^2)
r2 <- 1 - ss_residuals / ss_total

write.xlsx(sample, file = "WA_Line_14_15_Sebelum_SMT_Balance.xlsx")
