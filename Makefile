pkg = $(shell basename $(CURDIR))

all: build

NAMESPACE: R/*
	Rscript -e "devtools::document()"

README.md: README.Rmd
	Rscript -e "knitr::knit('README.Rmd')"

README.html: README.md
	pandoc -o README.html README.md

../$(pkg)*.tar.gz: DESCRIPTION NAMESPACE README.md
	cd ../ && R CMD build $(pkg)

build: ../$(pkg)*.tar.gz

check: ../$(pkg)*.tar.gz
	cd ../ && R CMD check $(pkg)*.tar.gz
	rm ../$(pkg)*.tar.gz

install: ../$(pkg)*.tar.gz
	cd ../ && R CMD INSTALL $(pkg)*.tar.gz
	rm ../$(pkg)*.tar.gz

vignettes: vignettes/A-introduction.Rmd vignettes/B-search.Rmd vignettes/C-retrieval.Rmd vignettes/D-archiving.Rmd

vignettes/A-introduction.Rmd: vignettes/A-introduction.Rmd2
	Rscript -e "knitr::knit('vignettes/A-introduction.Rmd2', 'vignettes/A-introduction.Rmd', encoding = 'UTF-8')"

vignettes/B-search.Rmd: vignettes/B-search.Rmd2
	Rscript -e "knitr::knit('vignettes/B-search.Rmd2', 'vignettes/B-search.Rmd', encoding = 'UTF-8')"

vignettes/C-retrieval.Rmd: vignettes/C-retrieval.Rmd2
	Rscript -e "knitr::knit('vignettes/C-retrieval.Rmd2', 'vignettes/C-retrieval.Rmd', encoding = 'UTF-8')"

vignettes/D-archiving.Rmd: vignettes/D-archiving.Rmd2
	Rscript -e "knitr::knit('vignettes/D-archiving.Rmd2', 'vignettes/D-archiving.Rmd', encoding = 'UTF-8')"
