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

# Read train data into train_df
train_df <- read.table("X_train.txt", header = FALSE, sep = "")
# train_df <- tbl_df(train)
# rm(train)

# read test data file into test_df
test_df <- read.table("X_test.txt", header = FALSE, sep = "")
# test_df <- tbl_df(test)
# rm(test)

# merge the two data sets into merged_df
# merged_df <- rbind(train, test)
merged_df <- rbind(train_df, test_df)
# merged_df <- tbl_df(rbind(train_df, test_df))

# import the feature names
features_orig <- read_tsv("features.txt", col_names = FALSE)

# extract the feature name and discard the row number
features_orig <- separate(features_orig, X1, c(NA, "feature"), " ")

# remove special characters from the feature names
features <- features_orig  %>%
        # update the movements from numbers to more meaningful names - X direction
        sapply(str_replace_all, "\\)1", "\\)_walking") %>%
        sapply(str_replace_all, "\\)2", "\\)_walking_up") %>%
        sapply(str_replace_all, "\\)3", "\\)_walking_dn") %>%
        sapply(str_replace_all, "\\)4", "\\)_sitting") %>%
        
        # remove parentheses, comma, and dash
        sapply(str_replace_all, "\\)", "") %>%
        sapply(str_replace_all, "\\(", "") %>%
        sapply(str_replace_all, "\\,", "") %>%
        sapply(str_replace_all, "-", "") %>%
        
        sapply(str_replace_all, "X1", "x_walking") %>%
        sapply(str_replace_all, "X2", "x_walking_up") %>%
        sapply(str_replace_all, "X3", "x_walking_dn") %>%
        sapply(str_replace_all, "X4", "x_sitting") %>%
        
        # update the movements from numbers to more meaningful names - Y direction
        sapply(str_replace_all, "Y1", "y_walking") %>%
        sapply(str_replace_all, "Y2", "y_walking_up") %>%
        sapply(str_replace_all, "Y3", "y_walking_dn") %>%
        sapply(str_replace_all, "Y4", "y_sitting") %>%

        # update the movements from numbers to more meaningful names - Z direction
        sapply(str_replace_all, "Z1", "z_walking") %>%
        sapply(str_replace_all, "Z2", "z_walking_up") %>%
        sapply(str_replace_all, "Z3", "z_walking_dn") %>%
        sapply(str_replace_all, "Z4", "z_sitting") %>%
        
        tolower()

features_orig <- tbl_df(features_orig)
features <- tbl_df(features)

# direction is missing from some parameters, add them
for (i in 303:316) {
        features[i,1] <- paste0(features[i,1], "_x")
}

for (i in 317:330) {
        features[i,1] <- paste0(features[i,1], "_y")
}

for (i in 331:344) {
        features[i,1] <- paste0(features[i,1], "_z")
}

for (i in 382:395) {
        features[i,1] <- paste0(features[i,1], "_x")
}

for (i in 396:409) {
        features[i,1] <- paste0(features[i,1], "_y")
}

for (i in 410:423) {
        features[i,1] <- paste0(features[i,1], "_z")
}

for (i in 461:474) {
        features[i,1] <- paste0(features[i,1], "_x")
}

for (i in 475:488) {
        features[i,1] <- paste0(features[i,1], "_y")
}

for (i in 489:502) {
        features[i,1] <- paste0(features[i,1], "_z")
}


# convert features to a vector
features <- as.list(features) %>%
        transpose %>%
        unlist

        # unlist(transpose(as.list(features)))

# convert data to a data frame
merged_df <- as.data.frame(merged_df)

# update column names of the data frame
names(merged_df) <- features

# make a tibble
merged_df <- tbl_df(merged_df)


# extract only mean and standard deviation and save in data_stats
data_stats <- merged_df %>%
        select(matches('mean|std'))


# import subject IDs for both training and testing sets
subject_train <- read.table("subject_train.txt", header = FALSE, sep = "")

subject_test <- read.table("subject_test.txt", header = FALSE, sep = "")

# merge the two tables
subject_merged <- rbind(subject_train, subject_test)

# create another table with data and subject IDs
id_data <- cbind(merged_df, subject_merged)

# rename the column to subject_id
id_data <- rename(id_data, subject_id = V1)

subject_avg <- id_data %>%
        group_by(subject_id) %>%
        summarise_all(mean)

rm(i, train_df, test_df, subject_train, subject_test)


