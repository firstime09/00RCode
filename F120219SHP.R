# library(rgdal)
# library(sf)
library(openxlsx)
library(readxl)
library(dplyr)
library(e1071)
library(rpart)
library(raster)

setwd('D:/Pegunungan/')
# fileSHP <- shapefile("DT.shp")
# shptoDF <- data.frame(fileSHP)
loadDF <- read_xlsx('Pegunungan_Sumatera.xlsx')
dframe <- loadDF[, c("Class", "frci5m", "B2corr", "B3corr", "B4corr", "B5corr", "B6corr", "B7corr")]
# dframe <- loadDF %in% select(frci5m, B2corr, B3corr, B4corr, B5corr, B6corr, B7corr, Class)
head(dframe)

value <- min(table(dframe$Class)) # For to know frekuensi values


setwd('D:/00RCode/Result/')
write.xlsx(dframe, file = "Pegunungan_Sumatera.xlsx")