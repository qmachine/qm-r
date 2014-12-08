qm
==


This repository contains the R client for [QMachine](https://www.qmachine.org),
a web service for distributing computations. The client will be published as
its own R package on [CRAN](http://cran.r-project.org) -- hopefully as `qm` --
in the near future, but it is still very rough. In the meantime, you can
install it and try it out thanks to the excellent
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

# Example 1: Computing `2 + 2` remotely

f <- function(x) x + 2
x <- 2
y <- qm::submit(box = qm_box, f = f, x = x)

print(y)

# Example 2: Summing numbers remotely with built-in (native) functions

print(qm::submit(box = qm_box, f = sum, x = 1:5))
```

The [browser client](https://github.com/qmachine/qm-browser-client) developed
for the  [original paper](http://www.biomedcentral.com/1471-2105/15/176) also
provided higher-order `map`, `reduce`, and `mapreduce` patterns, but those have
not been included in this package.

---

[![Build Status](https://travis-ci.org/qmachine/qm-r.png?branch=master)](https://travis-ci.org/qmachine/qm-r)

