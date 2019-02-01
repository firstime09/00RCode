library(readxl)
library(openxlsx)
library(dplyr)

remove_outliers <- function(x, na.rm = TRUE, ...){
  qnt <- quantile(x, probs = c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

#----- Load new dataframe
setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/') # Path for load Data
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
print(dframe)

rm_outlyr <- remove_outliers(dframe$Band_4NN) # remove outliers in dataframe
addDF <- (dframe["Band_43"] = rm_outlyr)

dropCol <- c("FID", "Shape", "kategori", "Band_1", "Band_9", "Band_4N", "Band_4NN") # Drop row and column on dataframe
dropDF <- dframe[ , !(names(dframe) %in% dropCol)]
NewDF <- dropDF[ !(dropDF$Band_43 %in% c(NA)), ]

value <- min(table(NewDF$Class))
dropCol <- c("Band_43")
dropDF <- NewDF[ , !(names(NewDF) %in% dropCol)]
newDF <- NewDF %>% group_by(Class) %>% sample_n(value)

setwd('D:/00RCode/Result') # Path for save result
New_DF_xlsx <- write.xlsx(newDF, file = "Cidanau_Try02.xlsx")
