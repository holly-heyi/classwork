# name: 何艺  ID:SA22008304

rm(list = ls())

# Part 1 ####################################################################
# Read data and data pre-Process
# reading env and fish data, and summarizing fish abundance data by sites, 
# and combining env and total fish to a new data frame named as "env_fish".
#
## 读取数据并转换数据格式。
library(ade4)
data(doubs)
library(tidyverse)
env <- doubs$env
fish <- doubs$fish

## 按地点计算fish_tib中鱼类总数量，并将fish_abundance列添加到env_tib数据表中。
env_fish <- mutate(env,fish_abundance = rowSums(fish[1:27]))
view(env_fish)

# Part 2 ####################################################################
# visualizing the features of the new env_fish set using scatterplot(). 
# Do you find any linear relationships between environmental variables and the total fish abundance at the sites?
#
## 用散点图可视化环境变量和鱼丰富度之间的关系
env_fish %>% gather(-fish_abundance,key="value", value = "env") %>%
  ggplot(aes(x= env, y=fish_abundance)) + 
  geom_point() +
  geom_smooth(se =FALSE) +
  facet_wrap(~value, scale ="free") +
  theme_bw()
## 或者也可以用以下代码,featurePlot在caret包中：
## featurePlot(x=env_fish[,-12],
##             y=env_fish[,12],
##             plot="scatter",
##             type=c("p","smooth"),
##             layout=c(3,4))

# Part 3 ####################################################################
# having the sites with no fishes? If yes, deleting such sites. 
# Having null values or outliers? If yes, removing all rows where any column contains an outlier. 
# 
## 删除没有鱼的地点
env_fish_1 <- subset(env_fish, fish_abundance!=0)
## 查看是否存在缺失值
table(is.na(env_fish_1))
## 检测每列的离群值
## 提取列名向量
y <- colnames(env_fish_1)
N <- c()
## 每列依此绘制箱型图，并在图上展示出离群值的位置。
for (i in 1:12) 
{
## 查找该列离群值的位置
  M <- which(env_fish_1[,i] %in% boxplot.stats(env_fish_1[,i])$out)
## 统计合并所有的离群值位置
  N <- union(N,M)
## 转换M数据类型，便于后续在绘图中输出
  M <- as_tibble(M)
## 绘制箱型图，设置大标题为列名，设置小标题为离群值。
  boxplot(env_fish_1[,i],main=y[i],sub=paste("outlier rows:",M))
}
## 输出所有异常值的位置
print(N)
## 得到结果为：1 28 29 14  2  3  6 22 23 24 25，故删除这几行。
env_fish_2 <- env_fish_1[-c(1:3,6,14,22:25,28,29),]
View(env_fish_2)

# Part 4 ####################################################################
# identifying near zero-variance, outlies of the env variables. 
# and excluding them for analysis.
#
library(lattice)
library(caret)
## 环境变量离群值上一步依据处理过。
## 识别并剔除近零方差变量
rm_col <- nearZeroVar(env_fish_2, freqCut = 95/5, uniqueCut = 10,name=F, saveMetrics= F)
rm_col
## 发现不存在近零方差变量
## 如果存在，可以剔除：env_fish_3 <- env_fish_2[,-rm_col]

# Part 5 ####################################################################
# detecting the collinearity among env variables 
# or removing highly correlated features(with an absolute correlation of 0.75 or higher) 
#
## 生成pearson相关系数矩阵
env_fishCor <- cor(env_fish_2[ ,-12])
## 找出相关系数高于0.75的
highlyCor<- findCorrelation(env_fishCor, cutoff = .75)
highlyCor
## 删除相关系数过高的列
env_fish_3 <- env_fish_2[,-highlyCor] 
env_fish_3 
## 找出共线性的变量
comboInfo <- findLinearCombos(env_fish_3)
comboInfo
## 没有共线性变量，所以无须删除。

# Part 6 ####################################################################
# Section II: Building a regression model. This section covers
# splitting data into training and test sets
#
## 设置随机数种子
set.seed(666)
## 数据过滤后，还剩18行7列，将数据集拆分
train_index <- createDataPartition(env_fish_3$fish_abundance,p=0.75,list = FALSE)
## 75%的数据作为训练集
train_data <- env_fish_3[train_index,]
## 25%的数据作为测试集
test_data <-env_fish_3[-train_index,]

# visualizing the features and targets of the training set
## 绘制密度图，选出对目标变量影响较大的特征。
x<-as.matrix(env_fish_3[ ,1:6])
y<-as.factor(env_fish_3$fish_abundance)
featurePlot(x,y,plot="density",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales=list(x=list(relation="free"),
                        y=list(relation="free")))

# Part 7 ####################################################################
# Creating a baseline model between the environmental variables 
# and the total fish abundance with the tree-based algorithm.
## 对训练集进行重采样，因为样本量较少，采用留一交叉验证。
fitControl <- trainControl(method = "LOOCV",number =1,17)
## 采用提升回归树模型拟合
set.seed(777)
model1 <- train( as.factor(fish_abundance)~ ., 
                data = train_data , 
                method = "rf", 
                preProcess=c("center","scale"),
                trControl = fitControl,
                tuneLength=3,
                metric="ROC"
                verbose = FALSE)
print(model1)

## 评估模型
model1.pred <- predict(model1, test_data)
library(Metrics)
rmse(actual=test$fish_abundance,
     predicted=model1.pred)


         
