library(dbscan)
library(readxl)
library(dplyr)
library(e1071)
library(Boruta)
library(caret)
library(raster)
library(dismo)

rmse <- function(error)
{
  sqrt(mean(error^2))
}

setwd('E:/00AllResult/00AllData/08102019_All Data CDN Join SMT/')
load_df <- read_xlsx('Line6_Cidanau.xlsx')
head(load_df)
plot(load_df$Band_4, load_df$FRCI, xlab='Band_4', ylab='Frekuensi')

# Round_data <- as.data.frame(lapply(load_df, function(x) round(x, 3)))
Min_Max_scaling <- as.data.frame(lapply(load_df, function(x) round((x-min(x))/(max(x)-min(x)), 3)))
Z_scaling <- Min_Max_scaling
head(Z_scaling)
svrdata <- Z_scaling[,-c(1)]
head(svrdata)

kNNdistplot(svrdata, k = 5)
change_data <- 0.07
abline(h = change_data, col = "red", lty = 2) #------------------- Note
res <- dbscan(svrdata, eps = change_data, minPts = 5)
res
pairs(svrdata, col = res$cluster + 1L)
svrdata$cluster <- res$cluster
cleanall <- svrdata %>% filter(cluster > 0)
par(mfrow=c(1,2))
plot(svrdata$Band_4, svrdata$FRCi)
plot(cleanall$Band_4, cleanall$FRCI)
svrdata <- cleanall[,-c(8)]

# Divide data to training and testing ================================
set.seed(3033)
intrain <- createDataPartition(y = svrdata$FRCI, p= 0.7, list = FALSE)
training <- svrdata[intrain,]
testing <- svrdata[-intrain,]

dim(training)
dim(testing)
anyNA(svrdata)

# svr model ==========================================================
model <- svm(FRCI ~ . , training)
predictedY <- predict(model, testing)

error <- testing$FRCI - predictedY
svrPredictionRMSE <- rmse(error)

df <- data.frame(testing$FRCI, predictedY)
y_actual <- mean(df$testing.FRCI)
ss_tot <- sum((df$testing.FRCI - y_actual)^2)
ss_reg <- sum((df$predictedY - y_actual)^2)
ss_res <- sum((df$testing.FRCI - df$predictedY)^2)
RSquared <- (1 - (ss_res/ss_tot))

setwd("E:/00AllResult/00AllData/02102019_All Data CDN Join SMT/") #=== After running
write.xlsx(cleanall, file = "Cidanau_Line6_87_12.xlsx")
