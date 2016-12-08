##### Codes for Analytics Vidhya Online Hackathon 3.X - Predict-customer-worth-for-happy-customer-bank

http://discuss.analyticsvidhya.com/t/hackathon-3-x-predict-customer-worth-for-happy-customer-bank/3802

##### My approach for the hackathon is as follows:


######  Data Preprocessing ( R Code)
1.  I looked into levels of data and created a data dictionary by mentioning the level gaps, as I figured out that there is difference in level of data in training and testing data set (Like some cities are only in training dataset but are missing from testing and vice versa)

2.  Treated City and Employee Name column by removing extra spaces and making proper font

3. Removed Extra levels from city by looking at count of cities finally reduced it to 15 levels by making other cities as "Others"

4. Removed some extra levels from Employee names, replaced all Employers below 30 cases to "Others"

5. Extracted Date, Month and Year from DOB column and then removed DOB because of many levels

6. Extracted Day and Month from Lead Creation Date, but kept Lead creation date

7. Replaced missing values of Loan Amount and Tenure submitted from Loan Amount and Tenure Applied

8. Replaced missing values of Processing Fee to zero

9. Imputed missing value of Interest Rate, Loan Amount Submitted and Loan tenure by using bagged imputation from R caret

10. Created a new variable of EMI_calculated :  E = P×r×(1 + r)n/((1 + r)n - 1)

11. Created a new variable of Future_EMI_perincome ratio : (Existing EMI + EMI submitted)/ Monthly Income, restrited value till 2

12. Removed outlier from Monthly income by anything greater than 1,000,000 to 1,000,000

13. Created a new variable Process_percent : (Processing Fee/ Monthly Income) * 100, restricted it to 40

14. Created two variables exist_EMI_perincome(Existing EMI / Monthly income) and exx_EMI_perincome (EMI_calculated/ Monthly income)

######  Modelling (Python)

1. Used Extreme Gradient boosting and optimized the tuning parameterss based on local CV score, as many solutions on LB were proven to be overfitting in Weekender version

2. Final XGB model had a Local CV(4-Fold) score of 0.854141 +- 0.004308 and a LB rating of 0.85456

3. Used a Random forest classifier(1000 trees) and tuned it on a 75:25 approach

4. Final RF model was having local score of 0.84233 and a LB rating of 0.85213

5. Finally used Rank Average Ensembing for the final solution. Weights (2*XGB_score + Rf_score)/3

