################################################################################
#
#                         Run Analysis Program
#
#   This program downloads, cleans, and analyzes data from UCI HAR.
#
################################################################################
# 1. Initialize and download UCI HAR data sets
################################################################################
# Set URL and filepath
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- file.path(getwd(), "samsung-accelerometer-data.zip")

# Download and unzip file if not already downloaded
if(!file.exists(zipfile)) {
  download.file(url,
                destfile = zipfile)
  unzip(zipfile)
}

# Set file paths for various sub-folders in the unzipped folder

# Parent folder
filepath_all_files <- file.path(
  getwd(),"UCI HAR Dataset"
)
# Testing files
filepath_test_files <- file.path(
  filepath_all_files,"test"
)
# Training files
filepath_training_files <- file.path(
  filepath_all_files,"train"
)
# Testing Inertial Signals files
filepath_test_inertial_files <- file.path(
  filepath_test_files,"Inertial Signals"
)
# Training Inertial Signals files
filepath_training_inertial_files <- file.path(
  filepath_training_files,"Inertial Signals"
)

################################################################################
# 2. Read in and clean training and testing files
################################################################################
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)



## Read in informational data files

# README
readme <- readr::read_lines(
  file.path(filepath_all_files,"README.txt"))

# Features Info
features_info <- readr::read_lines(
  file.path(filepath_all_files,"features_info.txt"))

# Features file
features <- readr::read_table(
  file.path(filepath_all_files, "features.txt"), 
  col_names = FALSE)

features <- features %>% purrr::set_names(c("feature","feature_name"))

# Activity Labels
activity_labels <- readr::read_table(
  file.path(
    filepath_all_files,"activity_labels.txt"), 
  col_names = FALSE)

activity_labels <- activity_labels %>% purrr::set_names(c("activity","activity_name"))



## Read in training data files

# Training - Subject Train: This table contains the training subjects who
# performed the activity for each window sample.
subject_train <- readr::read_table(
  file.path(
    filepath_training_files,"subject_train.txt"),
    col_names = "subject_id")

# Training - X Train: This table contains the training set.
x_train <- readr::read_table(
  file.path(filepath_training_files, "X_train.txt"),
  col_names = FALSE)

# Set the x_train column names to the corresponding feature names
x_train <- x_train %>% purrr::set_names(features$feature_name)

# Training - Y Train: This table contains training labels.
y_train <- readr::read_table(
  file.path(
    filepath_training_files,"y_train.txt"), 
  col_names = "activity")

# Use the actual activity names instead of the activity indices
y_train <- y_train %>%
  left_join(activity_labels, by = "activity") %>%
  select(activity = activity_name)

# Combine subject_train, y_train, and x_train and pivot to long format
training_data <- bind_cols(subject_train, y_train, x_train)

training_data <- training_data %>%
  pivot_longer(
    cols = -c(subject_id, activity),
    names_to = "feature",
    values_to = "value"
  )



## Read in testing data files 

# Testing - Subject Test: This table contains the testing subjects
subject_test <- readr::read_table(
  file.path(
    filepath_test_files,"subject_test.txt"),
  col_names = "subject_id")


# Testing - X Test: This table contains the testing set.
x_test <- readr::read_table(
  file.path(filepath_test_files, "X_test.txt"),
  col_names = FALSE)

# Set the x_test column names to the corresponding feature names
x_test <- x_test %>% purrr::set_names(features$feature_name)

# Testing - Y Test: This table contains the testing labels.
y_test <- readr::read_table(
  file.path(
    filepath_test_files,"y_test.txt"),
  col_names = "activity")

# Use the actual activity names instead of the activity indices
y_test <- y_test %>%
  left_join(activity_labels, by = "activity") %>%
  select(activity = activity_name)

# Combine subject_test, y_test, and x_test and pivot to long format
testing_data <- bind_cols(subject_test, y_test, x_test)

testing_data <- testing_data %>%
  pivot_longer(
    cols = -c(subject_id, activity),
    names_to = "feature",
    values_to = "value"
  )



## Merge the training and testing data sets
testing_and_training_data <- dplyr::bind_rows(training_data, testing_data)
View(testing_and_training_data)



################################################################################
# 3. Analyze the testing and training data
################################################################################
## Extract only the measurements on the mean and standard deviation
mean_and_stdev <- testing_and_training_data %>%
  filter(
    str_detect(feature, fixed("mean()")) | 
    str_detect(feature, fixed("std()"))
)

# Validate that only means and stdevs are included in the data set
unique(str_extract(mean_and_stdev$feature, "mean|std")) # "mean" and "std"



## Create a second data set with the average of each variable by activity and subject
training_and_testing_averages <- mean_and_stdev %>%
  group_by(subject_id, activity, feature) %>%
  summarise(average = mean(value), .groups = "drop")
View(training_and_testing_averages)
