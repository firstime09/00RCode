# Try to removing outliers from dataframe 
library(openxlsx)
library(readxl)
library(dplyr)
library(lidR)

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

#----- Load new dataframe
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Cidanau Dataframe/')
dframe00 <- read_xlsx('Data_1048_Yoga.xlsx')
plot(dframe00$Band_4, dframe00$frci)

DF_B4 <- remove_outliers(dframe00$Band_4)
addDF0 <- (dframe00["Band_4New"] = DF_B4)

dropsDF <- c("FID", "Shape", "kategori", "Band_1", "Band_9")
NewDF <- dframe00[ , !(names(dframe00) %in% dropsDF)] # Drop dataframe based columns

NewDF1 <- NewDF[ !(NewDF$Band_4New %in% c(NA)), ] # Drop dataframe based row
NewDF2 <- NewDF %>% filter(class=="Clas_Name_Select")# Select spesific row

value <- min(table(NewDF1$Class)) # For to know frekuensi values
newData <- NewDF1 %>% group_by(Class) %>% sample_n(value)
New_Df_XlX <- write.xlsx(newData, file = "Cidanau_Remove_Outlyr_From1048-to-420.xlsx")
