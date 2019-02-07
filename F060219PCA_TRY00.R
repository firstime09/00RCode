library(readxl)
library(openxlsx)
library(dplyr)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
dfx <- dframe %>% select(Band_2, Band_3, Band_4, Band_5, Band_6, Band_7)
dfx_B4 <- dfx$Band_4
dfy <- dframe$frci

pca <- prcomp(dfx_B4, scale. = TRUE)
dataPCA <- pca$x
DFPCA <- data.frame(dataPCA, dfy)
setwd('D:/00RCode/Result')
New_Df_XlX <- write.xlsx(dataPCA, file = "Cidanau_PCA.xlsx")

plot(pca$x, pch = 20, col = c(rep("red", 33), rep("blue", 99)))

par(mfrow=c(1,2))
plot(dframe$Band_4, dframe$frci)
plot(dataPCA)
