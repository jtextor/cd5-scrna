
load("tmp/umaps.Rdata" )
source("scripts/tools.R")

library(plotfunctions)

pdf("plots/umaps.pdf", width=4, height=4)
par( mar=c(1.2,1.2,.2,.2), xaxt="n", yaxt="n", mgp=c(.2,0,0) )

plt <- function( xu ){
	cd5.quartiles <- as.integer(cut(cd5.level, 
		quantile(cd5.level, prob=c(0,.25,.75,1)), include.lowest=T))
	plot(xu, col=c("blue","black","black")[cd5.quartiles], bg=c("white","gray","red")[cd5.quartiles],
		pch=21, xlim=c(-2.8,2.8), ylim=c(-2.8,2.8),
		bty='l', xlab="UMAP 1", ylab="UMAP 2")
	confidence.region(xu[cd5.quartiles==1,],col=rgb(0,0,1,alpha=0.5),border=rgb(0,0,1,alpha=1))
	confidence.region(xu[cd5.quartiles==2,],col=rgb(.5,.5,.5,alpha=0.5),border="black")
	confidence.region(xu[cd5.quartiles==3,],col=rgb(1,.5,0,alpha=0.5),border=rgb(1,.5,0,alpha=1))
}

plt( xu )
plt( xu.d )

dev.off()

