## ------ Make the new dataframe from SHP File
install.packages(c("rgdal", "sf"))
library(rgdal)
library(openxlsx)
library(readxl)
library(dplyr)
library(e1071)
library(rpart)
library(raster)

setwd('F:/All Data Forests2020/26032019_Pavilion/FRCI_6_7/')
fileSHP <- shapefile("FRCI_6_7.shp")
shptoDF <- data.frame(fileSHP)
head(shptoDF)

new_dataframe <- shptoDF[,-c(1,2,4,5,6,7,8,10,17,18,19,20,21,22)]
head(new_dataframe)

#loadDF <- read_xlsx('Pegunungan_Sumatera.xlsx')
#dframe <- loadDF[, c("Class", "frci5m", "B2corr", "B3corr", "B4corr", "B5corr", "B6corr", "B7corr")]
# dframe <- loadDF %in% select(frci5m, B2corr, B3corr, B4corr, B5corr, B6corr, B7corr, Class)
#head(dframe)

min_class <- min(table(new_dataframe$Kelas)) # For to know frekuensi values
dframe <- new_dataframe %>% group_by(Kelas) %>% sample_n(min_class)
head(dframe)

setwd('D:/00RCode/Result/')
write.xlsx(dframe, file = "Pegunungan_Sumatera.xlsx")