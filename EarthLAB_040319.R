library(raster)
library(rgdal)
library(rgeos)

options(stringsAsFactors = FALSE) #--- Turn off factors
#--- Load the landsat bands in our computer
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/DATA/From Eci/landsat/LC80340322016189-SC20170128091153/crop')
all_landsat_bands <- list.files(pattern = glob2rx("*band*.tif$"), full.names = TRUE)

#--- Creat spatial raster stack from the list of file names
all_landsat_bands_st <- stack(all_landsat_bands)
all_landsat_bands_br <- brick(all_landsat_bands_st)

#--- Turn the axis color to white and turn off sticks
par(col.axis = "white", col.lab = "white", tck = 0)
plotRGB(all_landsat_bands_br,
        r = 4, g = 3, b = 2, stretch = "hist",
        main = "Pre-fire RGB image with cloud\n Cold Springs Fire", axes = TRUE)
box(col = "white")

#--- Open cloud mask layer
cloud_mask_189_conf <- raster("LC80340322016189LGN00_cfmask_conf_crop.tif")
plot(cloud_mask_189_conf, main = "Landsat Julian Day 189 - Cloud mask layer")
cloud_mask_189 <- raster("LC80340322016189LGN00_cfmask_crop.tif")
plot(cloud_mask_189, main = "Landsat Julian Day 189 - Cloud mask layer with shadow")


#--- Creat mask layer in R
par(xpd = FALSE, mar = c(0,0,1,5))
cloud_mask_189[cloud_mask_189 > 0] <- NA
plot(cloud_mask_189, main = "The Raster Mask", col = c("green"),
     legend = FALSE, axes = FALSE, box = FALSE)
