# Second Step
library(openxlsx)
library(readxl)
library(dplyr)

#----- Load new dataframe
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe00 <- read_xlsx('Cidanau_Remove_Outlyr_Try01.xlsx')

##----- for test new dataframe
value <- min(table(dframe00$Class))
newData <- dframe00 %>% group_by(Class) %>% sample_n(value)

New_Df_XlX <- write.xlsx(newData, file = "Cidanau_Remove_Outlyr_New.xlsx")