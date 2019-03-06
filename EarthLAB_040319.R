library(raster)
library(rgdal)
library(rgeos)

options(stringsAsFactors = FALSE) #--- Turn off factors
#--- Load the landsat bands in our computer
setwd('C:/Users/user/Dropbox/FORESTS2020/00AllData/DATA/From Eci/landsat/LC80340322016189-SC20170128091153/crop')
#setwd('D:/00AllData/00 Data Load/Path112Row56 Manado')
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

par(xpd = TRUE) # force legend to plot outside of the plot extent
legend(x = cloud_mask_189@extent@xmax, cloud_mask_189@extent@ymax,
       c("Not masked", "Masked"),
       fill = c("green", "white"),
       bty = "n")

# mask the stack
all_landsat_bands_mask <- mask(all_landsat_bands_br, mask = cloud_mask_189)

# check the memory situation
inMemory(all_landsat_bands_mask)
## [1] TRUE
class(all_landsat_bands_mask)
## [1] "RasterBrick"
## attr(,"package")
## [1] "raster"

# plot RGB image
# first turn all axes to the color white and turn off ticks
par(col.axis = "white", col.lab = "white", tck = 0)
# then plot the data
plotRGB(all_landsat_bands_mask,
        r = 4, g = 3, b = 2,
        main = "Landsat RGB Image \n Are the clouds gone?",
        axes = TRUE)
box(col = "white")

# plot RGB image
# first turn all axes to the color white and turn off ticks
par(col.axis = "white", col.lab = "white", tck = 0)
# then plot the data
plotRGB(all_landsat_bands_mask,
        r = 4, g = 3, b = 2,
        stretch = "lin",
        main = "Landsat RGB Image \n Are the clouds gone?",
        axes = TRUE)
box(col = "white")
