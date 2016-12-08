########## AV Hackathon 3.X ########

#setting working library
setwd("E:/DS/AV Hack 3.x")

#loading libraries
library(caret)
library(randomForest)
library(rpart)

#reading the files
train=read.csv("train.csv")
test=read.csv("test.csv")

str(train)

#just converting some levels
train$Var4 = as.factor(train$Var4)
train$Var5 = as.factor(train$Var5)
train$Disbursed = as.factor(train$Disbursed)
train$DOB = as.Date(train$DOB, format = "%d-%m-%Y")
train$Lead_Creation_Date = as.Date(train$Lead_Creation_Date, format = "%d-%m-%Y")




test$Var4 = as.factor(test$Var4)
test$Var5 = as.factor(test$Var5)
test$DOB = as.Date(test$DOB, format = "%d-%m-%Y")
test$Lead_Creation_Date = as.Date(test$Lead_Creation_Date, format = "%d-%m-%Y")


#treating some of the variables

#0) Creating Dummy Variable of class factors Gender
  #0.i) is_male
  is_male <- function(x) {
    if(x == "Male") {
      y <- 1
    } else {
      y <- 0
    }
    return(y)
  }

train_1 <- cbind(train,is_male = as.factor(mapply(is_male,train$Gender)))
test_1 <- cbind(test,is_male = as.factor(mapply(is_male,test$Gender)))



##############################################################################
#1) Adding age by using DOB and Lead_Creation_Date column 
train_1 <- cbind(train_1,age = as.integer(round((train_1$Lead_Creation_Date - train$DOB)/365,digits =0)))
test_1 <- cbind(test_1,age = as.integer(round((test_1$Lead_Creation_Date - test$DOB)/365,digits = 0)))


##############################################################################
#2) Extraction and Addition of DOB month and year
train_1 <- cbind(train_1,DOB_month = as.factor(format(train_1$DOB,'%m')))
train_1 <- cbind(train_1,DOB_year = as.factor(format(train_1$DOB,'%Y')))

test_1 <- cbind(test_1,DOB_month = as.factor(format(test_1$DOB,'%m')))
test_1 <- cbind(test_1,DOB_year = as.factor(format(test_1$DOB,'%Y')))

##############################################################################
#3) Extraction and Addition of Lead_Creation_Date month
train_1 <- cbind(train_1,Lead_Creation_day = as.factor(format(train_1$Lead_Creation_Date,'%d')))
train_1 <- cbind(train_1,Lead_Creation_month = as.factor(format(train_1$Lead_Creation_Date,'%m')))
train_1 <- cbind(train_1,Lead_Creation_year = as.factor(format(train_1$Lead_Creation_Date,'%Y')))

test_1 <- cbind(test_1,Lead_Creation_day = as.factor(format(test_1$Lead_Creation_Date,'%d')))
test_1 <- cbind(test_1,Lead_Creation_month = as.factor(format(test_1$Lead_Creation_Date,'%m')))
test_1 <- cbind(test_1,Lead_Creation_year = as.factor(format(test_1$Lead_Creation_Date,'%Y')))


##############################################################################
#4) Treating Loan_Amount_Submitted by adding zero 
train_1$Loan_Amount_Submitted[is.na(train_1$Loan_Amount_Submitted)] <- train_1$Loan_Amount_Applied[is.na(train_1$Loan_Amount_Submitted)]
test_1$Loan_Amount_Submitted[is.na(test_1$Loan_Amount_Submitted)] <- test_1$Loan_Amount_Applied[is.na(test_1$Loan_Amount_Submitted)]

##############################################################################
#5) Treating Loan_Tenure_Submitted by adding zero 
train_1$Loan_Tenure_Submitted[is.na(train_1$Loan_Tenure_Submitted)] <- train_1$Loan_Tenure_Applied[is.na(train_1$Loan_Tenure_Submitted)]
test_1$Loan_Tenure_Submitted[is.na(test_1$Loan_Tenure_Submitted)] <- test_1$Loan_Tenure_Applied[is.na(test_1$Loan_Tenure_Submitted)]

##############################################################################
#6) Treating Processing_Fee and EMI_Loan_Submitted
Processing_Fee_null_train <- is.na(train_1$Processing_Fee)
Processing_Fee_null_test <- is.na(test_1$Processing_Fee)

train_1$Processing_Fee[is.na(train_1$Processing_Fee)] <- 0
test_1$Processing_Fee[is.na(test_1$Processing_Fee)] <- 0


EMI_Loan_Submitted_null_train <- is.na(train_1$EMI_Loan_Submitted)
EMI_Loan_Submitted_null_test <- is.na(test_1$EMI_Loan_Submitted)

train_1$EMI_Loan_Submitted[is.na(train_1$EMI_Loan_Submitted)] <- 0
test_1$EMI_Loan_Submitted[is.na(test_1$EMI_Loan_Submitted)] <- 0

##############################################################################
#7) Creating Counter for Existing EMI and Interest Rate
Existing_EMI_null_train <- is.na(train_1$Existing_EMI)
Interest_Rate_null_train <- is.na(train_1$Interest_Rate)

Existing_EMI_null_test <- is.na(test_1$Existing_EMI)
Interest_Rate_null_test <- is.na(test_1$Interest_Rate)


##############################################################################
#8) Missing value Imputation of columns


numeric_columns <- NULL
for (i in 1:ncol(train_1)){
  if(class(train_1[,i]) == "integer"  | class(train_1[,i]) == "numeric") {
    numeric_columns <- rbind(numeric_columns,i)
  }
}

preproc <- preProcess(method = "bagImpute", train_1[,numeric_columns[-10]])

train_1_imputed <- predict(preproc, train_1[,numeric_columns])
numeric_columns_1 <- NULL
for (i in 1:ncol(train_1_imputed)){
  if(class(train_1_imputed[,i]) == "integer"  | class(train_1_imputed[,i]) == "numeric") {
    numeric_columns_1 <- rbind(numeric_columns_1,i)
  }
}
train_1[,numeric_columns] <- train_1_imputed[,numeric_columns_1]

#train_1$Loan_Tenure_Submitted <- train_1_imputed$Loan_Tenure_Submitted

numeric_columns <- NULL
for (i in 1:ncol(test_1)){
  if(class(test_1[,i]) == "integer"  | class(test_1[,i]) == "numeric") {
    numeric_columns <- rbind(numeric_columns,i)
  }
}


test_1_imputed <- predict(preproc, test_1[,numeric_columns])
numeric_columns_1 <- NULL
for (i in 1:ncol(test_1_imputed)){
  if(class(test_1_imputed[,i]) == "integer"  | class(test_1_imputed[,i]) == "numeric") {
    numeric_columns_1 <- rbind(numeric_columns_1,i)
  }
}


test_1[,numeric_columns] <- test_1_imputed[,numeric_columns_1]


#######################################################################
#9) New Variable Creation : EMI_calculated

EMI <- function(x,y,z) {
  if(y == 0 | z == 0) {
    a <- 0
  } else {
    b <- y/1200
    c <- z*12
    a <- (x*b*((1+b)^c)) / (((1+b)^c) - 1)
  }
  return(a)
}

train_1 <- cbind(train_1,EMI_calculated= as.numeric(mapply(EMI,x = train_1$Loan_Amount_Submitted , y = train_1$Interest_Rate,z = train_1$Loan_Tenure_Submitted)))
test_1 <- cbind(test_1,EMI_calculated = as.numeric(mapply(EMI,x = test_1$Loan_Amount_Submitted , y = test_1$Interest_Rate,z = test_1$Loan_Tenure_Submitted)))


#######################################################################
#10) New Variable Creation : Future_EMI_perincome index

train_1 <- cbind(train_1,Future_EMI_perincome = as.numeric((train_1$Existing_EMI + train_1$EMI_calculated) / (train_1$Monthly_Income+1)))
test_1 <- cbind(test_1,Future_EMI_perincome = as.numeric((test_1$Existing_EMI + test_1$EMI_calculated) / (test_1$Monthly_Income+1)))

train_1$Future_EMI_perincome[train_1$Future_EMI_perincome > 2] = 2
test_1$Future_EMI_perincome[test_1$Future_EMI_perincome > 2] = 2

## Creating is_zero function
is_zero <- function(x) {
  if(x == 0) {
    a <- 1
  } else {
    a <- 0
  }
  return(a)
}



#######################################################################
#11) Changing monthly income outliers

train_1$Monthly_Income[train_1$Monthly_Income > 1000000] = 1000000
test_1$Monthly_Income[test_1$Monthly_Income > 1000000] = 1000000

#######################################################################
#12) New Variable Creation : Process_percent

train_1 <- cbind(train_1,Proces_perct = as.numeric((train_1$Processing_Fee*100) / (train_1$Monthly_Income+1)))
test_1 <- cbind(test_1,Proces_perct = as.numeric((test_1$Processing_Fee*100) / (test_1$Monthly_Income+1)))

train_1$Proces_perct[train_1$Proces_perct > 40] = 40
test_1$Proces_perct[test_1$Proces_perct > 40] = 40

#######################################################################
#13) New Variable Creation : exist_EMI_perincome index

train_1 <- cbind(train_1,exist_EMI_perincome = as.numeric((train_1$Existing_EMI) / (train_1$Monthly_Income+1)))
test_1 <- cbind(test_1,exist_EMI_perincome = as.numeric((test_1$Existing_EMI) / (test_1$Monthly_Income+1)))

train_1$exist_EMI_perincome[train_1$exist_EMI_perincome > 1.5] = 1.5
test_1$exist_EMI_perincome[test_1$exist_EMI_perincome > 1.5] = 1.5

#14) New Variable Creation : exx_EMI_perincome index

train_1 <- cbind(train_1,exx_EMI_perincome = as.numeric((train_1$EMI_calculated) / (train_1$Monthly_Income+1)))
test_1 <- cbind(test_1,exx_EMI_perincome = as.numeric((test_1$EMI_calculated) / (test_1$Monthly_Income+1)))

train_1$exx_EMI_perincome[train_1$exx_EMI_perincome > 2] = 2
test_1$exx_EMI_perincome[test_1$exx_EMI_perincome > 2] = 2

#15) Removal of some Columns 
remove_var <- c('Gender','LoggedIn','EMI_Loan_Submitted')
train_1 <- train_1[ , -which(names(train_1) %in% remove_var)]
test_1 <- test_1[ , -which(names(test_1) %in% remove_var)]

#16) Final file for modelling
write.csv(test_1,file="test_1.csv",row.names=FALSE)
write.csv(train_1,file="train_1.csv",row.names=FALSE)

