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

test_box <- qm::uuid()
test_key <- qm::uuid()
job1 <- list(x = 2, f = function(x) x + 2)

qm::set_avar(box = test_box, key = test_key, status = 'waiting', val = job1)

job_list <- qm::get_jobs(box = test_box, status = 'waiting')

job2 <- qm::get_avar(box = test_box, key = job_list[1])$val

# Has the computation been transferred faithfully?

y1 <- job1$f(job1$x)
y2 <- job2$f(job2$x)

print(identical(y1, y2))
```

The higher-level functions like `submit` that were used in the
[original paper](http://www.biomedcentral.com/1471-2105/15/176)
have not yet been implemented, but they are relatively easy to build from the
three base functions shown above :-)

