library(rgdal)
library(rgeos)
library(yaml)
library(EBImage)

# load the data ----
library(magrittr)
library(lidR)
setwd('D:/00RCode/Data/')
lidline2_44 <- readLAS ("LINE_1_1.las")
plot(lidline2_44)

## make DTM and normalization
dtmN <- grid_terrain(lidline2_44, 0.5, kriging(k=10L))
lasN <- lasnormalize(lidline2_44, dtmN, na.rm = TRUE)
##
dtm2_44 <- grid_terrain(lidline2_44, res = 0.5, algorithm = kriging(k = 10L))
plot(dtm2_44)
#lasnorm2_44 <- lasnormalize(lidline2_44, dtm2_44, copy = TRUE)
lasnorm2_44 <- lasnormalize(lidline2_44, dtm2_44, na.rm = TRUE)
plot(lasnorm2_44)

# check Z ----
# :: N rows / observations ----
nrow(lasnorm2_44@data)

# :: histogram ----
hist(lasnorm2_44@data$Z)

# :: min/max, summary ----
min(lasnorm2_44@data$Z)
max(lasnorm2_44@data$Z)
summary(lasnorm2_44@data$Z)

# :: N obs close to extremes ----
# to know whether the significance
library(dplyr)
filter(lasnorm2_44@data, Z < 0) %>% nrow
filter(lasnorm2_44@data, Z > 50) %>% nrow

# trim 0 < Z < extremely high ---- 
lidline2_44_trim <- lasfilter(lasnorm2_44, Z >= 0 & Z < 50)

# check Clasification ----
# to see whether there is an "abnormal class" in the ROI
unique(lidline2_44_trim@data$Classification)
table(lidline2_44_trim@data$Classification)

## filter classification <- tidak dikerjakan
lidline5_1_filtclas <- lasfilter(lidline5_1_trim, Classification > 2)
unique(lidline5_1_filtclas@data$Classification)
table(lidline5_1_filtclas@data$Classification)

# make ID ----
lidline2_44_trim@data$ID <- 1:nrow(lidline2_44_trim@data)
names(lidline2_44_trim@data)

# save data .rds
saveRDS(lidline2_44_trim, "fn_line2.44.RDS")

## Membuat CHM dan Smoothing
chm2_44 <- grid_canopy(lidline2_44_trim, res = 0.5, subcircle = 0.3, na.fill = "knnidw", k=5, p=2)
plot(chm2_44)
rchm <- as.raster(chm2_44)

## Membuat raster CHM
library(raster)
writeRaster(rchm, filename = "chm_line2.44.tif")

# LiDAR metric ----
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

# get starting point to calculate CCfrci ----
# load the flight line and grid

# load the flight line and grid
library(sf)
pline2 <- st_read("E:/ProjectR_Zeus/AOI_LIDAR/LINE_2.shp")
gline2 <- st_read("E:/ProjectR_Zeus/AOI-LIDAR-GIZ/LINE_2-vgrid.shp")

# select which tile
pline2_44 = pline2 %>% filter(tmpLine == "LINE2_44")

# select the grid
gline2_44 = gline2[pline2_44, op=st_within]

# add ID for selection
gline2_44$gridID <- 1:nrow(gline2_44) # gile, langsung jadi sf
st_write(gline2_44, "gline2_44_sf.shp")


# select the first grid
g1 = gline2_44 %>% filter(gridID == 1)

# extent
startX <- raster::extent(g1)[1]
startY <- raster::extent(g1)[3]

# arci ~ height  ----
# :: extract metric ----
CCarci <- grid_metrics(lidline2_44_trim, 
                       metrik_arci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=2), 
                       start = c(startX, startY), 
                       res = 30)

arci3m <- grid_metrics(lidline2_44_trim, 
                       metrik_arci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=3), 
                       start = c(startX, startY),  
                       res = 30)

arci4m <- grid_metrics(lidline2_44_trim, 
                       metrik_arci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=4), 
                       start = c(startX, startY),  
                       res = 30)

arci5m <- grid_metrics(lidline2_44_trim, 
                       metrik_arci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=5), 
                       start = c(startX, startY), 
                       res = 30)

CCfrci <- grid_metrics(lidline2_44_trim, 
                       metrik_frci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=2), 
                       start = c(startX, startY), 
                       res = 30)

frci3m <- grid_metrics(lidline2_44_trim, 
                       metrik_frci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=3), 
                       start = c(startX, startY),  
                       res = 30)

frci4m <- grid_metrics(lidline2_44_trim, 
                       metrik_frci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=4), 
                       start = c(startX, startY),  
                       res = 30)

frci5m <- grid_metrics(lidline2_44_trim, 
                       metrik_frci(ReturnNumber, NumberOfReturns, 
                                   Classification, Z, h=5), 
                       start = c(startX, startY), 
                       res = 30)

# :: merging metric arci----
names(CCarci)[3] <- "arci2m"
CCarci$arci3m <- arci3m$arci
CCarci$arci4m <- arci4m$arci
CCarci$arci5m <- arci5m$arci
names(CCarci)
head(CCarci)

# :: merging metric frci----
names(CCfrci)[3] <- "frci2m"
CCfrci$frci3m <- frci3m$frci
CCfrci$frci4m <- frci4m$frci
CCfrci$frci5m <- frci5m$frci
names(CCfrci)
head(CCfrci)

# turn CCfrci into sf frci 
sfCCfrci = CCfrci %>% as.data.frame %>% 
  st_as_sf(coords = c("X","Y"), 
           crs=32748)
plot(sfCCfrci)

in_sfCCfrci = sfCCfrci[gline2_44, op=st_within]
in_sfCCfrci$sfCCfrciID <- 1:nrow(in_sfCCfrci)
st_write(in_sfCCfrci, "in_sfCCfrci_ln2_44.shp", delete_layer = TRUE)

# turn CCarci into sf arci
sfCCarci = CCarci %>% as.data.frame %>% 
  st_as_sf(coords = c("X","Y"), 
           crs=32748)
plot(sfCCarci)

in_sfCCarci = sfCCarci[gline2_44, op=st_within]
in_sfCCarci$sfCCarciID <- 1:nrow(in_sfCCarci)
st_write(in_sfCCarci, "in_sfCCarci_ln2_44.shp", delete_layer = TRUE)

# :: order the data and make id frci----
o.CCfrci = st_set_geometry(in_sfCCfrci, NULL) %>%
  arrange(., frci3m)
o.CCfrci$oCCfrciID <- 1:nrow(o.CCfrci)
head(o.CCfrci)

# :: order the data and make id arci----
o.CCarci = st_set_geometry(in_sfCCarci, NULL) %>%
  arrange(., arci3m)
o.CCarci$oCCarciID <- 1:nrow(o.CCarci)
head(o.CCarci)

# :: melt the data and plot frci----
library(purrr)
library(reshape2)
m.CCfrci <- melt(o.CCfrci, id.vars = c("oCCfrciID", "sfCCfrciID"))
library(ggplot2)
ggplot(data=m.CCfrci, aes(x = oCCfrciID, y=value, colour=variable)) + geom_line()

# :: melt the data and plot arci----
m.CCarci <- melt(o.CCarci, id.vars = c("oCCarciID", "sfCCarciID"))
ggplot(data=m.CCarci, aes(x = oCCarciID, y=value, colour=variable)) + geom_line()

# evaluate
filter(m.CCfrci, oCCfrciID < 200, variable == "arci4m", value < 0.05)
filter(m.CCarci, oCCarciID < 200, variable == "arci4m", value < 0.05)

# Scan Angle ----
summary(lidline5_1_trim@data$ScanAngle)
lidar.sc15 <- lasfilter(lidline5_1_trim, ScanAngle >=-15 & ScanAngle <= 15)
lidar.sc12 <- lasfilter(lidline5_1_trim, ScanAngle >=-12 & ScanAngle <= 12)

# Scan angle ~ arci (3m) ----
CC.full <- grid_metrics(lidline5_1_trim, 
                        metrik(ReturnNumber, NumberOfReturns, 
                               Classification, Z, h=3), 
                        start = c(raster::extent(lidline5_1_trim)[1], 
                                  raster::extent(lidline5_1_trim)[3]), 
                        res = 30)
names(CC.full)[3] <- "scFull"

CC.sc15 <- grid_metrics(lidar.sc15, 
                        metrik(ReturnNumber, NumberOfReturns, 
                               Classification, Z, h=3), 
                        start = c(raster::extent(lidline5_1_trim)[1], 
                                  raster::extent(lidline5_1_trim)[3]), 
                        res = 30)
names(CC.sc15)[3] <- "sc15"

CC.sc12 <- grid_metrics(lidar.sc12, 
                        metrik(ReturnNumber, NumberOfReturns, 
                               Classification, Z, h=3), 
                        start = c(raster::extent(lidline5_1_trim)[1], 
                                  raster::extent(lidline5_1_trim)[3]), 
                        res = 30)
names(CC.sc12)[3] <- "sc12"

CC.full <- as.data.frame(CC.full)
coordinates(CC.full) <- ~ X + Y
proj4string(CC.full) <- CRS("+init=epsg:32748")

CC.sc15 <- as.data.frame(CC.sc15)
coordinates(CC.sc15) <- ~ X + Y
proj4string(CC.sc15) <- CRS("+init=epsg:32748")

CC.sc12 <- as.data.frame(CC.sc12)
coordinates(CC.sc12) <- ~ X + Y
proj4string(CC.sc12) <- CRS("+init=epsg:32748")

CC.full$sc15 <- over(CC.full, CC.sc15[ , "sc15"])
CC.full$sc12 <- over(CC.full, CC.sc12[ , "sc12"])
head(CC.full)

CC.ScA <- as.data.frame(CC.full)

# sort
CC.ScA <- CC.ScA[order(CC.ScA$scFull),]
CC.ScA$ID <- 1:nrow(CC.ScA)

head(CC.ScA)
m.CC.ScA <- melt(CC.ScA, id.vars=c("X", "Y", "ID"))

ggplot(m.CC.ScA, aes(x=ID, y=value, colour=variable)) + geom_line()

CC.L5T1.check <- filter(CC.ScA, ID > 250 & ID < 350, sc12 > 0.1)
coordinates(CC.L4T100.check) <- ~X + Y
proj4string(CC.L4T100.check) <- CRS("+init=epsg:32748")
writeOGR(CC.L4T100.check, dsn = "PROCESSED DATA/CC-L4T100-check.shp",
         layer="CC-L4T100-check",
         driver="ESRI Shapefile",
         overwrite_layer = TRUE)


# metrics30m <- as.data.frame(lidar_metrics)
# coordinates(metrics30m) <- ~X + Y
# proj4string(metrics30m) <- CRS("+init=epsg:32748")
# writeOGR(metrics30m, dsn = "PROCESSED DATA/metrics30m-5-v3.shp", 
#          layer="metrics30m-5-v3", 
#          driver="ESRI Shapefile", 
#          overwrite_layer = TRUE)