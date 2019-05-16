## ------- Test Hitung Nilai Entropy dan Energy dari Data Gabungan
library(openxlsx)
library(readxl)
library(dplyr)

f_NDVI <- function(f_NIR, f_RED){
  a <- f_NIR - f_RED
  b <- f_NIR + f_RED
  c <- a/b
  return(c)
}

f_NDWI <- function(f_NIR, f_SWIR){
  a <- f_NIR - f_SWIR
  b <- f_NIR + f_SWIR
  c <- a/b
  return(c)
}

f_EVI <- function()

setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
loadDF <- read_excel('Cidanau_Join_LINE6_61.18.xlsx')
head(loadDF)

a <- f_NDVI(loadDF$Band_5, loadDF$Band_4)

NDVI <- ((loadDF$Band_5 - loadDF$Band_4)/(loadDF$Band_5 + loadDF$Band_4))
add_Coll <- (loadDF["NDVI"] = round(a, 3))


saved_dataframe <- write.xlsx(loadDF, file = 'Cidanau_Join_LINE6_61.18_NEW.xlsx')
