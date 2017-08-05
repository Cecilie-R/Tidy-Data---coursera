#run_analysis

#You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#zipUrl<-"http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"

#features are the column names for the X table
features<-read.table("./data/features.txt")

#this is the data
X_test<-read.table("./data/test/X_test.txt")
X_train<-read.table("./data/train/X_train.txt")

#this is the test-subject ID number
subject_test<-read.table("./data/test/subject_test.txt")
subject_train<-read.table("./data/train/subject_train.txt")
names(subject_test)<-"subject"
names(subject_train)<-"subject"

#WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
#This is the test category (1-6)
y_test<-read.table("./data/test/y_test.txt")
y_train<-read.table("./data/train/y_train.txt")
names(y_test)<-"activity"
names(y_train)<-"activity"

#Rename the columns according to features
names(X_test)<-features$V2
names(X_train)<-features$V2

#Add columns for subject ID and test type
Test<-cbind(X_test, subject_test,y_test)
Train<-cbind(X_train, subject_train, y_train)

#Combine the test and training datasets
X<-rbind(Test, Train)

#subset so only mean and stdev
meancol<-grep("*mean",names(X))#
stdevcol<-grep("*std()",names(X))#

#select only mean ans std observations
Xsubset<-X[c(meancol, stdevcol, 562,563)]
names(Xsubset)<-gsub("-","", names(Xsubset))

#rename the activities following the key
Xsubset$activity<-sub("1","laying",Xsubset$activity)
Xsubset$activity<-sub("2","walking",Xsubset$activity)
Xsubset$activity<-sub("3","walkingupstairs",Xsubset$activity)
Xsubset$activity<-sub("4","walkingdownstairs",Xsubset$activity)
Xsubset$activity<-sub("5","sitting",Xsubset$activity)
Xsubset$activity<-sub("6","standing",Xsubset$activity)

#now melt the data to form a long narrow dataset
meltData <- melt(Xsubset,id = c("subject","activity"))

#use the long dataset to calculate means
TidyData <- dcast(meltData, subject + activity ~ variable, mean)

#save the dataset
write.table(TidyData, file="TidyData.txt", row.name=FALSE) 