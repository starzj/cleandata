library(plyr)
library(data.table)

#setwd("C:/Users/jstarz/Documents/Jim/school/getcleandata/Project")

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