check_packages = function(names){
  for(name in names)
  {
    if (!(name %in% installed.packages()))
      install.packages(name, repos="http://cran.us.r-project.org")
    
    library(name, character.only=TRUE)
  }
}

check_packages(c("gridExtra","e1071","kernlab","caret","lattice","grDevices","RColorBrewer"))

library(e1071)
library(caret)
library(kernlab)

## Read training and testing data sets
training.data <- read.csv("train.csv",header=T)
testing.data <- read.csv("test.csv",header=T)

## convert predicted column to factor
training.data$label <- as.factor(training.data$label)

## digits plots
library(gridExtra)
library(lattice)
vec=c(2,39,23,66,82,100,161,173,215,87)
list.plot=rep(list(list()),10)
for (i in 1:10){
  digit=matrix(training.data[vec[i],2:785],nrow=28,ncol=28)
  digit=digit[,nrow(digit):1]
  plot=levelplot(digit,col.regions = grey(seq(1, 0, length = 256)),colorkey=FALSE)
  list.plot[[i]]=plot
}
grid.arrange(list.plot[[1]],list.plot[[2]],list.plot[[3]],list.plot[[4]],
             list.plot[[5]],list.plot[[6]],list.plot[[7]],list.plot[[8]],
             list.plot[[9]],list.plot[[10]],nrow=2,ncol=5)

## take 5000 sample data for cross validation
cross.validation.training <- training.data[1:5000,]

## create 5 folds
num.folds <- 5
folds <- createFolds(cross.validation.training$label , k = num.folds, list = TRUE, returnTrain = FALSE)

## run K-folds cross validation on 5000 records
## train model on 4000 recors
## predict on 1000 records

accuracy <- numeric(5)
for ( i in 1:length(folds)){
    
    ## Subset data to train/test sets
    cat("Creating training and testing data sets for fold num: ", i, "\n")
    train <- cross.validation.training[as.numeric(unlist(folds[-i])),]
    test <- cross.validation.training[as.numeric(unlist(folds[i])),]    
    
    ## Build SVM model
    cat("Buliding model for fold num: ", i, "\n")
    fit.svm <- ksvm(label~., data=train, kernel="rbfdot")
    
    ## Prediction for new data
    cat("Making prediction for fold num: ", i, "\n")
    predict.svm <- predict(fit.svm,test)
    
    ## calculate accuracy
    cat("Calculating accuracy for fold num: ", i, "\n")
    tmp <- confusionMatrix(test$label, predict.svm)
    overall <- tmp$overall
    cat(overall, "\n")
    overall.accuracy <- overall['Accuracy']
    cat(overall.accuracy, "\n")
    accuracy[i] <- as.numeric(tmp[[3]][1])
}

## model accuracy
paste("Avg accuracy: ",round(mean(accuracy)*100,1),"%",sep="")


## visualization of results
library(grDevices)
library(RColorBrewer)
table <- as.matrix(tmp$table)
table
byclass <- as.matrix(tmp$byClass)
colors <- colorRampPalette(brewer.pal(9, "Pastel1"))
plot1 <- barplot(byclass[,1], col = colors(9), main = "Correct Classification Rate", 
                 ylab = "Digits",ylim=c(0,1.2))
text(plot1,0,labels = round(byclass[,1],3), cex=0.9,pos=3)
plot2 <- barplot(byclass[,8], col = colors(9), main = "Balanced Accuracy", 
                 ylab = "Digits",ylim=c(0,1.2))
text(plot2,0,labels = round(byclass[,8],3), cex=0.9,pos=3)


## run model on full data set
## fit svm model 
## using Gaussian kernel
fit.svm <- ksvm(label~., data=training.data, kernel="rbfdot")

## predict labels for testing data
predict.svm <- predict(fit.svm,testing.data)

## merge predictions for one data frame
prediction <- data.frame(label=predict.svm,testing.data)

## write results to file
write.csv( prediction,file="prediction.csv",row.names=F)


## visualization of prediction
## 1 error out of 10 predictions

vec=seq(1:20)
list.plot=rep(list(list()),20)
for (i in 1:20){
  digit=matrix(prediction[vec[i],2:785],nrow=28,ncol=28)
  digit=digit[,nrow(digit):1]
  plot=levelplot(digit,col.regions = grey(seq(1, 0, length = 256)),colorkey=FALSE)
  list.plot[[i]]=plot
}
grid.arrange(list.plot[[1]],list.plot[[2]],list.plot[[3]],list.plot[[4]],
             list.plot[[5]],list.plot[[6]],list.plot[[7]],list.plot[[8]],
             list.plot[[9]],list.plot[[10]],nrow=2,ncol=5)
grid.arrange(list.plot[[11]],list.plot[[12]],
             list.plot[[13]],list.plot[[14]],list.plot[[15]],list.plot[[16]],
             list.plot[[17]],list.plot[[18]],list.plot[[19]],list.plot[[20]],nrow=2,ncol=5)
as.character(prediction[1:10,1])
as.character(prediction[11:20,1])

