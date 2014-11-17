#-  R source code

#-  volunteer.r ~~
#
#   This program shows how to volunteer for a specific "box" using R and the
#   QMachine web service. It checks for new jobs no more than once per second
#   when idle.
#
#                                                       ~~ (c) SRW, 17 Nov 2014
#                                                   ~~ last updated 17 Nov 2014

library(qm)

while (TRUE) {
  qm::volunteer(box = 'test-from-r')
  Sys.sleep(1)
}

#-  vim:set syntax=r:
