"# datacleaning" 
 run_analysis.R

This includes function called "getdata(dir = "./Data"). The function has one argument which 
specificies the location of the root file of the HAR dataset

getdata requires dplyr to be installed and library(dplyr) called prior to execution

getdata performs the following steps:

Looks in subdirectory dir to find the HAR dataset downloaded from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Reads the features datatable and marks the fields associated with a mean or std deviation

Read the activities label database

Loads the datatables from the training and test databases and labels the columns

Removes the unneeded fields from the training and test databases

Combines the training and test datatables

Adds the activity descriptions

This creates a large datatable with all data from the required fields

 We now create a table for each of the 6 activities showing variable averages by subject
from the data set in step 4, creates a second, independent tidy data set with 
 the average of each variable for each activity and each subject.


To do this we iterate through subject and activity creating a row with averages for all data fields 
for that subject and activity and add that, row by row to the output datatable
