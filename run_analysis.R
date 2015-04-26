## This function is used to create a less cryptic name for the variable headers
## While it's not necessary for the project, it's always a good practice to make
## the resulting datasets more readable.
betterVarNames <- function(varName)
{
  varName <- gsub("-mean\\(\\)","Mean", varName)  #-mean() to Mean
  varName <- gsub("-std\\(\\)","StdDev", varName) #-str() to StdDev
  varName <- gsub("[()]","", varName)             #Removing parenthesis
  varName <- gsub("[-]","", varName)              #Removing dashes 
  varName <- gsub("^f","Frequency", varName)      #Replacing names that start with f
  varName <- gsub("^t","Time", varName)           #Replacing names that start with t
  varName <- gsub("BodyBody","Body", varName)     #Replacing names that start with BodyBody
  
  varName
}

# Set the working directory
setwd("~/R/UCI")

## This is the main processing script used to create tidy dataset from the data
library(dplyr)

############################
## Train data
############################

# First load the train data 
trainDataset <- read.table('train/X_train.txt', sep="")

# Add the lables
trainDatasetLabels <- read.table('train/y_train.txt', sep="")
names(trainDatasetLabels)[1] <- 'ActivityId'
trainDataset <- cbind(trainDataset, trainDatasetLabels )

# Add the subjects
trainDatasetSubjects <- read.table('train/subject_train.txt', sep="")
names(trainDatasetSubjects)[1] <- 'Subject'
trainDataset <- cbind(trainDataset, trainDatasetSubjects)

############################
## Test data
############################

# First load the test data
testDataset <- read.table('test/X_test.txt', sep="")

# Add the labels
testDatasetLabels <- read.table('test/y_test.txt', sep="")
names(testDatasetLabels)[1] <- 'ActivityId'
testDataset <- cbind(testDataset, testDatasetLabels)

# Add the subjects
testDatasetSubjects <- read.table('test/subject_test.txt', sep="")
names(testDatasetSubjects)[1] <- 'Subject'
testDataset <- cbind(testDataset, testDatasetSubjects)


# Join both sets into a single one
combinedDataset <- rbind(testDataset, trainDataset)

#############################
## Set the column names 
#############################

# Get the column names 
colNamesFile <- read.table('features.txt', sep="")

# Get a vector with only the column names
columnNames <- as.character(colNamesFile[,2])

#add the activityId column name
columnNames <- c(columnNames, "ActivityId")
columnNames <- c(columnNames, "Subject")

# rename complete set
names(combinedDataset) <- columnNames

# Load the activity table
activityDataset <- read.table('activity_labels.txt', sep="", col.names=c("ActivityId", "Activity"))

#Join the activity names to the data (this will join by 'ActivityId')
joinedDataset <- inner_join(combinedDataset, activityDataset)

#Repopulate the column names because there's additional columns that were not in the features.txt file
#If we don't do this, the column indexes are not going to match with the dataset and we have trouble :)
columnNames <- names(joinedDataset)

#Get only the columns with mean and std in the name
destinationColumnNames <- grep("-mean\\(\\)|-std\\(\\)", columnNames)
shortDataset <- joinedDataset[destinationColumnNames]
shortDataset <- cbind(shortDataset, Subject = joinedDataset$Subject)
shortDataset <- cbind(shortDataset, Activity = joinedDataset$Activity)

shortDatasetColumns <- names(shortDataset)
names(shortDataset) <- lapply(shortDatasetColumns, betterVarNames)

#Summarize the data by Subject and Activity
tidyDataset <- ddply(shortDataset, .(Subject, Activity), .fun = function(x) { colMeans(x[,1:66]) } )

write.table(tidyDataset, "TidyData.txt", row.name=FALSE) 
