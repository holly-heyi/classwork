# name: 何艺  ID:SA22008304

# 1.Loading libraries of tidyverse and ade4, as well as the doubs data into R, and checking what the data looks like and the class of the data. 

# 导入所需要的包和数据
library(ade4)
library(tidyverse)
# 查看doubs数据集
data(doubs)
doubs
# 运行后，看到数据集依次有4个数据表，第一个是环境数据表，记录了30个样点的11个环境变量；第二个是物种数据表，记录了30个样点其27种鱼的丰度；第三个是地理坐标数据表，记录了30个样点的地理坐标；第四个表是物种名称和编码表，记录了27个鱼种的名称等信息。
# 如果数据太多，也可在获取数据集大概信息后，通过一些命令查看数据表的基本信息
env <- doubs$env  # 提取数据集中的环境数据表
nrow(env)  # 提取数据框总行数
ncol(env)  # 提取数据框总列数
dim(env)  # 提取数据框的维度
colnames(env)  # 提取列名
rownames(env)  # 提取行名

# 2. Turning the row names into a column called site, then convert the data frame to a tibble, named it env_tb.

env <- doubs$env  # 提取数据集中的环境数据表
site <- rownames(env)  # 提取数据库行名这一列，名为site
rownames(env) <- NULL
Env <- cbind(site, env)  # 将行名列变为数据框的第一列，新的数据框名为Env
head(Env)  # 查看变更是否成功
env_tb <- as_tibble(Env)
env_tb  # 查看格式更改后的数据

# 3. Concatenating several steps with %>% pipe, and name the final variable as env_final.
# 3.1 One of the columns is dfs. It indicates the distance from sources. Extract and remain the data of the dfs with more than 1000 km.
# 3.2 Only interested in these columns: site, dfs, slo, flo, pH, nit, oxy. Select these columns for further analysis.
# 3.3 Some column names are not intuitive. Rename them as follows: dfs to distsour, slo to slope, flo to flowrate, nit to nitrogen, oxy to oxygen.
# 3.4 Order the data. Arrange the data first by slope in ascending order, and then by pH in descending order.

# 使用第二步得到的tibble格式数据，进行第三部操作。利用filter函数进行行筛选，利用select命令选取指定的列，利用rename命令对部分列进行重命名，利用arrange命令进行排序
# 根据slope进行升序排列
env_tb %>% filter(dfs>1000)%>% select(site, dfs, slo, flo, pH, nit, oxy) %>% rename(distsour=dfs, slope=slo, flowrate=flo, nitrogen=nit, oxygen=oxy) %>% arrange(slope) 
# 根据pH进行降序排列, 并将最后变量命名为env_final
env_final <- env_tb %>% filter(dfs>1000)%>% select(site, dfs, slo, flo, pH, nit, oxy) %>% rename(distsour=dfs, slope=slo, flowrate=flo, nitrogen=nit, oxygen=oxy) %>% arrange(desc(pH))
head(env_final)  # 查看操作后的数据表格