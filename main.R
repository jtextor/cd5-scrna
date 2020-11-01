# This script performs all the individual steps of the data analysis. For those
# who prefer to use a Makefile, this is also provided. 

# First, we convert the raw data of the individual plates into R format. 

source("scripts/prepare-data.R")

source("scripts/prepare-umaps.R")

source("scripts/plot-umaps.R")




