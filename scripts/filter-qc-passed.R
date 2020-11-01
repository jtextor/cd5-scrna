load("tmp/merged.Rdata")

load("data/qc-passed.Rdata")

load("data/cd5-levels.Rdata")
names(cd5.levels) <- colnames(scrna.data)

confidence.region <- function(sx, col=col, conf.level=0.95){
        require(ellipse)
        n <- dim(sx)[1]
        p <- dim(sx)[2]
        df.1 <- p
        df.2 <- n - p
        S <- stats::cov(sx)
        mX <- colMeans(sx)
        t <- sqrt(((n - 1) * df.1/(n * df.2)) * stats::qf(1 - 
        conf.level, df.1, df.2, lower.tail = F))
        polygon(ellipse(S,centre=mX,t=t), col=col, lwd=2)
}

save(list=ls(), file="tmp/scrna-filtered.Rdata")
