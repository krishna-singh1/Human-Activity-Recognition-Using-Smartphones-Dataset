activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2] )

features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Extracts only the measurements on the mean and standard deviation for each measurement
featuresWanted <- grep(".*mean.*|.*std.*",features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names <- gsub('-mean','Mean',featuresWanted.names)
featuresWanted.names <- gsub('-std','Std',featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#Load the training datasets, training lables and subject who performed the activity window sample 
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Merge Training dataset, Activities and Subjects
train <- cbind(trainSubjects, trainActivities, train)

#Load the testing datasets, testing lables and subject who performed the activity window sample 
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merge Testing dataset, Activities and Subjects
test <- cbind(testSubjects, testActivities, test)

#Merges the training and the testing data sets to create one data set
CombinedData <- rbind(train, test)

#Appropriately labels the data set with descriptive variable names
colnames(CombinedData) <- c("subject", "activity", featuresWanted.names)

#Convert activities & subjects into factors from activityLabels
CombinedData$activity <- factor(CombinedData$activity, 
                                levels = activityLabels[,1], 
                                labels = activityLabels[,2])

CombinedData$subject <- as.factor(CombinedData$subject)

library(reshape2)
CombinedData.melted <- melt(CombinedData, id = c("subject", "activity"))
CombinedData.mean <- dcast(CombinedData.melted, 
                           subject + activity ~ variable, mean)

#Upload complete data set as a txt file created with write.table() using row.name=FALSE
write.table(CombinedData.mean, file = "TidyDataSet.txt", 
            row.names = FALSE, quote = FALSE)
