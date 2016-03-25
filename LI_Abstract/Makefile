all: brainhack-report-formatted.tex
	pdflatex brainhack-report-formatted.tex
	bibtex brainhack-report-formatted
	pdflatex brainhack-report-formatted.tex
	pdflatex brainhack-report-formatted.tex
	texcount brainhack-report-formatted.tex

brainhack-report-formatted.tex: brainhack-report-template.tex brainhack-report.bib README.md
	pandoc -s -S -N --template brainhack-report-template.tex README.md -o brainhack-report-formatted.tex
	
clean:
	rm *.aux *.bbl *.log *.blg *.out
