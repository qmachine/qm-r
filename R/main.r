#-  R source code

#-  main.r ~~
#
#   This file is mostly a placeholder at the moment ...
#
#                                                       ~~ (c) SRW, 11 Nov 2014
#                                                   ~~ last updated 11 Nov 2014

library(jsonlite)
library(RCurl)

main <- function() {
  # This function is just a placeholder right now, rather than the "main" entry
  # point for execution that the name would suggest ...
    cat('Hooray, it worked!\n')
}

uuid <- function() {
  # This function needs documentation.
    x <- sample(c(0:9, letters[1:6]), size = 32, replace = TRUE)
    return(paste(x, collapse = ''))
}

#-  vim:set syntax=r:
