#import required libraries
library(raster)
library(rgdal)
library(dplyr)
library(readxl)
library(openxlsx)

setwd('D:/TIFF DATA/New DataFrame/Sumatera 15052019/SHP/WINDOW AREA/')
load_shpfile <- shapefile("WA_LINE_14_15_SESUDAH.shp")
shp_2_df <- data.frame(load_shpfile)
head(shp_2_df)

# select_df <- shp_2_df[, c("frci5m", "Class", "b2_L8_SMT_", "b3_L8_SMT_", "b4_L8_SMT_",
#                           "b5_L8_SMT_", "b6_L8_SMT_", "b7_L8_SMT_")]

select_df <- shp_2_df[, c("frci5m", "Class", "b2_SSD_L8_", "b3_SSD_L8_", "b4_SSD_L8_",
                          "b5_SSD_L8_", "b6_SSD_L8_", "b7_SSD_L8_")]

colnames(select_df)[which(names(select_df) == "Class")] <- "Class"
colnames(select_df)[which(names(select_df) == "b2_SSD_L8_")] <- "Band_2"
colnames(select_df)[which(names(select_df) == "b3_SSD_L8_")] <- "Band_3"
colnames(select_df)[which(names(select_df) == "b4_SSD_L8_")] <- "Band_4"
colnames(select_df)[which(names(select_df) == "b5_SSD_L8_")] <- "Band_5"
colnames(select_df)[which(names(select_df) == "b6_SSD_L8_")] <- "Band_6"
colnames(select_df)[which(names(select_df) == "b7_SSD_L8_")] <- "Band_7"

number <- select_df %>% group_by(Class) %>% summarize(n())
number
sample <- select_df %>% group_by(Class) %>% sample_n(min(number$`n()`))
min(table(sample$Class))

head(select_df)
savefile <- write.xlsx(select_df, file = 'WA_Line_14_15_Sesudah_SMT.xlsx')
