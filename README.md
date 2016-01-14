                                VANCOUVER AUTO CRIME DATA 2003-2014: READ ME


SUMMARY
#######
The aim of this project was to create a series of visualizations related to auto crime in the 
City of Vancouver.  The data was collected by the Vancouver Police Department between 2003 and 
2014.  The visualizations were to be created with Tableau Public, so the data had to be  
tidied and assigned a geolocation by the BC Physical Address BATCH Geocoder.  
Performing these tasks required the creation of two different R scripts: 

1) CrimeData.R
2) Geocoding Merge & Tidy.R

The first of these dealt with downloading and merging the yearly crime data files in preparation 
for the DataBC geocoder.  As an output of this script two files were created 
"geocoding.crime.csv" and "merged.crime.csv".  Of these outputs, the first 
was sent to the geocoder; the second was merged with the geocoder's output by the 
"Geocoding Merge & Tidy.R" script.  A fuller breakdown of the "CrimeData.R" script can be 
found in the first section below.

The second script dealt with the output from the DataBC geocoder and the file produced by the 
"CrimeData.R" script, "merged.crime.csv".  This second script merged the geocoder 
output "job-30704-result-9982.csv" with the "merged.crime.csv" file, and generally cleaned 
and tidied the data so that it was ready for import into Tableau Public.  A fuller breakdown 
of the "Geocoding Merge & Tidy.R" script can be found in the second section below.

1) THE "CrimeData.R" SCRIPT
###########################
In broad strokes this script:

STEP 1: Checks to see if a VancouverCrimeData folder exists in Documents, if it does not
        it creates one.  It then checks to see if a RawData folder exists in the
        VancouverCrimeData folder, if it does not it creates one.  It then downloads the 
        12 raw crime data files and names them by year. Ex: "crime.2003.csv"
        
STEP 2: Reads in each file, corrects typos in it, and then subsets out only the rows
        related to auto theft and theft from automobiles.  

STEP 3: Merges the month and year columns into a singe column. Then formats the HUNDRED_BLOCK column to be acceptable to the geocoder by substituting 'XX' with '00', replacing '/' with 'and', and adding 'Vancouver, BC' to the end of each string.  
        Ex 1: '50XX Maple St.' became '5000 Maple St. Vancouver, BC'.
        Ex 2: 'Broadway St. / Granville St.' became 'Broadway St. and Granville St. Vancouver, BC'
        
        (Detailed instructions on what forms of unstructured address data are acceptable to 
        the geocoder can be found at :
        
        http://www.data.gov.bc.ca/local/dbc/docs/geo/services/standards-procedures/batch_address_data_prep.pdf
        
STEP 4: Adds column names to the data and adds an identifier column, yourID.  Then 
        writes the files "merged.crime.csv" and "geocoding.crime.csv"; the 
        former contains all columns, while the latter contains only "yourID" and 
        "addressString" as per the geocoder requirements.

2) THE "Geocoding Merge & Tidy.R" SCRIPT
########################################
In broad strokes this script:

STEP 5: Reads in the geocoder output file "job-30704-result-9982.csv" and subsets it to only 
        contain the relevant columns.  It then merges it to the "merged.crime.csv" 
        file produced in STEP 4 of the "CrimeData.R" script.

STEP 6: Subsets the merged data to select entries that the geocoder had scored as having 
        >= 65 % confidence that it had found the correct location.
        
STEP 7: Converts the location column to a character vector and tidies it up by 
        removing unwanted characters, spaces and text. Then splits the location column
        into two columns longitude and latitude.
        
STEP 8: Removes the location column and adds the longitude and latitude columns to the data set;
        then writes the output file "merged.tidy.crime.csv"
        


