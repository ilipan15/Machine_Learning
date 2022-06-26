### --- loading libraries --- ###
library(caret)
library(class) 
library(MASS)
library(dplyr)
library(pROC)

### --- loading the file --- ###

data = read.delim("newthyroid.txt", sep =",")


### --- creating a lists for the for loop --- ###

seeds = c(10, 20, 30, 40, 50, 60, 70 ,80, 90, 100) # seed list

auc.knn = c() # auc score list for knn
auc.lda = c() # auc score list for lda
accuracy.knn = c() # accuracy list for knn
accuracy.lda = c() # accuracy list for lda

### ---  for loop --- ###
for (i in seeds) {
  set.seed(i)

  ### --- creating training (70%) and test(30%) sets --- ###
  trainIndex = createDataPartition(data$class, p = 0.7, list = FALSE, times = 1) 
  train.feature=data[trainIndex,] # training features 
  train.feature$class = NULL
  train.label=data$class[trainIndex] # training labels 
  test.feature=data[-trainIndex,] # test features
  test.feature$class = NULL
  test.label=data$class[-trainIndex] # test labels
  
### --- setting up the train control --- ### 
fitControl = trainControl(method = "repeatedcv", 
                          number = 5, # 5-fold CV
                          repeats = 1)
                          


### --- kNN Training --- ###
knnFit=train(train.feature ,train.label, method = "knn",
             trControl = fitControl,
             metric = "Accuracy",
             tuneLength=10)

### --- kNN test process --- ###
pred.knn = predict(knnFit,test.feature) 

### --- getting the knn accuracy --- ###
acc.knn = mean(pred.knn==test.label)

accuracy.knn = c(accuracy.knn, acc.knn)
roc.knn = roc(as.factor(test.label), as.numeric(pred.knn))
auc.knn = c(auc.knn, as.numeric(roc.knn$auc))


### --- LDA training --- ###

ldaFit =train(train.feature, train.label,method="lda2",
             trControl=fitControl)

#### --- LDA test process --- ### 

pred.lda = predict(ldaFit,test.feature)

### --- getting the lda accuracy --- ###
acc.lda = mean(test.label== pred.lda)

accuracy.lda = c(accuracy.lda, acc.lda)
roc.lda = roc(as.factor(test.label), as.numeric(pred.lda))
auc.lda = c(auc.lda, as.numeric(roc.lda$auc))

}

mean(auc.lda)
mean(auc.knn)


### --- creating the Boxplot --- ###
boxplot(auc.knn ,auc.lda,
        horizontal=TRUE,
        names=c("kNN","LDA"),
        col=c("thistle","wheat"),
        xlab="AUC Scores",
        main="Boxplot based on the 10 AUC scores of kNN and LDA")






