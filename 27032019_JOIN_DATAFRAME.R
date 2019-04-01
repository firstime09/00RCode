library(openxlsx)
library(dplyr)
library(readxl)

# setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
# file1 <- read.csv('Cidanau_NN_130319.csv')
# head(file1)
# delColumn <- file1[-c(1,9)]
# 
# write.xlsx(delColumn, file = 'Cidanau_NN_130319.xlsx')

##---- Gabung DataFrame
setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
df1 <- read_xlsx('Cidanau_NN_130319.xlsx')
head(df1)
df2 <- read_xlsx('FRCI_LINE6_7_75.14.xlsx')
head(df2)
delcoll <- df2[-8]
head(delcoll)

join_df <- full_join(df1, delcoll)
View(join_df)
write.xlsx(join_df, file = 'Cidanau_LINE_6_7_NEW.xlsx')

#---- Plot data CIDANAU 25/03-2019
setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
loaDF <- read_excel('Cidanau_Join_LINE6_61.18.xlsx')
