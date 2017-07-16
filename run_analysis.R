library(dplyr)
library(tidyr)

# Cleans the UCI HAR Dataset from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

read_files <- function() {
    # Stores necessary data files in tables
    subject_test <<- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
    dat_test <<- read.table("./UCI HAR Dataset/test/X_test.txt")
    activity_test <<- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity", colClasses = "factor")
    subject_train <<- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
    dat_train <<- read.table("./UCI HAR Dataset/train/X_train.txt")
    activity_train <<- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity", colClasses = "factor")
    features <<- read.table("./UCI HAR Dataset/features.txt", sep = " ")[[2]]
    activity_labels <<- read.table("./UCI HAR Dataset/activity_labels.txt", sep = " ", colClasses = "character")[[2]]
}

name_columns <- function(x) {
    # Takes test/train data table, filters out and labels the mean/std columns appropriately
    mean_std_cols <- grep("mean\\(\\)|std\\(\\)", features)    # indexes of columns with mean and std measurements
    named_table <- x[, mean_std_cols]
    mean_std_features <- as.character(features[mean_std_cols])
    col_names <- sub("\\(\\)", "", mean_std_features)
    col_names <- gsub("-", "_", col_names)
    names(named_table) <- col_names
    named_table
}

name_activities <- function(x) {
    # Replaces numeric values in "Activity" columns with the respective activity description
    levels(x[[1]]) <- activity_labels
    x
}

merge_train_test <- function() {
    # Merges the named train and test data sets to create one data set
    # Returns a tibble of the combined data set
    if (!exists("subject_test")) {
        read_files()
    }
    dat_test <- name_columns(dat_test)
    dat_train <- name_columns(dat_train)
    activity_test <- name_activities(activity_test)
    activity_train <- name_activities(activity_train)
    test <- cbind(subject_test, activity_test, dat_test)
    train <- cbind(subject_train, activity_train, dat_train)
    combined_data <- tbl_df(rbind(test, train))
    arrange(combined_data, Subject, Activity)
}

# Creates from combined data set a separate data set with the average of each variable for each activity and each subject.
summarized_data <- merge_train_test() %>%
    group_by(Subject, Activity) %>%
    summarise_all(mean) 

# Tidies data
tidy_data_1 <- summarized_data %>%
    gather(Feature_Statistic_Coordinate, Signal, -(Subject:Activity)) %>%
    separate(Feature_Statistic_Coordinate, c("Feature", "Statistic", "Coordinate"), sep = "_", fill = "right") 
tidy_data_1$Coordinate[is.na(tidy_data_1$Coordinate)] <- ""
tidy_data <- tidy_data_1 %>%
    replace_na(list(rep("", 6))) %>%
    unite(Features, c(Feature, Coordinate), sep = "_") %>%
    spread(Features, Signal)

