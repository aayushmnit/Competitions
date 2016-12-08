# Approach and Codes for Hacker-Earth Will-Bill-Solve-it? 

https://www.hackerearth.com/machine-learning-india-hacks-2016/machine-learning/will-bill-solve-it/

Finished - 4th over Public LB(AUC - 0.833, winners(0.834))

##Problem Statement:
HackerEarth is a community of programmers. Thousands of hackers solve problems on HackerEarth everyday to improve their programming skills or win prizes. These hackers can be beginners who are new to programming, or experts who know the solution in a blink. There is a pattern to everything, and this problem is about finding those patterns and problem solving behaviours of the users.

Finding these patterns will be of immense help to the problem solvers, as it will allow to suggest relevant problems to solve and offer solution when they seem to be stuck. The opportunities are diverse and you are entitled with the task to predict them.

## Data Sets:
Both training and testing dataset consist of 3 files :-

### 1) User File:  
With Attributes of a User:<br />
<br />
user_id - the user id <br />
skills - all his skills separated by the delimiter '|' <br />
solved_count - number of problems solved by the user <br />
attempts - total number of incorrect submissions done by the user <br />
user_type : type of user (S - Student, W - Working, NA - No Information Available)<br />
  
### 2) Problem File:
Attribute related to a Problem : <br />
<br />
problem_id - the id of the problem<br />
level - difficulty of the problem (Very-Easy, Easy, Easy-Medium, Medium, Medium-Hard, Hard)<br />
accuracy - the accuracy score for the problem<br />
solved_count - number of people who have solved it<br />
error_count - number of people who have solved it incorrectly<br />
rating - star (quality) rating of the problem on scale of 0-5<br />
tag1 - tag of the problem representing the type e.g. Data Structures<br />
tag2 - tag of the problem<br />
tag3 - tag of the problem<br />
tag4 - tag of the problem<br />
tag5 - tag of the problem<br />
  
### 3) Submissions File:
Problem User interaction and final results for each attempt a user made to a solve a particular problem.<br />
<br />
user_id - the id of the user who made a submission<br />
problem_id - the id of the problem that was attempted<br />
solved_status - indicates whether the submission was correct (SO : Solved or Correct solution, AT : Attempted or Incorrect solution )<br />
result - result of the code execution (PAC: Partially Accepted, AC : Accepted, TLE : Time limit exceeded, CE : Compilation Error, RE : Runtime Error, WA : Wrong Answer)<br />
language_used - the lang used by user to code the solution <br />
execution_time - the execution time of the solution<br />

## Approach:
### Preprocessing
#### User File:
1. Create Features of user skill, there are total 24 skills in the skills columns so created binary flag for each skills
2. Counting the total number of skills a user have
3. User Success Rate Percentage: Solved count * 100/ (Attempts + Solved Counts)
  
#### Problem File:
1. Count of Tag : Counting number of tags present in problems ( 5- number of NA's)
2. I created a Dictionary file for 81 unique tags present in Tag1 to Tag5, and bucketed it in 17 super categories based on business understanding of tag
3. Made Binary features of each of the 17 skills (1/0) if the respected tag is present in front of problem
4. Imputing missing value with zero
5. Assuming Text variables as categorical vairables and encoding each with numeric values
6. Accuracy Measure : (Solved Count*100) / (Solved count + Error Count)
      
#### Submission File(Only for Training Submission File) :
1. Removing entries which have Solved status as UK (Unknown)
2. Creating 1/0 of our target variable as solved status == "SO" then 1 else 0
3. Rolling up data at User ID, Problem ID level and sum of solved status
4. Creating our final Target Variable(1/0) by checking Solved Status > 1 as 1 else 0
    
Merging all the 3 files to get our Final training and testing set
    
### Modelling
1. I trained 3 XGboost modesls with different number of rounds, but same probabily cutoffs
2. Did vote ensemble of the three models

    
