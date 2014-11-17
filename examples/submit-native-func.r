#-  R source code

#-  submit-native-func.r ~~
#
#   This program shows how to submit a job that uses a native R function to
#   the QMachine web service.
#
#                                                       ~~ (c) SRW, 17 Nov 2014
#                                                   ~~ last updated 17 Nov 2014

library(qm)

qm_box <- 'test-from-r'

f <- sum
x <- 1:5
y <- qm::submit(box = qm_box, f = f, x = x)

print(y)

#-  vim:set syntax=r:
