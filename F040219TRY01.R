library(dplyr)
library(openxlsx)
library(readxl)
library(bindrcpp)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe <- read_xlsx('0402CIDANAU_1037.xlsx')
print(dframe)

NewDF00 <- dframe %>% filter( !((dframe$New_B3 == FALSE) & 
                                  (dframe$New_B4 == FALSE) & 
                                  (dframe$New_B6 == FALSE) & 
                                  (dframe$New_B7 == FALSE)))
