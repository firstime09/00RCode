library(rgdal)
library(rgeos)
library(yaml)
library(sf)
library(dplyr)
library(raster)
library(magrittr)
library(lidR)

##-------------------------------------- LiDAR metric --------------------------------------
metrik_arci <- function(rn, nr, cls, z, h) # first return canopy index
{
  
  ar <- (rn > 0 & z >= 0) # all return disregard the class
  
  vg <- (cls >= 3) & (cls <= 5)
  hx <- (z >= h) 
  ac <- (vg & hx)
  
  arci <- sum(ac) / sum(ar)
  
  return(list(arci = arci))
}

metrik_frci <- function(rn, nr, cls, Z, h)
{
  fr <- (rn == 1 & Z >= 0)
  sr <- (nr == 1 & Z >= 0)
  hx <- (Z >= h)
  ac <- (cls >= 3 & cls <= 5)
  
  fc_tree <- (fr & hx & ac)
  sc_tree <- (sr & hx & ac)
  
  frci <- (sum(fc_tree) + sum(sc_tree)) / (sum(fr) + sum(sr))
  
  return(list(frci = frci))
}

##-------------------------------------- Load dataframe --------------------------------------
setwd('D:/00RCode/Data/') #-------- Load data LAS
lidRline <- readLAS("LINE_1_1.las") #-------- Load data LAS
plot(lidRline)

##------------------------- DTM and Normalization
dtmfile <- grid_terrain(lidRline, res = 0.5, algorithm = kriging(k = 10L))
lasnormfile <- lasnormalize(lidRline, dtmfile, na.rm = TRUE)
plot(dtmfile)
plot(lasnormfile)

##------------------------- check Z ----
##------------------------- :: N rows / observations ----
nrow(lasnormfile@data)
##------------------------- :: histogram ----
hist(lasnormfile@data$Z)
##------------------------- :: min/max, summary ----
min(lasnormfile@data$Z)
max(lasnormfile@data$Z)
summary(lasnormfile@data$Z)

##------------------------- :: N obs close to extremes ----
## to know whether the significance
filter(lasnormfile@data, Z < 0) %>% nrow
filter(lasnormfile@data, Z > 50) %>% nrow
##------------------------- trim 0 < Z < extremely high ---- 
lidRline <- lasfilter(lasnormfile, Z >= 0 & Z < 50)

##------------------------- check Clasification ----
##------------------------- to see whether there is an "abnormal class" in the ROI
unique(lidRline@data$Classification)
table(lidRline@data$Classification)

##------------------------- filter classification <- tidak dikerjakan
#lidline5_1_filtclas <- lasfilter(lidline2_44_trim, Classification > 2)
#unique(lidline5_1_filtclas@data$Classification)
#table(lidline5_1_filtclas@data$Classification)

##------------------------- make ID ----
lidRline@data$ID <- 1:nrow(lidRline@data)
names(lidRline@data)

##------------------------- save data .rds
setwd('D:/00RCode/Result')
saveRDS(lidRline, "fn_line1_New.RDS") #----------------------------------------- Fix 20-02-2019

##------------------------- Make CHM and Smoothing with lidRline Data -------------------------
chmfile <- grid_canopy(lidRline, res = 0.5, p2r(subcircle = 0.3, na.fill = knnidw(k=5, p=2)))
plot(chmfile)
ras2chm <- writeRaster(chmfile, filename = "chm_fn_line1_New.tif") #-------- Make raster CHM




