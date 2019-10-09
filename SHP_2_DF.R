library(openxlsx)
library(readxl)
library(dplyr)
library(raster)
library(foreign)

class_data <- function(data){
  if(data >= 1){sprintf("%f", 10)}
  else if(data <= 0.9){sprintf("%f", 9)}
  else if(data <= 0.8){sprintf("%f", 8)}
  else if(data <= 0.7){sprintf("%f", 7)}
  else if(data <= 0.6){sprintf("%f", 6)}
  else if(data <= 0.5){sprintf("%f", 5)}
  else if(data <= 0.4){sprintf("%f", 4)}
  else if(data <= 0.3){sprintf("%f", 3)}
  else {sprintf("%f", 2)}
}

setwd('D:/TIFF DATA/New DataFrame/Cidanau 13052019/')
load_file_SHP <- read.dbf('CIDANAU_TEST_01.dbf')
head(load_file_SHP)
# shp2df <- data.frame(load_file_SHP)

select_data <- load_file_SHP[, c(1,2,4,5,6,7,8,9)]
new_df <- data.frame(select_data)
head(new_df)
colnames(new_df)[which(names(new_df) == "b2_L8_CIDA")] <- "Band_2"
colnames(new_df)[which(names(new_df) == "b3_L8_CIDA")] <- "Band_3"
colnames(new_df)[which(names(new_df) == "b4_L8_CIDA")] <- "Band_4"
colnames(new_df)[which(names(new_df) == "b5_L8_CIDA")] <- "Band_5"
colnames(new_df)[which(names(new_df) == "b6_L8_CIDA")] <- "Band_6"
colnames(new_df)[which(names(new_df) == "b7_L8_CIDA")] <- "Band_7"
View(new_df)

savefile <- write.xlsx(new_df, file = 'CIDANAU_NEW.xlsx')
