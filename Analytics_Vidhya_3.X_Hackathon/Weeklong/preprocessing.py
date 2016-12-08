import pandas as pd
import numpy as np

from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier
import xgboost as xgb
from sklearn.cross_validation import cross_val_score, cross_val_predict


train = pd.read_csv("Train.csv")
test = pd.read_csv("Test.csv")
submission = pd.read_csv("sample_submission.csv")
print "Train dataset dimensions:", train.shape
print "Test dataset dimensions:", test.shape

salary_acc = train.Salary_Account.value_counts(dropna=False)
salary_acc_rare = list(salary_acc[salary_acc<40].index)
train.ix[train['Salary_Account'].isin(salary_acc_rare), "Salary_Account"] = "Others"

train['dob_day'] = pd.to_datetime(train['DOB']).dt.day
train['dob_dayofweek'] = pd.to_datetime(train['DOB']).dt.dayofweek
train['dob_weekofyear'] = pd.to_datetime(train['DOB']).dt.weekofyear
train['dob_quarter'] = pd.to_datetime(train['DOB']).dt.quarter
train['dob_month'] = pd.to_datetime(train['DOB']).dt.month
train['dob_year'] = pd.to_datetime(train['DOB']).dt.year

train['Lifetime'] = pd.to_datetime(train['Lead_Creation_Date']) - pd.to_datetime(train['DOB'])
train['Lifetime'] = train['Lifetime'].dt.days.astype(int)

train['lcd_day'] = pd.to_datetime(train['Lead_Creation_Date']).dt.day
train['lcd_dayofweek'] = pd.to_datetime(train['Lead_Creation_Date']).dt.dayofweek
train['lcd_weekofyear'] = pd.to_datetime(train['Lead_Creation_Date']).dt.weekofyear
train['lcd_quarter'] = pd.to_datetime(train['Lead_Creation_Date']).dt.quarter
train['lcd_month'] = pd.to_datetime(train['Lead_Creation_Date']).dt.month
train['lcd_year'] = pd.to_datetime(train['Lead_Creation_Date']).dt.year

city = pd.DataFrame(train['City'].value_counts())
city_rare = list(city[city[0] < 100].index)
train.ix[train['City'].isin(city_rare), 'City'] = "Others"
train['Loan_Tenure_Applied'].replace([10,6,7,8,9],value = np.nan, inplace = True)
train['Loan_Tenure_Submitted'].replace(6, np.nan, inplace = True)

from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
train['City_encoded'] = le.fit_transform(train['City'])

empnames = pd.DataFrame(train['Employer_Name'].value_counts())
empnames_rare = list(empnames[empnames[0]<30].index)
train.ix[train['Employer_Name'].isin(empnames_rare), 'Employer_Name'] = "Others"

# # Preprocessing
train2 = train.copy()

id_train = train['ID']
label = train2['Disbursed']

dropCols = ['ID', 'LoggedIn', 'Disbursed', 'DOB']#, 'Lead_Creation_Date']
train2.drop(dropCols, axis=1, inplace = True)

y_train = label
X_train = pd.get_dummies(train2)

# # Test set preparation
test.ix[test['Salary_Account'].isin(salary_acc_rare), "Salary_Account"] = "Others"

test['lcd_day'] = pd.to_datetime(test['Lead_Creation_Date']).dt.day
test['lcd_dayofweek'] = pd.to_datetime(test['Lead_Creation_Date']).dt.dayofweek
test['lcd_weekofyear'] = pd.to_datetime(test['Lead_Creation_Date']).dt.weekofyear
test['lcd_quarter'] = pd.to_datetime(test['Lead_Creation_Date']).dt.quarter
test['lcd_month'] = pd.to_datetime(test['Lead_Creation_Date']).dt.month
test['lcd_year'] = pd.to_datetime(test['Lead_Creation_Date']).dt.year

test['dob_day'] = pd.to_datetime(test['DOB']).dt.day
test['dob_dayofweek'] = pd.to_datetime(test['DOB']).dt.dayofweek
test['dob_weekofyear'] = pd.to_datetime(test['DOB']).dt.weekofyear
test['dob_quarter'] = pd.to_datetime(test['DOB']).dt.quarter
test['dob_month'] = pd.to_datetime(test['DOB']).dt.month
test['dob_year'] = pd.to_datetime(test['DOB']).dt.year

test['Lifetime'] = pd.to_datetime(test['Lead_Creation_Date']) - pd.to_datetime(test['DOB'])
test['Lifetime'] = test['Lifetime'].dt.days.astype(int)

test.ix[test['City'].isin(city_rare), 'City'] = "Others"
newcities = list(set(test['City']) - set(train['City']))
test.ix[test['City'].isin(newcities), 'City'] = np.nan
test['City_encoded'] = le.transform(test['City'])

test['Loan_Tenure_Applied'].replace([10,6,7,8,9],value = np.nan, inplace = True)
test['Loan_Tenure_Submitted'].replace(6, np.nan, inplace = True)

test.ix[test['Employer_Name'].isin(empnames_rare), 'Employer_Name'] = "Others"

newempnames = list(set(test['Employer_Name']) - set(train['Employer_Name']))
test.ix[test['Employer_Name'].isin(newempnames), "Employer_Name"] = "Others"

testdropcols = list(set(dropCols)-set(['LoggedIn', 'Disbursed']))
test2 = test.drop(testdropcols, axis=1)

X_test = pd.get_dummies(test2)
missingCols = list(set(X_train.columns)-set(X_test.columns))
for col in missingCols:
    X_test[col] = 0
X_test = X_test[X_train.columns]
assert X_train.columns.equals(X_test.columns)

X_train.to_csv("temp_data/train_preprocessed.csv", index = False)
X_test.to_csv("temp_data/test_preprocessed.csv", index = False)
y_train.to_csv("temp_data/train_labels.csv", index = False)
test['ID'].to_csv("temp_data/test_ids.csv", index = False)