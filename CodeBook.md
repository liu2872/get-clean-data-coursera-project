# get-clean-data-coursera-project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. xtracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.Cousera Final Project Code Book
To finish this project, I used package called dplyr and saved all related files in my local drive: 
C:/WFH Cdrive/
For the first steps, I upload all files to R studio and rename tables by using read.table function. 
peopleintestfolder=read.table("./test/subject_test.txt")
resultintestfolder=read.table("./test/x_test.txt")
activityintestfolder=read.table("./test/y_test.txt")
resultintrainfolder=read.table("./train/x_train.txt")
activityintrainfolder=read.table("./train/y_train.txt")
features=read.table("./features.txt", as.is = TRUE)
activity=read.table("./activity_labels.txt")
For the first question: Merges the training and the test sets to create one data set.
1.	I used cbine and rbind to combine everything together and name the consolidate table as “result”.
result= rbind(cbind(peopleintestfolder,resultintestfolder,activityintestfolder),
cbind(peopleintrainfolder,resultintrainfolder,activityintrainfolder))
2.	I need to match features and activity together 
features=read.table("./features.txt", as.is = TRUE)
activity=read.table("./activity_labels.txt")
colnames(activity)=c("ActivityId", "ActivityLabel")
3.	Then I rename all columns in the result table. 
colnames(result) <- c("subject", features[, 2], "activity")
For the second questions: extracts only the measurements on the mean and standard deviation for each measurement.
1.	I used grepl function to filter out columns other than mean and standard deviation. 
MeanandStdOnly=grepl("subject|activity|mean|std", colnames(result))
result=result[, MeanandStdOnly]
For the third questions: Uses descriptive activity names to name the activities in the data set
I changed the activity code to the actual names
result$activity <- factor(result$activity, 
                                 levels = activity[, 1], labels = activity[, 2])
For the forth question: Appropriately labels the data set with descriptive variable names.
I found all descriptive information in features file. Explanations are followings: 
        #1. tBodyAcc-XYZ: body acceleration signals time
        #2. tGravityAcc-XYZ: gravity acceleration signals time
        #3. tBodyAccJerk-XYZ: body linear acceleration obtains Jerk signals time
        #4. tBodyGyro-XYZ: body gyroscope signals time
        #5. tBodyGyroJerk-XYZ: body gyroscope obtains Jerk signals time
        #6. tBodyAccMag: magnitude of body acceleration signals time
        #7. tGravityAccMag: magnitude of gravity acceleration signals time
        #8. tBodyAccJerkMag: magnitude of body linear acceleration obtains Jerk signals time
        #9. tBodyGyroMag: magnitude of body gyroscope signals time
        #10. tBodyGyroJerkMag: magnitude of body gyroscope obtains Jerk signals time
        #11. fBodyAcc-XYZ: body acceleration signals frequency
        #12. fBodyAccJerk-XYZ: body linear acceleration obtains Jerk signals frequency
        #13. fBodyGyro-XYZ: body gyroscope signals frequency
        #14. fBodyAccMag: magnitude of body acceleration signals frequency
        #15. fBodyAccJerkMag: magnitude of body linear acceleration obtains Jerk signals frequency
        #16. fBodyGyroMag: magnitude of body gyroscope signals frequency
        #17. fBodyGyroJerkMag: magnitude of body gyroscope signals frequency
Then I used gsub function to replace indicators to actual names
resultCols = colnames(result)
resultCols= gsub("[\\(\\)-]", "", resultCols)
resultCols= gsub("^t", "time of ",resultCols)
resultCols= gsub("^f", "frequency of ", resultCols)
resultCols= gsub("BodyBody", "Body", resultCols)
resultCols= gsub("Body", "Body ", resultCols)
resultCols= gsub("Acc", "Accelerometer ", resultCols)
resultCols= gsub("Gyro", "Gyroscope ",resultCols)
resultCols= gsub("Gravity", "Gravity ",resultCols)
resultCols= gsub("Mag", "Magnitude ",resultCols)
resultCols= gsub("Jerk", "to obtain Jerk ",resultCols)
colnames(result) <- resultCols

For the last questions: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
resultMeans <- result %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
# output to file "tidy_data.txt"
write.table(resultMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)

