# RUCINET - a package to interaction with UCINET files in R.

This package is intended to help with getting data from UCINET into R and back again.

At this current time I have it reading single v6404 binary matrices. More to come in the future. See ths example. You will neeed to install `devtools` in order to install it directly from Github.

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
