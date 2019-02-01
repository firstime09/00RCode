library(dplyr)
library(openxlsx)
library(readxl)

# Load Data Frame
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/')
dframe <- read_xlsx('New_Cidanau_580_290119.xlsx')

Mean_DF <- mean(dframe$Band_4) # Select the specific column to find Mean
Std_DF <- sd(dframe$Band_4) # Select the specific column to find Std
X1 <- Mean_DF + Std_DF
X2 <- Mean_DF - Std_DF
addDF <- (dframe["Value_X1"] = NA)

for (i in 1:length(dframe$Band_4)){
  #print(i)
  if (dframe$Band_4[i] >= X1){
    dframe$Band_4Value[i] <- 0
  }else{
    dframe$Band_4Value[i] <- 1
  }
}
boxplot(dframe)