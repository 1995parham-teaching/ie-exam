# Contributing

This repository holds the question bank and the exam sheets for the **Internet
Engineering** course. Read this before adding a question.

## Prerequisites

- **TeX Live 2023 or newer** with XeLaTeX and `latexmk` (`scheme-full` is
  easiest; otherwise `tlmgr install xepersian minted fvextra`).
- **[Pygments](https://pygments.org)** (`pip install Pygments`) for `minted`.

Or use the image CI uses, with nothing installed locally:

```bash
docker run --rm -v "$PWD":/work -w /work texlive/texlive:latest make
```

Fonts are vendored in `fonts/` and picked up automatically — do not install them
system-wide, and do not switch the class to a system font: a font that only
exists on your laptop breaks the build for everyone else.

## Layout

| Path | What it is |
| --- | --- |
| `src/<question>/main.tex` | one question, plus its answer and grading notes |
| `exams/<exam>.tex` | one exam: metadata and the list of questions |
| `exams/all-questions.tex` | every question, built by CI as a compile check |
| `ie-exam.cls` | the shared class |
| `fonts/` | Vazirmatn (Persian) and Roboto (Latin) |

`latexmk` runs from `src/`, which is why an exam includes a question as
`\ورودی{<question>/main}` and images resolve as `<question>/<image>.png`.

## Adding a question

1. Create `src/<question>/main.tex`. Name the folder after the topic in
   kebab-case (`host-header`, `slice-vs-array`) — not after the exam it first
   appeared in, because questions get reused.

2. Write the question as a fragment — no `\documentclass`, no
   `\begin{document}`:

   ```latex
   \قسمت{یک عنوان خوب}

   صورت پرسش ...

   \نمره{۲}

   \begin{پاسخ}
   پاسخ نمونه و نکات تصحیح ...
   \end{پاسخ}
   ```

3. Add it to `exams/all-questions.tex`, and to the exam that uses it.

4. Build and check both outputs:

   ```bash
   make build/all-questions.pdf
   make answers
   ```

### Conventions

- **Marks** are set with `\نمره{۲}`, not as loose text. One `\نمره` per
  question, after the question body and before the answer.
- **Answers** go in a `پاسخ` environment and are hidden unless the document is
  built with `make answers`. Put the grading notes there too — percentages lost
  per missing point, what earns partial credit — because that is what makes a
  question reusable by a different TA next semester.
- **Latin words** inside Persian text belong in `\متن‌لاتین{...}`, code in
  `minted` inside a `latin` environment.
- **Images** live next to their question (`src/<question>/<name>.png`), with the
  editable `.drawio` source next to the export.

## Writing a good question

- State what the answer should contain: "دو مورد را نام ببرید" beats "توضیح
  دهید" when you intend to grade two specific points.
- Ask for the reasoning, not only the verdict. A question that can be answered
  با «بله» or «خیر» will be, and then it grades nothing.
- Keep the marks proportional to the work. A question with three sub-questions
  should not be worth the same as a one-line recall question.
- Prefer a scenario over a definition. The scenario questions in this bank
  (`fetch`, `cookie-1`, `cap`) discriminate far better than the recall ones.
- If a question depends on an external service (`swapi`, `github`,
  `genderize`), say what a student should do when it is unreachable during the
  exam — those services have gone down before.

## Exams

An exam is a thin file: metadata plus the list of questions.

```latex
\documentclass[]{ie-exam}

\عنوان{مهندسی اینترنت}
\نویسنده{پرهام الوانی}
\تاریخ{خرداد ۱۴۰۳}

\جزئیات‌آزمون{
دانشگاه={دانشگاه صنعتی امیرکبیر},
نام={آزمون پایانی},
ترم={نیم‌سال دوم ۱۴۰۲-۱۴۰۳},
زمان={۹۰}
}

\begin{document}
\عنوان‌ساز
\فهرست‌مطالب
\صفحه‌شکن

\ورودی{validation/main}

\پایان‌ساز
\end{document}
```

Name it `<year>-<semester>-<kind>.tex`, e.g. `1402-2-final.tex`. Do not delete
old exams — they are the record of what was asked, and questions are reused.

## What does not belong here

This repository is **public** and it contains answer keys. Do not commit:

- student names, student numbers, submissions, or grades,
- an exam that has not been given yet.

If you need to prepare an unreleased exam, keep it in a private repository until
after it has been sat.
