setwd("C:/Users/choks_000/Dropbox/Choropleth1")
#Importing data file
library(xlsx)
data3 <- read.xlsx("Data.xlsx", sheetIndex = 1, header = TRUE)
#Renaming column County as id for proper merging
library(data.table)
setnames(data3, "County", "id")
#Reading shape file of Arizona counties
library(maptools)
arizona <- readShapeSpatial("azcounties.shp")
#Fortifying shape file with Region
library(ggplot2)
arizonastates.shp <- fortify(arizona, region = "NAME")
#Merging shape file with data3
merge.shp.coef = merge(arizonastates.shp, data3, by = "id", all.x = TRUE)
part3data <- merge.shp.coef[order(merge.shp.coef$order), ]
#Now our final data to be plotted is ready, we'll start off with creating map using ggplot2
gg0 <- ggplot() + geom_map(data = part3data, map = arizonastates.shp, aes(x = long, y = lat, group =group, map_id = id), color = "black", size = 0.25)
#Creating equalbreaks
library(classInt)
equalbreaks <- classIntervals(part3data$Dissolution.Rate, n = 7, style = "equal")
#Vector to print names according to mean of longitude and latitude
cnames <- aggregate(cbind(long, lat) ~ id, data = part3data, FUN=function(x) mean(range(x)))
equalbreaks$brks
#Removing grid, inserting scale, appropriate breaks and names of counties on map
library(mapproj)
library(RColorBrewer)
library(scales)
library(ggmap)
plot1 <-  gg0 + geom_map(data = part3data, map = part3data, aes(map_id = id, fill = `Dissolution.Rate`), color = "black", size = 0.15) + coord_map()  + scale_fill_distiller(name = "Dissolution Rate(%)", palette = "Greens", direction = 1, breaks = c(1.271, 1.943, 2.614, 3.286, 3.957, 4.629, 5.300), labels = c("0.600-1.271", "1.271-1.943", "1.943-2.614", "2.614-3.286", "3.286-3.957", "3.957-4.629", "4.629-5.300")) + guides(fill = guide_legend(override.aes = list(colour = NA))) + geom_text(data = cnames, aes(long, lat, label = id), size = 2, fontface = "bold") + labs(title = "Dissolution of marriage rates for Arizona") + theme_nothing(legend = TRUE)
#Wrapping 6 maps in 1 plot in 3 columns and pushing the legend at the bottom of the plot
plot2 <- plot1 + facet_wrap(~Year, ncol = 3)
library(ggthemes)
plot2 <- plot2 + theme_map() + theme(legend.position = "bottom") + guides(fill = guide_legend(override.aes = list(colour = NA))) + coord_map()
#Adjusting size of title, legend and legend title
plot2 <- plot2 + theme(strip.background = element_blank()) + theme(strip.text = element_text(face = "bold", size = 10)) + theme(plot.title = element_text(face = "bold", hjust = 0, size = 16)) + theme(legend.title= element_text(face="bold", hjust=0, size=10)) + theme(legend.text = element_text(size = 8))
#Saving the image
ggsave("6yearplot.png", plot2, width = 5, height = 4, scale = 1.3)
plot2