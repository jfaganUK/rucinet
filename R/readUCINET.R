#' This will read a UCINET file. Make sure you set UCINET to save files as 6404 file format only, and save a new data file before using this function.
#'
#' @param fileName The filename of the UCINET file. Do not include the .##h or .##d
#' @return A matrix object of the UCINET data.
readUCINET <- function(fileName) {
  ucinet.details <- readUCINETHeader(fileName)

  ## Matrix
  con <- file(paste0(fileName, '.##d'), open='rb')
  sz <- file.info(paste0(fileName, '.##d'))$size
  (f <- readBin(con, what=numeric(), n=sz, size = 4))
  close(con)
  ## If there are more than one matrix in the file, pull them and put them into a list
  if(!is.null(ucinet.details$dim3)) {
    o <- list()
    for(d3 in 1:ucinet.details$dim3) {
      i0 <- (d3 - 1) * (ucinet.details$dim1 * ucinet.details$dim2) + 1
      i1 <- (d3) * (ucinet.details$dim1 * ucinet.details$dim2)
      m <- matrix(f[i0:i1], ncol=ucinet.details$dim1, nrow=ucinet.details$dim2)
      colnames(m) <- ucinet.details$col.labels
      rownames(m) <- ucinet.details$row.labels
      o[[ucinet.details$matrix.labels[d3]]] <- m
    }
    attr(o, 'ucinet.details') <- ucinet.details
    return(o)
  } else {
    m <- matrix(f, ncol=ucinet.details$dim1, nrow=ucinet.details$dim2)
    colnames(m) <- ucinet.details$col.labels
    rownames(m) <- ucinet.details$row.labels
    attr(m, 'ucinet.details') <- ucinet.details
   return (m)
  }
}
