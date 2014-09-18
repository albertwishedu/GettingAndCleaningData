# 1. Merge the training and the test sets to create one data set
#    Read training set

setwd("c:\\MyR\\GettingAndCleaningData\\Data")
trainData <- read.table("./train/X_train.txt")
trainLabels <- read.table("./train/Y_train.txt")
trainSubjects <- read.table("./train/subject_train.txt")

#   Read test set
testData <- read.table("./test/X_train.txt")
testLabels <- read.table("./test/Y_train.txt")
testSubjects <- read.table("./test/Subject_test.txt")

# Join the data sets by row binding 
joinedData <- rbind(trainData, testData)
joinedLabels <- rbind(trainLabels, testLabels)
joinedSubjects <- rbind(trainSubjects, testSubjects)

#   Clean up unused objects
rm(trainData, testData, trainLabels, testLabels, trainSubjects, testSubjects)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
#    Read features
features <- read.table("./features.txt")

# Find variables(columns) related to mean and std deviation
columns <- grep("mean\\(.|std\\(.", features[,2])

# Subset the joined data set to extract the right columns 
joinedData <- joinedData[, columns]

# Sanitize column names 
names(joinedData) <- gsub("\\(\\)", "", features[columns,2])
names(joinedData) <- gsub("mean", "Mean", names(joinedData))
names(joinedData) <- gsub("std", "Std", names(joinedData))
names(joinedData) <- make.names(names(joinedData))

# Clean up unused objects
rm(columns, features)

# 3. Use descriptive activity names to name the activities in the data set.
#Read the activity data
activity <- read.table("./activity_labels.txt")
activity[,2] <- tolower(make.names(activitiy[,2], allow_=FALSE))
joinedLabels[, 1] <- activitiy[joinedLabels[,1], 2]
names(joinedLabels) <- "activity"

#Clean up unused objects
rm(activity)

# 4. Appropriately label the data set with descriptive variable names.
names(joinedSubjects) <- "subject"

#Bind data using column binding
tidyDataTemp <- cbind(joinedSubjects, joinedLabels, joinedData)
#Clean up unused objects
rm(joinedSubjects, joinedLabels, joinedData)

# 5. Create an independent tidy dataset with the average of each variable for each activity and each subject.
tidyData <- with(tidyDataTemp, aggregate(tidyDataTemp[, c(-1,-2)], list(subject, activity), mean))

# Fix column names after aggregation
names(tidyData)[1] <- "subject"
names(tidyData)[2] <- "activity"

# Sort data by "subject, activity"
tidyData <- tidyData[order(tidyData[, 1:2]), ]
tidyData <- tidyData[1:180, ]

# Write tidy Data without row names as specified in assignment
write.table(tidyData, file="tidydata_with_means.txt", row.names=FALSE)
