# name: 何艺  ID:SA22008304

rm(list = ls())
library(ade4)
data(doubs)

# delete the site 8 which has no fishes
spe<-doubs$fish[-8,]
spa<-doubs$xy[-8,]

# species richness
sit.pres <- apply(spe>0,1,sum)
sort(sit.pres)
par(mfrow=c(1,2))
plot(sit.pres, type="s",las=1, col="gray",
     xlab="site",ylab="species abundance")
text(sit.pres, row.names(spe), cex=.5, col="red")
plot(spa, asp=1, pch=21,col="white", bg="brown",
     cex=5*sit.pres/max(sit.pres),xlab="x(km)",ylab="y(km)")
lines(spa, col="light blue")
# As we can see, the 29th site has 26 kinds of species, ranking the top.

# species aundance
spe.pres <- apply(spe>0,2,sum)
sort(sit.pres)
spe.relf<-100*spe.pres/nrow(spe)
round(sort(spe.relf),1)
par(mfrow=c(1,2))
hist(spe.pres, right=FALSE,las=1, 
     xlab="number of site",ylab="number of species",
     breaks=seq(0,30,by=5),col="bisque")
hist(spe.relf, right=FALSE,las=1, 
     xlab="site(%)",ylab="number of species",
     breaks=seq(0,100,by=10),col="bisque")
# As we can see, the fish was founded in 25 sites, 
# regarded as the most widespread species.

# In terms of the fish community composition, which groups of species can you identify? 
library(permute)
library(lattice)
library(vegan)
spe.t<-t(spe) 
spe.t.chi<-decostand(spe.t,"chi.square") 
spe.t.D<-dist(spe.t.chi)
library(gclus)
source("coldiss.R")
coldiss(spe.t.D,byrank=FALSE,diag=FALSE)
spe.t.S<-vegdist(spe.t, "jaccard", binary=TRUE)
coldiss(spe.t.S, diag=FALSE)

# Which groups of species are related to these groups of sites?
env.pearson<-cor(env)
round(env.pearson,2)
env.o<-order.single(env.pearson)
source("panelutils.R")
op<-par(mfrow=c(1,1),pty="s")
pairs(env[,env.o],lower.panel=panel.smooth,upper.panel=panel.cor,
      diag.panel=panel.hist,main="Pearson相关矩阵")
par(op)

# Which environmental variables cause a community to vary across a landscape?
env<- doubs$env[-8,]
decorana(spe)
pca<-rda(spe)
pca
sum(apply(spe,2,var))
rda<-rda(spe,env)
rda
spe.ca<-cca(spe)
summary(spe.ca)
plot(spe.ca,scaling=1)
plot(spe.ca,scaling=2)
cca(spe,env)

