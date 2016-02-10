SUB = $(find . -maxdepth 1 -mindepth 1 -type d)
RNW = $(wildcard *.Rnw)
TEX = $(RNW:.Rnw=.tex)
PDF = $(TEX:.tex=.pdf)

all: $(PDF)

auto:
	latexmk -bibtex -f -pdf -pvc

clean:
	latexmk -C
	for i in $(SUB); do $(MAKE) -C $$i clean; done

install:
	if [ -f /etc/redhat-release ]; then	sudo dnf -y install R texlive-framed; elif [ -f /etc/debian_version ]; then sudo apt-get install r-base r-base-dev texlive r-cran-rgl r-cran-ggplot2 -y; fi
	R -e 'install.packages("knitr", dependencies = TRUE, repos="http://cran.rstudio.com/")'
	R -e 'install.packages("ggplot2", dependencies = TRUE, repos="http://cran.rstudio.com/")'
	wget https://raw.githubusercontent.com/geneura/biblio/master/geneura.bib

%.tex: %.Rnw
	R -e 'library(knitr);knit("$<")'

%.pdf: %.tex
	latexmk -bibtex -pdf $*

.PHONY: all auto clean install
