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
    req <- httr::GET(mothership, path = path)
    if (req$status_code != 200) {
        stop('HTTP failure: ', req$status_code, '\n')
    }
    text <- httr::content(req, as = 'text')
    #cat(text, '\n', sep = '')
    avar <- jsonlite::fromJSON(text)
    avar$val <- jsonlite::unserializeJSON(avar$val)
    return(avar)
}

get_jobs <- function(box = uuid(), status = 'waiting') {
  # This function needs documentation.
    path <- stringr::str_c('box/', box, '?status=', status, collapse = '')
    #cat(path, '\n', sep = '')
    req <- httr::GET(mothership, path = path)
    if (req$status_code != 200) {
        stop('HTTP failure: ', req$status_code, '\n')
    }
    text <- httr::content(req, as = 'text')
    #cat(text, '\n', sep = '')
    jobs <- jsonlite::fromJSON(text)
    return(jobs)
}

main <- function() {
  # This function is just a placeholder right now, rather than the "main" entry
  # point for execution that the name would suggest ...
    cat('Hooray, it worked!\n')
}

mothership <- 'https://api.qmachine.org/'

set_avar <- function(box = mothership, key = uuid(), status = NULL, val = NULL){
  # This function needs documentation.
    avar <- list(box = box, key = key, val = jsonlite::serializeJSON(val))
    if (missing(status) == FALSE) {
        avar$status = status
    }
    req <- httr::POST(mothership, httr::content_type_json(),
            path = stringr::str_c('box/', box, '?key=', key, collapse = ''),
            body = jsonlite::toJSON(avar, auto_unbox = TRUE))
    if (req$status_code != 201) {
        stop('HTTP failure: ', req$status_code, '\n')
    }
    #text <- httr::content(req, as = 'text')
    #cat(text, '\n', sep = '')
    return(NULL)
}

uuid <- function() {
  # This function needs documentation.
    x <- sample(c(0:9, letters[1:6]), size = 32, replace = TRUE)
    return(stringr::str_c(x, collapse = ''))
}

#-  vim:set syntax=r:
