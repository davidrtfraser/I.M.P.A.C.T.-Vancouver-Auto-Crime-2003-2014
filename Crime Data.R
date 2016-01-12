# Vancouver Auto Crime Data 2003 - 2015 #
#########################################

# STEP 1
########
# Create new folders for this project:
if (!file.exists("~/Documents/VancouverCrimeData")) {
        dir.create("~/Documents/VancouverCrimeData")
}

if (!file.exists("~/Documents/VancouverCrimeData/RawData")) {
        dir.create("~/Documents/VancouverCrimeData/RawData")
}

# Download the 2003-2014 crime statistics raw data into a folder and record
# the date downloaded:
setwd("~/Documents/VancouverCrimeData/RawData")
years <- c(2003:2014)
for(i in 1:12) { 
        url1 <- 'ftp://webftp.vancouver.ca/opendata/csv/crime_'
        url2 <- '.csv'
        years.vect <- years[i]
        url <- paste(url1, years.vect, url2, sep = "")
        crime <- read.csv(url, header=TRUE, sep = ",")
        filename <- paste('crime', years.vect, 'csv', sep='.')
        write.csv(crime, file=filename)
        i = i + 1
}
date.downloaded <- date()

# Discarding data/values that are no longer needed:
rm(i, url, url1, url2, filename, crime)

# The packages employed in this wrangling:
library(dplyr)
library(zoo)

# Reading the raw data into memory:
for(i in 1:12){
        years.vect <- years[i]
        file.location <- paste('~/Documents/VancouverCrimeData/RawData/crime',
                               years.vect, 'csv', sep = '.')
        crime.data <- tbl_df(read.table (file.location, sep=",", header=TRUE))

# STEP 2
########
# Fixing typos in the TYPE variable:
        crime.data$TYPE <- gsub("Thef ", "Theft", crime.data$TYPE)
        crime.data$TYPE <- gsub("TheftOf", "Theft Of", crime.data$TYPE) 

# Subsetting the data read into memory to pull out only the data related to 
# auto theft and theft from autos:
        crime.data <- filter (crime.data, TYPE == "Theft Of Auto Under $5000" |
                                         TYPE == "Theft Of Auto Over $5000" |
                                         TYPE == "Theft From Auto Under $5000" |
                                         TYPE == "Theft From Auto Over $5000" |
                                         TYPE == "Thef Of Auto Under $5000" | 
                                         TYPE == "TheftOf Auto Under $5000")
        
# STEP 3
########
# Merging the month/year fields into a YEARbyMONTH column.
        YEARbyMONTH <- as.yearmon(paste(crime.data$YEAR, crime.data$MONTH),
                                  "%Y %m")
        crime.data[, "YEARbyMONTH"] <- YEARbyMONTH
        crime.data <- select(crime.data, -(YEAR:MONTH))
        
# Formating the address data so that it can be geocoded by:
# a) Setting XX to 00 for the HUNDRED_BLOCK.
# b) Replacing the '/' in interstection locations with an 'and'.   
# c) Creating addressString which adds 'Vancouver, BC' every element in 
#    HUNDRED_BLOCK. 
        crime.data$HUNDRED_BLOCK <- gsub("XX", "00", crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("/", "and", crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("BLOCK", "", crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("BLK", "", crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("PRDE", "PARADE", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("SCHOOL GR", "SCHOOL GREEN,", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("BRDG", "BRIDGE", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" VIA", " VIADUCT ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(".4800 ELDORADO MEWS.", "", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("ROLSTON.CRES", "ROLSTON ST", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" OFRP", " OFF RAMP", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" NW ", " NORTH WEST ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" SW ", " SOUTH WEST ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" RD", " ROAD ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" AVE", " AVENUE ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub("16000 BEACH", " BEACH ", 
                                         crime.data$HUNDRED_BLOCK)
        crime.data$HUNDRED_BLOCK <- gsub(" SQ", " SQUARE ", 
                                         crime.data$HUNDRED_BLOCK)
        
        CITY <- NULL
        for (j in 1:nrow(crime.data)) {
                CITY[j] <- "Vancouver, BC"
                j = j + 1
        }
        crime.data[, "addressString"] <- paste(crime.data$HUNDRED_BLOCK, CITY,
                                               sep=', ') 
        crime.data <- select(crime.data, TYPE, YEARbyMONTH, addressString)

# Check to see if merged dataset exists, if it does append data to it:
        if (!exists("dataset")){
                dataset <- crime.data
        }
        else if (exists("dataset")){
                temp_dataset <- crime.data
                dataset <- rbind(dataset, temp_dataset)
                rm(temp_dataset)
        }
}

# Discarding data/values that are no longer needed:
rm (i, j, CITY, years, years.vect, YEARbyMONTH, file.location, crime.data)

# STEP 4
########

# Adding an Id column and renaming columns:
dataset$yourId <- 1:length(dataset$TYPE)
colnames(dataset) <- c("CrimeType", "YearbyMonth", "addressString", "yourId")

# Selecting columns we want to write to each file:
geolocate <- select(dataset, yourId, addressString)
merged <- select(dataset, yourId, CrimeType, YearbyMonth, addressString)

# Writing two files; one for the geolocator, and one that we will later merge 
# the geolocator output with.
dir3 <- '~/Documents/VancouverCrimeData/merged.crime.csv'
dir4 <- '~/Documents/VancouverCrimeData/geocoding.crime.csv'
write.csv(merged, dir3, row.names = FALSE ) 
write.csv(geolocate, dir4, row.names = FALSE)

# Discarding data/values that are no longer needed:
rm(list=ls())
