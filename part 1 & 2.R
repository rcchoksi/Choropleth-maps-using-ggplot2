setwd("C:/Users/choks_000/Dropbox/Choropleth1")
#Importing data file
library(xlsx)
data12 <- read.xlsx("t5g5.xlsx", sheetIndex = 1, header = TRUE)
#Renaming column County as id for proper merging
library(data.table)
setnames(data12, "County", "id")
#Reading shape file of Arizona counties
library(maptools)
arizona <- readShapeSpatial("azcounties.shp")
#Fortifying shape file with Region
arizonastates.shp <- fortify(arizona, region = "NAME")
#Merging shape file with data12
merge.shp.coef = merge(arizonastates.shp, data12, by = "id", all.x = TRUE)
part12data <- merge.shp.coef[order(merge.shp.coef$order), ]
#Now our final data to be plotted is ready, we'll start off with creating map using ggplot2
library(ggplot2)
gg0 <- ggplot() + geom_map(data = part12data, map = arizonastates.shp, aes(x = long, y = lat, group =group, map_id = id), color = "black", size = 0.25)
#Creating equalbreaks
library(classInt)
equalbreaks <- classIntervals(part12data$X2015, n = 8, style = "equal")
#Vector to print names according to mean of longitude and latitude
cnames <- aggregate(cbind(long, lat) ~ id, data = part12data, FUN=function(x) mean(range(x)))
#Removing grid, inserting scale, appropriate breaks and names of counties on map
library(mapproj)
library(RColorBrewer)
library(scales)
library(ggmap)
plot1 <-  gg0 + geom_map(data = part12data, map = part12data, aes(map_id = id, fill = X2015), color = "black", size = 0.15) + coord_map()  + scale_fill_distiller(name = "Dissolution Rate(%)", palette = "Greens", direction = 1, breaks = c(1.35, 1.80, 2.25, 2.70, 3.15, 3.60, 4.05, 4.50), labels = c("0.90-1.35", "1.35-1.80", "1.80-2.25", "2.25-2.70", "2.70-3.15", "3.15-3.60", "3.60-4.05", "4.05-4.50")) + guides(fill = guide_legend(override.aes = list(colour = NA))) + geom_text(data = cnames, aes(long, lat, label = id), size = 2, fontface = "bold") + labs(title = "Dissolution of marriage rates for Arizona in 2015") + theme_nothing(legend = TRUE)
#Adjusting size of Title and Legend
plot1 <- plot1 + theme(plot.title = element_text(face = "bold", size = 20)) + theme(legend.text = element_text(size = 10))
#Loading US map as inset image
library(cowplot)
library(png)
img <- readPNG("arizona.png")
library(grid)
gpp <- rasterGrob(img, interpolate=TRUE)
#Inserting inset image and source text in plot
h1 <- ggdraw(plot1)
plot2 <- h1 + draw_grob(gpp, 0.75, 0.10, 0.2, 0.2) + draw_label("Source: Arizona Department of Health Services", 0.20, 0.05, colour = "black", size = 8)
#Quantile breaks
quantilebreaks <- classIntervals(part12data$X2015, n = 7, style = "quantile")
#Creating a quantile plot with legend and title
plot3 <- gg0 + geom_map(data = part12data, map = part12data, aes(map_id = id, fill = X2015), color = "black", size = 0.15) + coord_map()  + scale_fill_distiller(name = "Dissolution Rate(%)", palette = "Blues", direction = 1, breaks = c(2, 2.2, 2.6, 2.8, 3.4, 4, 4.5), labels = c("0.9-2.0", "2.0-2.2", "2.2-2.6", "2.6-2.8", "2.8-3.4", "3.4-4.0", "4.0-4.5")) + guides(fill = guide_legend(override.aes = list(colour = NA))) + geom_text(data = cnames, aes(long, lat, label = id), size = 2, fontface = "bold") + labs(title = "Dissolution of marriage rates per county in Arizona in 2015") + theme_nothing(legend = TRUE)
plot3 <- plot3 + theme(plot.title = element_text(face = "bold", size = 20)) + theme(legend.text = element_text(size = 10))
plot3 <- plot3 + theme(plot.title = element_text(hjust = 0))
plot3
h2 <- ggdraw(plot3)
plot3 <- h2 + draw_grob(gpp, 0.77, 0.10, 0.2, 0.2) + draw_label("Source: Arizona Department of Health Services", 0.23, 0.04, colour = "black", size = 8)
plot2
plot3
#Saving the images
ggsave("equalplot.png", plot2, width = 5, height = 4, scale = 1.50)
ggsave("quantileplot.png", plot3, width = 5, height = 4, scale = 1.30)

