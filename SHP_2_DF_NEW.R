#import required libraries
library(raster)
library(rgdal)
library(dplyr)
library(readxl)
library(openxlsx)

setwd('E:/Data_Landsat8_Metric_2018_Sum/E104S02/TOA_FILE/New folder/')
# load_shpfile <- shapefile("FRCI_Line_7.shp")
load_shpfile <- read_xlsx('CIDANAU_LINE6_BALANCE_160719.xlsx')
shp_2_df <- data.frame(load_shpfile)
# shp_2_df <- load_shpfile
head(shp_2_df)

select_df <- shp_2_df[, c("frci_5m", "Kelas", "B2corr", "B3corr", "B4corr",
                          "B5corr", "B6corr", "B7corr")]

# select_df <- shp_2_df[, c("frci_5m", "kelas", "B2corr", "B3corr", "B4corr",
#                           "B5corr", "B6corr", "B7corr")]

colnames(select_df)[which(names(select_df) == "frci_5m")] <- "frci5m"
colnames(select_df)[which(names(select_df) == "Kelas")] <- "Class"
colnames(select_df)[which(names(select_df) == "B2corr")] <- "Band_2"
colnames(select_df)[which(names(select_df) == "B3corr")] <- "Band_3"
colnames(select_df)[which(names(select_df) == "B4corr")] <- "Band_4"
colnames(select_df)[which(names(select_df) == "B5corr")] <- "Band_5"
colnames(select_df)[which(names(select_df) == "B6corr")] <- "Band_6"
colnames(select_df)[which(names(select_df) == "B7corr")] <- "Band_7"
head(select_df)


number <- select_df %>% group_by(Class) %>% summarize(n())
number
sample <- select_df %>% group_by(Class) %>% sample_n(min(number$`n()`))
min(table(sample$Class))

head(sample)
savefile <- write.xlsx(select_df, file = 'Data_LINE6_160719.xlsx')
savefile <- write.xlsx(sample, file = 'Data_LINE7_160719_BALANCE.xlsx')
