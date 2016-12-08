Tuning and CV strategy for XGB:
==============================

Typically, people use 5 folds. You can make a choice. To see the reliability of CV estimate, a few guys use 10-fold as well. 

Steps:
-----
  1. Decide 'n' in n-fold. Stick to it for complete analysis.
  2. Create a baseline score using a simple model.
  3. Now, use XGBoost default settings and establish another XGB baseline score.
  4. Put num_trees at 10000 and a tiny learning rate of 0.01.
  5. Try step(4) for various max_depth.
  6. While doing step(4), monitor the progress. Note at what tree# is the model overfitting
  7. After you're done with 1-6, you would have reached a saturation score
  8. Now comes some magic! Start using subsample and tada, your score improves.
  9. Use colsample_bytree, then scale_pos_weight, improve your score
  10. Try using max_delta_step and gamma too (a little tricky to tune)
