# name: 何艺  ID:SA22008304

rm(list = ls())
library(ade4)
data(doubs)

# Part 1 ####################################################################
# Read in the doubs into your R and delete the site 8 which has no fishes. 
# Write code and answer the questions: Which site has the most species (and how many species)? 
# Which species is the most widespread (i.e., found in the most sites)?

# 删除第8行（这个地点没有鱼）
spe<-doubs$fish[-8,]
spa<-doubs$xy[-8,]
View(doubs$fish)
View(spe)

# 计算鱼的丰富度，即每个样地存在多少种鱼类。
## 使用apply函数按行处理spe数据框，按地点，统计每行大于0的单元格数量（鱼的物种数），得到序列向量sit.pres。
sit.pres <- apply(spe>0,1,sum)
## 使用sort函数对每个地点的鱼类种类总数按值进行升序排列。
sort(sit.pres)

## 结论：排序之后可以看到第29号样地所含鱼的种类最多，有27种。

# 计算物种多度，即每一种鱼类出现在了多少个样地里。
## 使用apply函数按列处理spe数据框，按鱼的物种，统计每列大于0的单元格数量（地点数量），得到序列向量spe.pres。
spe.pres <- apply(spe>0,2,sum)
## 使用sort函数对每个鱼种出现的地点数量进行升序排列。
sort(spe.pres)

## 结论：根据排序，鱼种Lece出现在25个样地中，分布最广泛。

# 图形补充分析 ####################################################################
## 将画布分为左右两部分。
par(mfrow=c(1,2))
## 绘制鱼丰富度和地点的楼梯状图。
plot(sit.pres, type="s",las=1, col="gray",
     xlab="site",ylab="species abundance")
text(sit.pres, row.names(spe), cex=.5, col="red")
## 绘制每个样点的分布图，并用点的大小来表示该样点鱼种类的丰富度。
## asp表示y轴数值长度与x轴数值长度的比例，pch表示点的形状，col表示颜色，bg表示背景颜色。
## cex表示点的大小，此处设置用物种丰富度的大小来表示点的大小。
plot(spa, asp=1, pch=21, col="white", bg="brown",
     cex=5*sit.pres/max(sit.pres),xlab="x(km)",ylab="y(km)")
## 样地点连成一条线。
lines(spa, col="light blue")

# 结论：从左图可以看到，每个样地鱼的种类数量分布；
## 从右图可以看到含鱼种类较丰富的地理区块。

## 计算每个鱼种在总样地中出现的频率，便于统一标准用于后续绘图。
spe.relf<-100*spe.pres/nrow(spe)
## 利用sort函数进行升序排列，用round函数对计算结果进行四舍五入。
round(sort(spe.relf),1)
## 将画布分为左右两部分。
par(mfrow=c(1,2))
## 分别绘制鱼种出现频度和出现频率的直方图，right=FALSE表示分组区间左右都开，
## las=1表示标签与坐标轴的倾斜度。
## breaks为数字向量，指定直方图在哪些点截断，此处为对site统计值进行分组。
hist(spe.pres, right=FALSE,las=1, 
     xlab="number of site",ylab="species",
     breaks=seq(0,30,by=5),col="bisque")
hist(spe.relf, right=FALSE,las=1, 
     xlab="site(%)",ylab="species",
     breaks=seq(0,100,by=10),col="bisque")

## 从左图可以看到，分布在10~15个样地里的鱼种类最多。
## 从右图可以看到，大部分鱼类分布广度在20%~70%之间，其中分布广度在40%~50%的鱼的种类最多。


# Part 2 ####################################################################
# Select a suitable association measure of species, write code for clusters and answer: 
# In terms of the fish community composition, which groups of species can you identify? 
# Which groups of species are related to these groups of sites?
# 
# 根据样地鱼类物种组成，进行Q模式的关联测度，比较样地物种组成之间的相似性和相异性。
library(permute)
library(lattice)
library(vegan)
## 计算Bray-Curtis非相似性矩阵(既考虑物种组成，也考虑物种丰度),
## 无须设置，vegdist函数默认就是求Bray-Curtis非相似性矩阵。
spe.db <- vegdist(spe)
## 下载coldiss函数，调用其可视化相异矩阵。
## coldiss函数需要用到gclus包中的函数order.single，故须导入gclus包及其所依赖的包。
library(cluster)
library(gclus)
library(sp)
library(vegsoup)
source("coldiss.R")
coldiss(spe.db, byrank=FALSE, diag=TRUE)

# 比较不同鱼类分布的相似性，进行R模式的关联测度。
## 物种丰度转置
spe.t <- t(spe)
## 计算Jaccard相异矩阵
spe.ja <- vegdist(spe.t,"jaccard",binary=TRUE)
## 可视化相异矩阵
coldiss(spe.ja, byrank=FALSE, diag=TRUE)

# 结论：根据相异矩阵，可以看到各样地物种组成的相似性，也可以看到鱼类分布的相似性。

# Part 3 ####################################################################
# Do RDA analysis, and then write code and answer: 
# Which environmental variables cause a community to vary across a landscape?
#
## 判断采取线性模型还是单峰模型
decorana(spe)
## 结果显示DCA1在3.0~4.0之间，两种模型都可以。

#  此处按要求采用线性模型RDA，分析环境对物种分布的影响。
## 提取环境变量
env <-doubs$env[-8,]
## 进行冗余分析
rda<-rda(spe,env,scale = T)
## 画图可视化结果
plot(rda)


