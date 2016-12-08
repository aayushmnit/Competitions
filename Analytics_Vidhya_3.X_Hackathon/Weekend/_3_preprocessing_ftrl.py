import pandas as pd

train = pd.read_csv("train_preprocessed.csv")
labels = pd.read_csv("train_labels.csv", header = None)

labels = list(labels.iloc[:,0])

train['Disbursed'] = labels

train.to_csv("train_preprocessed_full.csv", index = False)