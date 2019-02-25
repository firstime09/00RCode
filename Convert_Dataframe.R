library(openxlsx)
library(readxl)
library(dplyr)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/Data FRCI Window Area_Malta')
# loadDF_csv <- read.csv('FRCI_Line_7.csv')
# head(loadDF_csv)
loadDF_xls <- read.csv('FRCI_Line_7.csv')
head(loadDF_xls)
colnames(loadDF_xls)[which(names(loadDF_xls) == "B1corr")] <- "Band_1"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B2corr")] <- "Band_2"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B3corr")] <- "Band_3"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B4corr")] <- "Band_4"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B5corr")] <- "Band_5"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B6corr")] <- "Band_6"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B7corr")] <- "Band_7"
colnames(loadDF_xls)[which(names(loadDF_xls) == "B9corr")] <- "Band_9"

## Condition if data csv
loadDF_xls$frci <- loadDF_xls$frci_5m
head(loadDF_xls)
loadDF_xls$Class <- loadDF_xls$Kelas
head(loadDF_xls)
rmcoll_csv <- loadDF_xls[,-c(1,2,3,4,5,6,7,8,9,10)]

dfx <- rmcoll_csv[, -c(9,10)]
dfy <- rmcoll_csv[, -c(1,2,3,4,5,6,7,8)]
df <- data.frame(dfy, dfx)

## Condition if data xls
# loadDF_xls$frci <- loadDF_xls$frci5m
# head(loadDF_xls)
# loadDF_xls$Class <- loadDF_xls$CLASS
# head(loadDF_xls)
# rmcoll_xls <- loadDF_xls[,-c(1,2,3,4,5,6,15,16)]
# 
# dfx <- rmcoll_xls[, -c(9,10)]
# dfy <- rmcoll_xls[, -c(1,2,3,4,5,6,7,8)]
# df <- data.frame(dfy, dfx)

setwd('D:/00RCode/Result/Data Sumatera/')
savefile <- write.xlsx(df, file = 'FRCI_Line_7.xlsx')
