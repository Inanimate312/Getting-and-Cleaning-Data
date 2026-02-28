# Getting-and-Cleaning-Data

The run_analysis.R program performs basic data collection and cleaning to produce a tidy dataset containing Human Activity Recognition data from the UC Irvine Machine Learning Repository: https://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones. This data is initially available in two partitions: training and testing data, which contain data recorded by a wearable device that subjects wore while performing various activities. Results data are recorded in various "feature" variables.

The run_analysis program produces a table called training_and_testing_averages, as follows (see the data dictionary below for column definitions):
  1. Downloads and unzips the HAR files to the working directory
  2. Reads in training and testing files
  3. Cleans the training and testing files:
    a. Assigns descriptive column names
    b. Assigns descriptive values (i.e., using activity names and feature names obtained from the features_info file)
    c. Pivots the data into long format, where each row represents one subject, activity, feature, and result value
    d. Merges the training and testing data into a single data set
  4. Extracts the mean and standard deviation results
  5. Calculates the average result value for each subject, activity, and feature

Data dictionary:
subject_id: the training/test subject ID number. Valid values include integers from 1-30.
activity: the activity performed by the training/test subject. Valid values include: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.
feature: the mean and standard deviation results from the following measurements recorded by the subject's wearable device (see the features_info file for more information):
  tBodyAcc-XYZ
  tGravityAcc-XYZ
  tBodyAccJerk-XYZ
  tBodyGyro-XYZ
  tBodyGyroJerk-XYZ
  tBodyAccMag
  tGravityAccMag
  tBodyAccJerkMag
  tBodyGyroMag
  tBodyGyroJerkMag
  fBodyAcc-XYZ
  fBodyAccJerk-XYZ
  fBodyGyro-XYZ
  fBodyAccMag
  fBodyAccJerkMag
  fBodyGyroMag
  fBodyGyroJerkMag
average: the average value for the given subject, activity, and feature.
