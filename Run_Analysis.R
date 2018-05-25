library(plyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download file

download.file(url, destfile= ".\\data\\Dataset.zip")

#unzip file

unzip(zipfile=".\\data\\Dataset.zip", exdir=".\\data")



#read the activity files from both test and train datasets

ActivityTest <- read.table(".\\UCI HAR Dataset\\test\\Y_test.txt"), header=F)

ActivityTrain <- read.table(".\\UCI HAR Dataset\\train\\Y_train.txt"), header=F)

#read subject files from both test and train datasets

SubjectTest <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt"), header=F)

SubjectTrain <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt"), header=F)

# read features files from test and train datasets

FeaturesTest <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt"), header=F)

FeaturesTrain <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt"), header=F)

# combine the datatables

dataSubject <- rbind(SubjectTrain, SubjectTest)

dataActivity <- rbind(ActivityTrain, ActivityTest)

dataFeatures <- rbind(FeaturesTrain, FeaturesTest)

# set names to the variables

names(dataSubject) <- "subject"

names(dataActivity) <- "activity"

dataFeaturesNames <- read.table(".\\UCI HAR Dataset\\features.txt"), header=F)

names(dataFeatures) <- dataFeaturesNames$V2

# 1.Merges the training and the test sets to create one data set.

Data <- cbind(dataSubject, dataActivity, dataFeatures)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

subData <- Data[, grepl("mean\\(\\)|std\\(\\)|subject|activity", names(Data))]

# check

names(subData) 

# 3. Uses descriptive activity names to name the activities in the data set


activityLabels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", header=F)


# factorise the variable activity with activity labels

subData$activity <- factor(subData$activity, levels=activityLabels[,1], labels=activityLabels[,2])

# 4. Appropriately labels the data set with descriptive variable names

 names(subData) <- gsub("^t", "Time", names(subData))
 names(subData) <- gsub("^f", "Frequency", names(subData))
 names(subData) <- gsub("Acc", "Accelerometer", names(subData))
 names(subData) <- gsub("Gyro", "Gyroscope", names(subData))
 names(subData) <- gsub("Mag", "Magnitude", names(subData))
 names(subData) <- gsub("BodyBody", "Body", names(subData))

# check

head(names(subData))
[1] "subject"                        "activity"                      
[3] "TimeBodyAccelerometer-mean()-X" "TimeBodyAccelerometer-mean()-Y"
[5] "TimeBodyAccelerometer-mean()-Z" "TimeBodyAccelerometer-std()-X" 



# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data_mean <- aggregate(. ~subject + activity, subData, mean)

 Data_mean <- Data_mean[order(Data_mean$subject, Data_mean$activity),]

 

 write.table(Data_mean, file= "tidy_data.txt", row.name=F)



