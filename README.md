# crunchgeo

[![Build Status](https://travis-ci.org/jonkeane/crunchgeo.png?branch=master)](https://travis-ci.org/jonkeane/crunchgeo)  [![codecov](https://codecov.io/gh/jonkeane/crunchgeo/branch/master/graph/badge.svg)](https://codecov.io/gh/jonkeane/crunchgeo)
[![cran](https://www.r-pkg.org/badges/version-last-release/crunchgeo)](https://cran.r-project.org/package=crunchgeo)

## Installing

<!-- If you're putting `crunchgeo` on CRAN, it can be installed with

    install.packages("crunchgeo") -->

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("jonkeane/crunchgeo", build_vignettes=TRUE)

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
