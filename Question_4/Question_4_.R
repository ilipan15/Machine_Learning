##### ----- Question 4 ----- #####

### --- loading the libraries --- ###

library(caret)
library(dplyr)

### --- loading the German credit data --- ###

data(GermanCredit)


Q4F <- function(label, k, seeds){
  
  ### --- creating a table with the unique label observations --- ###
  freq.table = data.frame(table(label))
  
  set.seed(seeds) # setting the seed 
  
  fold.list = c() # creating lists for the loop 
  index.list = c()
  
  for (i in unique(label)) {
    
    label.index = which(label == i) # Segmenting the index of the label by the label
    
    ### Calculating the size of each fold 
    label.size = freq.table$Freq[freq.table$label == i]
    fold.size = floor(label.size / k )  
    
    ### --- for loop to randomly select the index --- ###
    for (x in 1:k) {
      sample.index = sample(label.index, fold.size)
      index.list = append(index.list, sample.index) # filling the index list with the random index
      fold.list = append(fold.list, rep(x, length(sample.index))) #  filing fold list with x repeated as the length of sample.index
      label.index = setdiff(label.index, sample.index) # updating the label.index every time for loop is ending 
    }
  }
  
  final = cbind(fold.list, index.list)
                                                                                                                        
  return(final)
}

Q4F(GermanCredit$Class, k = 10, seeds = 100)



