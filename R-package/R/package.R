#' TensorFlow IO API for R
#'
#' This library provides an R interface to the
#' \href{https://github.com/tensorflow/io}{TensorFlow IO} API
#' that provides datasets and filesystem extensions maintained by SIG-IO.
#'
#' @docType package
#' @name tfio
NULL

#' @importFrom reticulate py_last_error tuple py_str py_has_attr import
#' @import tfdatasets
#' @import forge
NULL

tfio_lib <- NULL

.onLoad <- function(libname, pkgname) {

  # Delay load handler
  displayed_warning <- FALSE
  delay_load <- list(

    priority = 5,

    environment = "r-tensorflow-io",

    on_load = function() {
      check_tensorflow_version(displayed_warning)
    },

    on_error = function(e) {
      stop(tf_config()$error_message, call. = FALSE)
    }
  )

  if (!reticulate::py_module_available("tensorflow_io")) {
    tfio_module_not_available_message()
  } else {
    tfio_lib <<- import("tensorflow_io", delay_load = delay_load)
  }
}

tfio_module_not_available_message <- function() {
  packageStartupMessage(
    paste0("tensorflow_io Python module is not available. ",
           "Please install it and try load it via library(tfio) again."))
}

check_tensorflow_version <- function(displayed_warning) {
  current_tf_ver <- tf_version()
  required_ver <- "1.12.0"
  if (current_tf_ver != required_ver) {
    if (!displayed_warning) {
      packageStartupMessage(
        "tfio requires TensorFlow version == ", required_ver, " ",
        "(you are currently running version ", current_tf_ver, ").\n")
      displayed_warning <<- TRUE
    }
  }
}

.onUnload <- function(libpath) {

}

.onAttach <- function(libname, pkgname) {

}

.onDetach <- function(libpath) {

}
