# cd5-scrna

Single-cell RNA sequencing analysis of naive T cells correlated to CD5 expression.

This repository contains all data and code to reproduce our analysis. If you 
want to conduct your own analysis of our data, the file 
[cd5-scrna.csv.gz](data/cd5-scrna.csv.gz) is a good starting point.

If you want to re-create our figures, use the script 
[main.R](main.R) or the provided
[Makefile](Makefile).

We performed a quality control step to exclude poor wells from our analysis. 
The vignette  [qc.Rmd](vignettes/qc.Rmd) explains how this quality
control was done.
