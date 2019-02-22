library(readxl)
library(openxlsx)
library(dplyr)

setwd('D:/00RCode/Result/')
file1 <- read.xlsx('CIDANAU580_MinMax.xlsx')
file2 <- read.xlsx('CIDANAU580_Zscore.xlsx')
dfx <- file1[, c("Band_2", "Band_3", "Band_4", "Band_5", "Band_6", "Band_7")]
dfy <- file1[, c("frci")]
dfxy <- file1[, c("Band_7", "frci")]
dfyx <- file1[, c("frci", "Band_7")]

set.seed(1)
fileCluster <- kmeans(dfx$Band_7, 5, nstart = 1)
class <- fileCluster$cluster
addDF <- (file1["New_Class"] = class)
NewDF1 <- file1[ !(file1$New_Class %in% c(1)), ]

value <- min(table(NewDF1$Class))

plot(file1$Band_7)
plot(file1$Band_7, col = fileCluster$cluster, title("Center = 3, Nstart = 10"))

plot(file1$Band_7, file1$frci)

setwd('D:/00RCode/Result/')
New_Df_XlX <- write.xlsx(NewDF1, file = "CIDANAU580_MinMax_KMEANS.xlsx")
