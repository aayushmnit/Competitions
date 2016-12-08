import pandas as pd
import numpy as np

import xgboost as xgb
from sklearn.cross_validation import cross_val_score, cross_val_predict

# # Modeling

train = pd.read_csv("temp_data/train_preprocessed.csv")
test = pd.read_csv("temp_data/test_preprocessed.csv")
labels = pd.read_csv("temp_data/train_labels.csv", header = None)
test_ids = pd.read_csv("temp_data/test_ids.csv", header = None)

labels = list(labels.iloc[:,0])
test_ids = list(test_ids.iloc[:,0])

params = {'booster':'gbtree', 'objective':'binary:logistic', 'max_depth':9, 'eval_metric':'auc',
          'eta':0.02, 'silent':1, 'nthread':4, 'subsample': 0.9, 'colsample_bytree':0.9, 'scale_pos_weight': 1,
          'min_child_weight':3, 'max_delta_step':3}
num_rounds = 400

params['seed'] = 523264626346
dtrain = xgb.DMatrix(train, labels, missing=np.nan)
# xgb.cv(params, dtrain, num_rounds, nfold=4)
# exit()

clf = xgb.train(params, dtrain, num_rounds)
dtest = xgb.DMatrix(test, missing = np.nan)
test_preds_xgb = clf.predict(dtest)

submission = pd.DataFrame({ 'ID':test_ids, 'Disbursed':test_preds_xgb})
submission = submission[['ID', 'Disbursed']]
submission.to_csv("temp_submission/Sub241.csv", index = False)

