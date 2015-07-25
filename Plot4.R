library(dplyr) ## use the dplyr library
## NOTE:  I have not saved the data to github, it should be unzipped into the directrory where this script is run

## ensure that the data is there
files <- dir()
if(is.element("summarySCC_PM25.rds",files)) { #the data exists, go ahead and work
    ## read the data into a dataframe
    sourceData <- readRDS("summarySCC_PM25.rds")
    classes <- readRDS("Source_Classification_Code.rds")
    ## just grab the SCC #s I care about
    sccs <- classes$SCC[grep("Coal",classes$EI.Sector)]
    ## grab the data pertaining to these SCCs 
    coalData <- filter(sourceData, SCC == sccs)
    
    year = c(1999,2002,2005,2008)
    emissions = c(0,0,0,0)
    df = data.frame(year , emissions)
    
    ## fill in the dataframe for each year
    counter = 1
    for(i in year) {
        df$emissions[counter] <- colSums(select(filter(coalData, year == i),Emissions))
        counter <- counter + 1
    }
    
    ## use the png filter to write to a graphics file device
    png(file="plot4.png")
    plot(df, main="Annual Coal Related Emmissions across US", type="l")
    
    dev.off()
    
} else { # datafile isn't there ... 
    print("Expected datafile not found, please ensure it is in the current directory and retry")
    
}