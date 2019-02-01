library(openxlsx)
library(readxl)
library(dplyr)

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/')
# Load dataFrame
#dframe <- read_xlsx('New_Cidanau_580_290119.xlsx')
dframe01 <- read_xlsx('30001_Cidanau_580_NEW.xlsx')
print(dframe01)
plot(dframe$Band_4, dframe$frci)

DF_B4 <- remove_outliers(dframe01$Band_4)
addDF0 <- (dframe01["Band_4New"] = DF_B4)
New_Df_XlX <- write.xlsx(dframe, file = "30001_Cidanau_01.xlsx")
