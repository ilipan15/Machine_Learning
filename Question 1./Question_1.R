###### ----- Question 1 ----- #####


### --- loading libraries --- ###

library(tree)
library(randomForest)
library(gbm)
library(caret)
library(rattle)
library(dplyr)
library(corrplot)
library(ggplot2)
library(pROC)

### --- loading the German credit data from caret package --- ###

data(GermanCredit)

### --- Show the first 10 columns of the Dataset --- ###

str(GermanCredit[, 1:10])

### --- Delete two variables where all values are the same for both classes --- ###

GermanCredit[,c("Purpose.Vacation","Personal.Female.Single")] <- list(NULL)

### --- Creating training and test sets --- ### 

set.seed(12)
train.index=createDataPartition(GermanCredit$Class, p=0.7, list=FALSE)
train.feature = GermanCredit[train.index,] # training features
test.feature = GermanCredit[-train.index,] # training features
test.labels = GermanCredit$Class[-train.index] # test labels

### --- Decision Tree --- ###

# --- training the decision tree -- ###

gc.tree = tree(Class ~ . , train.feature)
summary(gc.tree)

gc.tree


# --- plotting the tree --- ###

plot(gc.tree)
text(gc.tree, pretty = 1)


### --- Pruning the decision Tree --- ###

set.seed(102)
gc.cv = cv.tree(gc.tree, FUN = prune.misclass, K = 5)
gc.cv

# --- plotting CV results --- ###

par(mfrow = c(1,2))
plot(gc.cv$size, gc.cv$dev, type = "b",
     xlab = "number of leaves of the tree",ylab="CV error rate%",
     cex.lab = 1.5, cex.axis = 1.5)
plot(gc.cv$k, gc.cv$dev, type = "b",
     xlab = expression(alpha), ylab = "CV error rate%",
     cex.lab = 1.5, cex.axis = 1.5)


# --- pruning the tree --- ###

gc.prune = prune.misclass(gc.tree, best = 9)
plot(gc.prune)
text(gc.prune, pretty = 1)

# --- predict the test instances --- ###

pred.pruned = predict(gc.prune, test.feature, type = "class")

mean(pred.pruned == test.labels)

### --- Caret for random forest --- ###

fitControl = trainControl(method = "cv", 
                          number = 5)
set.seed(2) 
random_f_Fit = train(Class ~ ., data = train.feature, method = "rf",
              metric = "Accuracy",
              trControl = fitControl,
              tuneLength = 5, 
              ntree = 1000)

random_f_Fit
plot(random_f_Fit)
random_f_Fit$finalModel
variable_Imp = varImp(random_f_Fit, scale = FALSE)

### --- plot the variable importance --- ###

plot(variable_Imp, top = 20)


# --- predict the test instances --- ###

pred.rf = predict(random_f_Fit, test.feature)
mean(pred.rf == test.labels)



# --- Creating the roc curves --- ### 

roc.dt = plot(roc(as.numeric(test.labels), as.numeric(pred.pruned)), print.auc = TRUE, 
              col = "green", print.auc.y = .4, add = TRUE)


roc.rf = plot(roc(as.numeric(test.labels), as.numeric(pred.rf)), print.auc = TRUE, 
              col = "blue", print.auc.y = .4, add = TRUE)


# --- plotting ROC plot --- ###

gl = ggroc(list("AUC for Decision Tree" = roc.dt, 
                "AUC for Random forest" = roc.rf), 
           legacy.axes = TRUE)

gl + xlab("False Positive Rate (1 - Specificity)") + ylab("True Positive Rate (Sensitivity)") + annotate("text", x = 0.26, y = 0.85, label = "AUC for DT: 68.57%") +
  annotate("text", x = 0.75, y = 0.82, label = "AUC for RF: 63.89%") + 
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="black", linetype="dashed") + theme(legend.title = element_blank())



