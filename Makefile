.SECONDARY:
.DELETE_ON_ERROR:

FIGURES_IN_PAPER=plots/figure-1.pdf plots/expression.pdf
EXTRA_FIGURES=plots/umaps.pdf vignettes/qc.pdf
PLATE_FILES=RMC-JB-001_AH22TCBGX9_S1_R2.TranscriptCounts.tsv.gz \
	RMC-JB-002_AH22TCBGX9_S1_R2.TranscriptCounts.tsv.gz \
	RMC-JB-003_AH22TCBGX9_S1_R2.TranscriptCounts.tsv.gz

all : $(FIGURES_IN_PAPER) $(EXTRA_FIGURES)

plots/figure-1.pdf : scripts/plot-figure-1.R tmp/sce.rds tmp/packages-checked.txt
	Rscript scripts/plot-figure-1.R

plots/expression.pdf : scripts/plot-expression.R tmp/expression.Rdata tmp/packages-checked.txt
	Rscript scripts/plot-expression.R

plots/umaps.pdf : scripts/plot-umaps.R tmp/umaps.Rdata tmp/packages-checked.txt
	Rscript scripts/plot-umaps.R

tmp/umaps.Rdata : scripts/prepare-umaps.R data/dakota-dge.csv.gz data/cd5-scrna.csv.gz tmp/packages-checked.txt
	Rscript scripts/prepare-umaps.R

tmp/expression.Rdata : scripts/prepare-expression.R data/cd5-scrna.csv.gz tmp/packages-checked.txt
	Rscript scripts/prepare-expression.R

tmp/sce.rds : scripts/convert-to-sce-format.R data/cd5-scrna.csv.gz tmp/packages-checked.txt
	Rscript scripts/convert-to-sce-format.R

vignettes/qc.pdf : vignettes/qc.Rmd data/cd5-scrna.csv.gz tmp/packages-checked.txt
	Rscript -e "rmarkdown::render('vignettes/qc.Rmd')"

tmp/packages-checked.txt : scripts/check-packages.R
	Rscript scripts/check-packages.R

## For information, this is how the joint count files was generated from the 
## individual plates, the quality control selection, and the CD5 levels for each cell.
data/cd5-scrna.csv.gz : scripts/prepare-data.R $(PLATE_FILES) data/qc-passed.Rdata data/cd5-levels.Rdata
	Rscript $<

clean: 
	rm -f tmp/* plots/* vignettes/qc.pdf
