# Set the working directory
setwd("/home/kirty/R/Coursera/GettingData/Project/")

# Download the files
if (!file.exists("./data")){dir.create("./data")}
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url, destfile = "./data/Dataset.zip", method = "curl")

unzip(zipfile = './data/Dataset.zip', exdir = './data')
path_file <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_file, recursive=TRUE)
files

##########################################


# Reading the data
dataActivityTrain <- read.table(file.path(path_file, "train","y_train.txt"), header = FALSE)
dataActivityTest <- read.table(file.path(path_file, "test","y_test.txt"), header = FALSE)

dataSubjectTrain <- read.table(file.path(path_file, "train","subject_train.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(path_file, "test","subject_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_file, "train","X_train.txt"), header = FALSE)
dataFeaturesTest <- read.table(file.path(path_file, "test","X_test.txt"), header = FALSE)


#Merging the data
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_file, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


#Extracting the measurements
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject","activity")
Data<- subset(Data, select = selectedNames)

activityLabels <- read.table(file.path(path_file, "activity_labels.txt"),header = FALSE)
head(Data$activity, 30)

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

library(knitr) 
knit2html("codebook.Rmd");
