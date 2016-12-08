#Code for D-Hack Weeklong version 

#importing libraries
from sklearn.ensemble import RandomForestClassifier
#from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import confusion_matrix
import xgboost as xgb
import pandas as pd
import numpy as np
from sklearn import preprocessing
import pandas as pd
from sklearn import ensemble
import random

#Importing i/p files
train=pd.read_csv('E:/DS/DHack/train_FBFog7d.csv')
test=pd.read_csv('E:/DS/DHack/Test_L4P23N3.csv')
train.head()

#Pre-processing
def convert(data):
    number = preprocessing.LabelEncoder()
    data['Var1'] = number.fit_transform(data.Var1)
    data['WorkStatus'] = number.fit_transform(data.WorkStatus)
    data['Divorce'] = number.fit_transform(data.Divorce)
    data['Widowed'] = number.fit_transform(data.Widowed)
    data['Education'] = number.fit_transform(data.Education)
    data['Residence_Region'] = number.fit_transform(data.Residence_Region)
    data['babies'] = number.fit_transform(data.babies)
    data['preteen'] = number.fit_transform(data.preteen)
    data['teens'] = number.fit_transform(data.teens)
    data['income'] = number.fit_transform(data.income)
    data['Engagement_Religion'] = number.fit_transform(data.Engagement_Religion)
    data['Var2'] = number.fit_transform(data.Var2)
    data['TVhours'] = number.fit_transform(data.TVhours)
    data['Gender'] = number.fit_transform(data.Gender)
    data['Unemployed10'] = number.fit_transform(data.Unemployed10)
    data['Alcohol_Consumption'] = number.fit_transform(data.Alcohol_Consumption)
    data=data.fillna(-999)
    return data
new = train.append(test)
new = convert(new)
train = new[0:10357]
test = new[10357:]

#Features
Columns_names = train.columns.values
features = Columns_names[0:np.size(Columns_names)]
features = np.delete(features,[5,6])
features

#Creating Data set for training
x_train = train[list(features)].values
y_train = train['Happy'].values
x_test=test[features].values


############## RF Models ############
#0 Rf_model - 900
rf = ensemble.RandomForestClassifier(n_estimators=900,max_depth=16,criterion='entropy',max_features=6,  min_samples_leaf=35, n_jobs=4, random_state=0)
rf.fit(x_train, y_train)
Happy = rf.predict(x_test)
test['Happy_Rf_900']=Happy[:]

#1 Rf_model - 850
rf = ensemble.RandomForestClassifier(n_estimators=850,max_depth=16,criterion='entropy',max_features=6,  min_samples_leaf=35, n_jobs=4, random_state=0)
rf.fit(x_train, y_train)
Happy = rf.predict(x_test)
test['Happy_Rf_850']=Happy[:]

#2 Rf_model - 800
rf = ensemble.RandomForestClassifier(n_estimators=800,max_depth=16,criterion='entropy',max_features=6,  min_samples_leaf=35, n_jobs=4, random_state=0)
rf.fit(x_train, y_train)
Happy = rf.predict(x_test)
test['Happy_Rf_800']=Happy[:]

#3 Rf_model - 750
rf = ensemble.RandomForestClassifier(n_estimators=750,max_depth=16,criterion='entropy',max_features=6,  min_samples_leaf=35, n_jobs=4, random_state=0)
rf.fit(x_train, y_train)
Happy = rf.predict(x_test)
test['Happy_Rf_750']=Happy[:]

# Making Function for XGB
def happy_to_scores2(x):
    if x == 2:
        return 'Very Happy'
    elif x == 1:
        return 'Pretty Happy'
    elif x == 0:
        return 'Not Happy'
		
########### XG boost Models #############

xgtrain = xgb.DMatrix(x_train,label=number.fit_transform(y_train),missing=-999)
xgtest = xgb.DMatrix(x_test,missing=-999)

# Defining Parameter
params = {}
params["objective"] = "multi:softmax"
params["num_class"] = 3
params["eta"] = 0.01
params["min_child_weight"] = 15
params["subsample"] = 0.7
params["colsample_bytree"] = 0.7
params["max_depth"] = 6
params["seed"] = 0
number = preprocessing.LabelEncoder()
plst = list(params.items())

#4 XGB model : num_round - 390
num_rounds = 390
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_390']=label[:]

#5 XGB model : num_round - 340
num_rounds = 340
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_340']=label[:]

#6 XGB model : num_round - 290
num_rounds = 290
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_290']=label[:]

#7 XGB model : num_round - 240
num_rounds = 240
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_240']=label[:]

#8 XGB model : num_round - 190
num_rounds = 190
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_190']=label[:]

#9 XGB model : num_round - 140
num_rounds = 140
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_140']=label[:]

#10 XGB model : num_round - 90
num_rounds = 90
model_xgb = xgb.train(plst, xgtrain, num_rounds)
label = pd.DataFrame(model_xgb.predict(xgtest))
label = label[0].apply(lambda x: happy_to_scores2(x))
test['Happy_XGB_90']=label[:]

########### Gradient Boosting Models ##################

#11 GB model - 1200
clf = GradientBoostingClassifier(n_estimators=1200, learning_rate=0.01)
clf.fit(x_train, y_train) 
Happy = clf.predict(x_test)
test['Happy_GB_1200']=Happy[:]

#12 GB model - 1300
clf = GradientBoostingClassifier(n_estimators=1300, learning_rate=0.01)
clf.fit(x_train, y_train) 
Happy = clf.predict(x_test)
test['Happy_GB_1300']=Happy[:]

#13 GB model - 1400
clf = GradientBoostingClassifier(n_estimators=1400, learning_rate=0.01)
clf.fit(x_train, y_train) 
Happy = clf.predict(x_test)
test['Happy_GB_1400']=Happy[:]

Test_final = test[['ID','Happy_Rf_900','Happy_Rf_850','Happy_Rf_800','Happy_Rf_750','Happy_XGB_390','Happy_XGB_340','Happy_XGB_290','Happy_XGB_240','Happy_XGB_190','Happy_XGB_140','Happy_XGB_90','Happy_GB_1100','Happy_GB_1200','Happy_GB_1300','Happy_GB_1400']].copy()
Test_final.to_csv('E:/DS/DHack/Solution_ensemble_15.csv',index=False)

# After this did a maximum vote ensemble in excel, as I am not so good with Python :P Happy Hacking!
