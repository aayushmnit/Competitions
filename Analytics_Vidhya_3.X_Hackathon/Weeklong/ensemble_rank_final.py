import pandas as pd
import numpy as np
from scipy.stats import rankdata

xgb1_pred = pd.read_csv("temp_submission/XGB1_Ens.csv") #XGB
xgb2_pred = pd.read_csv("temp_submission/XGB2_Ens.csv") #XGB
rf_pred = pd.read_csv("temp_submission/RF_Ens.csv") #RF
ftrl_pred = pd.read_csv("temp_submission/FTRL_Ens.csv") # FTRL

ens = xgb1_pred.copy()
ens.rename(columns={'Disbursed':'XGB1'}, inplace = True)
ens['XGB2'] = xgb2_pred['Disbursed']

ens['RF'] = rf_pred['Disbursed']
ens['FTRL'] = ftrl_pred['Disbursed']


ens['XGB1_Rank'] = rankdata(ens['XGB1'], method='min')
ens['XGB2_Rank'] = rankdata(ens['XGB2'], method='min')

ens['XGB_Rank'] = 0.5 * ens['XGB1_Rank'] + 0.5 * ens['XGB2_Rank']
ens['RF_Rank'] = rankdata(ens['RF'], method='min')
ens['FTRL_Rank'] = rankdata(ens['FTRL'], method='min')

ens['Final'] = (0.75*ens['XGB_Rank'] + 0.25*ens['RF_Rank']) * 0.75 + 0.25 * ens['FTRL']

ens = ens[['ID', 'Final']]
ens.rename(columns={'Final':'Disbursed'}, inplace = True)
ens.sort_index(inplace = True)
ens.head()

ens.to_csv("FinalSolution.csv", index = False)