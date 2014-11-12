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

test_box <- 'try-from-r'
test_key <- qm::uuid()
test_val <- 1:5

qm::set_avar(box = test_box, key = test_key, val = test_val)

test_val2 <- qm::get_avar(box = test_box, key = test_key)$val

print(identical(test_val, test_val2))
```

