library("readxl", "openxlsx", "dplyr")

func_B3 <- function(dt){
  hit <- ((-135.56*(dt**2)) - 3.129*(dt) + 1.4912)
  return(hit)
}

func_B4 <- function(dt){
  hit <- 305.58*(dt**2) - 51.035*(dt) + 2.2449
  return(hit)
}

func_B6 <- function(dt){
  hit <- ((-8.4326*(dt**2)) - 2.0884*(dt) + 1.0687)
  return(hit)
}

func_B7 <- function(dt){
  hit <- 53.379*(dt**2) - 16.887*(dt) + 1.405
  return(hit)
}

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Cidanau/') #---- load data path
loadDF <- read_xlsx('Data_1048_Yoga.xlsx')
dframe <- loadDF[-c(1,2,4,6,13)]

minclass <- table(dframe$Class)
minclss <- min(minclass)
NewDF <- dframe %>% group_by(Class) %>% sample_n(minclss) #---- Balencing dataframe
plot(NewDF$Band_4, NewDF$frci)

dfx <- NewDF[, c("Band_2","Band_3","Band_4","Band_5","Band_6","Band_7")]
dfy <- NewDF["frci"]

get_index11 <- func_B3(NewDF$Band_3)
get_index12 <- func_B4(NewDF$Band_4)
get_index13 <- func_B6(NewDF$Band_6)
get_index14 <- func_B7(NewDF$Band_7)
get_index2 <- rbf.gauss(dframe$Band_4)
addDF <- (NewDF["New2_B3"] = get_index11)
addDF <- (NewDF["New2_B4"] = get_index12)
addDF <- (NewDF["New2_B6"] = get_index13)
addDF <- (NewDF["New2_B7"] = get_index14)
plot(NewDF$New2_B7, NewDF$frci)

setwd('D:/00RCode/Result') #---- saved data path
writeDF <- write.xlsx(NewDF, file = "580_CIDANAU_190219N.xlsx")

#------------------------------------------------------------------ Plot and bloxpot
par(mfrow = c(1,2))
plot(loadDF$B2corr, loadDF$frci5m)
boxplot(loadDF$B2corr)
plot(loadDF$B3corr, loadDF$frci5m)
boxplot(loadDF$B3corr)
plot(loadDF$B4corr, loadDF$frci5m)
boxplot(loadDF$B4corr)
plot(loadDF$B5corr, loadDF$frci5m)
boxplot(loadDF$B5corr)
plot(loadDF$B6corr, loadDF$frci5m)
boxplot(loadDF$B6corr)
plot(loadDF$B7corr, loadDF$frci5m)
boxplot(loadDF$B7corr)