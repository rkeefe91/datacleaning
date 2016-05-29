getdata <- function(dir = "./Data") {
  
  ### Looks in subdirectory dir to find the HAR dataset downloaded from
  ### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
  ### requires dplyr
  
  
  ### Extracts the files and saves in file list
  ###  
  
  setwd(dir)
  
  ## Read the features datatable
  
  features <- read.delim("features.txt",header = FALSE, sep = " ", col.names = c("index","feature"))
  
  
  ## Append a logical variable "include" indicating if feature is a mean or std deviation
  
  features$include <- grepl('mean()',features$feature)|grepl('std()',features$feature)
  
  ## Read the activity labels table
  
  alabels <- read.delim("activity_labels.txt" ,header = FALSE, sep = "", col.names = c("activitynum","activity"))
  
  
  ## Load the training set and save as "xtrain", load the subject key and save as "strain"
  
  setwd("train")
  
  xtrain <- read.delim("X_train.txt" ,header = FALSE, sep = "")
  ytrain <- read.delim("y_train.txt" ,header = FALSE, sep = "", col.names = "activitynum")
  strain <- read.delim("subject_train.txt" ,header = FALSE, sep = "", col.names = "subject")
  
  ## Load the testing set and save as "xtest". Save the subject key as "stest"
  
  setwd("..")
  setwd("test")
  
  xtest <- read.delim("X_test.txt" ,header = FALSE, sep = "")
  ytest <- read.delim("y_test.txt" ,header = FALSE, sep = "", col.names = "activitynum")
  stest <- read.delim("subject_test.txt", sep= "", header = FALSE, col.names = "subject")
  
  
  ##  Assign column names to xtrain and xtest from features vector
  
  colnames(xtrain) <- features$feature
  colnames(xtest) <- features$feature
  

  ##  Create new subsetted tables by removing the extra columns
  
  xnewtest <- subset(xtest, select = features$include)
  xnewtrain <- subset(xtrain, select = features$include)
  
  
  ## Append the subject column to the tables
  
  xnewtest <- bind_cols(xnewtest, stest)
  xnewtrain <- bind_cols(xnewtrain, strain)
  
  
  ## Append the activity label to the tables
  
  xnewtest <- bind_cols(xnewtest, ytest)
  xnewtrain <- bind_cols(xnewtrain, ytrain)
  
  
  ## Combine the training and test dataframes in to xall
  
  xall <- bind_rows(xnewtest,xnewtrain)
  
  
  ## Add the description of the activity

  xall <- inner_join(xall,alabels)
    
  ### Create a table for each of the 6 activities showing variable averages by subject
    ## From the data set in step 4, creates a second, independent tidy data set with 
    ## the average of each variable for each activity and each subject.
  
  
  ## Intiatialize a blank dataframe
  
  mean.df <- NULL
  
  
  ## Create a new df without the activity column. xall2 will be completely numeric
  
  xall2 <- xall[,1:81]

  ## Iterate through the subjects 1 through 30
  
  for(i in 1:30){
    
    ## Iterate through the activites, 1 through 6
    
    for(j in 1:6){
      
      # Create a row containing the mean for each variable in xall2 for subject i and activity j
      
      tempsubj <- filter(xall2, subject == i)
      tempsubjact <- filter(tempsubj, activitynum == j)
      meanvec <- summarise_each(tempsubjact, funs(mean))
      
      # Append the row to the results dataframe
      
      mean.df <- rbind(mean.df, meanvec)
      
      }
    
  }
  
  
  #Finally, add the activity description column
  
  mean.df <- inner_join(mean.df,alabels)
  
  
  mean.df
  
}