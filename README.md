# Internet Engineering Exams

[![build](https://github.com/1995parham-teaching/ie-exam/actions/workflows/build.yml/badge.svg)](https://github.com/1995parham-teaching/ie-exam/actions/workflows/build.yml)

## Introduction

Questions for the Internet Engineering midterm and final exams. Each question
lives in its own folder under `src/`, and an exam picks the questions it needs.
The first exam was a quiz at Beheshti University, Fall 2020, when everything was
remote.

```
src/<question>/main.tex   one question — the bank
exams/<exam>.tex          one exam — which questions, in which order
ie-exam.cls               the shared class
```

## How to build?

The exams are built with [TeX Live](https://tug.org/texlive/) (XeLaTeX, driven
by `latexmk`) and [Pygments](https://pygments.org), which `minted` shells out to
for code listings.

**TeX Live 2023 or newer is required.** The class asks `xepersian` for its
Persian command aliases with the `localize` option, which was spelled `localise`
up to TeX Live 2022.

| Platform | Install |
| --- | --- |
| macOS | `brew install --cask mactex-no-gui` (or [MacTeX](https://tug.org/mactex/)) |
| Debian/Ubuntu | `apt install texlive-full latexmk python3-pygments` |
| Arch | `pacman -S texlive texlive-langarabic texlive-latexextra python-pygments` |
| Any | [`install-tl`](https://tug.org/texlive/acquire-netinstall.html) with `scheme-full` |

```bash
make            # every exam           -> build/<exam>.pdf
make answers    # every exam, with the answer keys and grading notes shown
make list       # the exams
make questions  # the question bank
make clean      # remove build artefacts
```

Or, without installing a TeX distribution — this is also what CI runs:

```bash
docker run --rm -v "$PWD":/work -w /work texlive/texlive:latest make
```

## Answers

Answers and grading notes live next to their question inside a `پاسخ`
environment. They are **hidden** in a normal build and only appear in
`make answers`, so the same source produces both the exam sheet and the answer
key.

Because of that, this repository holds answer keys: keep that in mind before
sharing a link to it with students.

## Writing a question

See [CONTRIBUTING.md](CONTRIBUTING.md). The short version — create
`src/<question>/main.tex`:

```latex
\قسمت{یک عنوان خوب}

صورت پرسش ...

\نمره{۲}

\begin{پاسخ}
پاسخ و نکات تصحیح ...
\end{پاسخ}
```

and add it to an exam in `exams/`:

```latex
\ورودی{<question>/main}
```

`exams/all-questions.tex` includes every question in the bank; it exists so that
CI fails when any question stops compiling, not only the ones the current exam
happens to use. It is a check, not a sheet to hand out.

## Midterms (Frontend)

On midterms, I always ask students to implement a very simple GUI (based on pure
JS, CSS and HTML) for an API which is easy, fun and also a good way to measure
students knowledge.

- <https://github.com/marcelscruz/public-apis>
- <https://publicapis.dev/>

## Midterms (Backend)

On midterms, I always ask students to implement a very simple backend server in
Go with a few APIs. They are free to use any library or framework that fits them.
