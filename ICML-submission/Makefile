filename_submission=main-submission
filename_supplementary=main-supplementary

.PHONY: all clean

all: submission supplementary

submission:
	pdflatex ${filename_submission}
	bibtex ${filename_submission} || true
	pdflatex ${filename_submission}
	pdflatex ${filename_submission}

supplementary:
	pdflatex ${filename_supplementary}
	bibtex ${filename_supplementary} || true
	pdflatex ${filename_supplementary}
	pdflatex ${filename_supplementary}

read:
	evince ${filename_submission}.pdf || open ${filename_submission}.pdf &

spell:
	find . -name "*.tex" -exec aspell --lang=en --mode=tex check "{}" \;

clean:
	rm -f *.aux *.dvi *.bak *.bbl *.blg *.log *.nav *.out *.toc ${filename_submission}.pdf ${filename_supplementary}.pdf
