# Iterative Single Imputation Using missForest in R

## Background

The missForest package in R using non-parametric techniques to train random forests on observed (not missing) data and use that information to predict missing values. This technique for imputing missing data is flexible in that it can be used for both continuous and categorical data.

## How Does it Work?

1. Data set is split into 4 parts: observed values on the variable(s) you are imputing; missing values on the variable(s) you are imputing; other variables in the data set with observed values; and other variables in the data set with missing values
2. Initial value is imputed for the missing values using mean imputation
3. Variables with missing values sorted based on amount of missing data
4. Missing values imputed using random forest on observed data (either classification or regression trees, depending on type of variable)
5. Missing values predicted based on previous step
6. Process continues until stopping criterion met

## Reference

Stekhoven, D. J., & Bühlmann, P. (2011). MissForest—non-parametric missing value imputation for mixed-type data. Bioinformatics, 28(1), 112-118.
