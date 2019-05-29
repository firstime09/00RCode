#import required libraries
library(raster)
library(rgdal)
library(dplyr)
library(readxl)
library(openxlsx)

setwd('D:/TIFF DATA/[28-05-2019] All Data/SUMSEL/YOGA/(-6) Sebelum/')
load_shpfile <- shapefile("WA_LINE_14_15_SEBELUM.shp")
shp_2_df <- data.frame(load_shpfile)
head(shp_2_df)

# select_df <- shp_2_df[, c("frci_5m", "Kelas", "b2_L8_SMT_", "b3_L8_SMT_", "b4_L8_SMT_",
#                           "b5_L8_SMT_", "b6_L8_SMT_", "b7_L8_SMT_")]

select_df <- shp_2_df[, c("frci5m", "Class", "b2_SBL_L8_", "b3_SBL_L8_", "b4_SBL_L8_",
                          "b5_SBL_L8_", "b6_SBL_L8_", "b7_SBL_L8_")]

colnames(select_df)[which(names(select_df) == "Class")] <- "Class"
colnames(select_df)[which(names(select_df) == "b2_SBL_L8_")] <- "Band_2"
colnames(select_df)[which(names(select_df) == "b3_SBL_L8_")] <- "Band_3"
colnames(select_df)[which(names(select_df) == "b4_SBL_L8_")] <- "Band_4"
colnames(select_df)[which(names(select_df) == "b5_SBL_L8_")] <- "Band_5"
colnames(select_df)[which(names(select_df) == "b6_SBL_L8_")] <- "Band_6"
colnames(select_df)[which(names(select_df) == "b7_SBL_L8_")] <- "Band_7"
head(select_df)

number <- select_df %>% group_by(Class) %>% summarize(n())
number
sample <- select_df %>% group_by(Class) %>% sample_n(min(number$`n()`))
min(table(sample$Class))

head(sample)
savefile <- write.xlsx(select_df, file = 'SEBELUM_DATA_LINE_14_15_SUMSEL.xlsx')
savefile <- write.xlsx(sample, file = 'SEBELUM_LINE_14_15_SUMSEL_BALANCE.xlsx')
