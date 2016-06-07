### UCINET Read and Write
### A set of functions for reading and writing UCINET 6 6404 binary files.
### Jesse Fagan
### May 16, 2014

library(data.table)
library(dplyr)
library(rucinet)

## Whole file
sz <- file.info('./ucinetfiles/Camp92_6404.##h')$size
con <- file('./ucinetfiles/Camp92_6404.##h', open='rb')
f <- readBin(con, what=raw(), n=sz)
close(con)
data.frame(raws=f,chars=sapply(f, rawToChar))

## Whole file
con <- file('./ucinetfiles/campnet2.##d', open='rb')
(f <- readBin(con, what=integer(), n=10000, size = 4))
close(con)
f[f != 0 ] <- 1
m <- matrix(f, nrow=6)

camp92 <- readUCINET('./ucinetfiles/Camp92_6404')






