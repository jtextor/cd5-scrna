load("tmp/expression.Rdata")

source("scripts/tools.R")
library( plotfunctions )

pdf("plots/expr.pdf", width=14, height=2)

par( mar=c(0,0,.2,.2), xaxt="n", yaxt="n", mgp=c(.8,0,0) )

bb <- function(g) c(by( as.numeric(x[g,]), cc, FUN=mean ))

pe <- function(g) c(by( as.numeric(x[g,]), cc, FUN=function(x) mean(x>0) ))


pgg <- function(gg){
p <- barplot(c(sapply( gg, bb )), col=1:0, ylab="mean reads per cell")
p1 <- p[seq(2,length(p),by=2)]
p2 <- p[seq(1,length(p),by=2)]
pp <- apply( rbind(p1,p2), 2, mean )
axis( 1, at=pp, labels=gg, tick=FALSE,las=2 )
}

library(readxl)
dd <- read_excel("data/genes-for-circle-plot.xlsx")
genes.of.interest <- intersect(dd$Genes, rownames(x))

mean.expr <- sapply(genes.of.interest, bb)
perc.expr <- sapply(genes.of.interest, pe)

wh <- perc.expr[1,]>0.06

mean.expr <- mean.expr[,wh]
genes.of.interest <- genes.of.interest[wh]
perc.expr <- perc.expr[,wh]

n <- length(genes.of.interest)

mel <- log(.3+mean.expr)
me <- 99*(mel-min(mel))/(max(mel)-min(mel))+1

library( RColorBrewer )

cl <- colorRampPalette(rev(brewer.pal(11, "Spectral")) )(100)

br <- 40

border.color <- 'black'

plot(  1:n, rep(.4,n), cex=sqrt(br*perc.expr[1,]),
	type="p", bty="n", xlab="", pch=21,
	xlim=c(0,n+4), ylim=c(-1.5,.8),
	ylab="", bg=cl[round(me[1,])], col=border.color )

points( 1:n, rep(-.4,n), col=border.color, bg=cl[round(me[2,])],
	pch=21, cex=sqrt(30*perc.expr[2,]) )

text( 1:n, -.8, genes.of.interest, srt=45, pos=1 )

text( 0, c(.4,-.4), c("CD5lo","CD5hi") )

xx <- n+1.6

gradientLegend(c(0,1), cl, n.seg=1, border.col=NA, pos=c(xx-.25,-.4,xx+.25,.4), coords=TRUE)

text(xx,-.4,"0",pos=1)
text(xx,.4,as.character(round(max(mean.expr),1)),pos=3)
text(xx-.7,0,"expression", srt=90)


xx <- n+3.5
points( rep(xx,3), c(-.5,-.05,.5), pch=21, cex=sqrt(br*c(.1,.5,.9)))

text(xx+.3,-.5,"10%",pos=4)
text(xx+.3,-.05,"50%",pos=4)
text(xx+.3,.5,"90%",pos=4)
text(xx-.7,0,"percentage", srt=90)

dev.off()

dd <- rbind(mean.expr, perc.expr)
dd <- t(dd)

colnames(dd) <- c("expr.cd5lo","expr.cd5hi","perc.cd5lo","perc.cd5hi")
dd <- as.data.frame(dd)
dd <- cbind(gene=rownames(dd),dd)


library(writexl)

write_xlsx(dd, "data/gene-expressions.xlsx")

