
library( scran )
library( scater )
library( ggplot2 )
library( cowplot )


## Global variables

umap.quantiles <- c(0,.15,.85,1)

sce <- readRDS( "tmp/sce.rds" )

no_bg <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
			panel.background = element_blank(), axis.line = element_line(colour = "black"))

is.mito <- grepl("^mt", rownames(sce))
gene.var <- modelGeneVar( sce, lowess=TRUE, subset.row=!is.mito )

cd5 <- c( assay( altExp( sce, "cd5" ) ) )
cd5.dis <- factor( cut( cd5, breaks=quantile( cd5, umap.quantiles ), include.lowest=TRUE ) )
levels( cd5.dis ) <- c("lo 15%","mid 70%","hi 15%")
cd5.dis.0 <- cd5.dis[cd5.dis %in% c("lo 15%","hi 15%")]

## Panel A: Simple u-map

hvgs <- getTopHVGs( gene.var, n=2000 )
set.seed( 123 )
sce <- runUMAP( sce, subset_row = hvgs )
umap <- reducedDim( sce, "UMAP" )
colnames(umap) <- c("UMAP1", "UMAP2")
panel.a <- ggplot( as.data.frame( umap ), aes( x=UMAP1, y=UMAP2, col=cd5 ) ) + 
		geom_point( alpha = 0.7 ) + scale_color_gradientn( colors=c("gray","red"), labels=NULL, name="CD5" ) + no_bg


# Panel B: Mean-variance trend, highlighting top 5% HVGs and some genes of interest 

top.hvg.names <- getTopHVGs( gene.var, n=round(nrow(gene.var)*0.05))

hvg.names <- union( c("Cd5","Cd69","Cd4","S1pr1"), getTopHVGs( gene.var, n=25 ) )
hvg.names  <- hvg.names[!grepl( "^Gm", hvg.names )]
hvg.names  <- hvg.names[!grepl( "Rik$", hvg.names )]

gene.var$name <- rownames( gene.var )
gene.var$top5p <- gene.var$name %in% top.hvg.names

gene.var$name[!(gene.var$name %in% hvg.names)] <- ""

gene.var <- gene.var[order(gene.var$name %in% top.hvg.names + gene.var$name %in% hvg.names),]

panel.b <- ggplot( as.data.frame(gene.var), aes( x=mean, y=total ) ) +
	geom_point( size = 1.5, stroke = gene.var$top5p, 
		shape = 21, 
		colour=c("white","black")[1+gene.var$top5p], 
		aes(fill=factor(top5p)) ) + 
	scale_fill_manual("top 5% HVG", values=c("gray","red")) +
	stat_function( fun=metadata(gene.var)$trend, colour="black" ) + 
  	ggrepel::geom_text_repel(
		data=as.data.frame(gene.var),
		aes(x=mean,y=total,label=name),
		box.padding=0.5,
		max.overlaps=500 ) + 
	theme(legend.position="top") + no_bg

## Panel C: compare FACS and scRNA levels of CD5 on cells
xx <- data.frame( FACS=cd5, RNA=logcounts(sce)["Cd5",] )
xx0 <- xx[,2] == 0
xx[xx0,2] <- xx[xx0,2] + rnorm( sum(xx0), 0, .025 )

panel.c <- ggplot( xx, aes( x=FACS, y=RNA ) ) + geom_point( alpha=.7 ) + geom_smooth( ) + no_bg

## Panel D: PCA on a subset of the genes

pca.plot <- function( sce ){
	pca <- reducedDim( sce, "PCA" )[,1:2]
	colnames(pca) <- c("PC1", "PC2")

	print( cor.test( pca[,1], cd5 ) )

	pca.0 <- pca[cd5.dis %in% c("lo 15%","hi 15%"),]

	ggplot( as.data.frame( pca ), aes( x=PC1, y=PC2, colour=cd5.dis ) ) + 
		geom_point( alpha=0.7 ) +
		scale_color_manual("CD5 MFI", values=c("blue","gray","red")) +
		theme(legend.position="top" ) + 
		ggpubr::stat_conf_ellipse( data=as.data.frame(pca.0), level=0.95, colour="black", 
			show.legend=FALSE,
			aes( x=PC1, y=PC2, fill=cd5.dis.0 ), geom="polygon", alpha=.7 ) +
			scale_fill_manual(values=c("blue","red")) +
			no_bg
}


drr <-  as.character(read.table("data/go-genes-t-cell-differentiation.txt")[,1])
drr <-  union( drr, as.character(read.table("data/go-genes-positive-regulation-activation.txt")[,1]) )
sce <- runPCA( sce, exprs_values="logcounts", ncomponents=2, subset_row = intersect( top.hvg.names, drr ), scale=TRUE ) 
panel.d <- pca.plot( sce )


## Combine panels to figure and save

pl <- plot_grid( panel.a, panel.b, panel.c, panel.d, labels=c("A","B","C","D"), ncol=2 )
save_plot( "plots/figure-1.pdf", pl, base_width=10, base_height=10 )

