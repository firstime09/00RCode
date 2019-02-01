#----- Balancing data based Class
library(readxl)
library(openxlsx)
library(dplyr)

setwd('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/')
setwd('D:/00RCode/Result')
dframe <- read_xlsx('Cidanau_Try03.xlsx')
print(dframe)

dropCol <- c("FID","Shape","kategori")
dropDF <- dframe[ , !(names(dframe) %in% dropCol)]

value <- min(table(dframe$Class)) # Balancing data
newDF <- dframe %>% group_by(Class) %>% sample_n(value)
sort_dataframe <- arrange(newDF)

setwd('D:/00RCode/Result') # Path for save result
New_DF_xlsx <- write.xlsx(newDF, file = "Cidanau_Try03_New.xlsx")
