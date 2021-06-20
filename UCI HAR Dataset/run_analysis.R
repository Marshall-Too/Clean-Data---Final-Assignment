library(openxlsx)
setwd("C:/Users/Marshall Too/Desktop/UCI HAR Dataset/")

# Read files
x.train <- read.table("train/X_train.txt")
y.train <- read.table("train/y_train.txt")
x.test <- read.table("test/x_test.txt") 
y.test <- read.table("test/y_test.txt")
z.test <- read.table("test/subject_test.txt")
z.train <- read.table("train/subject_train.txt")
  
  
#1 and #3 Left join to tag X variable labels 
X <- rbind(x.train,x.test) 
X.names <- read.table("features.txt",head=FALSE)
names(X) <- X.names$V2

#3 Use of a left join to map dependent variable to activity type
Y.names <- read.table("activity_labels.txt",head=FALSE)
Y <- rbind(y.train,y.test) %>% left_join(Y.names) %>% rename(activity = V2) %>% select(-V1)

subject <- rbind(z.train,z.test) %>% rename("subject"= V1 ) 
  
Merged_Data <- cbind(X,Y,subject)

#2 select variables with mean
TidyData <- Merged_Data %>% select(subject,activity,X.names$V2, contains("mean"),contains("sd"))

# clean dependent variable names
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#5 summarize for each activity
Output <- TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Output, "FinalData.txt", row.name=FALSE)
