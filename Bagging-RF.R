#Bremen Big Data Challenge
#------------------------------------------------------------------------------------------------------------------------##Bremen Big Data Challenge
#Removing old variables
rm(list = ls())              # Remove everything from your current workspace
ls()                         # Anything there? Nope.
getwd()
#Setting working directory
setwd("~/Desktop/Yasin/Data Engineering/2.nd Semester/Data Mining/BremenBigData18/")
getwd()

install.packages("dplyr")
install.packages("plyr")
install.packages("data.table")

library(dplyr)
library(plyr)
library(data.table)
library(lubridate)
#------------------------------------------------------------------------------------------------------------------------#
#Loading all data sets
train_csv <- read.csv('~/Desktop/Yasin/Data Engineering/2.nd Semester/Data Mining/BremenBigData18/1303/dtrain1303',fileEncoding="latin1")
challenge_csv <- read.csv('~/Desktop/Yasin/Data Engineering/2.nd Semester/Data Mining/BremenBigData18/1303/dtest1303',fileEncoding="latin1")
#------------------------------------------------------------------------------------------------------------------------#
#Data Preparation
train <- train_csv
test <- challenge_csv
#Datum_sequence <- seq(from=1,to=nrow(test),by=1)
#test <- cbind(test,Datum_sequence)
str(train)
View(train)
library(tree)
library(survival)
library(lattice)
library(splines)
library(parallel)
library(gbm)
library(randomForest)
head(train)
#Bagging
set.seed(12-03-2018)
bag.output <- randomForest(Output ~ ., data = train, mtry = 63, ntree = 500)
bag.output

summary(bag.output)
yhat.bag <- predict(bag.output, newdata = train)
sum(abs(yhat.bag - train$Output))/6301987200*100
str(train)
summary(yhat.bag)
summary(train$Output)
importance(bag.output) # relative importance of predictors (highest <-> most important)
varImpPlot(bag.output) # plot results


####Test######
#Bagging Test
pred.bag.test<- predict(bag.output,newdata= test)
summary(pred.bag.test)
pred.bag.test

c1 <- pred.bag.test

write.csv(c1, file = "120318pred.bag.csv")
