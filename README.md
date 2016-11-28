# getting-and-cleaning-data-project
## Introduction
The purpose of the files in the repo is the demonstrate:
- Retrieving data
- Loading data
- Merging data
- Making column names more understandable
- Mutating data to add additional columns
- Creating a tidy dataset
- Writing data out to a file

The above listed items are all demonstrated in the run_analysis.R script.  In addition to the default packages used by _R_ the run_analyis.R script uses the _dply_ and _data.table_ packages.

## run_analysis.R
### Retrieving data
The run_analysis.R script initially checks for the existence of the _UCI_HAR_Dataset.zip_ file.  If the file does not exist then it will be downloaded from the <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> using the _download.file_ method.  Once downloaded the unzip function is used to decompress the file.

### Loading data
The data is loaded into _R_ via the _fread_ function from the _data.table_ package.  For this analysis the following files where loaded from the downloaded data:
- UCI HAR Dataset/test/X_test.txt
- UCI HAR Dataset/test/y_test.txt
- UCI HAR Dataset/test/subject_test.txt
- UCI HAR Dataset/train/X_train.txt
- UCI HAR Dataset/train/y_train.txt
- UCI HAR Dataset/train/subject_train.txt
- UCI HAR Dataset/activity_labels.txt
- UCI HAR Dataset/features.txt

### Merging data
The scripts begins the process of merging the data by assigning column names to the various *training* data sets.  The primary variable names are extracted from the previously mentioned _features.txt_ file.  Then the _cbind_ function is used to merge the *training* data columns.  The *test* data is then merged in the same fashion.  Since the *testing* data and the *training* data have the same columns we can extract the columnn names from the merged *training* data set and assign it to the merged *testing* dataset.  Now that the *testing* and *training* data both have the same columns and column names the script can use the _rbind_ function to merge them into one cohesive dataset.

### Making column names more understandable
The script performs several operations to transform the column names into something more understandable.  Bolow is a list of the operations.  All operations are performed to all column headers.
- replace all "()" with empty strings
- convert all characters to lower case
- use the _make.names_ function to ensure that the column names are syntacticly correct.  This method removes characters such as underscores and replaces them with periods.
- replace "std" with "standard.deviation"
- if a column name starts with "t" then replace it with "time."
- if a column name starts with "f" then replace it with "frequency."
- replace all "acc" with "accelerometer"
- replace all "gyro" with "gyroscope"
- replace all "mag" with "magnitude"
- if a column name ends with "freq" then replace it with "frequency"
- replace all double periods ".." with a single period "."

### Mutating data to add the activity labels
The _mutate_ function from the _dplyr_ package is used to assign the appropriate _activity label_ based on the observation's _activity.id_.  Activity labels where extracted from the _activity_labels.txt_ file.

### Creating a tidy dataset
The _aggregate_ function is used to create the _tidy dataset_.  It takes the previously mentioned merged dataset, calculates the mean of each column and groups by the _activity.id_ and the _subject.id_ variables.

### Writing data out to a file
The _write.table_ function is used to output the data to the file system.  The resulting output file is named _tidyOutput.csv_.
