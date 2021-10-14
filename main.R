# This script performs all the individual steps of the data analysis. For those
# who prefer to use a Makefile, this is also provided. 

# This script converts the raw data of the individual plates into a CSV file that
# also contains the information about each cell's CD5 level as measured by FACS and
# whether the cell passed our quality control.

# The CSV file is also provided in the repository; this script is provided for 
# reproducibility purposes only and does not need to run to generate the figures.

# source("scripts/prepare-data.R")

# We provide a script to automatically install needed packages. Uncomment and run
# this if you want to use it.
source("scripts/check-packages.R")




# This script prepares data for the analyses conducted in Figure 1 of the paper.
source("scripts/convert-to-sce-format.R")
source("scripts/plot-figure-1.R")




# This script prepares data for a plot of expression levels and percentages.
source("scripts/prepare-expression.R")
# And this script performs the actual plot.
source("scripts/plot-expression.R")




# This script computes the UMAP embeddings of the single-cell data.
source("scripts/prepare-umaps.R")
# This script plots the UMAPS.
source("scripts/plot-umaps.R")




# Finally, this code executes the vignette that describes our data preprocessing
# strategy.
rmarkdown::render("vignettes/qc.Rmd")
