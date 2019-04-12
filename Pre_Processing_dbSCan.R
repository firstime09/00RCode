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

##----------- Load Data Frame
setwd('E:/All Data Forests2020/26032019_Pavilion/FRCI_6_7') ## """Load Data Frame"""
dataFrame <- read.xlsx('Data_LINE_6_7_SUMATERA.xlsx')
dataFrame <- dataFrame[-2]
head(dataFrame)

round_data <- as.data.frame(lapply(dataFrame, function(x) round(x, 3)))
head(round_data)
dframe <- round_data
kNNdistplot(dframe, k = 5)
# """Note make line before increase data"""
abline(h = 0.04, col = 'red', lty = 2)

dbSCAN_Out <- dbscan(dframe, eps = 0.04, minPts = 5)
dbSCAN_Out
pairs(dframe, col = dbSCAN_Out$cluster + 1L)
dframe$cluster <- dbSCAN_Out$cluster
clean_dframe <- dframe %>% filter(cluster > 0)
par(mfrow = c(1,2))
plot(clean_dframe$Band_4, clean_dframe$frci)
plot(dframe$Band_4, dframe$frci)

# """Make SVR Model from clean_dframe"""
head(clean_dframe)
svrdata <- clean_dframe
svrdata <- clean_dframe[-8]

boruta_output <- Boruta(frci ~ ., data = na.omit(svrdata), doTrace = 2)  # perform Boruta search
boruta_signif <- names(boruta_output$finalDecision[boruta_output$finalDecision %in% ("Confirmed")])  # collect Confirmed and Tentative variables
print(boruta_signif)  # significant variables
plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")  # plot variable importance

# """Divide data for testing and training data"""
set.seed(3033)
intrain <- createDataPartition(y = svrdata$frci, p= 0.7, list = FALSE)
training <- svrdata[intrain,]
testing <- svrdata[-intrain,]

dim(training)
dim(testing)
anyNA(svrdata)

model <- svm(frci ~ . , training)
predictedY <- predict(model, testing)

error <- testing$frci - predictedY 
svrPredictionRMSE <- rmse(error)

tuneResult <- tune(svm, frci ~ .,  data = training,
                   ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))

# """Tune Model from SVR result"""
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

setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/') #---------------------- After running
write.xlsx(clean_dframe, file = "FRCI_LINE6_7_75.14.xlsx")
write.csv(clean_dframe, file = "FRCI_LINE6_7_75.14.csv")
