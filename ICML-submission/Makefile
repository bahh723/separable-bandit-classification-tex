filename=main-all
filename_submission=main-first-10-pages

.PHONY: all clean

all:
	pdflatex ${filename}
	bibtex ${filename} || true
	pdflatex ${filename}
	pdflatex ${filename}
	pdflatex ${filename}
	pdftk ${filename}.pdf cat 1-10 output ${filename_submission}.pdf

read:
	evince ${filename}.pdf || open ${filename}.pdf &

spell:
	find . -name "*.tex" -exec aspell --lang=en --mode=tex check "{}" \;

clean:
	rm -f *.aux *.dvi *.bak *.bbl *.blg *.log *.nav *.out *.toc ${filename}.pdf ${filename_submission}.pdf
