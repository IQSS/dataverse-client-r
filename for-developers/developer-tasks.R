rm(list=ls(all=TRUE))
# library(devtools)
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #http://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

devtools::document()
devtools::check_man() #Should return NULL
devtools::clean_vignettes()
devtools::build_vignettes()
# pkgdown::clean_site()
# pkgdown::build_site()
system("R CMD Rd2pdf --no-preview --force --output=./documentation-peek.pdf ." )

checks_to_exclude <- c(
  "covr",
  "lintr_line_length_linter"
)
gp <-
  goodpractice::all_checks() %>%
  purrr::discard(~(. %in% checks_to_exclude)) %>%
  goodpractice::gp(checks = .)
goodpractice::results(gp)
gp

devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# devtools::run_examples(, "redcap_read.Rd")
test_results_checked <- devtools::test()
# test_results_checked <- devtools::test(filter = "read_b.*")
# testthat::test_dir("./tests/")
# test_results_not_checked <- testthat::test_dir("./tests/manual/")

# lintr::lint_package()
lintr::lint("R/add_dataset_file.R")
# devtools::check(force_suggests = FALSE)
devtools::check(cran=T)
# devtools::check_rhub(email="wibeasley@hotmail.com", env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))
# devtools::check_win_devel() #CRAN submission policies encourage the development version
# devtools::revdep_check(pkg="REDCapR", recursive=TRUE)
# devtools::release(check=FALSE) #Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
