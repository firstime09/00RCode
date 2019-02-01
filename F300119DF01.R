# Boruta algorithm for feature selection
library(Boruta)
library(openxlsx)
library(readxl)
library(dplyr)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/') # Set path (directory)
LoadDF <- read_xlsx('New_Cidanau_580.xlsx')
dropDF <- c("FID","Shape","kategori")
dframe <- LoadDF[, !(names(LoadDF) %in% dropDF)] # New dataframe after 
print(dframe)

FS <- Boruta(dframe, dframe$frci)
plot(FS)
New_DF_xlsx <- write.xlsx(dframe, file = "Nama_File.xlsx")