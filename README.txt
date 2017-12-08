SafeTree Documentation

1. DESCRIPTION
This package functions to obtain, structure, and analyze data from the Bureau of Labor Statistics (BLS) on workplace injuries, specifically nonfatal cases involving days away from work. This package produces a Shiny Web Application built in R that visualizes average days away from work due to injury and predicts days away from work using random forest regression. The data necessary for this package is too large to be included. A sample dataset has been included for the application to run. All data files can be downloaded from the BLS's directory here: https://download.bls.gov/pub/time.series/cs/

2. INSTALLATION

2.1 Importing
To install and setup the code, it is necessary to have the following programs downloaded to your machine: sqlite, R, RStudio.

sqlite - Follow the link to download the correct version of sqlite for your machine: https://www.sqlite.org/download.html

R - Follow the link to download the correct version of R for your machine: https://cran.r-project.org/

RStudio - Follow the link to download the correct version of RStudio for your machine (Free version is adequate for this package): https://www.rstudio.com/products/rstudio/download/
In RStudio you will need to install the following packages: shiny, dplyr, csvread, randomForest, party and plotly. Install by clicking "Install" in the bottom right navigation bar under "Packages" and copy "shiny, dplyr, csvread, randomForest, party, plotly" into the input box.

Once all software is loaded to your machine, create a directory folder with the structure as follow:
			BLS_Injury_Viz/
				|---data/
						|---sqlite3.exe
						|---BLS_IN.txt
				|---clean
						|---Data_Clean.R
				|---visual
					|---application
						|---app.R
						|---data_grouped.csv
						|---random_forest.R
						|---www
							|---bootstrap.css
					|---database
						|---Industry
							|---Accomodation and Food Services
								|---age_toy.csv
								...
							...
					
								
						
						
If you decide to download the flat files from the BLS Web Directory, the full data files the sample data sets are sampled from can be created by running the following code in the shell, assuming the DATA folder is the working directory: 
					$sqlite3 < BLS_IN.txt > BLS_OUT.txt
					Note: This will take over 10 minutes to run.
					
The BLS_IN.txt file will export two CSV files named "blah " and "blah". These files will house all the data needed to create the web application.

3. EXECUTION
To manipulate the data into a structure that can be read by the application, the output files from 2.1 will be imported and cleaned using the Data_Clean.R script. This is only necessary if you do not choose to use the sample datasets.

Open RStudio and load the Data_Clean.R file. 

Once all packages have been installed, select the block of code in the Data_Clean.R file and hit "Run". The R script will manipulate and clean the data then export it to the folder the application file, app.r, is located in. Again, this is only necessary if the sample datasets are not used.

The application is run through the app.R script. To run the application, open RStudio and load the app.R script. If you are running the application with the sample dataset, press "Run App" in the top left corner. If you are using the CSV files from the Data_Clean.R script, navigate to the read.csv() calls in the app.R script and alter the import file names to match the created CSV files. Press "Run App" to start the application.

Upon pressing "Run App", a GUI should appear that houses the visualization and prediction tool. Adjust the parameters and explore the workplace injury data like never before!


