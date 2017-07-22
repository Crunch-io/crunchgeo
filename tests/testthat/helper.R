Sys.setlocale("LC_COLLATE", "C") ## What CRAN does; affects sort order
set.seed(999) ## To ensure that tests that involve randomness are reproducible
options(warn=1)

# grab the crunch package's test framework
source(system.file("crunch-test.R", package="crunch"))
