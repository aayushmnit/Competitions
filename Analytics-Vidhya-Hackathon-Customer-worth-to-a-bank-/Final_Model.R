##########################
######## After including different features and CV finally obtained 
#######  the following features as important 
#########################
k = c(3,6:8,11,12,14:19,23:29) 

train = cbind(Train[,k],banks,city,var1,var4,Source,dates[,1:10],Employer[,1:3],var2[,4])
test = cbind(Test[,k],bankstest,citytest,var1test,var4test,Sourcetest,datestest[,1:10],Employertest[,1:3],var2test[,4])

#######################
###### CV #######
########################

nrounds = 5000
nfolds = 4
ps = list( max_depth = 5 ,eta = 0.01,objective = "binary:logistic")
ms = list( 'auc','rmse')

cvXgb = xgb.cv(params = ps, data = as.matrix(train) , 
               label = dispnum, nrounds = nrounds ,nfold = nfolds,showsd = T,metrics = ms,stratified = T, verbose = T,subsample = 0.7
)

#######################
###### FINAL MODEL #######
########################
xgb2 <- xgboost(data = as.matrix(train),
                label = dispnum,
                nrounds = 1426, max_depth = 5 ,eta = 0.01,
                objective = "binary:logistic", verbose=1,subsample = 0.7)


#n = xgb.importance(feature_names = colnames(banks),model = xgb2,data = dates,label = #dispnum)
pred <- predict(xgb2, as.matrix(test,type = 'response'))

pp2 = data.frame(ID = Test[,1] ,Disbursed = pred)
write.csv(pp2, "samplesub.csv", row.names=FALSE)

################
################
