# Build the Internet Engineering exams with TeX Live.
#
# Every exam lives in exams/<name>.tex and picks the questions it needs out of
# src/. `make` builds the question sheets into build/<name>.pdf; `make answers`
# builds build/<name>-answers.pdf with the answer keys and grading notes shown.
#
# latexmk runs from src/, because an exam refers to the class as ../exam and
# includes its questions by their path inside src/.

# TEXINPUTS puts the repository root ahead of the TeX tree, so ie-exam.cls and
# fonts/ resolve while latexmk runs from src/.
TEXINPUTS_ROOT := ..:

LATEXMK ?= latexmk
LATEXMKFLAGS ?= -xelatex -shell-escape -halt-on-error -interaction=nonstopmode

EXAMS := $(patsubst exams/%.tex,%,$(wildcard exams/*.tex))
QUESTIONS := $(wildcard src/*/main.tex)
DEPS := ie-exam.cls $(QUESTIONS) $(wildcard fonts/*.ttf)

.PHONY: all
all: $(patsubst %,build/%.pdf,$(EXAMS))

.PHONY: answers
answers: $(patsubst %,build/%-answers.pdf,$(EXAMS))

build/%-answers.pdf: exams/%.tex $(DEPS)
	@mkdir -p build
	cd src && TEXINPUTS=$(TEXINPUTS_ROOT) $(LATEXMK) $(LATEXMKFLAGS) -usepretex='\def\showanswers{}' \
		-jobname=$*-answers -outdir=../build ../exams/$*.tex

build/%.pdf: exams/%.tex $(DEPS)
	@mkdir -p build
	cd src && TEXINPUTS=$(TEXINPUTS_ROOT) $(LATEXMK) $(LATEXMKFLAGS) -jobname=$* -outdir=../build ../exams/$*.tex

.PHONY: list
list:
	@for exam in $(EXAMS); do echo "$$exam"; done

.PHONY: questions
questions:
	@for q in $(QUESTIONS); do basename $$(dirname $$q); done

.PHONY: clean
clean:
	rm -rf build src/_minted-*

.PHONY: help
help:
	@echo "make           build every exam into build/"
	@echo "make answers   build every exam with the answer keys shown"
	@echo "make list      list the exams"
	@echo "make questions list the question bank"
	@echo "make clean     remove build artefacts"
