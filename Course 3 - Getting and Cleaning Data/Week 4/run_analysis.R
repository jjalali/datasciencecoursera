# Course Project - Course 3 (Getting and Cleaning Data) Week 4
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
rm(list = ls())

library(tidyverse)


# download the zip file
zip_file_path <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(zip_file_path,temp)
unzip(temp)

# Read train data 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")


# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")


# read activity labels and features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")


# add column names
y_train <- rename(y_train, activity = V1)
y_test <- rename(y_test, activity = V1)

subject_train <- rename(subject_train, subject_id = V1)
subject_test <- rename(subject_test, subject_id = V1)

subject_data <- rbind(subject_train, subject_test)

# merge training and testing datasets
X_data <- rbind(X_train, X_test)

# merge training and test labels
y_data <- rbind(y_train, y_test)

# get column numbers that contain mean() and std() from the features table
mean_std_cols <- features %>% 
        filter(str_detect(V2, "[Mm]ean\\(\\)|[Ss]td\\(\\)"))

# extract column numbers that have mean() and std()
mean_std_cols <- as.numeric(unlist(mean_std_cols[1]))

# create a subset of the data that are only mean() and std() of measurements
subset_mean_std <- X_data[mean_std_cols]
# write.table(subset_mean_std, "mean_std.txt", row.names = FALSE)


# use descriptive activity names for activites

# help from http://stat545.com/bit008_lookup.html
act <- tbl_df(activity_labels)
indices <- match(x = y_data$activity, table = act$V1)

# add activity labels to Data
subset_mean_std <- subset_mean_std %>% 
        mutate(activity = act$V2[indices] )

# cleaning the variable names, removing special characters and making 
# everything lowercase
features[,2] <- features[,2] %>%
        # remove parentheses, comma, and dash
        sapply(str_replace_all, "\\)", "") %>%
        sapply(str_replace_all, "\\(", "") %>%
        sapply(str_replace_all, "\\,", "") %>%
        sapply(str_replace_all, "-", "") %>%
        sapply(str_replace_all, "-", "") %>%
        # repalce t with time and f with freq, suggested by
        # https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view
        sapply(str_replace, "^t", "time") %>%
        sapply(str_replace, "^f", "freq") %>%
        
        tolower()

# get the column names from the dataset
new_labels <- names(subset_mean_std[1:(ncol(subset_mean_std)-1)])

# remove the "V" from the names. the remaining will be the row number 
# in the features table that contains the corrent feature name
new_labels <- sapply(new_labels, substr, 2,4)
new_labels <- as.vector(new_labels)

# update the subset_mean_std column names with the names from features
for (i in 1:(ncol(subset_mean_std)-1)) {
        # m <- as.numeric(new_labels[i])
        colnames(subset_mean_std)[i] <- features[as.numeric(new_labels[i]),2]
}


# add the subject id to the data
subset_mean_std <- cbind(subset_mean_std, subject_data)

# summarize based on subject id then activity
tidy_data <- subset_mean_std %>%
        group_by(subject_id, activity) %>%
        summarise_all(mean)

# write the tidy data to a txt file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)


# remove files that are no longer needed
rm(y_train, y_test, X_train, X_test, subject_train, subject_test, act, 
   activity_labels, X_data, y_data, i, indices, new_labels,subject_data)

