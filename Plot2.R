library(dplyr) ## use the dplyr library
## NOTE:  I have not saved the data to github, it should be unzipped into the directrory where this script is run

## ensure that the data is there
files <- dir()
if(is.element("summarySCC_PM25.rds",files)) { #the data exists, go ahead and work
    ## read the data into a dataframe
    sourceData <- readRDS("summarySCC_PM25.rds")
    
    ## build a dataframe to hold data and plot from
    year = 1999:2008
    emissions = 1999:2008
    df = data.frame(year , emissions)
    
    ## fill in the dataframe for each year
    counter = 1
    for(i in year) {
        df$emissions[counter] <- colSums(select(filter(sourceData, year == i, fips == 24510),Emissions))
        counter <- counter + 1
    }
    df <- filter(df,emissions > 0)
    ## use the png filter to write to a graphics file device
    png(file="Plot2.png")
    plot(df, type = "l", main="Annual Emissions in Baltimore")
    
    dev.off()
    
} else { # datafile isn't there ... 
    print("Expected datafile not found, please ensure it is in the current directory and retry")
    
}