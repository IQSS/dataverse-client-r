# library(devtools)

devtools::document()
devtools::check_man() #Should return NULL
devtools::clean_vignettes()
devtools::build_vignettes()
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

devtools::run_examples(); # dev.off() # This overwrites the NAMESPACE file too
test_results_checked <- devtools::test()
test_results_checked <- devtools::test(filter = "get_dataframe_*")
# testthat::test_dir("./tests/")

View(urlchecker::url_check())
urlchecker::url_update()

# lintr::lint_package()
lintr::lint("R/add_dataset_file.R")
# devtools::check(force_suggests = FALSE)
devtools::check(cran = TRUE)
devtools::check( # Equivalent of R-hub
  manual    = TRUE,
  remote    = TRUE,
  incoming  = TRUE
)
# devtools::check_rhub(email="shirokuriwaki@gmail.com", env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))
# devtools::check_win_devel() # CRAN submission policies encourage the development version
# devtools::release(check=FALSE) # Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
