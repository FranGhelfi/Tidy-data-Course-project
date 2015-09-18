## Getting and Cleaning Data course project

## Libraries loading

    library(dplyr)

## Data loading

    activity_labels <- read.table("activity_labels.txt")
    features <- read.table("features.txt")
    x_test <- read.table("X_test.txt")
    y_test <- read.table("y_test.txt")
    x_train <- read.table("X_train.txt")
    y_train <- read.table("y_train.txt")
    subject_test <- read.table("subject_test.txt")
    subject_train <- read.table("subject_train.txt")

## Includes the test and subject labels info in each data set
    
    x_test <- tbl_df(x_test)
    x_test <- mutate(x_test, test_label = y_test[,1], subject_label = subject_test[,1])
    x_train <- tbl_df(x_train)
    x_train <- mutate(x_train, test_label = y_train[,1], subject_label = subject_train[,1])

## Merges the "test" & "train" sets (Project point 1)
    
    merged_df <- rbind(x_test, x_train)

## Applies the variable names from the features lables for each data set (Project point 4)
    
    colnames(merged_df) <- c(as.character(features[,2]), "activity_label", "subject_label")

## Replaces activities numbers for descriptive activity names (Project point 3)
    
    merged_df <- data.frame(merged_df)
    for (x in 1:nrow(merged_df)) {
        merged_df[x, 562] <- as.character(activity_labels[merged_df[x, 562],2])
    }
    
## Extracts the measurements on the mean and standard deviation for 
## each measurement (Project point 2), keeping the "activity labels" column
    
    merged_df <- select(merged_df, grep("*[Mm]ean*|*[Ss]td", colnames(merged_df)), 562, 563)

## Creates a new tidy data set with the average of each variable for each 
## activity and each subject (Project point 5)
    
    grouped_df <- group_by(merged_df, activity_label, subject_label)
    grouped_df <- summarise_each(grouped_df, funs(mean), 1:86)
    write.table(grouped_df, file = "ResultingTidyData.txt")
    
    
