library(dplyr)
setwd("C:/WFH Cdrive/UCI HAR Dataset")

#read and name file in test folder

peopleintestfolder=read.table("./test/subject_test.txt")
resultintestfolder=read.table("./test/x_test.txt")
activityintestfolder=read.table("./test/y_test.txt")

#read and name file in train folder


resultintrainfolder=read.table("./train/x_train.txt")
activityintrainfolder=read.table("./train/y_train.txt")
###################################################################################################################

#Item1: Merges the training and the test sets to create one data set.

#merge files in test and train folder
result= rbind(
  cbind(peopleintestfolder,resultintestfolder,activityintestfolder),
  cbind(peopleintrainfolder,resultintrainfolder,activityintrainfolder)
)

#to add lable to the consolidate file, we need to create combine feature file with activity file
features=read.table("./features.txt", as.is = TRUE)
activity=read.table("./activity_labels.txt")
colnames(activity)=c("ActivityId", "ActivityLabel")

#now we can add column name to the cosolidate file

colnames(result) <- c("subject", features[, 2], "activity")
###################################################################################################################

#Item2: Extracts only the measurements on the mean and standard deviation for each measurement.

#I will use grepl funtion to filter out columns other than mean and standard deviation. 

MeanandStdOnly=grepl("subject|activity|mean|std", colnames(result))
result=result[, MeanandStdOnly]

###################################################################################################################

#Item3: Uses descriptive activity names to name the activities in the data set

#change the activity code to the actual names
result$activity <- factor(result$activity, 
                                 levels = activity[, 1], labels = activity[, 2])

###################################################################################################################

#Item4: Appropriately labels the data set with descriptive variable names.

#Based on features_info.txt file, below are explanation for each item: 
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
#Use gsub function to replace indicators to actual names
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

###################################################################################################################

#Item5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

resultMeans <- result %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# output to file "tidy_data.txt"
write.table(resultMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)





















