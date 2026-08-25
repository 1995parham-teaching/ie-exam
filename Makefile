# Build the Internet Engineering exams with TeX Live.
#
# The course has two kinds of handout, and they are built the same way:
#
#   exams/<name>.tex     a final — questions from src/questions/, sat in a room
#   midterms/<name>.tex  a midterm — one take-home project from src/projects/
#
# `make` builds both into build/<name>.pdf; `make answers` builds
# build/<name>-answers.pdf with the answer keys and grading notes shown.
#
# latexmk runs from src/, because an exam refers to the class as ../exam and
# includes its questions by their path inside src/.

# TEXINPUTS puts the repository root and the shared latex/ subtree ahead of the
# TeX tree, so ie-exam.cls and teaching-base.sty resolve while latexmk runs
# from src/.
TEXINPUTS_ROOT := ..:../latex:

LATEXMK ?= latexmk
LATEXMKFLAGS ?= -xelatex -shell-escape -halt-on-error -interaction=nonstopmode

EXAMS := $(patsubst exams/%.tex,%,$(wildcard exams/*.tex))
MIDTERMS := $(patsubst midterms/%.tex,%,$(wildcard midterms/*.tex))
SHEETS := $(EXAMS) $(MIDTERMS)
QUESTIONS := $(wildcard src/questions/*/main.tex)
PROJECTS := $(wildcard src/projects/*/main.tex)
DEPS := ie-exam.cls $(wildcard latex/*.sty) $(QUESTIONS) $(PROJECTS) $(wildcard latex/fonts/*.ttf)

.PHONY: all
all: $(patsubst %,build/%.pdf,$(SHEETS))

.PHONY: answers
answers: $(patsubst %,build/%-answers.pdf,$(SHEETS))

# $(sheet) finds the sheet whether it is a final or a midterm.
sheet = $(firstword $(wildcard exams/$(1).tex midterms/$(1).tex))

build/%-answers.pdf: $(DEPS)
	@mkdir -p build
	cd src && TEXINPUTS=$(TEXINPUTS_ROOT) $(LATEXMK) $(LATEXMKFLAGS) -usepretex='\def\showanswers{}' \
		-jobname=$*-answers -outdir=../build ../$(call sheet,$*)

build/%.pdf: $(DEPS)
	@mkdir -p build
	cd src && TEXINPUTS=$(TEXINPUTS_ROOT) $(LATEXMK) $(LATEXMKFLAGS) \
		-jobname=$* -outdir=../build ../$(call sheet,$*)

.PHONY: list
list:
	@echo "finals:"; for exam in $(EXAMS); do echo "  $$exam"; done
	@echo "midterms:"; for m in $(MIDTERMS); do echo "  $$m"; done

.PHONY: questions
questions:
	@echo "questions:"; for q in $(QUESTIONS); do echo "  $$(basename $$(dirname $$q))"; done
	@echo "projects:"; for p in $(PROJECTS); do echo "  $$(basename $$(dirname $$p))"; done

.PHONY: clean
clean:
	rm -rf build src/_minted-*

.PHONY: help
help:
	@echo "make           build every final and midterm into build/"
	@echo "make answers   the same, with the answer keys shown"
	@echo "make list      list the finals and midterms"
	@echo "make questions list the question bank and the projects"
	@echo "make clean     remove build artefacts"
