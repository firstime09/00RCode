install.packages("xlsx")
library("readxl")
library("dplyr")
library("openxlsx")

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
# Load dataFrame
dframe0 <- read_xlsx('Cidanau_Remove_Outlyr_From1048-to-416.xlsx')

addDF0 <- (dframe0["Persen"] = dframe0$frci*100)
test <- replace(addDF0$Persen)
print(addDF0)

#dropsDF <- c("Band_1","Band_9","%_CC5","sfCCID","Bangunan","Badan_Air")
dropsDF <- c("Band_4New")
#dropsDF <- c("BTS_Bawah","BTS_Atas","Mean_B4","Std_B4","X__1","X__2")
dropDF <- dframe0[ , !(names(dframe0) %in% dropsDF)]
print(dropDF)

value <- min(table(dframe0$Class)) # For to know frekuensi values
newData <- dframe0 %>% group_by(Class) %>% sample_n(value) # Random new Data Frame
# New_Df_CSV <- write.csv2(newData, file="Cidanau_New_DF.csv") # Save new Data Frame
New_Df_XlX <- write.xlsx(newData, file = "Cidanau_Remove_Outlyr_From416-to-380.xlsx")
