library(ggplot2)
library(gplots)
library(caTools)
library(lattice)
library(caret)
library(foreach)
library(Matrix)
library(pROC)
library(ROCR)
library(Rcpp)
library(mice)
library(xgboost)
library(survival)
library(gbm)
library(randomForest)

######################
########## Load data
loans = read.csv('Train.csv',stringsAsFactors = F)
loanstest = read.csv('Test.csv',stringsAsFactors = F)

Train = loans
Train[,c(3,10,11,14,22:26)]  = lapply(c(3,10,11,14,22:26), function(x) as.factor(Train[,x]))

Train$Mobile_Verified = ifelse (Train$Mobile_Verified == "Y",1,0)
Train$Filled_Form = ifelse (Train$Filled_Form == "Y",1,0)
Train$IsMobile = ifelse (Train$Device_Type == "Mobile",1,0)
Train$IsMale = ifelse (Train$Gender == "Male",1,0)

Train$Gender = NULL
Train$Device_Type = NULL
###########################
###### Handling NA Values######################
############################ 
#### keeping track of Rows with NA
Train$issubmitNA = ifelse (is.na(Train$Loan_Amount_Submitted),1,0)
table(Train$issubmitNA)

###### Filling very few NA values in Loan_Amount_Applied && Loan_Tenure_Applied
###### using mean(remaing data) or Loan_Amount_submitted && Loan_Tenure_Submitted (If available)
Train$Loan_Amount_Applied = ifelse(is.na(Train$Loan_Amount_Applied),ifelse(is.na(Train$Loan_Amount_Submitted),230300,Train$Loan_Amount_Submitted),Train$Loan_Amount_Applied )

Train$Loan_Tenure_Applied = ifelse(is.na(Train$Loan_Tenure_Applied),ifelse(is.na(Train$Loan_Tenure_Submitted),2,Train$Loan_Tenure_Submitted),Train$Loan_Tenure_Applied )

####### Multiple Imputation
####### First imputing Loan_Amount_submitted && Loan_Tenure_Submitted using Loan_Amount_Applied #######  && Loan_Tenure_Applied

temp = Train[,c(6,7,14,15)] 

set.seed(123)
imputed = complete(mice(temp))

Train$Loan_Amount_Submitted = imputed$Loan_Amount_Submitted
Train$Loan_Tenure_Submitted = imputed$Loan_Tenure_Submitted
Train$Existing_EMI = ifelse(is.na(Train$Existing_EMI),0,Train$Existing_EMI)


####### Imputation of Int.Rate, Proc.fee and EMI_Loan_Submitted using already imputed
#######  Loan_Amount_submitted && Loan_Tenure_Submitted

temp = Train[,c(14,15,16,17,18)]

set.seed(123)

imputed = complete(mice(temp)) ### This will takes several minutes 

Train$Interest_Rate = imputed$Interest_Rate
Train$Processing_Fee = imputed$Processing_Fee
Train$EMI_Loan_Submitted = imputed$EMI_Loan_Submitted

###### OUTCOME variables
disb = Train$Disbursed
dispnum = as.numeric(as.character(disb))
Train$Disbursed = NULL
Lin = Train$LoggedIn
Train$LoggedIn = NULL

##################################### age variable
dob = strptime(Train$DOB, format = "%d-%b-%Y")
year = format(dob,"%Y")
year = as.numeric(year)
Train$age = 115 - year
## assuming people with year 0015 have wrongly mentioned their yob as 2015
## assigning avg value of 30 to 17 such cases in the data
Train$age = ifelse(Train$age == 100, 30, Train$age)  
#############################

#############
############# similarly cleaning test data
############
Test = loanstest
Test[,c(3,10,11,14,22:24)]  = lapply(c(3,10,11,14,22:24), function(x) as.factor(Test[,x]))

Test$Mobile_Verified = ifelse (Test$Mobile_Verified == "Y",1,0)
Test$Filled_Form = ifelse (Test$Filled_Form == "Y",1,0)
Test$IsMobile = ifelse (Test$Device_Type == "Mobile",1,0)
Test$IsMale = ifelse (Test$Gender == "Male",1,0)

Test$Gender = NULL
Test$Device_Type = NULL

########## Dealing with NA
####### keeping track of NA rows
Test$issubmitNA = ifelse (is.na(Test$Loan_Amount_Submitted),1,0)
table(Test$issubmitNA)

##### Imputation
temp = Test[,c(6,7,14,15)]
set.seed(123)
imputed = complete(mice(temp))
Test$Loan_Amount_Submitted = imputed$Loan_Amount_Submitted
Test$Loan_Tenure_Submitted = imputed$Loan_Tenure_Submitted
Test$Loan_Amount_Applied = imputed$Loan_Amount_Applied
Test$Loan_Tenure_Applied = imputed$Loan_Tenure_Applied
Test$Existing_EMI = ifelse(is.na(Test$Existing_EMI),0,Test$Existing_EMI)
##write.csv(Test,"Testpartialimp.csv",row.names = F) 
###### second imputation
temp = Test[,c(14,15,16,17,18)]
set.seed(123)
imputed = complete(mice(temp))
Test$Interest_Rate = imputed$Interest_Rate
Test$Processing_Fee = imputed$Processing_Fee
Test$EMI_Loan_Submitted = imputed$EMI_Loan_Submitted
##write.csv(Test,"TestFullimp.csv",row.names = F) 
##################
################ age variable
dob = strptime(Test$DOB, format = "%d-%b-%Y")
year = format(dob,"%Y")
year = as.numeric(year)
Test$age = 115 - year
Test$age = ifelse(Test$age == 100, 30, Test$age) 
#############################

