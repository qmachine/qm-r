#-  R source code

#-  submit-user-func.r ~~
#
#   This program shows how to submit a job with a user-defined R function to
#   the QMachine web service.
#
#                                                       ~~ (c) SRW, 17 Nov 2014
#                                                   ~~ last updated 17 Nov 2014

library(qm)

qm_box <- 'test-from-r'

f <- function(x) x + 2
x <- 2
y <- qm::submit(box = qm_box, f = f, x = x)

print(y)

#-  vim:set syntax=r:
