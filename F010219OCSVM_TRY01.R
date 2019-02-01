library(e1071)
library(openxlsx)
library(readxl)
library(dplyr)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('New_Cidanau_580.xlsx')
print(dframe)

dfx <- (dframe$Band_4)
dfy <- (dframe$frci)

modelSVM <- svm(dfx, dfy, type = 'one-classification')
pred <- predict(modelSVM, dframe$Band_4)
get_index <- predict(modelSVM)

addDF <- (dframe["OCSVM"] = get_index)
NewDF <- dframe[ !(dframe$OCSVM %in% c(FALSE)), ]

setwd('D:/00RCode/Result') # Path for save result
New_DF_xlsx <- write.xlsx(NewDF, file = "Cidanau_Try01_OCSVM.xlsx")
