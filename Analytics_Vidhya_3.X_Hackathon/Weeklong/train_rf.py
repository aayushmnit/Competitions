
import pandas as pd
import numpy as np

from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import cross_val_score, cross_val_predict

train = pd.read_csv("Train.csv")
test = pd.read_csv("Test.csv")
submission = pd.read_csv("sample_submission.csv")

salary_acc = train.Salary_Account.value_counts(dropna=False)
salary_acc_rare = list(salary_acc[salary_acc<40].index)
train.ix[train['Salary_Account'].isin(salary_acc_rare), "Salary_Account"] = "Others"

train2 = train.copy()#[~pd.isnull(train['Loan_Amount_Applied'])]

id_train = train['ID']
label = train2['Disbursed']

dropCols = ['ID', 'LoggedIn', 'Disbursed', 'DOB', 'Lead_Creation_Date', 'City', 'Employer_Name']
train2.drop(dropCols, axis=1, inplace = True)

y_train = label
X_train = pd.get_dummies(train2)

# # Test set preparation
test.ix[test['Salary_Account'].isin(salary_acc_rare), "Salary_Account"] = "Others"
testdropcols = list(set(dropCols)-set(['LoggedIn', 'Disbursed']))
test2 = test.drop(testdropcols, axis=1)

X_test = pd.get_dummies(test2)
missingCols = list(set(X_train.columns)-set(X_test.columns))
for col in missingCols:
    X_test[col] = 0
X_test = X_test[X_train.columns]
assert X_train.columns.equals(X_test.columns)

# # Modeling
X_train_2 = X_train.fillna(-999)
X_test_2 = X_test.fillna(-999)

# from sklearn.cross_validation import KFold
# kf = KFold(len(X_train_2), n_folds=4)
# scores = cross_val_score(clf, X_train_2, y_train, scoring='roc_auc', cv=kf)
# print "CV:", np.mean(scores), "+/-", np.std(scores), "All:", scores
# CV: 0.831889207925 +/- 0.0109754348042 All: [ 0.82381549  0.82907869  0.85055107  0.82411158]
seeds = [31121421,53153,5245326,6536,75]
numbers = [151,152,153,154,155]

for i in range(5): 
    clf = RandomForestClassifier(n_estimators=360, max_depth=9, criterion = 'entropy', min_samples_split=2, bootstrap = False, n_jobs=-1, random_state=seeds[i])
    clf.fit(X_train_2, y_train)
    test_preds = clf.predict_proba(X_test_2)[:,1]
    print("RF %s done" % i)

    submission = pd.DataFrame({'ID':test['ID'], 'Disbursed':test_preds})
    submission = submission[['ID', 'Disbursed']]
    submission.to_csv("temp_submission/Sub%s.csv" % str(numbers[i]), index = False)