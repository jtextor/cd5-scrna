# Single-cell RNAseq analysis of CD5hi/lo T cells

This code belongs to the following paper:

Dakota Rogers, Aditi Sood, HanChen Wang, Jasper J. P. van Beek, Thomas J. Rademaker, Patricio Artusa, Caitlin Schneider, Connie Shen, Dylan C. Wong, Marie-Eve Lebel, Stephanie A. Condotta, Martin J. Richer, Andrew J. Martins, John S. Tsang, Luis Barreiro, Paul Francois, David Langlais, Heather J. Melichar, Johannes Textor, Judith N. Mandl:
Pre-existing chromatin accessibility and gene expression differences among naïve CD4+ T cells influence effector potential. Biorxiv, 2021; doi: https://doi.org/10.1101/2021.04.21.440846 (to appear in _Cell Reports_)

This repository contains all data and code to reproduce our analysis. If you 
want to conduct your own analysis of our data, the file 
[cd5-scrna.csv.gz](data/cd5-scrna.csv.gz) is a good starting point.

If you want to re-create our figures, use the script 
[main.R](main.R) or the provided
[Makefile](Makefile).

We performed a quality control step to exclude poor wells from our analysis. 
The vignette  [qc.Rmd](vignettes/qc.Rmd) explains how this quality
control was done.

You will need to have the following R and Bioconductor packages installed to run everything. We give the package versions we used for conducting the analyses.

R (4.0.4):
 * plotfunctions (1.4)
 * readxl (1.3.1)
 * writexl (1.3.1)
 * RColorBrewer (1.1.2)
 * ggplot2 (3.3.3)
 * cowplot (1.1.1)

Bioconductor (3.12):
 * SingleCellExperiment (1.12.0)
 * scran (1.18.5)
 * scater (1.18.6)
 
