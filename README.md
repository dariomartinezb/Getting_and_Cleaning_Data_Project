
# Readme.md

## Human Activity Recognition Using Smartphones Data Set


This repo contains the files needed to run the Getting and Cleaning Data Project from Coursera.

For this to work, a few assumptions are being made:

	* The dataset to be processed has to reside in the same location as the run_analysis.R script.
	* You have downloaded the dataset, which can be obtained from the following URL

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

	* The working directory needs to be set to where the script and the data are located.

This script produces a file called "TidyData.txt", which is also included in this repo for comparison.

The script does the following:
  * Merges the training and the test sets to create one data set.
  * Extracts only the measurements on the mean and standard deviation for each measurement.
  * Uses descriptive activity names to name the activities in the data set
  * Labels the data set with descriptive variable names.
  * Creates a tidy data set with the average of each variable for each activity and each subject.
  