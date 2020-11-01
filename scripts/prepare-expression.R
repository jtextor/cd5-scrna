
scrna.data <- read.csv(gzfile("data/cd5-scrna.csv.gz"),row.names=1)
scrna.data <- scrna.data[,scrna.data["qc.passed",]==1]
cd5.level <- unlist(scrna.data["cd5.level",])

X <- scrna.data[-c(1,2),]

rownames(X) <- (gsub("_.*","",rownames(X)))
spikeins <- grep("^ERCC-", rownames(X))
X <- X[-spikeins,]
X <- sweep(X,2,colSums(X),"/")
X <- log2(1+10000*X)

cd5.quartiles <- as.integer(cut(cd5.level,
quantile(cd5.level, prob=c(0,.25,.75,1)), include.lowest=T))
ch <- cd5.quartiles %in% c(min(cd5.quartiles),max(cd5.quartiles))
cc <- droplevels(factor(cd5.quartiles[ch]))


x <- X[,ch]

save( x, cc, file="tmp/expression.Rdata" )
