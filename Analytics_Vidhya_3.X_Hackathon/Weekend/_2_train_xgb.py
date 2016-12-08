import pandas as pd
import numpy as np

import xgboost as xgb

train = pd.read_csv("train_preprocessed.csv")
test = pd.read_csv("test_preprocessed.csv")
labels = pd.read_csv("train_labels.csv", header = None)
test_ids = pd.read_csv("test_ids.csv", header = None)

labels = list(labels.iloc[:,0])
test_ids = list(test_ids.iloc[:,0])

params = {'booster':'gbtree', 'objective':'binary:logistic', 'max_depth':9, 'eval_metric':'logloss',
          'eta':0.02, 'silent':1, 'nthread':4, 'subsample': 0.9, 'colsample_bytree':0.9, 'scale_pos_weight': 1,
          'min_child_weight':3, 'max_delta_step':3}
num_rounds = 400

params['seed'] = 523264626346 # 0.85533
dtrain = xgb.DMatrix(train, labels, missing=np.nan)
# xgb.cv(params, dtrain, num_rounds, nfold=4)
# exit()
# [395]   cv-test-logloss:0.062599+0.001852       cv-train-logloss:0.042591+0.001435
# [396]   cv-test-logloss:0.062594+0.001854       cv-train-logloss:0.042548+0.001437
# [397]   cv-test-logloss:0.062595+0.001854       cv-train-logloss:0.042507+0.001445
# [398]   cv-test-logloss:0.062601+0.001851       cv-train-logloss:0.042446+0.001435
# [399]   cv-test-logloss:0.062603+0.001852       cv-train-logloss:0.042390+0.001416


clf = xgb.train(params, dtrain, num_rounds)
dtest = xgb.DMatrix(test, missing = np.nan)
test_preds = clf.predict(dtest)

submission = pd.DataFrame({ 'ID':test_ids, 'Disbursed':test_preds})
submission = submission[['ID', 'Disbursed']]
submission.to_csv("xgb_final.csv", index = False)

