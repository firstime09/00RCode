install.packages("dplyr")
library(readxl)

dframe <- read_excel('C:/Users/Felix/Dropbox/FORESTS2020/00AllData/Data_1048_Yoga.xlsx')
#print(dframe)
Value <- min(table(dframe$Class))
NewDF <- dframe %>% group_by(Class)