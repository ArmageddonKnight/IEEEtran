all: main.pdf Makefile

%.pdf: %.tex
	pdflatex -synctex=1 -interaction=nonstopmode $<
	-bibtex $*.aux
	pdflatex -synctex=1 -interaction=nonstopmode $<
	pdflatex -synctex=1 -interaction=nonstopmode $<

.PHONY: clean upgrade
clean:
	find . -maxdepth 1 \
		\( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
	           -name "*.log" -o -name "*.out" -o -name "*.pdf" -o \
		   -name "*.synctex.gz" \) | xargs $(RM)

upgrade:
	curl https://ctan.math.ca/tex-archive/macros/latex/contrib/IEEEtran/IEEEtran.cls \
		-o IEEEtran.cls
	curl https://www.ieee.org/content/dam/ieee-org/ieee/web/org/conferences/IEEEtranBST2.zip -o IEEEtranBST2.zip && \
		unzip -o IEEEtranBST2.zip IEEEtran.bst && \
		rm -f IEEEtranBST2.zip
