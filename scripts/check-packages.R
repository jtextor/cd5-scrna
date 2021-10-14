latex.packages <- c("tinytex")
bioconductor.packages <- c("SingleCellExperiment", "scran", "scater")
r.packages <- c("plotfunctions", "readxl", "writexl", "uwot", "ellipse",
                "RColorBrewer", "ggplot2", "cowplot" )

cat("Checking availability of required R and Bioconductor packages:\n")

unavailable.packages <- c()

for( p in c(r.packages, bioconductor.packages) ){
  cat( p, "... " )
  if( requireNamespace( p, quietly=TRUE ) ){
    cat( "OK" )
  } else {
    cat( "FAIL" )
    unavailable.packages <- c( unavailable.packages, p )
  }
  cat("\n")
}

myAskYesNo <- function( prompt ){
  cat(prompt)
  answer <- tolower(readLines(file("stdin"),1))
  answer == "y"
}

if( length(unavailable.packages) > 0 ){
  cat("I could not find: ", paste(unavailable.packages,sep=", "), "\n" )
  r <- myAskYesNo("Do you want to me to install these packages for you? [y/n] ")
  if( !r ){
    cat("OK, please install these packages yourself and run the script again!\n")
    quit( status=1, save="no" ) 
  } else {
    options( repos="https://cloud.r-project.org" )
    for( p in unavailable.packages ){
      if( p %in% bioconductor.packages ){
        if( !requireNamespace("BiocManager", quietly = TRUE) ){
          install.packages("BiocManager")
        }
        BiocManager::install( p )
      } else if(p %in% latex.packages){
        tinytex::install_tinytex()
      } else {
        install.packages( p )
      }
      if( !requireNamespace( p, quietly = TRUE ) ){
        quit( status=1, save="no" ) 
      }
    }
  }
}

# If we made it this far, all packages should be installed

sink("tmp/packages-checked.txt")
cat()
sink()


