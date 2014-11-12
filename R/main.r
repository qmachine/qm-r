#-  R source code

#-  main.r ~~
#
#   This file is mostly a placeholder at the moment ...
#
#                                                       ~~ (c) SRW, 11 Nov 2014
#                                                   ~~ last updated 11 Nov 2014

library(httr)

get_avar <- function(box = uuid(), key) {
  # This function needs documentation.
    if (missing(key)) {
        stop('`get_avar` requires a known `key`.')
    }
    path = stringr::str_c('box/', box, '?key=', key, collapse = '')
    req <- GET(mothership, path = path)
    cat(content(req, as = 'text'), '\n', sep = '')
    return(req)
}

get_jobs <- function(box = uuid(), status = 'waiting') {
  # This function needs documentation.
    path <- stringr::str_c('box/', box, '?status=', status, collapse = '')
    req <- GET(mothership, path = path)
    cat(content(req, as = 'text'), '\n', sep = '')
    return(req)
}

main <- function() {
  # This function is just a placeholder right now, rather than the "main" entry
  # point for execution that the name would suggest ...
    cat('Hooray, it worked!\n')
}

mothership <- 'https://api.qmachine.org/'

set_avar <- function(box = mothership, key = uuid(), status = NULL, val = 0) {
  # This function needs documentation.
    avar <- list(box = box, key = key, val = jsonlite::serializeJSON(val))
    if (missing(status) == FALSE) {
        avar['status'] = status
    }
    req <- POST(mothership, content_type_json(),
            path = stringr::str_c('box/', box, '?key=', key, collapse = ''),
            body = jsonlite::toJSON(avar, auto_unbox = TRUE))
    cat(content(req, as = 'text'), '\n', sep = '')
    return(req)
}

submit <- function(x, f, box = uuid(), env = environment(f)) {
  # This function needs documentation.
    cat('(`submit` placeholder)\n')
}

uuid <- function() {
  # This function needs documentation.
    x <- sample(c(0:9, letters[1:6]), size = 32, replace = TRUE)
    return(stringr::str_c(x, collapse = ''))
}

#-  vim:set syntax=r:
