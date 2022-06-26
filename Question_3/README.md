## Assignment outline

Use the [newthyroid.txt](https://github.com/ilipan15/Machine_Learning/blob/main/data/newthyroid.txt) data. This data contain measurements for normal patients and those with hyperthyroidism. The first variable class=n if a patient is normal and class=h if a patients suffers from hyperthyroidism. The rest variables feature1 to feature5 are some medical test measurements.

- Apply kNN and LDA to classify the newthyroid.txt data: randomly split the data to a training set (70%) and a test set (30%) and repeat the random split 10 times.
For kNN, use 5-fold cross-validation to choose k from (3, 5, 7, 9, 11, 13, 15). Use AUC as the metric to choose k, i.e. choose k with the largest AUC.
Record the 10 test AUC values of kNN and LDA in two vectors. 
- Draw two boxplots in one plot based on the 10 AUC values of kNN and LDA.
