#####################################
## Using missForest for Imputation ##
##### code created by Val Ryan ######
##### last updated July 29, 2020 ####
#####################################

#############################################
## Read and Recode Baseline Attribute Data ##
#############################################

#set working directory
setwd("C:/Users/Your File Path")

#read in csv files
baseline <- read.csv("nodesfinal.csv", header=T)

#recode variables
attach(baseline)

#Education
##0 = elementary, 1 = high school, 2 = college
baseline$edcat[b03_1.x <= 2] <- 0
baseline$edcat[b03_1.x == 3] <- 1
baseline$edcat[b03_1.x == 4] <- 1
baseline$edcat[b03_1.x > 4] <- 2

#Employment
##0 = employed, 1 = unemployed, 2 = no work medical reason, 3 = other
baseline$employcat[b04.x <= 7] <- 0
baseline$employcat[b04.x == 8] <- 1
baseline$employcat[b04.x == 9] <- 2
baseline$employcat[b04.x == 10] <- 3

#Living Situation
##0 = rent, 1 = no rent, 2 = homeless, 3 = missing
baseline$livecat[b07.x == 1] <- 0
baseline$livecat[b07.x == 3] <- 0
baseline$livecat[b07.x == 4] <- 0
baseline$livecat[b07.x == 2] <- 1
baseline$livecat[b07.x == 5] <- 1
baseline$livecat[b07.x == 6] <- 2
baseline$livecat[b07.x == 7] <- NA
baseline$livecat[b07.x == 97] <- NA

#Nationality
##0 = Greek, 1 = not Greek
baseline$natcat[b05_1.x == 1] <- 0
baseline$natcat[b05_1.x == 2] <- 1
baseline$natcat[b05_1.x == 3] <- 1
baseline$natcat[b05_1.x == 4] <- 1
baseline$natcat[b05_1.x == 5] <- 1
baseline$natcat[b05_1.x == 7] <- 1
baseline$natcat[b05_1.x == 8] <- 1
baseline$natcat[b05_1.x == 9] <- 1
baseline$natcat[b05_1.x == 13] <- 1
baseline$natcat[b05_1.x == 14] <- 1
baseline$natcat[b05_1.x == 15] <- 1

detach(baseline)

###################################################################
## Impute Values for 8 People with Missing Living Situation Data ##
###################################################################

#make sure missing values that you want to impute are set to NA for this analysis

#make a reduced dataset that only includes variables you'll be using to impute data
#otherwise this could take a long time to run, if you have a lot of variables
#I've included the variables I just recategorized, an ID variable, and age, which is continuous
data <- subset(baseline, select=c(egoid, employcat, natcat,
                                  edcat, age.x, livecat, gender.x))

#impute data using missForest package
library(missForest)

#cutoff statement is a list of cutoffs for each variable
#set to 1 for continuous variables
#specify possible values for categorical variables
baseline.imp <- missForest(xmis = data, 
                           maxiter = 10, ntree = 100,
                           replace = TRUE,
                           cutoff = list(1, c(0,1,2,3), c(0,1), c(0,1,2), 1,
                                         c(0,1,2), c(0,1)),
                           xtrue = NA)

#checking the imputed values
#ximp is the imputed data matrix
table(baseline.imp$ximp$livecat)

#make cut-offs for imputed data, which is numeric, to add to categories
data$livecategory[baseline.imp$ximp$livecat < 0.5] <- 0
data$livecategory[baseline.imp$ximp$livecat > 0.5 & baseline.imp$ximp$livecat <= 1.5] <- 1
data$livecategory[baseline.imp$ximp$livecat > 1.5] <- 2

#check to make sure categorization worked
table(data$livecategory, baseline.imp$ximp$livecat)

#remove old livecat variable from the dataset before analysis
data <- subset(data, select=c(egoid, employcat, natcat, edcat, 
                                        age.x, livecategory, gender.x))