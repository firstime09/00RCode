library(e1071)
library(openxlsx)
library(readxl)
library(dplyr)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
dropsDF <- c("FID","Shape","kategori")

NewDF <- dframe[ , !(names(dframe) %in% dropsDF)]
dfy <- (NewDF$frci)
dfx_B3 <- (NewDF$Band_3)
dfx_B4 <- (NewDF$Band_4)
dfx_B7 <- (NewDF$Band_7)

model <- svm(dfx_B7, dfy, type = 'one-classification', kernel = "radial")
pred <- predict(model, NewDF$Band_7)
get_index <- predict(model)

addDF <- (NewDF["New_B7"] = get_index)
DFNew <- NewDF[ !(NewDF$New_B3 %in% c(FALSE)), ]
