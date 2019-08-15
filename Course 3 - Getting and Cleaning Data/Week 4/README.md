---
title: "README"
author: "Jalal Jalali"
date: "August 14, 2019"
output: html_document
---

## About the analysis

To run the code, make sure that the five data files are in the same folder as the run_analysis.R code. These five files are:  
X_train.txt  
X_test.txt  
features.txt  
subject_train.txt  
subject_test.txt  

The code in run_analysis will do the following:  
1. Reads the train and test files and merges them into merged_df (rbind)  
2. Reads the features file, separates numbers from the feature names and only
   keeps the feature names  
3. Removes "(),-" from feature names, inserts "_" instead of "-"  
4. Parameters 303-344, 382-423, and 461-502 are missing x, y, z. added them  
5. Updates the merged_df column names with the new feature names  
6. Extracts only mean and std columns and saves them into data_stats  
7. Reads subject train and test files, merges them into subject_merged  
8. Creates id_data table that is the merged_df table with the subject_id added  
9. Calculates the mean for each measurement for each subject_id and saves it 
   into subject_avg  
10. Removes the data files and vectors except the ones needed  

