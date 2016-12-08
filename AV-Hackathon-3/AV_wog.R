#################### AV Hackathon 3####################

#setting working library
setwd("E:/DS/AV wog")

#loading libraries
library(caret)
library(randomForest)

#reading the files
train=read.csv("train.csv")
test=read.csv("test.csv")

str(train)
str(test)


# removing some unwanted variables
remove_var <- c("institute_country")
train <- train[ , -which(names(train) %in% remove_var)]
test <- test[ , -which(names(test) %in% remove_var)]
test <- test[,-26]

#run feature engineering file now then come back

remove_var <- c("Var15","institute_city","institute_state","subject_area","secondary_area")
train_1 <- train_1[ , -which(names(train_1) %in% remove_var)]
test_1 <- test_1[ , -which(names(test_1) %in% remove_var)]
remove(test)
remove(train)

# R part split check
library(rpart)
r_part=rpart(Project_Valuation~project_subject,data=train_1)
summary(r_part)
r_part

# R part split with RF
train_2_1 <- train_1[train_1$Similar_Project_Valuation_other_institute <549 & train_1$Project_Valuation<5750,]
train_2_2 <- train_1[train_1$Similar_Project_Valuation_other_institute >=549 & train_1$Project_Valuation < 5750,]
test_2_1 <- test_1[test_1$Similar_Project_Valuation_other_institute <549,]
test_2_2 <- test_1[test_1$Similar_Project_Valuation_other_institute >=549,]

rf_2_1 <- randomForest(Project_Valuation ~.,data=train_2_1[,-c(1)], ntree=100, norm.votes=FALSE,importance = TRUE,do.trace = 1,nodesize = 50)
rf_2_2 <- randomForest(Project_Valuation ~.,data=train_2_2[,-c(1)], ntree=100, norm.votes=FALSE,importance = TRUE,do.trace = 1,nodesize = 50)
save(rf_2_1,file='rf_2_1.RData')
save(rf_2_2,file='rf3_2_1.RData')

load('rf_2_1.RData')
load('rf3_2_1.RData')
test_2_1$Project_Valuation=0
test_2_2$Project_Valuation=0

pred_2_1= predict(rf_2_1,test_2_1)
pred_2_2= predict(rf_2_2,test_2_2)
test_2_1$Project_Valuation=pred_2_1
test_2_2$Project_Valuation=pred_2_2
submit_2_1<-data.frame(ID=test_2_1$ID,Project_Valuation_rf=test_2_1$Project_Valuation)
submit_2_2<-data.frame(ID=test_2_2$ID,Project_Valuation_rf=test_2_2$Project_Valuation)
submit_rf <- rbind(submit_2_1,submit_2_2)

write.csv(submit_rf,file="submit_rf_rpart.csv",row.names=FALSE)

