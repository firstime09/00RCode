library(dbscan) ## Algoritma untuk pengelompokan
library(readxl) ## Membaca data excel
library(dplyr) ## Data manipulation
library(e1071) ## Algoritma machine learning
library(Boruta) ## Feature selection
library(caret) ## For data spliting
library(raster) ## For data spatial
library(dismo) ## 

setwd('D:/00RCode/Data/')
load_data <- read_xlsx('Data_CIDANAU_160719.xlsx')
head(load_data)
summary(load_data)

new_data <- load_data[,c(2,3,4,5,6,7,8)]
head(new_data)

## Balencing data based class
number <- load_data %>% group_by(Class) %>% summarize(n())
sample <- load_data %>% group_by(Class) %>% sample_n(min(number$`n()`))
head(sample)

## Ploting Data
plot(load_data)
plot(load_data$Band_4, load_data$frci_5m,
     xlab = 'Band 4 Landsat', ylab = 'First Return Canopy Index')

