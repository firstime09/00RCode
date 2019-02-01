# First Step
library(openxlsx)
library(readxl)
library(dplyr)

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

#----- drop some columns in dataframe
dropsDF <- c("FID", "Shape", "kategori", "Band_1", "Band_9")
NewDF <- dframe00[ , !(names(dframe00) %in% dropsDF)]
#----- Balancing data based on the smallest class
value <- min(table(NewDF$Class)) # For to know frekuensi values
newData <- NewDF %>% group_by(Class) %>% sample_n(value) # Random new Data Frame

DF_B4 <- remove_outliers(newData$Band_4)
addDF0 <- (newData["Band_4New"] = DF_B4) # New columns for add the DF_B4
New_Df_XlX <- write.xlsx(newData, file = "Cidanau_Remove_Outlyr.xlsx")
