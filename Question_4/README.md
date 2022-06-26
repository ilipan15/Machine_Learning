## Assignment outline

Write a user-defined function to provide the training indexes for K-fold cross-validation
with the following requirements:

• Input: the label vector, K, the seed or random state.
• Output: the training indexes for each iteration.
• Make sure that the class labels in each fold follow the original distribution. For example, if the numbers of instances in three classes are (100,50,50), then in each fold the ratio of the numbers of instances in the three classes should be roughly 2 : 1 : 1.

Use this function to produce the training indexes for 10-fold cross-validation on the [GermanCredit](/Users/panagiotidouiliana/Documents/GitHub/Machine_Learning/data/GermanCredit.csv) data.