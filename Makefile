# Makefile for x-cheatsheet

MAKENOSTOP	:= -
SOURCES := $(wildcard *.tex)
TARGETS := $(SOURCES:%.tex=%.pdf)
PNGS 	:= $(TARGETS:%.pdf=%.png)
OPTIONS	:= -interaction=nonstopmode

XELATEX_EXEC  := $(shell command -v xelatex 2>/dev/null)
PDFTOPPM_EXEC := $(shell command -v pdftoppm 2>/dev/null)

all: $(PNGS)

$(TARGETS): %.pdf: %.tex
ifneq ($(XELATEX_EXEC),)
		@$(MAKENOSTOP)xelatex $(OPTIONS) $<
else
		$(error "xelatex not found, please install it.")
endif

$(PNGS): %.png: %.pdf
ifneq ($(PDFTOPPM_EXEC),)
		@$(PDFTOPPM_EXEC) -png $< ${@:.png=} # pdftoppm -png <pdf> <png-prefix>
else
		@echo "pdftoppm not found, skipping conversion to PNG."
endif

clean:
	@find . -name "*.png" -newer python-logo.png -exec rm {} \;
	@rm -rf ${TARGETS:.pdf=.png} $(TARGETS) *.log *.out *.aux *.toc *.nav *.snm *.vrb *fdb_latexmk *.fls *.synctex.gz

.PHONY: all clean
