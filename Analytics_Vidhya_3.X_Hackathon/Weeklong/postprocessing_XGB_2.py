import pandas as pd
from scipy.stats import rankdata

test = pd.read_csv("test.csv", usecols = ["ID"])

preds = pd.read_csv("temp_submission/Sub251.csv")
preds['ID'] = test['ID']

preds2 = pd.read_csv("temp_submission/Sub252.csv")
preds3 = pd.read_csv("temp_submission/Sub253.csv")
preds4 = pd.read_csv("temp_submission/Sub254.csv")
preds5 = pd.read_csv("temp_submission/Sub255.csv")

preds['Disbursed'] = rankdata(preds['Disbursed'], method='ordinal')
preds2['Disbursed'] = rankdata(preds2['Disbursed'], method='ordinal')
preds3['Disbursed'] = rankdata(preds3['Disbursed'], method='ordinal')
preds4['Disbursed'] = rankdata(preds4['Disbursed'], method='ordinal')
preds5['Disbursed'] = rankdata(preds5['Disbursed'], method='ordinal')

preds['Disbursed'] = 0.2 * (preds['Disbursed'] + 
							preds2['Disbursed'] + 
							preds3['Disbursed'] + 
							preds4['Disbursed'] + 
							preds5['Disbursed'])

preds.to_csv("temp_submission/XGB2_Ens.csv", index = False)