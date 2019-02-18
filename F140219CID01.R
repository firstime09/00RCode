# Test data CIDANAU 14022019
library(dplyr)
library(e1071)
library(openxlsx)
library(readxl)

setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/Dataframe Cidanau/')
dframe <- read_xlsx('Data_1048_Yoga.xlsx')
selectDF <- dframe %>% select(Class, frci, Band_2, Band_3, Band_4, Band_5, Band_6, Band_7)
dfx <- dframe$Band_4
dfy <- dframe$frci

#--------------lof & KMeans--------------
a <- cbind(dfx,dfy)
NewDF <- data.frame(dfx, dfy)
lof <- lof(cbind(a), k=5)
summary(lof)

kresult <- kmeans(dfx, centers = 10)
reslt <- kresult$centers
reslt <- c(reslt)
newdata <- NewDF[ !(NewDF$dfx %in% c(reslt)), ]
##--- Remove specific row in dataframe 
NewDF1 <- NewDF %>% filter[ !(NewDF$dfx == reslt), ]
NewDF2 <- NewDF[ !(NewDF$dfx %in% reslt), ]
NewDF3 <- NewDF %>% group_by(dfx) %>% sample_n(reslt)
NewDF4 <- NewDF %>% filter(dfx==reslt)
NewDF5 <- NewDF[!NewDF$dfx==reslt,]
NewDF6 <- filter(NewDF, !(dfx %in% reslt))

#-----------------lm---------------------
pred1 <- lm(exp(dfy)~exp(dfx))
pred2 <- lm(dfy~dfx)
model <- svm(dfx, dfy, type = 'one-classification', kernel = "radial")
pred3 <- predict(model, dfx) 

print(summary(pred1))
print(summary(model))

ggplot(result, aes(x = x, y = fitted)) + theme_bw() +
  geom_point(data = xy, aes(x = x, y = y)) +
  geom_line(aes(colour = model), size = 1)

plot(selectDF$Band_4, selectDF$frci, col = "blue")
plot(log())
abline(pred1, col = 2, lwd = 3)
abline(pred2, col = "red", lwd = 2)
