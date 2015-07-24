library(dplyr) ## use the dplyr library
library(ggplot2)
## NOTE:  I have not saved the data to github, it should be unzipped into the directrory where this script is run

## ensure that the data is there
files <- dir()
if(is.element("summarySCC_PM25.rds",files)) { #the data exists, go ahead and work
    ## read the data into a dataframe
    sourceData <- readRDS("summarySCC_PM25.rds")
    df <- filter(sourceData, fips == 24510)
    ## build a dataframe to hold data and plot from
    year = 1:16
    emissions = 1:16
    types = c("POINT","NONPOINT","ON-ROAD","NON-ROAD")  
    type <- c(types,types,types,types)
    df = data.frame(year, emissions, type)

    ## fill in the dataframe for each year
    counter = 1
    for(i in c(1999,2002,2005,2008)) {
        for(t in types) {
            df$year[counter] <- i
            typeEmis <- select(filter(sourceData, year == i, fips == 24510, type == t),Emissions)
            df$emissions[counter] <- colSums(typeEmis)
            df$type[counter] = t
            counter <- counter + 1
        }
    }
    ## use the png filter to write to a graphics file device
    
    #print("this is where I'd create a graph")
    png("plot3.png")
    g <- qplot(year, emissions, data=df, geom = c("point","smooth"), facets= ~type)
    print(g)
    dev.off()
} else { # datafile isn't there ... 
    print("Expected datafile not found, please ensure it is in the current directory and retry")
}
    
