qm
==

This is an R package that will enable the use of the
[QMachine](https://www.qmachine.org) web service for distributing computations.

Obviously, this project is still very incomplete, and it will probably be a
little while before it becomes available on [CRAN](http://cran.r-project.org).
In the meantime, you can install the package and try it out by using the
[devtools](https://github.com/hadley/devtools) package:

```r
library(devtools)
devtools::install_github('qmachine/qm-r')
```


Introduction
------------

Having installed `qm`, you can now start distributing computations and also
volunteering your own computer as part of a crowdsourced supercomputer, using
only R. The convention used in this library is to transform input data `x` to
output data `y` with a function `f`.

To volunteer to run jobs for the "test-from-r" `box` (more on this later), 

```r
library(qm)

while (TRUE) {
    qm::volunteer(box = 'test-from-r')
    Sys.sleep(1)
}
```


Some examples for submitting jobs are shown below, again using the
"test-from-r" `box`. Note that, if your `box` has no volunteers, your jobs will
not be executed.

```r
library(qm)

qm_box <- 'test-from-r'

cat('Submitting jobs to "', qm_box, '" box ...\n', sep = '')

# Example 1: 2 + 2

f <- function(x) x + 2
x <- 2
y <- qm::submit(box = qm_box, f = f, x = x)

print(y)

# Example 2: Summing numbers with built-in functions

print(qm::submit(box = qm_box, f = sum, x = 1:5))
```

The [browser client](https://github.com/qmachine/qm-browser-client) developed
for the  [original paper](http://www.biomedcentral.com/1471-2105/15/176) also
provided higher-order `map`, `reduce`, and `mapreduce` patterns, but those have
not been included here.

