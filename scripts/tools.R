

gradientLegend <- function (valRange, color = "topo", nCol = 30, pos = 0.5, side = 4, 
    length = 0.25, depth = 0.05, inside = TRUE, coords = FALSE, 
    pos.num = NULL, n.seg = 3, border.col = "black", dec = NULL, 
    fit.margin = TRUE) 
{
    loc <- c(0, 0, 0, 0)
    if (is.null(pos.num)) {
        if (side %in% c(1, 3)) {
            pos.num = 3
        }
        else {
            pos.num = side
        }
    }
    if (length(pos) == 1) {
        pos.other <- ifelse(side > 2, 1, 0)
        if (side %in% c(1, 3)) {
            switch <- ifelse(inside, 0, 1)
            switch <- ifelse(side > 2, 1 - switch, switch)
            loc <- getCoords(c(pos - 0.5 * length, pos.other - 
                switch * depth, pos + 0.5 * length, pos.other + 
                (1 - switch) * depth), side = c(side, 2, side, 
                2))
        }
        else if (side %in% c(2, 4)) {
            switch <- ifelse(inside, 0, 1)
            switch <- ifelse(side > 2, 1 - switch, switch)
            loc <- getCoords(c(pos.other - switch * depth, pos - 
                0.5 * length, pos.other + (1 - switch) * depth, 
                pos + 0.5 * length), side = c(1, side, 1, side))
        }
    }
    else if (length(pos) == 4) {
        if (coords) {
            loc <- pos
        }
        else {
            loc <- getCoords(pos, side = c(1, 2, 1, 2))
        }
    }
    mycolors <- c()
    if (length(color) > 1) {
        mycolors <- color
    }
    else if (!is.null(nCol)) {
        if (color == "topo") {
            mycolors <- topo.colors(nCol)
        }
        else if (color == "heat") {
            mycolors <- heat.colors(nCol)
        }
        else if (color == "terrain") {
            mycolors <- terrain.colors(nCol)
        }
        else if (color == "rainbow") {
            mycolors <- rainbow(nCol)
        }
        else {
            warning("Color %s not recognized. A palette of topo.colors is used instead.")
            mycolors <- topo.colors(nCol)
        }
    }
    else {
        stop("No color palette provided.")
    }
    vals <- seq(min(valRange), max(valRange), length = length(mycolors))
    if (!is.null(dec)) {
        vals <- round(vals, dec[1])
    }
    im <- as.raster(mycolors[matrix(1:length(mycolors), ncol = 1)])
    ticks <- c()
    if (side%%2 == 1) {
        rasterImage(t(im), loc[1], loc[2], loc[3], loc[4], col = mycolors, 
            xpd = T)
        rect(loc[1], loc[2], loc[3], loc[4], border = border.col, 
            xpd = T)
        ticks <- seq(loc[1], loc[3], length = n.seg)
        segments(x0 = ticks, x1 = ticks, y0 = rep(loc[2], n.seg), 
            y1 = rep(loc[4], n.seg), col = border.col, xpd = TRUE)
    }
    else {
        rasterImage(rev(im), loc[1], loc[2], loc[3], loc[4], 
            col = mycolors, xpd = T)
        rect(loc[1], loc[2], loc[3], loc[4], border = border.col, 
            xpd = T)
        ticks <- seq(loc[2], loc[4], length = n.seg)
        segments(x0 = rep(loc[1], n.seg), x1 = rep(loc[3], n.seg), 
            y0 = ticks, y1 = ticks, col = border.col, xpd = TRUE)
    }
    determineDec <- function(x) {
        out = max(unlist(lapply(strsplit(x, split = "\\."), function(y) {
            return(ifelse(length(y) > 1, nchar(gsub("^([^0]*)([0]+)$", 
                "\\1", as.character(y[2]))), 0))
        })))
        return(out)
    }
    labels = sprintf("%f", seq(min(valRange), max(valRange), 
        length = n.seg))
    if (is.null(dec)) {
        dec <- min(c(6, determineDec(labels)))
    }
    eval(parse(text = sprintf("labels = sprintf('%s', round(seq(min(valRange), max(valRange), length = n.seg), dec) )", 
        paste("%.", dec, "f", sep = ""))))
}


confidence.region <- function (sx, col = col, border, conf.level = 0.95) 
{
    require(ellipse)
    n <- dim(sx)[1]
    p <- dim(sx)[2]
    df.1 <- p
    df.2 <- n - p
    S <- stats::cov(sx)
    mX <- colMeans(sx)
    t <- sqrt(((n - 1) * df.1/(n * df.2)) * stats::qf(1 - conf.level, 
        df.1, df.2, lower.tail = F))
    polygon(ellipse(S, centre = mX, t = t), border=border, col = col, lwd = 2)
}
