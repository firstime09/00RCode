library(dplyr)
library(openxlsx)
library(readxl)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
#print(dframe)

dropDF <- dframe[, c(5, 7, 8, 9, 10, 11, 12)] # Lock dataframe
print(dropDF)

Mean_B2 <- mean(dropDF$Band_2)
Std_B2 <- sd(dropDF$Band_2)
Z_Score2 <- (dropDF$Band_2 - Mean_B2)/Std_B2

Mean_B3 <- mean(dropDF$Band_3)
Std_B3 <- sd(dropDF$Band_3)
Z_Score3 <- (dropDF$Band_3 - Mean_B3)/Std_B3

Mean_B4 <- mean(dropDF$Band_4)
Std_B4 <- sd(dropDF$Band_4)
Z_Score4 <- (dropDF$Band_4 - Mean_B4)/Std_B4

Mean_B5 <- mean(dropDF$Band_5)
Std_B5 <- sd(dropDF$Band_5)
Z_Score5 <- (dropDF$Band_5 - Mean_B5)/Std_B5

Mean_B6 <- mean(dropDF$Band_6)
Std_B6 <- sd(dropDF$Band_6)
Z_Score6 <- (dropDF$Band_6 - Mean_B6)/Std_B6

Mean_B7 <- mean(dropDF$Band_7)
Std_B7 <- sd(dropDF$Band_7)
Z_Score7 <- (dropDF$Band_7 - Mean_B7)/Std_B7