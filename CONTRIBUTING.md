# Contributing

This repository holds the question bank, the take-home projects, and the sheets
that assemble them for the **Internet Engineering** course. The course is
assessed with a **midterm, which is a take-home project** students have about a
week for, and a **final, which is a real exam** sat in a room. Read this before
adding either.

## Prerequisites

- **TeX Live 2023 or newer** with XeLaTeX and `latexmk` (`scheme-full` is
  easiest; otherwise `tlmgr install xepersian minted fvextra`).
- **[Pygments](https://pygments.org)** (`pip install Pygments`) for `minted`.

Or use the image CI uses, with nothing installed locally:

```bash
docker run --rm -v "$PWD":/work -w /work texlive/texlive:latest make
```

Fonts are vendored in `latex/fonts/` and picked up automatically — do not install them
system-wide, and do not switch the class to a system font: a font that only
exists on your laptop breaks the build for everyone else.

## Layout

| Path | What it is |
| --- | --- |
| `src/questions/<name>/main.tex` | one exam question, plus its answer and grading notes |
| `src/projects/<name>/main.tex` | one take-home project |
| `exams/<name>.tex` | a final: metadata and the list of questions |
| `midterms/<name>.tex` | a midterm: metadata, the deadline, and its project |
| `exams/all-questions.tex` | every question, built by CI as a compile check |
| `ie-exam.cls` | the shared class |
| `latex/` | the shared class base, from [latex-templates](https://github.com/1995parham-teaching/latex-templates) (git subtree) |
| `latex/fonts/` | Vazirmatn (Persian) and Roboto (Latin) |

`latexmk` runs from `src/`, which is why a final includes a question as
`\ورودی{questions/<name>/main}`. Images are found through `\graphicspath`, so
`\درج‌تصویر{<name>/<image>.png}` keeps working whether the folder sits under
`questions/` or `projects/`.

## Adding a question

1. Create `src/questions/<name>/main.tex`. Name the folder after the topic in
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

3. Add it to `exams/all-questions.tex`, and to the final that uses it.

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

## Adding a take-home project

A project is a whole midterm on its own, so it gets a folder under
`src/projects/` and a sheet under `midterms/`. Write the project the same way as
a question — a fragment starting with `\قسمت` — and keep its images and their
editable `.drawio` sources next to it.

The sheet carries the deadline rather than an exam duration:

```latex
\جزئیات‌آزمون{
دانشگاه={دانشگاه صنعتی امیرکبیر},
نام={میان‌ترم (پروژه فرانت‌اند)},
مهلت={یک هفته}
}
```

A project runs for a week, unsupervised, so it needs things an exam question
does not: what to hand in and how, what counts as out of scope, and what a
student should do if an external service it depends on is down or rate-limited.
Put the extra credit in an `امتیازی` environment, as `shopping-basket` does.

## Finals

A final is a thin file: metadata plus the list of questions.

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

\ورودی{questions/validation/main}

\پایان‌ساز
\end{document}
```

Name a final `<year>-<semester>-final.tex`, e.g. `1402-2-final.tex`. Midterm
sheets are named after their project, since a project is reused across
semesters. Do not delete old sheets — they are the record of what was asked.

## What does not belong here

This repository is **public** and it contains answer keys. Do not commit:

- student names, student numbers, submissions, or grades,
- an exam that has not been given yet.

If you need to prepare an unreleased exam, keep it in a private repository until
after it has been sat.
