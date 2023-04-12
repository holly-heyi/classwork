# name: 何艺  ID:SA22008304

# Read data and data pre-Process
# - reading env and fish data, and summarizing fish abundance data by sites, and combining env and total fish to a new data frame named as "env_fish". 

rm(list = ls())
library(ade4)
library(tidyverse)
library(carData)
library(car)
library(rpart)
library(lattice)
library(caret)

# reading env and fish data
data(doubs) 
env_tib <- as_tibble(doubs$env)
fish_tib <- as_tibble(doubs$fish)
View(env_tib)
View(fish_tib)

# summarizing fish abundance data by sites,combining env and total fish to a new data frame named as "env_fish"
env_fish<-env_tib %>%
  mutate(fish_abundance = rowSums(fish_tib[1:27]))
View(env_fish)

#visualizing the features of the new env_fish set using scatterplot(). 
env_fish %>% gather(-fish_abundance,key="value", value = "env") %>%
  ggplot(aes(x= env, y=fish_abundance)) + 
  geom_point() +
  geom_smooth(se =FALSE) +
  facet_wrap(~value, scale ="free") +
  theme_bw()

# delete sites which have no fishes.
env_fish <- dplyr::select(env_fish, 1:11,39) %>% subset(rowsum !=0)

#  removing all rows which contains an outlier.
for(i in 1:12){
  r<-which(env_fish[ ,i] %in% boxplot.stats(env_fish[ ,i])$out)
  print(r)
}

env_fish<-env_fish[-c(1,2,3,6,14,22:25,28,29), ]

# identifying near zero-variance, outlies of the env variables. and excluding them for analysis.
nearZeroVar(env_fish,name=T,saveMetrics= TRUE)

# detecting the collinearity among env variables or removing highly correlated features(with an absolute correlation of 0.75 or higher) 
env_fishCor <- cor(env_fish[ ,-12])
highlyCor<- findCorrelation(env_fishCor, cutoff = .75)
env_fish1 <- env_fish[,-highlyCor] 
comboInfo <- findLinearCombos(env_fish1)
comboInfo
env_fish1[, -comboInfo$remove]
dim(env_fish1)

# Section II: Building a regression model. This section covers
# splitting data into training and test sets
set.seed(666)
train_index<-createDataPartition(env_fish1$fish_abundance,p=0.8,list = FALSE)
training<-env_fish1[train_index,]
test<-env_fish1[-train_index,]

# visualizing the features and targets of the training set
x<-as.matrix(env_fish1[ ,1:6])
y<-as.factor(env_fish1$fish_abundance)
featurePlot(x,y,plot="density",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales=list(x=list(relation="free"),
                        y=list(relation="free")))

# Creating a baseline model between the environmental variables and the total fish abundance with the tree-based algorithm
set.seed(777)
names(getModelInfo())
model1<-rpart(formula = fish_abundance ~.,
data = training,
control=rpart.control(minsplit=2),
method = "anova")
library(rpart.plot)
rpart.plot(model1)

# evaluating the model
model1.pred <- predict(model1, test)
library(Metrics)
rmse(actual=test$fish_abundance,
     predicted=model1.pred)

# Build the model with random forests
fitControl<-trainControl(
           method = "repeatedcv",
           number = 30,
           repeats = 30)

set.seed(888)
model2<-train(total_fish~.,data=training,
              method="rf",
              trControl=fitControl,
              metric="RMSE",
              verbose=T)
 model2
 
# After comparing the two models,founding that the rf model is more suitable because the RMSE is smaller
         
         
