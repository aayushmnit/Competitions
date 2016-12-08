##### Codes for Analytics Vidhya Online Hackathon D Hack, 24th and 25th October, 2015 - Decode D Dalai Lama!

http://datahack.analyticsvidhya.com/contest/the-d-hack

###### My approach for the hackathon is as follows:

1.  Creating a Data dictionary by understanding levels of data and gaps in the data

2. Converting all the categorical variables into 1/0 encoder variables

3. Treating missing value as a different class itself by imputing it by -999

4. The evaluation metric used in the hackathon was very unconventional, it penalizes misclassification using several rules, which cannot be directly optimized by any conventional machine learning algorithm. So because of lack of time the best bet was to make a robust model, which doesn't deviate from Public to Private Leaderboard

5. Made 15 models , 4 - Random Forest, 8 - XGB , 4 - GB 

6. Did maximum vote ensemble for final Solution

###### Extras :

1. My single model was giving me a 0.71 score over Public LB , but I know its overfitting, my ensemble model was giving around 0.706 over public LB but I considered it to be more robust

2. The 0.71 single model was scored around 0.68329 over Private LB, while ensemble model was around 0.69304 over Private LB, so the assumption that ensemble model would be more robust proves to be right

3. I did tried one more thing just for fun, I made eval metric based in excel and extracted probability of each class from the model. After that I optimized weight of each class probability to maximize the eval metric. I didn't use it in final solution but would have been a fun thing to try :)
