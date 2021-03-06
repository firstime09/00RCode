library(dbscan)
library(openxlsx)
library(readxl)
library(dplyr)
library(e1071)
library(Boruta)
library(caret)
library(raster)
library(dismo)

normZ <- function(x){
  prt1 <- (x - mean(x))
  prt2 <- prt1/sd(x)
  return(prt2)
}

rmse <- function(error)
{
  sqrt(mean(error^2))
}

rbf.gauss <- function(gamma=1.0) {
  
  function(x) {
    exp(-gamma * norm(as.matrix(x),"F")^2 )
  }
}

func <- function(x){
  x0 <- x
  x1 <- x**2
  x2 <- (287.59 * (x1) - 50.846 * (x) + 2.3296)
  return(x2)
}

#-------------------------------------------------------------------------- DATA SUMATERA
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Sumatra/')
file1 <- read_xlsx('Pegunungan_Sumatera.xlsx')
#--------------------------------------------------------------------------- DATA CIDANAU
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Cidanau/')
setwd('D:/00RCode/Result/')
file <- read_xlsx('Cidanau_Data_300Yoga.xlsx')
file2 <- read_xlsx('CIDANAU580_MinMax.xlsx') #-------------- Data Normalisasi Min_Max
#----------------------------------------------------------- Load and Selection Dataframe
dframe <- file[, c(5,7,8,9,10,11,12)]
dfx <- file2[, c("Band_2", "Band_3", "Band_4", "Band_5", "Band_6", "Band_7")]
dfy <- file2[, c("frci")]
dfxy <- file2[, c("Band_7", "frci")]
dfyx <- file2[, c("frci", "Band_7")]
#----------------------------------------------------------------------------------------
get_index1 <- func(dframe$Band_4)
get_index2 <- rbf.gauss(dframe$Band_4)
addDF <- (dframe["New2_B4"] = get_index2(dframe$Band_4))
#------------------------------------------------------------------------------- DBSCAN 1
kNNdistplot(dfx, k = 5)
abline(h=.05, col = "red", lty=2)
res <- dbscan(dfx, eps = .015, minPts = 5)
pairs(dfx, col = res$cluster + 1L)
dframe$cluster <- res$cluster #----- add res$cluster in dataframe
clean <- dframe %>% filter(cluster > 0)
par(mfrow=c(1,2)) #----- Divide 2 column Plots
plot(clean$Band_4, clean$frci)

#------------------------------------------------------------------------------ 21/02-2019
set.seed(25)
fileCluster <- kmeans(dfyx, 3, iter.max = 10, nstart = 25)
fileCluster
dfCluster1 <- data.frame(file$frci, file$Band_4, irisCluster$cluster)
dfCluster2 <- data.frame()

plot(file$Band_7, title("Band_7"))
plot(file$Band_7, col = fileCluster$cluster, title("Center = 3, Nstart = 10"))

plot(file$Band_7, title("dfxy"))
plot(dfyx, col = fileCluster$cluster, title("Center = 3, Nstart = 25"))

#------------------------------------------------------------------------------ 22/02-2019
pca_test1 <- prcomp(dfx, scale. = FALSE)
pca_test2 <- prcomp(dfx, scale. = TRUE)
summary(pca_test1)

loadDF_PCA1 <- pca_test1$x
a <- round(loadDF_PCA1, 3)
dfPCA1 <- data.frame(dfy, a)

loadDF_PCA2 <- pca_test2$x
b <- round(loadDF_PCA2, 3)
dfPCA2 <- data.frame(dfy, b)

#------------------------------------------------------------------------------ 25/02-2019
set.seed(25)
kNNdistplot(dfx, k = 5)
abline(h=.10, col = "red", lty=2)

dbfilter <- dbscan(dfx, eps = .10, minPts = 5)
dbfilter
pairs(dfx, col = dbfilter$cluster + 1L)
file2$cluster <- dbfilter$cluster
cleanall <- file2 %>% filter(cluster > 0)

par(mfrow=c(1,2))
plot(file2$Band_4, file2$frci)
plot(cleanall$Band_4, cleanall$frci)

plot(file2$Band_7, file2$frci)
plot(cleanall$Band_7, cleanall$frci)

#------------------------------------------------------------------------------ 25/02-2019
#------------------------------------------------------------------------------ SVR Model
## Data Selection and Split data train and test
set.seed(3033)
intrain <- createDataPartition(y = cleanall$frci, p= 0.7, list = FALSE)
training <- cleanall[intrain,]
testing <- cleanall[-intrain,]

## Model and Prediction data training, testing
model <- svm(frci ~ . , training)
predictedY <- predict(model, testing)

error <- testing$frci - predictedY  # 
svrPredictionRMSE <- rmse(error)  #  


setwd('D:/00RCode/Result/')
write_xlsx <- write.xlsx(cleanall, file = "Cidanau_MinMax_DBSCAN.xlsx")


