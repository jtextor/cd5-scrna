.SECONDARY:
.DELETE_ON_ERROR:

all : plots/umaps.pdf plots/expression.pdf vignettes/qc.pdf

plots/%.pdf : scripts/plot-%.R tmp/%.Rdata
	Rscript $<

tmp/%.Rdata : scripts/prepare-%.R data/cd5-scrna.csv.gz
	Rscript $<

data/cd5-scrna.csv.gz : scripts/prepare-data.R
	Rscript $<

vignettes/%.pdf : vignettes/%.Rmd data/cd5-scrna.csv.gz
	Rscript -e "rmarkdown::render('$<')"

clean: 
	rm -f tmp/* plots/*
