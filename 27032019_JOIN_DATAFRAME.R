library(openxlsx)
library(dplyr)
library(readxl)

# setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
# file1 <- read.csv('Cidanau_NN_130319.csv')
# head(file1)
# delColumn <- file1[-c(1,9)]
# write.xlsx(delColumn, file = 'Cidanau_NN_130319.xlsx')

##---- Gabung DataFrame
# Load first data.frame
setwd('F:/All Data Forests2020/29032019_Pavilion/DATA NO_NORMALIZE/')
df1 <- read_xlsx('CIDANAU_29032019_68.16.xlsx')
head(df1)

# Load second data.frame
setwd('F:/All Data Forests2020/29032019_Pavilion/DATA NO_NORMALIZE/DATA SUMATERA/Malta_LINE_1_2/')
df2 <- read_xlsx('FRCI_LINE1_74.15.xlsx')
head(df2)
Change_position <- df2[c(7,1,2,3,4,5,6,8)]
df2 <- Change_position
head(df2)

# delcoll <- df2[-8]
# head(delcoll)
join_df <- full_join(df1, df2)
View(join_df)

# Saved NEW data.frame
setwd('F:/All Data Forests2020/00ResultDataFrame/JOIN DATA_FRAME/')
write.xlsx(join_df, file = 'CIDANAU_LINE_1_SUMATERA.xlsx')


# #---- Plot data CIDANAU 25/03-2019
# setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
# loaDF <- read_excel('Cidanau_Join_LINE6_61.18.xlsx')
