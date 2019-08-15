---
title: "CodeBook"
author: "Jalal Jalali"
date: "August 14, 2019"
output: html_document
---

## CodeBook

The original features were read from the file. Each line contains a number and the variable name.  These two had to be separated and only the variable name was kept. To tidy the variable names, all the special characters, "()," were removed and an underscore was placed instead of a dash.  
The entire variable was changed to be lowercase.  
  
1. Removes "(),-" from feature names, inserts "_" instead of "-"  
2. Parameters 303-344, 382-423, and 461-502 are missing x, y, z. These are the Fast Fourier Transform variables fBodyAcc, fBodyAccJerk, and fBodyGyro. I had to add the X, Y, and Z to the end of each category.  
  
3. replaced 1, 2, 3, and 4 with their corresponding activity level labels:  
        1: walking  
        2: walking_up (for walking upstairs)  
        3: walking_dn (for walking downstairs)  
        4: sitting  
  
I have kept the variable names as close to their original form as possible.  
