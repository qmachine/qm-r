#-  R source code

#-  main.r ~~
#
#   This file is contains a rough R client for the QMachine web service.
#
#                                                       ~~ (c) SRW, 11 Nov 2014
#                                                   ~~ last updated 13 Nov 2014

#' Read an avar's remote representation by known box and known key.
#' Read the remote representation of an "asynchronous variable" ("avar").
#'
#' @param box A string.
#' @param key A string.
#' @return An R list
get_avar <- function(box = uuid(), key) {
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

#' Read a list of keys for tasks that have a known box and known status.
#'
#' @param box A string.
#' @param status A string.
#' @return An R list
get_jobs <- function(box = uuid(), status = 'waiting') {
  path <- stringr::str_c('box/', box, '?status=', status, collapse = '')
  req <- httr::GET(mothership, path = path)
  if (req$status_code != 200) {
    stop('HTTP failure: ', req$status_code, '\n')
  }
  return(jsonlite::fromJSON(httr::content(req, as = 'text')))
}

mothership <- 'https://api.qmachine.org/'

#' Write an avar by known box and known key.
#'
#' @param box A string.
#' @param key A string.
#' @param status A string.
#' @param val
#' @return NULL
set_avar <- function(box = uuid(), key = uuid(), status = NULL, val = NULL) {
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

#' Submit a job to be distributed to a remote execution context.
#'
#' @param box A string.
#' @param env An environment.
#' @param f A function.
#' @param x Input data
#' @return The results of `f(x)`
submit <- function(x = NULL, f, box = uuid(), env = environment(f)) {
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
  y <- get_avar(box = box, key = task$val$y)
  if (status == 'failed') {
    stop(y$val)
  }
  return(y$val)
}

#' Create a universally unique identifier.
#'
#' @return A random hexadecimal string of length 32.
#'
#' Note that this is not RFC 4122 compliant ...
uuid <- function() {
  x <- sample(c(0:9, letters[1:6]), size = 32, replace = TRUE)
  return(stringr::str_c(x, collapse = ''))
}

#' Volunteer once to execute a job for a known box.
#'
#' @param box A string.
#' @return NULL
volunteer <- function(box = uuid()) {
  job_list <- get_jobs(box = box, status = 'waiting')
  if (length(job_list) == 0) {
    cat('Nothing to do ...\n')
    return(invisible(NULL))
  }
  task <- get_avar(box = box, key = sample(job_list, size = 1))
  set_avar(box = box, key = task$key, status = 'running', val = task$val)
  f <- get_avar(box = box, key = task$val$f)$val
  x <- get_avar(box = box, key = task$val$x)$val
  y <- tryCatch(list(status = 'done', y = f(x)),
      error = function(err) return(list(status = 'failed', y = err)))
  task$val$y <- uuid()
  set_avar(box = box, key = task$val$y, val = y$y)
  set_avar(box = box, key = task$key, status = y$status, val = task$val)
  cat('Done: ', task$key, '\n', sep = '')
  return(invisible(NULL))
}

#-  vim:set syntax=r:
