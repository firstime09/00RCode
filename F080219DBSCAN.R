library(readxl)
library(openxlsx)
library(DDoutlier)
library(dplyr)
library(dbscan)

# Set path for load dataframe
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/')
dframe <- read_xlsx('DataWA_Line14_Sumatra.xlsx')
dfx <- dframe %>% select(Band_2, Band_3, Band_4, Band_5, Band_6, Band_7)
dfy <- dframe$frci_5m

NewDF <- data.frame(dfy, dfx)

#----- DBSCAN 1
plot(dfx$Band_4, dfy)
clusDBSCAN <- dbscan(dfx, eps = 7, minPts = 10)

#----- LoF (local outlier factor)
