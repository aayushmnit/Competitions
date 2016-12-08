##### Codes for Analytics Vidhya Online Hackathon - Black Friday
http://datahack.analyticsvidhya.com/contest/black-friday-data-hack

##### Problem Statement
The challenge was to predict purchase prices of various products purchased by customers based on historical purchase patterns. The data contained features like age, gender, marital status, categories of products purchased, city demographics etc.

##### My approach for the hackathon is as follows:
1. Looked into levels of data and ran a basic random forest to understand Feature importance, realized Product ID was the most important feature
2. Added a new variable in Excel with mean of each product
3. Converted all categorical variable in one hot encoded categories
4. Built an XGB over it and optimized parameters
5. Got a RMSE of 2465, Public Leader Board Ranking 7 , Private Leaderboard Ranking 5
