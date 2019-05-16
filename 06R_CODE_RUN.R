library(raster)
library(tiff)

convRef2RadLinear <- function(band, refm, refa, radm, rada, szen){
  if(!missing(szen)){
    band <- band * cos(szen * pi / 180.0)
  }
  dn <- (band - refa) / refm
  result <- radm * dn + rada
  return(result)
}

reflconv <- function(x, Mp, Ap)
{
  results <- x
  x <- as.vector(as.matrix(x))
  x <- Mp*x+Ap
  if (class(results) == "SpatialGridDataFrame")
    results@data[, 1] <- x
  else if (is.data.frame(x))
    results <- data.frame(matrix(x, nrow = nrow(results),
                                 ncol = ncol(results)))
  else results <- x
  results
}

# data(band5)
setwd('F:/All Data Forests2020/Path112Row56 Manado/')
band_raster <- raster('LC08_L1TP_112059_20180902_20180912_01_T1_B2.TIF')
band5.dn <- as(band_raster, 'SpatialGridDataFrame')
band5.refl <- reflconv(band5.dn,2.0000E-05,-0.100000)

writeRaster(band5.refl, filename = "test.TIF", format = "GTiff")
# setwd('F:/All Data Forests2020/Path112Row56 Manado/')
# load_raster <- readTIFF('LC08_L1TP_112059_20180902_20180912_01_T1_B2.TIF')
# summary(load_raster)
# 
# convRef2RadLinear(load_raster, )
# 
# convert_tiff <- ((load_raster * 0.00002 - 0.1) / sin(()))