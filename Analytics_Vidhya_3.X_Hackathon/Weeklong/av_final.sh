mkdir temp_data
mkdir temp_submission

python preprocessing.py
python preprocessing2.py

echo "====> Lets train 5 XGBs for same type of configuration and average for seed stability and control overfitting"
python train_xgb.py
python train_xgb2.py
python train_xgb3.py
python train_xgb4.py
python train_xgb5.py
python postprocessing_XGB_1.py

echo "====> Train one more 5-set XGB with slightly different feature set(resulted in higher CV). Rank average."
python train_2xgb1.py
python train_2xgb2.py
python train_2xgb3.py
python train_2xgb4.py
python train_2xgb5.py
python postprocessing_XGB_2.py

python preprocessing_ftrl.py

echo "====> Shuffle the input data to train linear models with FTRL (Logistic Regression)"
python shuffle.py temp_data/train_preprocessed_full.csv temp_data/shuffled_train1.csv 1 100000 1234
python shuffle.py temp_data/train_preprocessed_full.csv temp_data/shuffled_train2.csv 1 100000 3456
python shuffle.py temp_data/train_preprocessed_full.csv temp_data/shuffled_train3.csv 1 100000 6789
python shuffle.py temp_data/train_preprocessed_full.csv temp_data/shuffled_train4.csv 1 100000 6543

echo "====> Train them in an online manner"
pypy script_ftrl.py
pypy script_ftrl2.py
pypy script_ftrl3.py
pypy script_ftrl4.py
pypy script_ftrl5.py

echo "====> Rank average linear models for stability"
python postprocessing_ftrl.py

echo "Let's train Random Forests on original data without city and employer name features"
python train_rf.py

python postprocessing_rf.py

echo "Final Rank ensemble!"
python ensemble_rank_final.py