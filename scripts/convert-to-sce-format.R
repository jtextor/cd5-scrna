# This script transforms the data into an object that's compatible with the 
# SingleCellExperiment Bioconductor package.

library(SingleCellExperiment)

X <- as.matrix( read.csv(gzfile("data/cd5-scrna.csv.gz"),row.names=1) )
X <- X[,X["qc.passed",]==1]
cd5l <- X["cd5.level",]
X <- X[-(1:2),]

rownames(X) <- (gsub("_.*","",rownames(X)))
spikeins <- grep("^ERCC-", rownames(X))

Xspike <- X[spikeins,]
X <- X[-spikeins,]

#rownames(X) <- toupper( rownames(X) )

sce <- SingleCellExperiment(list(counts=X))

spike_se <- SummarizedExperiment(list(counts=Xspike))

altExp( sce, "spike" ) <- spike_se
altExp( sce, "cd5" ) <- SummarizedExperiment( list( counts=matrix(cd5l,nrow=1) ) ) 

library( scran )
library( scater )
clust.tc <- quickCluster(sce) 
sce <- computeSumFactors(sce, cluster=clust.tc, min.mean=0.1)
sce <- logNormCounts( sce )

saveRDS( sce, "tmp/sce.rds" )

