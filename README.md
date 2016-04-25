# RUCINET - an R package to interact with UCINET files

This package is intended to ease the movement of data between R and UCINET.

At this current time, it only reliably reads v6404 files from UCINET to R. It will read numeric graph stacks and put them into a list.

You will neeed to install `devtools` in order to install it directly from Github. To read in the files enter the name of the file without the ##h or the ##d extensions. In the future I'll just strip that part.

```{r}
devtools::install_git('https://github.com/jfaganUK/rucinet')
library(rucinet)
fn <- './ucinetfiles/steve-6404'
m <- readUCINET(fn)

# quick visual
library(network)
g <- network(m)
plot(g)
```

### Coming soon

- Writing UCINET files
- Better and more descriptive error handling
- Directly reading UCINET files into `igraph` and `network` graph objects
- Directly writing `igraph` and `network` objects into UCINET files
- Maybe some direct interaction with the command line of UCINET? Maybe?
