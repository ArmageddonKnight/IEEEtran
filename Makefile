FIGURES_FOLDER := figures
PDFS := \
$(filter-out $(wildcard $(FIGURES_FOLDER)/*-crop.pdf),$(wildcard $(FIGURES_FOLDER)/*.pdf)) \
$(filter-out $(wildcard $(FIGURES_FOLDER)/**/*-crop.pdf),$(wildcard $(FIGURES_FOLDER)/**/*.pdf))
CROPPED_PDFS := $(PDFS:.pdf=-crop.pdf)

all: main.pdf

%.pdf: %.tex Makefile $(CROPPED_PDFS)
	pdflatex -synctex=1 -interaction=nonstopmode $<
	-bibtex $*.aux
	pdflatex -synctex=1 -interaction=nonstopmode $<
	pdflatex -synctex=1 -interaction=nonstopmode $<

.PHONY: figures
figures: $(CROPPED_PDFS)

.PRECIOUS: $(CROPPED_PDFS)
%-crop.pdf: %.pdf Makefile
	pdfcrop $<

.PHONY: clean upgrade
clean:
	find . -maxdepth 1 \
		\( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
	           -name "*.log" -o -name "*.out" -o -name "*.pdf" -o \
		   -name "*.synctex.gz" \) | xargs $(RM)
	find $(FIGURES_FOLDER) -name "*-crop.pdf" | xargs $(RM)

upgrade:
	curl -O https://mirror.quantum5.ca/CTAN/macros/latex/contrib/IEEEtran/IEEEtran.cls 
	curl -O https://www.ieee.org/content/dam/ieee-org/ieee/web/org/conferences/IEEEtranBST2.zip
	unzip -o IEEEtranBST2.zip IEEEtran.bst
	$(RM) IEEEtranBST2.zip
