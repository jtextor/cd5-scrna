getplate <- function(i=1){
	lf <- list.files("data/","*.tsv.gz")
	as.matrix(read.table(gzfile(paste0("data/",lf[grep(paste0("00",i),lf)])),
		row.names=1, header=T))
}

all.plates <- lapply(1:3,getplate)

all.g <- Reduce(union,lapply(all.plates,rownames))

ext.plates <- list()

for( i in seq_along(all.plates) ){
	print(i)
	missing.g <- setdiff( all.g, rownames(all.plates[i]) )
	filler <- matrix( 0, ncol=ncol(all.plates[[i]]),nrow=length(missing.g),
			 dimnames=list(missing.g) )
	ext.plates[[i]] <- rbind( all.plates[[i]], filler )
	ext.plates[[i]] <- ext.plates[[i]][all.g,]
}

plate <- rep(seq_along(all.plates),each=384)
scrna.data <- Reduce( cbind, ext.plates )
colnames(scrna.data) <- paste0(colnames(scrna.data),".",plate)

qc.df <- do.call( data.frame, as.list(rep(0,ncol(scrna.data))) )
colnames(qc.df) <- colnames(scrna.data)
rownames(qc.df) <- "qc.passed"
qc.df[,qc.passed] <- 1

cd5.df <- do.call( data.frame, as.list( cd5.levels ) )
colnames(cd5.df) <- colnames(scrna.data)
rownames(cd5.df) <- "cd5.level"

scrna.data <- rbind( qc.df, cd5.df, scrna.data )

save(scrna.data, file="tmp/merged.Rdata")

write.csv( scrna.data, "data/cd5-scrna.csv" )
