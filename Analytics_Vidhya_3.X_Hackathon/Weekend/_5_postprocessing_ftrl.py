import pandas as pd

test = pd.read_csv("test.csv", usecols = ["ID"])

preds = pd.read_csv("ftrl_final.csv")
preds['ID'] = test['ID']
preds.to_csv("ftrl_final2.csv", index  = False)