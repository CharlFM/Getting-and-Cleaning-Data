library(dplyr)

setwd("...") # Update as needed

test.path.x  <- "UCI HAR Dataset/test/X_test.txt"
test.path.y  <- "UCI HAR Dataset/test/Y_test.txt"
subject.x    <- "UCI HAR Dataset/test/subject_test.txt"
train.path.x <- "UCI HAR Dataset/train/X_train.txt"
train.path.y <- "UCI HAR Dataset/train/Y_train.txt"
subject.y    <- "UCI HAR Dataset/train/subject_train.txt"
feats        <- "UCI HAR Dataset/features.txt"
activities   <- "UCI HAR Dataset/activity_labels.txt"

# Get names and activities
feat.names <- read.table(feats)
activities <- read.table(activities)

# Merges the training and the test sets to create one data set.
test.x <- read.table(test.path.x)
names(test.x) <- feat.names$V2
test.y <- read.table(test.path.y)
subject.x <- read.table(subject.x)
names(subject.x) <- "subject"
test <- cbind(test.x, test.y, subject.x)

train.x <- read.table(train.path.x)
names(train.x) <- feat.names$V2
train.y <- read.table(train.path.y)
subject.y <- read.table(subject.y)
names(subject.y) <- "subject"
train <- cbind(train.x, train.y, subject.y)

all.dat <- rbind(test, train)

# Extracts only the measurements on the mean and standard deviation for each measurement.
all.dat <- all.dat[, c("V1", "subject", names(all.dat)[grepl(pattern = "mean|std", names(all.dat))])]

# Uses descriptive activity names to name the activities in the data set
all.dat <- merge(all.dat, activities, by = "V1", all.x = TRUE)
all.dat$V1 <- all.dat$V2
all.dat$V2 <- NULL
names(all.dat)[names(all.dat) == "V1"] <- "Activity"
# Appropriately labels the data set with descriptive variable names.
# - done before already 

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
means <- all.dat %>% 
  group_by(Activity, subject) %>% 
  summarise_each(funs(mean))

write.table(means, "meanData.txt", row.names = FALSE, quote = FALSE)









