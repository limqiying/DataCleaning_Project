# Data Cleaning Project
## Qi Ying Lim

This project is a submission for Coursera's Johns Hopkins Data Science, Data Cleaning track.
Data is taken from the study at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, the data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The script assumes that the unzipped data folder is placed in the working directory.

### The script includes the following functions:
 - read_files(): reads in data files and assigns them to respective global variables.
 
 - name_columns(): filters out the columns corresponding to mean and std data, and assigning them descriptive variable names
 
 - name_activities (): replaces numeric identifies with descriptive activity factors.
 
 - merge_train_test(): merges both training and test data sets
 
### The script then tidies up the merged data set:

 - uses dplyr to group by Subject and Activity, then taking the mean of each variable

 - stores "mean" and "std" as variables in their own column, named "Statistic".

Since some variables did not have any coordinates, I did not allocate a "Coordinate" column and left them combined with the feature variables.
 
 
