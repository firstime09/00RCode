library(tseries)
library(caret)
library(ggplot2)
library(raster)
#memasukkan data
data <- read.delim("clipboard")
attach(data)
#cek nama data
names(data)

data_new<-read_excel("E:/Data Canopy Cover.xlsx")

#Pembuatan model Regresi Linear
mod7 <- lm(FRCI ~ Band_7)
summary(mod7)
plot(Band_7, FRCI)
abline(mod7, col = 2, lwd = 3)

#Data Testing
data1 <- read.delim("clipboard")
names(data1)
test <- data1[c(2,10)]

#Nilai Prediction data continues
prediction2 <- predict(mod7, test)
test
#Nilai Prediction
confusionMatrix(test$Kategori, prediction2)

#Nilai RMSE
rmse<- function(error){
  sqrt(mean(error^2))
}
error<- FRCI - Prediksi

hasilRMSE2 <- rmse(error)


names(data15)
data15 <- read.delim("clipboard")
attach(data15)
data_extra <- data15
extra <- predict(mod7, data_extra)
mod7
rmse<- function(error){
  sqrt(mean(error^2))
}
error <- data_extra$frci - extra

hasilRMSE3 <- rmse(error)


B_7 <- raster("E:/Data Penelitian/Data Lidar/Data LiDAR/BAND LANDSAT/Cidanau/Band 7.img")
extra_pred<-predict(B_7, mod7)
#lokal optimul

Terrain <- read_excel("E:/Data Canopy Cover.xlsx")
