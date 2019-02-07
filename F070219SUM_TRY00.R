library(readxl)
library(openxlsx)
library(e1071)
library(dplyr)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/')
dframe <- read_xlsx('Data_Sumatra_LINE14.xlsx')
NewDF <- dframe %>% select(frci_5m, Band_2, Band_3, Band_4, Band_5, Band_6, Band_7)
dfx_B4 <- NewDF$Band_4
dfy <- NewDF$frci_5m
print(NewDF)

model <- svm(dfx_B4, dfy, type = 'one-classification', kernel = "radial")
pred <- predict(model, NewDF$Band_4)
get_index <- predict(model)

addDF <- (NewDF["New_B4"] = get_index)
DFRemove <- NewDF[ !(NewDF$New_B4 %in% c(FALSE)), ]
New_Df_XlX <- write.xlsx(DFRemove, file = "Sumatra_Line14_Try01.xlsx")
