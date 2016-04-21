# RUCINET - an R package to interact with UCINET files

This package is intended to ease the movement of data between R and UCINET.

At this current time, it only reliably reads a single v6404 binary matrix from UCINET to R. 

See ths example. You will neeed to install `devtools` in order to install it directly from Github.

```{r}
devtools::install_git('https://github.com/jfaganUK/rucinet')
library(rucinet)
fn <- './ucinetfiles/steve-6404'
m <- readBinary6404(fn)

# quick visual
library(network)
g <- network(m)
plot(g)
```
