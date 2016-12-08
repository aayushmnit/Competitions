import pandas as pd
import numpy as np
from scipy.stats import rankdata

xgb_pred = pd.read_csv("xgb_final.csv") #XGB
ftrl_pred = pd.read_csv("ftrl_final.csv") #FTRL

ens = xgb_pred.copy()
ens.rename(columns={'Disbursed':'XGB'}, inplace = True)
ens['FTRL'] = ftrl_pred['Disbursed']

ens['XGB_Rank'] = rankdata(ens['XGB'], method='min')
ens['FTRL_Rank'] = rankdata(ens['FTRL'], method='min')
ens['Final'] = 0.8*ens['XGB_Rank'] + 0.2*ens['FTRL_Rank']

ens = ens[['ID', 'Final']]
ens.rename(columns={'Final':'Disbursed'}, inplace = True)
ens.sort_index(inplace = True)
ens.head()

ens.to_csv("weekend_solution.csv", index = False) # 0.86116 public LB