# LaTeX Templates

The shared look of the course documents — assignments, exams, and the take-home
projects — so that a fix lands once instead of once per repository.

| File | What it is |
| --- | --- |
| `teaching-base.sty` | palette, fonts, sectioning, listings, callouts, marks, answers |
| `fonts/` | Vazirmatn (Persian), Neuton and Roboto (Latin), all OFL/Apache |

## Using it

This repository is consumed as a `git subtree` under `latex/`:

```bash
git subtree add --prefix latex \
  git@github.com:1995parham-teaching/latex-templates.git main --squash
```

To pull a later version:

```bash
git subtree pull --prefix latex \
  git@github.com:1995parham-teaching/latex-templates.git main --squash
```

A class then loads it, and adds only its own cover page and metadata:

```latex
\LoadClass[]{article}
\RequirePackage[latin=Roboto]{teaching-base}
```

The build has to see both the repository root and `latex/`. With `latexmk`
running from `src/`:

```make
TEXINPUTS_ROOT := ..:../latex:
```

## Options

| Option | Default | Meaning |
| --- | --- | --- |
| `latin` | `Neuton` | Latin text font family in `fonts/` |
| `persian` | `Vazirmatn` | Persian text font family in `fonts/` |
| `fontpath` | `../latex/fonts/` | where those families live, relative to the build directory |
| `accent` | `2457C5` | accent colour, six hex digits |

## What it gives a document

- **A palette.** `tbaccent`, `tbmuted`, `tbink`, and a tinted pair for each
  callout. Documents should not define their own colours.
- **Fonts, vendored.** No dependency on what happens to be installed.
- **Sectioning** in the accent colour with a hairline under each `\قسمت`.
- **Header and footer** — `\runninghead{}` and `\runningfoot{}`, with
  «صفحه ۲ از ۶» — because printed pages get separated.
- **Listings** in one style, framed with a left rule instead of a background,
  so long code breaks across pages and does not eat toner.
- **Callouts**: `نکته`, `راهنمایی`, `امتیازی`.
- **Marks**: `\نمره{۲}` renders as a badge and records itself in the `.aux`
  file, so a class can print a grading table from it.
- **Answers**: a `پاسخ` block, hidden unless `\showanswers` is defined before
  the class loads.

## Notes for whoever maintains this

- `xepersian` is loaded last, and the fonts are set after it.
- Do not load `array`, or anything that pulls it in (`colortbl`, `booktabs`
  column types). Under TeX Live 2026 `bidi` patches `\@tabular` into calling
  array's `\UseMathForPositioningText`, and every table in every document dies.
- Write fractional marks with the Arabic decimal separator (`۱٫۵`). An ASCII
  dot is a neutral character, so `۱.۵` comes out of an RTL run reading `۵.۱`.
- TeX Live 2023 is the floor: the Persian aliases come from `[localize]`, which
  was `[localise]` up to TeX Live 2022.
