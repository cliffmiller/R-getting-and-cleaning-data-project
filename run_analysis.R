
#Import libraries
library(dplyr)
library(data.table)

zipFileName <- "UCI_HAR_Dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists(zipFileName)) {
  print(paste("Downloading file: ", fileUrl, "to", zipFileName))
  download.file(fileUrl, destfile = zipFileName, method = "curl")
  
  print(paste("Extracting: ", zipFileName))
  unzip(zipFileName)
}
print("Loading data...")
xTest <- fread("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
yTest <- fread("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subjectTest <- fread("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

xTrain <- fread("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
yTrain <- fread("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTrain <- fread("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

activityLabels <- fread("./UCI HAR Dataset/activity_labels.txt")
features <- fread("./UCI HAR Dataset/features.txt")

print("Setting column names in the Training data.")
colnames(xTrain) <- features[[2]]
colnames(yTrain) <- "activity.id"
colnames(subjectTrain) <- "subject.id"
colnames(activityLabels) <- c("activity.id", "activity.type")

print("Merging Training data...")
mergedTrainData <- cbind(yTrain, subjectTrain, xTrain)

print("Merging Test data...")
mergedTestData <- cbind(yTest, subjectTest, xTest)

print("Setting merged Test data column names to the same values as the Training data column names...")
colnames(mergedTestData) <- colnames(mergedTrainData)

print("Merging Training and Test data...")
fullMerge <- rbind(mergedTrainData, mergedTestData)

print("Determine which columns contain either mean() or std()...")
matchingColumns <- which(grepl("activity.id|subject.id|mean()|std()", colnames(fullMerge)))
meanAndStdData <- fullMerge[, matchingColumns, with = FALSE]

print("Making the column names more readable...")
readableColumnNames <- gsub("\\(\\)", "", colnames(meanAndStdData))
readableColumnNames <- tolower(readableColumnNames)
readableColumnNames <- make.names(readableColumnNames)
readableColumnNames <- gsub("std", "standard.deviation",readableColumnNames)
readableColumnNames <- sub("^(t)", "time\\.",readableColumnNames)
readableColumnNames <- sub("^(f)", "frequency\\.",readableColumnNames)
readableColumnNames <- gsub("acc", "\\.accelerometer\\.",readableColumnNames)
readableColumnNames <- gsub("gyro", "\\.gyroscope\\.",readableColumnNames)
readableColumnNames <- gsub("mag", "\\.magnitude",readableColumnNames)
readableColumnNames <- sub("freq$", "\\.frequency",readableColumnNames)
readableColumnNames <- gsub("\\.\\.", "\\.",readableColumnNames)

colnames(meanAndStdData) <- readableColumnNames

print("Adding activity names based on activity.id values...")
meanAndStdData <- mutate(meanAndStdData, activity.id = activityLabels$activity.type[activity.id])

print("Creating tidy data set")
tidyData <- aggregate(meanAndStdData[, names(meanAndStdData) != c("activity.id", "subject.id")], 
                  by = list(activity.id = meanAndStdData$activity.id, subject.id = meanAndStdData$subject.id), 
                  mean)

print(tidyData)
