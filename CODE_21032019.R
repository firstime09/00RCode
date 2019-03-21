library(openxlsx)
library(dplyr)
library(readxl)

rMSE <- function(actual, pred, data){
  square <- (pred - actual)**2
  rootMSE <- sqrt(sum(square)/data)
  return(rootMSE)
}

setwd('D:/GitHub/GitTesis/SVR/Report/')
loadDF <- read.xlsx('predict_data_analisis.xlsx')
head(loadDF)
summary(loadDF)

New_Coll <- loadDF$Prediksi - loadDF$frci
add_New_Coll <- (loadDF["Pred-Frci"] = New_Coll)

#----- Sort data based class from lower to upper
arrange_data <- arrange(loadDF, class)
head(arrange_data)
K1 <- min(table(arrange_data$kategori == 'Sangat Rendah'))
data_K1 <- arrange_data %>% filter(kategori=='Sangat Rendah')

K2 <- min(table(arrange_data$kategori == 'Rendah'))
data_K2 <- arrange_data %>% filter(kategori=='Rendah')

K3 <- min(table(arrange_data$kategori == 'Sedang'))
data_K3 <- arrange_data %>% filter(kategori=='Sedang')

K4 <- min(table(arrange_data$kategori == 'Tinggi'))
data_K4 <- arrange_data %>% filter(kategori=='Tinggi')

K5 <- min(table(arrange_data$kategori == 'Sangat Tinggi'))
data_K5 <- arrange_data %>% filter(kategori=='Sangat Tinggi')

jumlah_data <- K1 + K2 + K3 + K4 + K5
total_rmse <- rMSE(arrange_data$frci, arrange_data$Prediksi, jumlah_data)
Sangat_Rendah_rmse <- rMSE(data_K1$frci, data_K1$Prediksi, K1)
Rendah_rmse <- rMSE(data_K2$frci, data_K2$Prediksi, K2)
Sedang_rmse <- rMSE(data_K3$frci, data_K3$Prediksi, K3)
Tinggi_rmse <- rMSE(data_K4$frci, data_K4$Prediksi, K4)
Sangat_Tinggi_rmse <- rMSE(data_K5$frci, data_K5$Prediksi, K5)
