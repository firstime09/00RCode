#--------- Select dataframe and remove based Minimum Class
library(readxl)
library(openxlsx)
library(dplyr)

Entropy <- function(vls){
  prop <- vls/sum(vls)
  res <- prop * log2(prop)
  res[vls==0] <- 0
  a <- -(sum(res))
  return(a)
}

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Cidanau/') #---- load data path
loadDF <- read_xlsx('Data_1048_Yoga.xlsx')
dframe1 <- loadDF[, c("Class", "frci5m", "B2corr", "B3corr", "B4corr", "B5corr", "B6corr", "B7corr")]
plot(dframe1$B4corr, dframe1$frci5m)
dframe2 <- loadDF[, c("Class", "frci", "Band_2", "Band_3", "Band_4", "Band_5", "Band_6", "Band_7")]
plot(dframe2$Band_4, dframe2$frci)

minclass <- table(dframe2$Class)
minclss <- min(minclass)
NewDF <- dframe2 %>% group_by(Class) %>% sample_n(minclss) #---- Balencing dataframe
plot(NewDF$Band_4, NewDF$frci)


setwd('D:/00RCode/Result') #---- saved data path
writeDF <- write.xlsx(NewDF, file = "All_SUMATERA_190219.xlsx")
