##### ----- Question 2 ----- #####


### --- loading the libraries --- ###

library(e1071)
library(caret)



### --- Generating the data set with 3 classes and 150 observations --- ###


y = matrix(rnorm(300), ncol =2)
y[1:50,] = y[1:50,] + 2
y[50:100,] = y[50:100,] + 3
y[100:150,] = y[100:150,] + 3
x = c(rep(1,50), rep(2,50), rep(3,50))


### --- Scater plot of the data set --- ###

plot(y, pch = 19, col=x)

### --- Creating a data frame of the data set with class as a factor --- ###

data = data.frame(y,as.factor(x))

### --- Renaming the last column --- ###

names(data)[names(data) == 'as.factor.x.'] = 'class'


### --- Splitting the dataset to training set (50%) and test set(50%) --- ###


trainIndex = createDataPartition(data$class, p = 0.5, list = FALSE, times  = 1)
train = data[trainIndex,]
test = data[-trainIndex,]
test.label = data$class[-trainIndex]


train = as.data.frame(train)


### --- SVM Linear Kernel --- ###

svmlinear = tune.svm(class~., data = train, kernel = "linear",
                     tunecontrol = tune.control(cross = 5),
                     cost=c(0.001,0.01,0.1, 1,5,10,100))

svmlinear

### --- plotting the SVM with linear kernel --- ###

plot(svmlinear)

### --- Using the best model for predictions --- ###

svmlinear$best.model
pred.linear = predict(svmlinear$best.model, test)
confusionmatrixlinear = table(pred.linear, test.label)
confusionmatrixlinear

### ---  Finding the accuracy for the linear kernel --- ###

accuracy.linear = sum(diag(confusionmatrixlinear))/sum(confusionmatrixlinear)
classification_error_linear = 1 - accuracy.linear
print(paste('The SVM with linear kernel has accuracy :', round(accuracy.linear, 2)))
print(paste('The classification error for the SVM with linear kernel is :', round(classification_error_linear, 2)))



### ---  SVM Polynomial Kernel --- ###


svmPoly = tune.svm(class~., data = train,
                   kernel = 'polynomial',
                   tunecontrol = tune.control(cross = 5),
                   degree = c(1,3,4,5,10))

svmPoly


### ---  Using the best model for predictions --- ###


svmPoly$best.model
pred.svmPoly = predict(svmPoly$best.model, test)
confusionmatrixPoly = table(pred.svmPoly, test.label)
confusionmatrixPoly

### ---  Finding the accuracy for the Poly kernel --- ###

accuracy.Poly = sum(diag(confusionmatrixPoly))/sum(confusionmatrixPoly)
classification_error_Poly = 1 - accuracy.Poly
print(paste('The SVM with Polynomial kernel has accuracy :', round(accuracy.Poly, 2)))
print(paste('The classification error for the SVM with Polynomial kernel is :', round(classification_error_Poly, 2)))



### --- SVM Radial Kernel --- ###

svmRadial = tune.svm(class~., data = train,
                   kernel = 'radial',
                   tunecontrol = tune.control(cross = 5),
                   sigma =  c(0.01, 0.1, 1,10),cost =c(0.001,0.01,0.1, 1,5,10,100))
svmRadial

plot(svmRadial)

### --- ### --- Using the best model for predictions --- ###

svmRadial$best.model
pred.svmRadial = predict(svmRadial$best.model, test)
confusionmatrixRadial = table(pred.svmRadial, test.label)
confusionmatrixRadial

### ---  Finding the accuracy for the Radial kernel --- ###

accuracy.Radial = sum(diag(confusionmatrixRadial))/sum(confusionmatrixRadial)
classification_error_Radial = 1 - accuracy.Radial
print(paste('The SVM with Radial kernel has accuracy :', round(accuracy.Radial, 2)))
print(paste('The classification error for the SVM with Radial kernel is :', round(classification_error_Radial, 2)))

















