library(openxlsx)
library(dplyr)
library(readxl)

##-------------------------------------------------------- Gabung DataFrame
setwd('E:/00AllResult/00AllData/08102019_All Data CDN Join SMT/')
df1 <- read_xlsx('New_Data Canopy Cover.xlsx')
head(df1)
select_coll <- df1[, c("Class", "FRCI", "Band_2", "Band_3", "Band_4",
                       "Band_5", "Band_6", "Band_7")]
head(select_coll)

##
df2 <- read_xlsx('FRCI_Line_6.xlsx')
head(df2)
select_coll_1 <- df2[, c("Class", "FRCI", "Band_2", "Band_3", "Band_4",
                       "Band_5", "Band_6", "Band_7")]
head(select_coll_1)

##
df3 <- read_xlsx('FRCI_Line_6.xlsx')
head(df3)
select_coll_2 <- df3[, c("Class", "frci", "Band_2", "Band_3", "Band_4",
                         "Band_5", "Band_6", "Band_7")]
head(select_coll_2)

##
df4 <- read_xlsx('FRCI_Line_7.xlsx')
head(df4)
select_coll_3 <- df4[, c("Class", "frci", "Band_2", "Band_3", "Band_4",
                         "Band_5", "Band_6", "Band_7")]
head(select_coll_3)

##
df5 <- read_xlsx('FRCI_Line_14_15.xlsx')
head(df5)
select_coll_4 <- df5[, c("Class", "frci", "Band_2", "Band_3", "Band_4",
                         "Band_5", "Band_6", "Band_7")]
head(select_coll_4)
##-----------------------------------------------------------------------

join_df1 <- full_join(select_coll, select_coll_1)
join_df2 <- full_join(join_df1, select_coll_2)
join_df3 <- full_join(join_df2, select_coll_3)
join_df4 <- full_join(join_df3, select_coll_4)
head(join_df4)

f_join <- full_join(join_df_1, join_df_2)
View(f_join)

number <- join_df4 %>% group_by(Class) %>% summarize(n())
number
sample <- join_df4 %>% group_by(Class) %>% sample_n(min(number$`n()`))
min(table(sample$Class))
write.xlsx(join_df1, file = 'Line6_Cidanau.xlsx')
write.xlsx(sample, file = 'AllData_Cidanau_SMT_Balance.xlsx')

#---- Plot data CIDANAU 25/03-2019
setwd('D:/00RCode/Result/Data Sumatera/Data Sumatera No_Normalize/')
loaDF <- read_excel('Cidanau_Join_LINE6_61.18.xlsx')
