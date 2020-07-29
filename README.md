# Iterative Single Imputation Using missForest in R

## Background

The missForest package in R uses non-parametric techniques to train random forests on observed (not missing) data and uses that information to predict missing values. This technique for imputing missing data is flexible in that it can be used for both continuous and categorical data.

## How Does it Work?

1. Data set is split into 4 parts: observed values on the variable(s) you are imputing; missing values on the variable(s) you are imputing; other variables in the data set with observed values; and other variables in the data set with missing values
2. Initial value is imputed for the missing values using mean imputation
3. Variables with missing values sorted based on amount of missing data
4. Missing values imputed using random forest on observed data (either classification or regression trees, depending on type of variable)
5. Missing values predicted based on previous step
6. Process continues until stopping criterion met

## The Code
```R
baseline.imp <- missForest(xmis = data, #specify your data set
                           maxiter = 10, #max number of iterations
                           ntree = 100, #number of trees for each forest
                           replace = TRUE, #bootstrap sampling with replacement
                           #cutoff for each variable; set to 1 for continuous variables, specify possible values for categorical variables
                           cutoff = list(1, c(0,1,2,3), c(0,1), c(0,1,2), 1,
                                         c(0,1,2), c(0,1)),
                           xtrue = NA #if you have the complete data set with no missing values, specify it here)

```

## Reference

Stekhoven, D. J., & Bühlmann, P. (2011). MissForest—non-parametric missing value imputation for mixed-type data. Bioinformatics, 28(1), 112-118.
