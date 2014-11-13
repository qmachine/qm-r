#-  R source code

#-  main.r ~~
#
#   This file is contains a very rough R client for the QMachine web service.
#   It is not intended for production use!
#
#                                                       ~~ (c) SRW, 11 Nov 2014
#                                                   ~~ last updated 12 Nov 2014

library(httr)

get_avar <- function(box = uuid(), key) {
  # This function needs documentation.
    if (missing(key)) {
        stop('`get_avar` requires a known `key`.')
    }
    path <- stringr::str_c('box/', box, '?key=', key, collapse = '')
    req <- httr::GET(mothership, path = path)
    if (req$status_code != 200) {
        stop('HTTP failure: ', req$status_code, '\n')
    }
    avar <- jsonlite::fromJSON(httr::content(req, as = 'text'))
    avar$val <- jsonlite::unserializeJSON(avar$val)
    return(avar)
}

get_jobs <- function(box = uuid(), status = 'waiting') {
  # This function needs documentation.
    path <- stringr::str_c('box/', box, '?status=', status, collapse = '')
    req <- httr::GET(mothership, path = path)
    if (req$status_code != 200) {
        stop('HTTP failure: ', req$status_code, '\n')
    }
    return(jsonlite::fromJSON(httr::content(req, as = 'text')))
}

mothership <- 'https://api.qmachine.org/'

set_avar <- function(box = uuid(), key = uuid(), status = NULL, val = NULL) {
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
    return(invisible(NULL))
}

submit <- function(x = NULL, f, box = uuid(), env = environment(f)) {
  # This function uses the functional signature from the original QM paper,
  # except that it returns the native value stored in the `val` property
  # instead of the "avar" itself.
    f_key <- uuid()
    x_key <- uuid()
    status <- 'waiting'
    task_key <- uuid()
    set_avar(box = box, key = f_key, val = f)
    set_avar(box = box, key = x_key, val = x)
    set_avar(box = box, key = task_key, status = status,
        val = list(f = f_key, x = x_key))
    while ((status != 'failed') && (status != 'done')) {
        Sys.sleep(1)
        task <- get_avar(box = box, key = task_key)
        status <- task$status
    }
    return(get_avar(box = box, key = task$val$y)$val)
}

uuid <- function() {
  # This function needs documentation.
    x <- sample(c(0:9, letters[1:6]), size = 32, replace = TRUE)
    return(stringr::str_c(x, collapse = ''))
}

volunteer <- function(box = uuid()) {
  # This function needs documentation.
    job_list <- get_jobs(box = box, status = 'waiting')
    if (length(job_list) == 0) {
        cat('Nothing to do ...\n')
        return(invisible(NULL))
    }
    task <- get_avar(box = box, key = sample(job_list, size = 1))
    set_avar(box = box, key = task$key, status = 'running', val = task$val)
    f <- get_avar(box = box, key = task$val$f)$val
    x <- get_avar(box = box, key = task$val$x)$val
    y <- f(x)
    task$val$y <- uuid()
    set_avar(box = box, key = task$val$y, val = y)
    set_avar(box = box, key = task$key, status = 'done', val = task$val)
    cat('Done: ', task$key, '\n', sep = '')
    return(invisible(NULL))
}

#-  vim:set syntax=r:
