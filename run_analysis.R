# load the required packages
  library(data.table)



## Download and unzip the dataset:
  filename <- "getdata_dataset.zip"
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename)  ## this downloads the data to your working directory
  }  
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename)
  }
## load test data to the objects
  subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
  X_test = read.table("UCI HAR Dataset/test/X_test.txt")
  Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")
  
## load training data to the objects
  subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
  X_train = read.table("UCI HAR Dataset/train/X_train.txt")
  Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")
  
## load lookup information
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)   
  
## merge test and training data 
  subject <- rbind(subject_test, subject_train)
  names(subject) <- "subjectId"
  ## Merges  test and train data of group X
  XData <- rbind(X_test, X_train)
  XData <- XData[, includedFeatures]
  names(XData) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
  ## Merges  test and train data of group Y
  YData <- rbind(Y_test, Y_train)
  names(YData) = "activityId"
  activity <- merge(YData, activities, by="activityId")$activityLabel

  
## merge data frames of different columns to form one data table
  data <- cbind(subject, XData, activity)
   write.table(data, "Merged_Data.txt")
  
## create a dataset grouped by subject and activity after applying standard deviation and average calculations

  dataDT <- data.table(data)
  calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
  write.table(calculatedData, "Tidy_Mean_Data.txt") 
