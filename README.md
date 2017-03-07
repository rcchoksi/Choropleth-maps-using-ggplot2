# Choropleth-maps-using-ggplot2
The dissolution of marriage rates for different counties in Arizona has been shown using choropleth maps. 

There are three parts to this project:

1. Choropleth map using equal interval classification for year 2015.
2. Choropleth map using quantile interval classificatio for year 2015.
3. Six small choropleth maps wrapped in a grid to show dissolution of marriage rates from 2010-2015.

The code for first two parts can be found combined in the file 'part 1 & 2', and that for the third part can be found in 'part 3'. 

The dataset has been obtained from http://pub.azdhs.gov/health-stats/menu/info/trend/index.php?pg=divorce. The file named 't5g5.xlsx'
can also be found in the repository. The same file has been used for parts 1 and of this project. A new dataset named 'Data.xlsx' has
been created to be used for part 3. 

The package ggplot2 has been used to create choropleth maps using shape files which are available online. Various different packages
have been used for different actions. The challenging part was to ready the data to be plotted on the map. Merging the dataset and the
shape file through a common attribute('id') was key for this task. 

The next step involved using different arguments of ggplot2 to select an appropriate color scheme, plot the legend and beautify the plot. 
Part 1 involved creating equal interval breaks for the plot whereas part 2 involved creating quantile intervals for the same. 

The dataset for part 3 involved the creation of 'Dissolution Rate' column and a 'Year' column. The facet_wrap function of the ggplot2 
package has been used to create a grid of 6 choropleth maps plotting values of Dissolution Rate for each year from 2010 to 2015. The color
scheme has been selected to be sequential to enable quick comparison between values for the same county in different years. 

The final results of parts 1 and 2 are shown in 'equalplot.png' and 'quantileplot.png'. The final plot of part 3 is shown in '6yearplot.png'.
