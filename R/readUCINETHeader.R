#' Reads the header information from a v6404 UCINET file.
#'
#' @param fileName The filename of the UCINET file. Do not include the .##h or .##d
#' @return A list object with all the details of the UCINET file header.
readUCINETHeader <- function(fileName) {
  con <- file(paste0(fileName, '.##h'), open='rb')

  ucinet.details <- list()

  readBin(con, what=raw(), n=2, size=1) #junk data?
  ucinet.details$file.version <- paste(rawToChar(readBin(con, what=raw(), n=4, size=1), multiple = T), collapse='') # version

  if(ucinet.details$file.version != '6404') {
    stop('The file does not indicate that it is version 6404. Pleae export a version 6404 file from UCINET.')
  }

  # Date modified
  yy <- readBin(con, what=integer(), n=1,size=2) # year (15)
  mm <- readBin(con, what=integer(), n=1,size=2) # month (7)
  dd <- readBin(con, what=integer(), n=1,size=2) # day (26)
  dow <- readBin(con, what=integer(), n=1,size=2) # day of week (1)
  ucinet.details$date.mo <- paste(yy + 2000, '-', mm, '-', dd, sep = '')

  # Label type
  ucinet.details$label.type <- readBin(con, what=integer(), n=1,size=2) # label type = 3

  # Matrix data type
  ucinet.details$data.type <- readBin(con, what=integer(), n=1,size=1) # data type = 7

  # Matrix dimensions
  ucinet.details$ndim <- readBin(con, what=integer(), n=1,size=2) # number of dimensions
  ucinet.details$dim1 <- readBin(con, what=integer(), n=1,size=4) # dimension 1
  ucinet.details$dim2 <- readBin(con, what=integer(), n=1,size=4) # dimension 2
  if(ucinet.details$ndim == 3) {
    ucinet.details$dim3 <- readBin(con, what=integer(), n=1,size=4)
  }

  # Get the file title
  ucinet.details$title.size <- readBin(con, what = integer(), n = 1, size = 1) # size of the title (00)
  if(ucinet.details$title.size > 0) {
    ucinet.details$title <- rawToChar(readBin(con, what = raw(), n = ucinet.details$title.size, size = 1))
  } else {
    ucinet.details$title <- ''
  }

  ### Do the matrices have column, row, and matrix labels?
  hasColumnLabels <- readBin(con, what = logical(), n = 1, size = 1) # do matrix columns have labels (01)
  hasRowLabels <- readBin(con, what = logical(), n = 1, size = 1) # do matrix rows have labels (01)
  hasMatrixLabels <- FALSE
  if(ucinet.details$ndim == 3) {
    hasMatrixLabels <- readBin(con, what = logical(), n = 1, size = 1) # do matrix levels have labels (only if number of dimensions are greater than 2)
  }

  ### Column labels
  col.labels <- as.character(1:ucinet.details$dim1)
  if(hasColumnLabels) {
    for(i in 1:ucinet.details$dim1) {
      l <- readBin(con, what = integer(), n = 1, size = 2) # (length of label 1) * 2
      col.labels[i] <- paste(readBin(con, what = character(), n = l / 2, size = 2 ), collapse='') # (length of label 1) * 2
    }
  }
  ucinet.details$col.labels <- col.labels

  ### Row labels
  row.labels <- as.character(1:ucinet.details$dim2)
  if(hasRowLabels) {
    for(i in 1:ucinet.details$dim2) {
      l <- readBin(con, what = integer(), n = 1, size = 2) # (length of label 1) * 2
      row.labels[i] <- paste(readBin(con, what = character(), n = l / 2, size = 2), collapse='') # (length of label 1) * 2
    }
  }
  ucinet.details$row.labels <- row.labels

  if(hasMatrixLabels){
    matrix.labels <- character(ucinet.details$dim3)
    for(i in 1:ucinet.details$dim3) {
      l <- readBin(con, what = integer(), n = 1, size = 2) # (length of label 1) * 2
      matrix.labels[i] <- paste(readBin(con, what = character(), n = l / 2, size = 2), collapse='') # (length of label 1) * 2
    }
    ucinet.details$matrix.labels <- matrix.labels
  }
  close(con)
  return(ucinet.details)
}
