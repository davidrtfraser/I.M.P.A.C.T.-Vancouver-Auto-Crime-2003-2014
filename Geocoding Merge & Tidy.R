# Vancouver Auto Crime Data 2003 - 2014 #
#########################################

# STEP 5
########
# Reading in the 'merged.crime.csv' file from STEP 4 of 'Crime Data.R'; and 
# reading in the output of the DataBC BC Physical Address BATCH Geocoder 
# 'job-30722-result-9999.csv':

setwd("~/Documents/VancouverCrimeData")
merged.crime <- 
        read.csv('~/Documents/VancouverCrimeData/merged.crime.csv')
geo.output <- 
        read.csv('~/Documents/VancouverCrimeData/job-30728-result-10004.csv')

# Subsetting the geocoder output for the columns that are useful, and merging
# them with the 'merged.crime.csv' file.
library(dplyr)
geo.output <- select(geo.output, sequenceNumber, fullAddress, score, 
                     faults, localityName, location)
merged.tidy <- merge(merged.crime, geo.output, by.x="yourId", 
                      by.y="sequenceNumber", all=FALSE)

# STEP 6
########
# Subsets the merged data to select entries that the geocoder had scored as 
# having >= 65 % confidence that it found a correct location, and that are in
# Vancouver.
merged.tidy <- filter(merged.tidy, score >= 65)
merged.tidy <- filter(merged.tidy, localityName == "Vancouver")

# STEP 7
########
# Converts the location column to a character vector, and then tidies it up by 
# removing unwanted characters, spaces and text.  Then creates two new columns
# from the location column; longitude and latitude.
merged.tidy$location <- as.character(merged.tidy$location)
merged.tidy$location <- gsub("SRID=4326;POINT", replacement = "",
                        merged.tidy$location)
merged.tidy$location <- gsub("\\(", replacement = "", merged.tidy$location)
merged.tidy$location <- gsub("\\)", replacement = "", merged.tidy$location)
library(tidyr)
location <- read.table (text = merged.tidy$location, 
                        col.names = c("Longitude", "Latitude"))

# STEP 8
########
# Removes the location and addressString columns, and adds the Longitude and 
# Latitude columns to the dataset:
merged.tidy <- select(merged.tidy, -c(location, addressString, 
                                      faults, localityName, score))
merged.tidy <- cbind(merged.tidy, location$Latitude, location$Longitude)

# Writes an output file "merged.tidy.crime.csv":
dir5 <- '~/Documents/VancouverCrimeData/merged.tidy.crime.csv'
write.csv(merged.tidy, dir5, row.names = FALSE ) 
rm(list=ls())