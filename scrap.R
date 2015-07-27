### UCINET Read and Write
### A set of functions for reading and writing UCINET 6 6404 binary files.
### Jesse Fagan
### May 16, 2014

library(data.table)

## Whole file
sz <- file.info('./ucinetfiles/test.##h')$size
con <- file('./ucinetfiles/test.##h', open='rb')
f <- readBin(con, what=raw(), n=sz)
close(con)
data.frame(raws=f,chars=sapply(f, rawToChar))

## Whole file
con <- file('./ucinetfiles/test.##d', open='rb')
(f <- readBin(con, what=integer(), n=10000, size = 4))
close(con)
f[f != 0 ] <- 1
m <- matrix(f, nrow=6)







## A step by step processes
closeAllConnections()
con <- file('./ucinetfiles/campnet-6404.##h', open='rb')

# store the details
ucinet.details <- list()

readBin(con, what=raw(), n=2, size=1) #junk
ucinet.details$file.version <- paste(rawToChar(readBin(con, what=raw(), n=4, size=1), multiple = T), collapse='') # version

# Date: 2015 (15), month (7), day (26), Sunday (1)
yy <- readBin(con, what=integer(), n=1,size=2) # year (15)
mm <- readBin(con, what=integer(), n=1,size=2) # month (7)
dd <- readBin(con, what=integer(), n=1,size=2) # day (26)
dow <- readBin(con, what=integer(), n=1,size=2) # day of week (1)
ucinet.details$date.modified <- paste(yy + 2000, '-', mm, '-', dd, sep = '')

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

# If the dimensions is 2 then we deal with the title, otherwise, we deal with the dimensions
readBin(con, what = raw(), n = 1, size = 1) # size of the title (00)
ucinet.details$title <- ''

hasColumnLabels <- readBin(con, what = raw(), n = 1, size = 1) # do matrix columns have labels (01)
hasRowLabels <- readBin(con, what = raw(), n = 1, size = 1) # do matrix rows have labels (01)
if(ucinet.details$ndim == 3) {
  hasMatrixLabels <- readBin(con, what = raw(), n = 1, size = 1) # do matrix levels have labels (only if number of dimensions are greater than 2)
}

col.labels <- character(ucinet.details$dim1)
for(i in 1:ucinet.details$dim1) {
  l <- readBin(con, what = integer(), n = 1, size = 2) # (length of label 1) * 2
  col.labels[i] <- paste(readBin(con, what = character(), n = l / 2, size = 2 ), collapse='') # (length of label 1) * 2
}
ucinet.details$col.labels <- col.labels

row.labels <- character(ucinet.details$dim2)
for(i in 1:ucinet.details$dim2) {
  l <- readBin(con, what = integer(), n = 1, size = 2) # (length of label 1) * 2
  row.labels[i] <- readBin(con, what = character(), n = l / 2, size = 2) # (length of label 1) * 2
}
ucinet.details$row.labels <- row.labels







close(con)
closeAllConnections()


