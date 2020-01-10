# crunchgeo

[![Build Status](https://travis-ci.org/Crunch-io/crunchgeo.png?branch=master)](https://travis-ci.org/Crunch-io/crunchgeo)  [![codecov](https://codecov.io/gh/Crunch-io/crunchgeo/branch/master/graph/badge.svg)](https://codecov.io/gh/Crunch-io/crunchgeo)
[![Build status](https://ci.appveyor.com/api/projects/status/njqhbd7ayy1vgp2k/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/crunchgeo/branch/master)
[![R build status](https://github.com/Crunch-io/crunchgeo/workflows/R-CMD-check/badge.svg)](https://github.com/Crunch-io/crunchgeo)
 [![cran](https://www.r-pkg.org/badges/version-last-release/crunchgeo)](https://cran.r-project.org/package=crunchgeo)

## Installing

<!-- If you're putting `crunchgeo` on CRAN, it can be installed with

    install.packages("crunchgeo") -->

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("crunch-io/crunchgeo", build_vignettes=TRUE)

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
