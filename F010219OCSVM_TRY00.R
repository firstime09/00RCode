library(e1071)
library(openxlsx)
library(readxl)
library(dplyr)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
dfx <- (dframe$Band_4)
dfy <- (dframe$frci)

model <- svm(dfx, dfy, type = 'one-classification', kernel = "radial")
pred <- predict(model, dframe$Band_4)
get_index <- predict(model)

addDF <- (dframe["OCSVM"] = get_index)
NewDF <- dframe[ !(dframe$OCSVM %in% c(FALSE)), ]

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe')
New_DF_xlsx <- write.xlsx(NewDF, file = "Cidanau_010219.xlsx")
