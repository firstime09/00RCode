library(dplyr)
library(openxlsx)
library(readxl)

setwd('D:/00RCode/Result/')
file <- read_xlsx('580_CIDANAU_190219.xlsx')
dframe <- file[, c("frci", "Band_2", "Band_3", "Band_4", "Band_5", "Band_6", "Band_7")]

#------ Normalizasi dataframe
minMax_norm <- as.data.frame(apply(dframe[,1:7], 2, function(x) (x - min(x))/(max(x) - min(x))))
dfMinMax <- round(minMax_norm, 3)
plot(minMax_norm$Band_4, minMax_norm$frci)
plot(minMax_norm$Band_7, minMax_norm$frci)

normZscore <- as.data.frame(apply(dframe[,1:7], 2, function(x) (x - mean(x))/sd(x)))
dfZscore <- round(normZscore, 3)
plot(normZscore$Band_4, normZscore$frci)
plot(normZscore$Band_7, normZscore$frci)

writeDF1 <- write.xlsx(dfMinMax, file = "CIDANAU580_MinMax.xlsx")
writeDF2 <- write.xlsx(dfZscore, file = "CIDANAU580_Zscore.xlsx")
