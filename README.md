---
title: "README.md"    # you must have lines similar to these in your Rmd file
---

## Executive Summary

The purpose of this software is to prepare tidy data from exercise sensor data. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This software assumes that the working directory is set to the directory where the above is unzipped.

## Implementation

This software performs the following
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
library(plyr)
library(data.table)

## Read in training sets
trainingSet <- read.table(file="UCI HAR Dataset/train/X_train.txt")
testSet <- read.table(file="UCI HAR Dataset/test/X_test.txt")
trainingYSet <- read.table(file="UCI HAR Dataset/train/Y_train.txt")
testYSet <- read.table(file="UCI HAR Dataset/test/Y_test.txt")

## Merge x y data
mergedSet <- rbind(trainingSet,testSet)
mergedYSet <- rbind(trainingYSet,testYSet)

## Add feature information
features = read.table(file="UCI HAR Dataset/features.txt")

namedMergeSet <- mergedSet
names(namedMergeSet) <- features$V2

# Lower case gets only the methods in this case (the project description was vague on this)
filteredMergedSet <- namedMergeSet[,grep('mean|std',features$V2)]
cols <- colnames(filteredMergedSet)

## Add activity information
filteredMergedSet["Activity"]<-mergedYSet

## Find mean
DT <- data.table(filteredMergedSet)
DT <- DT[,lapply(.SD,mean), by=Activity]

write.table(DT,file="tidy.txt",row.name=FALSE)
```