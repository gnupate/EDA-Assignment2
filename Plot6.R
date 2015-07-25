library(dplyr) ## use the dplyr library
## NOTE:  I have not saved the data to github, it should be unzipped into the directrory where this script is run

## ensure that the data is there
files <- dir()
if(is.element("summarySCC_PM25.rds",files)) { #the data exists, go ahead and work
    ## read the data into a dataframe
    sourceData <- readRDS("summarySCC_PM25.rds")
    
    ## I'm using the ON-ROAD data under the assumption that vehicles means motor vehicles driven on roads 
    ## (not boats, trains, planes, etc,)
    baltimoreData <- filter(sourceData, type == "ON-ROAD", fips == "24510")
    laData <- filter(sourceData, type == "ON-ROAD", fips == "06037")
    
    year = c(1999,1999,2002,2002,2005,2005,2008,2008)
    emissions = 1:8
    city = c("balt","la","balt","la","balt","la","balt","la")
    df = data.frame(year , emissions,city)
 
    
    ## fill in the dataframe for each year
    counter = 1
    for(i in c(1999,2002,2005,2008)) {
        df$emissions[counter] <- colSums(select(filter(baltimoreData, year == i),Emissions))
        counter <- counter + 1
        df$emissions[counter] <- colSums(select(filter(laData, year == i),Emissions))
        counter <- counter + 1
    }
    
    # the disparity between Baltimore and LA emissions are too great to see in raw data
    # try looking at difference vs mean for both
    bmean <- mean(subset(df, city=="balt")$emissions)
    lmean <- mean(subset(df, city=="la")$emissions)
    counter = 1
    for(i in c(1999,2002,2005,2008)) {
        df$emissions[counter] <- df$emissions[counter] - bmean
        counter <- counter + 1
        df$emissions[counter] <- df$emissions[counter] - lmean
        counter <- counter + 1
    }
    ## use the png filter to write to a graphics file device
    png(file="plot6.png", width=600)
    with(df, plot(year,emissions, main="Change in Annual Vehicle Related Emmissions - Baltimore vs LA", type="n"))
    with(subset(df,city == "balt"), points(year, emissions, col="blue", type="l"))
    with(subset(df,city == "la"), points(year, emissions, col="red", type="l"))
    legend("topright", pch = 1, col = c("blue", "red"), legend = c("Baltimore", "LA"))
    
    dev.off()
} else { # datafile isn't there ... 
    print("Expected datafile not found, please ensure it is in the current directory and retry")
    
}