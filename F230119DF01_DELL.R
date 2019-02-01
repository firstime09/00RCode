library("openxlsx")
library("dplyr")
library("readxl")

# Load Data Farame
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/')
dframe0 <- read_xlsx('New_Cidanau_580_290119.xlsx')
dfx <- dframe0$Band_4
dfy <- dframe0$frci

# Have two ways for select specific columns in R
Ways01 <- dframe0[, (names(dframe0) %in% c("Band_4"))]
Ways02 <- select(dframe0, Band_4)

Mean_DF <- mean(dframe0$Band_4) # Select the specific column to find Mean
Std_DF <- sd(dframe0$Band_4) # Select the specific column to find Std
X1 <- Mean_DF + Std_DF
X2 <- Mean_DF - Std_DF
data_clean <- dframe0[dframe0$Band_4 >= X1 & dframe0$Band_4 <= X2, ]

plot(dfx, dfy, xlab = 'Band_4', ylab = 'FRCI')
