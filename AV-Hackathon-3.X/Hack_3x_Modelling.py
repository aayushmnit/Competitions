######### Python code for AV Hack 3.x , Author = Aayush Agrawal ##########

# Step 1: Importing Libraries
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
import pandas as pd
import numpy as np
from sklearn import preprocessing
from sklearn.metrics import roc_curve, auc
import pandas as pd
from sklearn import ensemble
import random
import xgboost as xgb

#Step 2 : Defining a 1/0 hard enccoder function
number = preprocessing.LabelEncoder()

#Step 3 : Importing Train and testing data after preprocessing from R code
train=pd.read_csv('E:/DS/AV Hack 3.x/train_1.csv')
test=pd.read_csv('E:/DS/AV Hack 3.x/test_1.csv')

#Step 4 : Having a look at the data	
train.head()


#Step 5 : Converting factor variables in 1/0 encoding and making any missing value -999
def convert(data):
    number = preprocessing.LabelEncoder()
    data['Lead_Creation_Date'] = number.fit_transform(data.Lead_Creation_Date)
    data['is_male'] = number.fit_transform(data.is_male)
    data['City'] = number.fit_transform(data.City)
    data['Salary_Account'] = number.fit_transform(data.Salary_Account)
    data['Employer_Name'] = number.fit_transform(data.Employer_Name)
    data['Mobile_Verified'] = number.fit_transform(data.Mobile_Verified)
    data['Var1'] = number.fit_transform(data.Var1)
    data['Filled_Form'] = number.fit_transform(data.Filled_Form)
    data['Device_Type'] = number.fit_transform(data.Device_Type)
    data['Var2'] = number.fit_transform(data.Var2)
    data['Var5'] = number.fit_transform(data.Var5)
    data['Var4'] = number.fit_transform(data.Var4)
    data['DOB_month'] = number.fit_transform(data.DOB_month)
    data['DOB_year'] = number.fit_transform(data.DOB_year)
    data['Lead_Creation_day'] = number.fit_transform(data.Lead_Creation_day)
    data['Lead_Creation_month'] = number.fit_transform(data.Lead_Creation_month)
    data['Source'] = number.fit_transform(data.Source)
    data=data.fillna(-999)
    return data

train=convert(train)
test=convert(test)

#Step 6 : Running my 1st Model XGB
# Step 6.i): Defining features for XGB
features=['City',
'Monthly_Income',
'Lead_Creation_Date',    
'Loan_Amount_Applied',
'Loan_Tenure_Applied',
'Existing_EMI',
'Employer_Name',
'Salary_Account',
'Mobile_Verified',
'Var5',
'Var1',
'Loan_Amount_Submitted',
'Loan_Tenure_Submitted',
'Interest_Rate',
'Processing_Fee',
'Filled_Form',
'Device_Type',
'Var2',
'Source',
'Var4',
'is_male',
'age',
'DOB_month',
'DOB_year',
'Lead_Creation_day',
'Lead_Creation_month',
'EMI_calculated',
'Future_EMI_perincome',
'Proces_perct',
'exist_EMI_perincome',
'exx_EMI_perincome'
#'Profit_perc'
#'EMI_Loan_Submitted'
]

## Step 6.ii) Preparing data from the features listed 
x_train = train[list(features)].values
y_train = train['Disbursed'].values
x_test=test[list(features)].values


## Step 6.iii) Defining Parameters
params = {}
params["objective"] = "binary:logistic"
params["eta"] = 0.01
params["min_child_weight"] = 7
params["subsample"] = 0.7
params["colsample_bytree"] = 0.7
params["scale_pos_weight"] = 0.8
params["silent"] = 0
params["max_depth"] = 4
params["seed"] = 0
params["eval_metric"] = "auc"  

plst = list(params.items())
num_rounds = 1525

xgtrain = xgb.DMatrix(x_train,label=y_train,missing=-999)
xgtest = xgb.DMatrix(x_test,missing=-999)

model_xgb = xgb.train(plst, xgtrain, num_rounds)

# Step 6.iv) Running the trained model on testing file
pred_test_y_xgb1 = model_xgb.predict(xgtest)
test['Disbursed']=pred_test_y_xgb1

# Step 6.v) Getting the output
test.to_csv('E:/DS/AV Hack 3.x/Solution_xgb.csv', columns=['ID','Disbursed'],index=False)

## Step 7) Running my 2nd Model Random Forest

# Step 7.i): Defining features for Random Forest
features=['City',
'Monthly_Income',
'Lead_Creation_Date',    
'Loan_Amount_Applied',
'Loan_Tenure_Applied',
'Existing_EMI',
'Employer_Name',
'Salary_Account',
#'Mobile_Verified',
'Var5',
'Var1',
'Loan_Amount_Submitted',
'Loan_Tenure_Submitted',
'Interest_Rate',
'Processing_Fee',
'Filled_Form',
#'Device_Type',
'Var2',
'Source',
'Var4',
#'is_male',
'age',
'DOB_month',
'DOB_year',
'Lead_Creation_day',
#'Lead_Creation_month',
'EMI_calculated',
'Future_EMI_perincome',
'Proces_perct',
'exist_EMI_perincome',
'exx_EMI_perincome'
#'Profit_perc'
#'EMI_Loan_Submitted'
]

## Step 7.ii) Preparing data from the features listed 
x_train = train[list(features)].values
y_train = train['Disbursed'].values
x_test=test[list(features)].values


## Step 7.iii) Running Model : Random Forest , 1000 classifier
rf = ensemble.RandomForestClassifier(n_estimators=1000,min_samples_leaf=50, max_features="auto", n_jobs=4, random_state=0)
rf.fit(x_train, y_train)


## Step 7.iv) Looking at Feature Importance
importances = rf.feature_importances_
indices = np.argsort(importances)

ind=[]
for i in indices:
    ind.append(features[i])

import matplotlib.pyplot as plt
plt.figure(1)
plt.title('Feature Importances')
plt.barh(range(len(indices)), importances[indices], color='b', align='center')
plt.yticks(range(len(indices)),ind)
plt.xlabel('Relative Importance')
plt.show()

# Step 7.v) Running the trained model on testing file
disbursed = rf.predict_proba(x_test)
test['Disbursed']=disbursed[:,1]

# Step 7.vi) Getting the output
test.to_csv('E:/DS/AV Hack 3.x/Solution_rf.csv', columns=['ID','Disbursed'],index=False)


### After that Ensemble the model in excel using Rank.avg function and assignment of weight 0.66 to XGBoost model and 0.33 to RF model

####### END ####### Happy Learning ####
