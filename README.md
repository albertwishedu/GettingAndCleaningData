Getting and Cleaning Data Assignment



This file describes how the run_analysis.R script works:


> *   Download and extract the data file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and rename the folder to 'data';

> *   Put the run_analysis.R file into the same folder as the data directory and make sure you set your working directory within R to that directory; 
> *   Next, source("run_analysis.R") within R to generate the tidy data set;
> *   Within the working directory you should find the output data file called 'tidydata_with_means.txt';
> *   Read the data into a new data frame within R: df <- read.table('tidydata_with_means.txt'). 
   
The script itself works in the following way (see R script for inline comments):
[1] Read the training data, labels, subjects into seperate data frames (X_train.txt, Y_train.txt, subject_train.txt)
### 2.  Read the test data, labels, subjects into seperate data frames (X_text.txt, Y_test.txt, subject_test.txt)
### 3.  Join the respective data frames using row binding: rbind()
### 4.  Read the features into a data frame (features.txt)
### 5.  Find relevant columns for subsetting the combined data using grep and regular expression: grep("mean\\(.|std\\(.")
### 6.  Using the columns indentified in 5. subset the data: df <- df[, columns]
### 7.  Sanitize the column names in the data by removing parenthesis and capitalizing 'mean' and 'std' columns. Use make.names() to make sure all column names are validated
### 8.  Read the activities into a data frame (activity_labels.txt)
### 9.  Sanitize the column names by lowercasing activities and disallowing underscores in names.
### 10.  Map labels to activities and rename first column to "activity"
### 11.  Rename first column in the subjects data frame to "subject"
### 12.  Construct first tidy data set by doing a column binding using: subjects, labels and data frames: tidyData1 <- cbind(subjects, labels, data)
### 13.  Aggregate the data from tidyData1 (calculate average of each variable for each activity and each subject): tidyData2 <- with(tidyData1, aggregate(tidyData1[,c(-1,-2)], list(subject, activity), mean))
### 14.  Sanitize aggregated data by renaming column 1 to "subject" and column 2 to "activity"
### 15.  Sort the tidy data by "subject, activity" in increasing order
### 16.  Subset the tidy data since only the first 180 records will contain meaningful entries (30 subjects with 6 activities each)
### 17.  Write the tidy data to 'tidydata_with_means.txt'
