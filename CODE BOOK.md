                          Code Book: merged.tidy.crime.csv
                        Vancouver Auto Crime Data 2003-2014


A full description of the raw data can be found here:
http://data.vancouver.ca/datacatalogue/crime-data.htm

The raw data was downloaded on: 

DATA SET DESCRIPTION:
#####################
This dataset represents the month-by-month auto crime data collected by the Vancouver Police 
Department between 2003 and 2014. The types of crime this dataset has been limited to are:

Theft From Auto Under $5000
Theft From Auto Over $5000
Theft Of Auto Under $5000
Theft Of Auto Over $5000

The data contains a generalized location of the incident such as an intersection or a 
hundred block.  It is updated on a delayed quarterly basis, and is extracted from the 
Vancouver Police Department's computer systems.  There were 176, 374 incidents, of which
the DataBC Batch Geolocator scored 144 of as  < 65.

VARIABLE NAMES & DESCRIPTION
############################
yourID          - An unique number assigned to each row of the data set.

TYPE            - One of the four different types of crime:
                    - Theft From Auto Under $5000
                    - Theft From Auto Over $5000
                    - Theft Of Auto Under $5000
                    - Theft Of Auto Over $5000
            
YEARbyMONTH     - The month and year in which the crime was committed.  Years range from 
                  2003 - 2014.

addressString   - The street address or intersection at which the crime was committed. Street addresses
                  can take one of two forms: they can be generalized to the hundred block (Ex: 5600 E Broadway), 
                  or they can take the value 1 (Ex: 1 Main St.)

score           - The score assigned by the DataBC BC Physical Address Batch Geolocator.  This score is in 
                  [0, 100] and represents how confident the geolocator is in the address match that it has provided.



NOTES ON COMPARING CRIME STATISTICS:
####################################
The Vancouver Police Department (VPD) has changed the way in which it reports its crime 
statistics. Historically, it reported data based on Statistics Canada reporting 
requirements, which meant that only the most serious offence per incident was counted. 
Now, the "all violations method" is used. Other policing agencies like Edmonton, Toronto, 
Ottawa and Calgary also present their crime statistics using the "all violations method". 
It is important to note these differences in reporting when comparing our crime statistics
 to other Police Agencies and Statistics Canada.

NOTES ON DATA ACCURACY:
#######################
The records provided here reflect data maintained by the Vancouver Police Department. 
Locational information is generalized and therefore provides only an approximate location
 of the incidents.