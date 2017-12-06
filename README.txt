SafeTree Documentation

1. DESCRIPTION
This package functions to obtain, structure, and analyze data from the Bureau of Labor Statistics (BLS) on workplace injuries, specifically nonfatal cases involving days away from work. This package produces a Shiny Web Application built in R that visualizes average days away from work due to injury and predicts days away from work using random forest regression. The data necessary for this package is too large to be included. A sample dataset has been included for the application to run. All data files can be downloaded from the BLS's directory here: https://download.bls.gov/pub/time.series/cs/

2. INSTALLATION

2.1 Importing
To install and setup the code, it is necessary to have the following programs downloaded to your machine: sqlite, R, RStudio.

sqlite - Follow the link to download the correct version of sqlite for your machine: https://www.sqlite.org/download.html

R - Follow the link to download the correct version of R for your machine: https://cran.r-project.org/

RStudio - Follow the link to download the correct version of RStudio for your machine (Free version is adequate for this package): https://www.rstudio.com/products/rstudio/download/

Once all software is loaded to your machine, create a directory folder with the structure as follow:
			BLS_Injury_Viz/
				|---DATA/
						|---sqlite.exe
						|---sql file
						|---data files?
				|---CLEAN
						|---R clean code
				|---VISUAL
						|---R App Code
						|---Sample Data files
						

If you decide to download the flat files from the BLS Web Directory, the full data files the sample data sets are sampled from can be created by running the following code in the shell, assuming the DATA folder is the working directory: 
					$sqlite3 < BLS_IN.txt > BLS_OUT.txt
					Note: This will take over 10 minutes to run.
					
The BLS_IN.txt file will export two CSV files named "blah " and "blah". These files will house all the data needed to create the web application.

2.2 Cleaning
To manipulate the data into a structure that can be read by the application, the output files from 2.1 will be imported and cleaned using the Data_Clean.R script. 
Open RStudio and open the script. Before running the code, open the "Packages" tab in the bottom right navigation bar. Next click install. In the field type "shiny, dplyr, plotly". These are the necessary R packages needed to run the code.
Once all packages have been installed, select the block of code in the Data_Clean.R file and hit "Run"
