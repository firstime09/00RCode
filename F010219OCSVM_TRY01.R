library(e1071)
library(openxlsx)
library(magrittr)
library(bindrcpp)
library(readxl)
library(dplyr)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('0402CIDANAU_1037.xlsx')
dropsDF <- c("FID","Shape","kategori")

NewDF <- dframe[ , !(names(dframe) %in% dropsDF)]
dfy <- (NewDF$frci)
dfx_B3 <- (NewDF$Band_3)
dfx_B4 <- (NewDF$Band_4)
dfx_B5 <- (NewDF$Band_5)
dfx_B6 <- (NewDF$Band_6)
dfx_B7 <- (NewDF$Band_7)

model <- svm(dfx_B5, dfy, type = 'one-classification', kernel = "radial")
pred <- predict(model, NewDF$Band_5)
get_index <- predict(model)

addDF <- (NewDF["New_B5"] = get_index)

NewDF00 <- NewDF %>% filter[ !((NewDF$New_B3 == FALSE) & (NewDF$New_B4 == FALSE) & (NewDF$New_B6 == FALSE)), ]
DFNew <- NewDF[ !(NewDF$New_B3 %in% c(FALSE)), ] # Drop row in dataframe

setwd('D:/00RCode/Result')
New_Df_XlX <- write.xlsx(NewDF, file = "0402CIDANAU_1037.xlsx")
