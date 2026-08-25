# Internet Engineering Exams

[![build](https://github.com/1995parham-teaching/ie-exam/actions/workflows/build.yml/badge.svg)](https://github.com/1995parham-teaching/ie-exam/actions/workflows/build.yml)

## Introduction

The course is assessed twice, and the two are not the same kind of thing:

- **the midterm is a take-home project** — students get about a week to build a
  small frontend or backend application;
- **the final is a real exam** — questions answered in a room, in a fixed time.

The repository keeps both, and the split runs all the way through it:

```
src/questions/<name>/main.tex   a question — the bank the finals draw on
src/projects/<name>/main.tex    a take-home project
exams/<name>.tex                a final: which questions, in which order
midterms/<name>.tex             a midterm: which project, and the deadline
ie-exam.cls                     the shared class
```

The first exam was a quiz at Beheshti University, Fall 2020, when everything was
remote.

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
make            # every final and midterm -> build/<name>.pdf
make answers    # the same, with the answer keys and grading notes shown
make list       # the finals and the midterms
make questions  # the question bank and the projects
make clean      # remove build artefacts
```

`make build/swapi.pdf` builds a single sheet, whichever kind it is.

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
`src/questions/<name>/main.tex`:

```latex
\قسمت{یک عنوان خوب}

صورت پرسش ...

\نمره{۲}

\begin{پاسخ}
پاسخ و نکات تصحیح ...
\end{پاسخ}
```

and add it to a final in `exams/`:

```latex
\ورودی{questions/<name>/main}
```

A take-home project is the same shape, in `src/projects/<name>/main.tex`, and
gets a sheet in `midterms/` that carries the deadline:

```latex
\جزئیات‌آزمون{
دانشگاه={دانشگاه صنعتی امیرکبیر},
نام={میان‌ترم (پروژه فرانت‌اند)},
مهلت={یک هفته}
}
```

`exams/all-questions.tex` includes every question in the bank; it exists so that
CI fails when any question stops compiling, not only the ones the current exam
happens to use. It is a check, not a sheet to hand out. The projects are covered
the same way, by their own midterm sheets.

## Midterms

**Frontend.** A very simple GUI (pure JS, CSS and HTML) for an API — easy, fun,
and a good way to measure what students actually picked up. `swapi`, `github`
and `genderize` are all this shape. Good sources for a new one:

- <https://github.com/marcelscruz/public-apis>
- <https://publicapis.dev/>

**Backend.** A very simple server in Go with a few APIs; students are free to
use any library or framework that fits them. `shopping-basket` is this shape.

Because these run for about a week off-campus, an external API that rate-limits
or goes down is a real risk — `github` uses the unauthenticated GitHub API,
which allows 60 requests per hour per IP. Say in the handout what a student
should do when the service is unreachable.
