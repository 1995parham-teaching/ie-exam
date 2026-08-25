% Named ie-exam rather than exam: TeX Live ships its own exam.cls, and a
% document that asks for `exam` can silently get that one instead.
\ProvidesClass{ie-exam}
              [IE exam Theme]

\RequirePackage{minted}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
% Questions and projects refer to their images by a path relative to src/, so
% both subdirectories are searched and a question can move between them
% without rewriting every \درج‌تصویر.
\graphicspath{{questions/}{projects/}{./}}
\RequirePackage{enumerate}
\RequirePackage{keyval}

% Questions use LightGray as a minted background; it is not one of the
% dvipsnames, so define it here rather than pulling in another colour set.
\definecolor{LightGray}{gray}{0.92}

\LoadClass[]{article}

\RequirePackage{hyperref}
\RequirePackage[
 a4paper,
 left=2.2cm,
 right=2.2cm,
 top=2.5cm,
 bottom=2.5cm
]{geometry}

% The Persian command aliases (\قسمت, \فقره, \متن‌لاتین, ...) come from this
% option. It was spelled [localise] before TeX Live 2023 and is [localize] now.
\RequirePackage[localize]{xepersian}

\newcommand\Extra{\textcolor{Orange}{امتیازی.}}
\newenvironment{extra}{
  \begin{quote}
  \color{Orange}
  \textbf{امتیازی.}
}{
  \end{quote}
}
\eqenvironment{امتیازی}{extra}

% Answers are hidden unless the document is built with `make answers`, which
% defines \showanswers before the class is loaded.
%
% The hidden case typesets the answer into a box that is thrown away, rather
% than skipping the source text. Skipping needs the terminator to be found
% textually, which cannot work here: the questions close the block with the
% localised \پایان{پاسخ}, and the scanner would be looking for \end{answer}.
\newif\ifie@answers
\@ifundefined{showanswers}{\ie@answersfalse}{\ie@answerstrue}
\newsavebox{\ie@answerbox}

\newenvironment{answer}
{%
  \ifie@answers
    \vspace{5mm}
    {%
      \color{WildStrawberry}
      \rule{\linewidth}{0.5pt}\\
      \textbf{پاسخ.}\\
    }%
  \else
    \setbox\ie@answerbox\vbox\bgroup
  \fi
}
{%
  \ifie@answers\else\egroup\fi
}
\eqenvironment{پاسخ}{answer}


\setlength{\parindent}{0pt}
\renewcommand{\baselinestretch}{1.5}

% \mark is a TeX primitive, hence the longer name.
\newcommand{\questionmark}[1]{{\hfill\textcolor{Gray}{\textbf{#1 نمره}}\par}}
\eqcommand{نمره}{questionmark}

\newcommand{\examdate}{\@date}
\eqcommand{تاریخ‌آزمون}{examdate}

\eqcommand{جزئیات‌آزمون}{examdetails}
\eqcommand{پایان‌ساز}{makefooter}
\eqcommand{تارنما}{href}

\define@key{exam}{دانشگاه}[]{\gdef\@university{#1}}
\define@key{exam}{ترم}[]{\gdef\@semester{#1}}
\define@key{exam}{زمان}[]{\gdef\@duration{#1}}
\define@key{exam}{مهلت}[]{\gdef\@deadline{#1}}
\define@key{exam}{نام}[]{\gdef\@exam{#1}}
\def\examdetails#1{{\setkeys{exam}{#1}}}

% A midterm does not set every field a final does, so the cover page prints a
% line only when its value exists and is not empty.
\newcommand{\ie@line}[1]{%
  \expandafter\ifx\csname #1\endcsname\relax\else
    \expandafter\ifx\csname #1\endcsname\@empty\else
      \csname #1\endcsname\\
    \fi
  \fi
}

% xepersian installs its own \maketitle for the document class after this
% class is read, so the cover page is defined once every package is loaded.
\AtBeginDocument{%
  \renewcommand{\maketitle}{%
    \begin{center}
      \vspace*{1cm}

      \Huge\textbf{\@title}

      \vspace{0.5cm}
      \Large
      \ie@line{@exam}
      \ie@line{@semester}
      \@date

      \vspace{1cm}

      \textbf{\@author}

      \@ifundefined{@duration}{}{%
      زمان آزمون: \@duration\space دقیقه
      }

      \@ifundefined{@deadline}{}{%
      مهلت تحویل: \@deadline
      }

      \vspace{0.5cm}

      \@university
    \end{center}
  }
}

\newcommand{\makefooter}{%
  \vfill
  \begin{flushleft}
    موفق و موید باشید
  \end{flushleft}
  \begin{center}
    این سند برپایه بسته \متن‌لاتین{\زی‌پرشین} گونه \متن‌لاتین{\گونه‌زی‌پرشین} توسعه پیدا کرده است.
    نگارش شده به تاریخ \@date
  \end{center}
}

% Vazirmatn has no italic, so its slanted shape is synthesised.
\settextfont[
  Path = ../fonts/,
  Extension = .ttf,
  UprightFont = *-Regular,
  BoldFont = *-Bold,
  AutoFakeSlant = 0.15
]{Vazirmatn}

\setlatintextfont[
  Path = ../fonts/,
  Extension = .ttf,
  UprightFont = *-Regular,
  BoldFont = *-Bold,
  ItalicFont = *-Italic
]{Roboto}
