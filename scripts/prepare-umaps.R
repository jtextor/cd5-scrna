
scrna.data <- read.csv(gzfile("data/cd5-scrna.csv.gz"),row.names=1)

scrna.data <- scrna.data[,scrna.data["qc.passed",]==1]
cd5.level <- unlist(scrna.data["cd5.level",])

X <- scrna.data[-(1:2),]

rownames(X) <- (gsub("_.*","",rownames(X)))
spikeins <- grep("^ERCC-", rownames(X))
X <- X[-spikeins,]
X <- sweep(X,2,colSums(X),"/")
X <- log2(1+10000*X)

d <- as.character(read.csv(gzfile("data/dakota-dge.csv.gz"))[,1])
d <- intersect( d, rownames( X ) )
d <- head(d,200)

set.seed( 123 )
xu <- uwot:::umap(t(X), metric="cosine", n_neighbors=30)

set.seed( 123 )
xu.d <- uwot:::umap(t(X[d,]), metric="cosine", n_neighbors=30)

save( xu, xu.d, cd5.level, file="tmp/umaps.Rdata" )


