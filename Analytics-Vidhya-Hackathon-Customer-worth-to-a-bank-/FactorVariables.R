#########
### All the factor variables(with >2 levels ) are finetuned using the following steps:
### 1. Select a factor variable and create an XGB model and rank the important features(levels)
### 2. keep the most important levelsand merge the rest in to a single level "Others"
### 3. Include a subset of this levels into the final model depending on their effect.
#########


##########################################
######## BANKS / SALARY ACCOUNT ###################
##########################################
banks = as.data.frame(model.matrix(~0 + Salary_Account, loans))
bankstest = as.data.frame(model.matrix(~0 + Salary_Account, loanstest))

xgb2 <- xgboost(data = as.matrix(banks),
                label = dispnum,
                nrounds = 1930, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(banks),model = xgb2)
xgb.plot.importance(m)

banksorder = m$Feature
banksordertest = intersect(banksorder,colnames(bankstest))
rembanks = setdiff(colnames(banks) , banksorder)
rembankstest = setdiff(colnames(bankstest) , banksordertest)
uselessbanks = banks[rembanks]
uselessbankstest = bankstest[rembankstest]
banks = banks[banksorder]
bankstest = bankstest[banksordertest]

banks$Otherbanks = rowSums(cbind(banks[,12:ncol(banks)],uselessbanks))
bankstest$Otherbanks = rowSums(cbind(bankstest[,12:ncol(bankstest)],uselessbankstest))
banks = banks[,-(12:(ncol(banks)-1))]
bankstest = bankstest[,-(12:(ncol(bankstest)-1))]
write.csv(banks, "banks.csv", row.names=FALSE)
write.csv(bankstest, "bankstest.csv", row.names=FALSE)
rm(uselessbanks,uselessbankstest)

##########################################
######## DATE OF LEAD ###################
##########################################

###### EXTRACTING ONLY MONTHS AND ADDING TO TRAIN AND TEST DATA SET#####
date = as.character(loans$Lead_Creation_Date)
doj = strptime(date, format = "%d-%b-%Y")
months = as.factor(format(doj,'%b'))
days = as.numeric((doj - min(doj))/86400)
###
datetest = as.character(loanstest$Lead_Creation_Date)
dojtest = strptime(datetest, format = "%d-%b-%Y")
monthstest = as.factor(format(dojtest,'%b'))
daystest = as.numeric((dojtest - min(dojtest))/86400)

Train = cbind(Train,month = months)
Test = cbind(Test,month = monthstest)

Train = cbind(Train,model.matrix(~0 + month, Train))
Test = cbind(Test,model.matrix(~0 + month, Test))

Train$month = NULL
Test$month = NULL
#############################

dates = as.data.frame(model.matrix(~0 + Lead_Creation_Date, loans))
datestest = as.data.frame(model.matrix(~0 + Lead_Creation_Date, loanstest))

xgb2 <- xgboost(data = as.matrix(dates),
                label = dispnum,
                nrounds = 727, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(dates),model = xgb2)
xgb.plot.importance(m)

datesorder = m$Feature
remdates = setdiff(colnames(dates) , datesorder)
uselessdates = dates[remdates]
uselessdatestest = datestest[remdates]
dates = dates[datesorder]
datestest = datestest[datesorder]

dates$Otherdates = rowSums(cbind(dates[,28:35],uselessdates))
datestest$Otherdates = rowSums(cbind(datestest[,28:35],uselessdatestest))
dates = dates[,-(28:(ncol(dates)-1))]
datestest = datestest[,-(28:(ncol(datestest)-1))]
write.csv(dates, "dates.csv", row.names=FALSE)
write.csv(datestest, "datestest.csv", row.names=FALSE)
rm(uselessdates,uselessdatestest)

##########################################
######## CITY ###################
##########################################

city = as.data.frame(model.matrix(~0 + City, loans))
citytest = as.data.frame(model.matrix(~0 + City, loanstest))

xgb2 <- xgboost(data = as.matrix(city),
                label = dispnum,
                nrounds = 588, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(city),model = xgb2)
xgb.plot.importance(m)

cityorder = m$Feature
cityordertest = intersect(cityorder,colnames(citytest))
remcity = setdiff(colnames(city) , cityorder)
remcitytest = setdiff(colnames(citytest) , cityordertest)
uselesscity = city[remcity]
uselesscitytest = citytest[remcitytest]
city = city[cityorder]
citytest = citytest[cityordertest]

city$Othercity = rowSums(cbind(city[,12:ncol(city)],uselesscity))
citytest$Othercity = rowSums(cbind(citytest[,12:ncol(citytest)],uselesscitytest))
city = city[,-(12:(ncol(city)-1))]
citytest = citytest[,-(12:(ncol(citytest)-1))]
write.csv(city, "city.csv", row.names=FALSE)
write.csv(citytest, "citytest.csv", row.names=FALSE)
rm(uselesscity,uselesscitytest)

##########################################
######## VAR1 ###################
##########################################
var1 = as.data.frame(model.matrix(~0 + Var1, loans))
var1test = as.data.frame(model.matrix(~0 + Var1, loanstest))

xgb2 <- xgboost(data = as.matrix(var1),
                label = dispnum,
                nrounds = 740, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(var1),model = xgb2)
xgb.plot.importance(m)


var1order = m$Feature
remvar1 = setdiff(colnames(var1) , var1order)
uselessvar1 = var1[remvar1]
uselessvar1test = var1test[remvar1]
var1 = var1[var1order]
var1test = var1test[var1order]
var1$Othervar1 = rowSums(cbind(var1[,7:16],uselessvar1))
var1test$Othervar1 = rowSums(cbind(var1test[,7:16],uselessvar1test))
var1 = var1[,-(7:(ncol(var1)-1))]
var1test = var1test[,-(7:(ncol(var1test)-1))]
write.csv(var1, "var1.csv", row.names=FALSE)
write.csv(var1test, "var1test.csv", row.names=FALSE)

rm(uselessvar1,uselessvar1test)

##########################################
######## VAR2 ###################
##########################################

var2 = as.data.frame(model.matrix(~0 + Var2, loans))
var2test = as.data.frame(model.matrix(~0 + Var2, loanstest))

'''
xgb2 <- xgboost(data = as.matrix(var2),
                label = dispnum,
                nrounds = 530, max_depth = 2 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(var2),model = xgb2)
xgb.plot.importance(m)

var2order = m$Feature
var2 = var2[var2order]
var2test = var2test[var2order]

var2$Var2AD = (var2$Var2A + var2$Var2D)
var2test$Var2AD = (var2test$Var2A + var2test$Var2D)
var2$Var2EF = (var2$Var2E + var2$Var2F)
var2test$Var2EF = (var2test$Var2E + var2test$Var2F)
var2 = var2[,-c(1,4:6)]
var2test = var2test[,-c(1,4:6)]
'''
##########################################
######## VAR4 ###################
##########################################
var4 = as.data.frame(model.matrix(~0 + Var4, loans))
var4test = as.data.frame(model.matrix(~0 + Var4, loanstest))


##########################################
######## Source ###################
##########################################

Source = as.data.frame(model.matrix(~0 + Source, loans))
Sourcetest = as.data.frame(model.matrix(~0 + Source, loanstest))

xgb2 <- xgboost(data = as.matrix(Source),
                label = dispnum,
                nrounds = 1230, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)
m = xgb.importance(feature_names = colnames(Source),model = xgb2)
xgb.plot.importance(m)

Sourceorder = m$Feature
Sourceorder = Sourceorder
Sourceordertest = intersect(Sourceorder,colnames(Sourcetest))
remSource = setdiff(colnames(Source) , Sourceorder)
remSourcetest = setdiff(colnames(Sourcetest) , Sourceordertest)
uselessSource = Source[remSource]
uselessSourcetest = Sourcetest[remSourcetest]
Source = Source[Sourceorder]
Sourcetest = Sourcetest[Sourceordertest]

Source$OtherSource = rowSums(cbind(Source[,13],uselessSource))
Sourcetest$OtherSource = rowSums(uselessSourcetest)
Source = Source[,-13]

rm(uselessSource,uselessSourcetest)
write.csv(Source, "Source.csv", row.names=FALSE)
write.csv(Sourcetest, "Sourcetest.csv", row.names=FALSE)

##########################################
######## EMPLOYERS ###################
##########################################
######################

t = as.data.frame(table(loans$Employer_Name))
empnames = as.character(tail(t[order(t$Freq),1],26)) ## selecting only 26 employers with max freq
emp = as.character(loans$Employer_Name)
emptest = as.character(loanstest$Employer_Name)

emp[1:87020] = lapply(1:87020, function(x) ifelse(emp[x] %in% empnames, emp[x],"OtherEmployer" ))

emptest[1:nrow(loanstest)] = lapply(1:nrow(loanstest), function(x) ifelse(emptest[x] %in% empnames, emptest[x],"OtherEmployer" ))

emp = as.factor(c(do.call("cbind",emp)))
emptest = as.factor(c(do.call("cbind",emptest)))

Employer = as.data.frame(model.matrix(~0 + emp, loans))
Employertest = as.data.frame(model.matrix(~0 + emp, loanstest))

xgb2 <- xgboost(data = as.matrix(Employer),
                label = dispnum,
                nrounds = 920, max_depth = 4 ,eta = 0.01,
                objective = "binary:logistic", verbose=1)

m = xgb.importance(feature_names = colnames(Employer),model = xgb2)
xgb.plot.importance(m)

Employerorder = m$Feature
remEmployer = setdiff(colnames(Employer) , Employerorder)
uselessEmployer = Employer[remEmployer]
uselessEmployertest = Employertest[remEmployer]
Employer = Employer[Employerorder]
Employertest = Employertest[Employerorder]

Employer$OtherEmployer2 = rowSums(cbind(Employer[,18:(ncol(Employer)-1)],uselessEmployer))
Employertest$OtherEmployer2 = rowSums(cbind(Employertest[,18:(ncol(Employer)-1)],uselessEmployertest))
Employer = Employer[,-(18:(ncol(Employer)-1))]
Employertest = Employertest[,-(18:(ncol(Employertest)-1))]
write.csv(Employer, "Employer.csv", row.names=FALSE)
write.csv(Employertest, "Employertest.csv", row.names=FALSE)
###################
#####################
