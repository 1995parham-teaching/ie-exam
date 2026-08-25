% Named ie-exam rather than exam: TeX Live ships its own exam.cls, and a
% document that asks for `exam` can silently get that one instead.
\ProvidesClass{ie-exam}
              [2026/08/25 Internet Engineering exams and midterms]

\LoadClass[]{article}

\RequirePackage[
  a4paper,
  left=2.2cm,
  right=2.2cm,
  top=2.7cm,
  bottom=2.5cm,
  headsep=0.7cm
]{geometry}

% Everything that is not the cover page of an exam lives in teaching-base:
% the palette, the fonts, the sectioning, the listings, the callout boxes,
% the marks and the answer blocks.
\RequirePackage[latin=Roboto]{teaching-base}

% Questions and projects refer to their images by a path relative to src/, so
% both subdirectories are searched and a question can move between them
% without rewriting every \درج‌تصویر.
\graphicspath{{questions/}{projects/}{./}}

\date{\persiantoday}

% ------------------------------------------------------------- metadata ---
%
%   \جزئیات‌آزمون{
%     دانشگاه={دانشگاه صنعتی امیرکبیر},
%     نام={آزمون پایانی},
%     ترم={نیم‌سال دوم ۱۴۰۲-۱۴۰۳},
%     زمان={۹۰}          % a final: minutes in the room
%     مهلت={یک هفته}     % a midterm: how long they have at home
%   }

\define@key{exam}{دانشگاه}[]{\gdef\@university{#1}}
\define@key{exam}{ترم}[]{\gdef\@semester{#1}}
\define@key{exam}{زمان}[]{\gdef\@duration{#1}}
\define@key{exam}{مهلت}[]{\gdef\@deadline{#1}}
\define@key{exam}{نام}[]{\gdef\@exam{#1}}
\def\examdetails#1{{\setkeys{exam}{#1}}}
\eqcommand{جزئیات‌آزمون}{examdetails}

\newcommand{\examdate}{\@date}
\eqcommand{تاریخ‌آزمون}{examdate}

% A midterm does not set every field a final does, so the cover page prints a
% line only when its value exists and is not empty.
\newcommand{\ie@line}[1]{%
  \expandafter\ifx\csname #1\endcsname\relax\else
    \expandafter\ifx\csname #1\endcsname\@empty\else
      \csname #1\endcsname\\
    \fi
  \fi
}

% -------------------------------------------------------- grading table ---
%
% Every \نمره{۲} writes its question number and weight into the .aux file.
% They are collected here and printed on the cover as the table to mark in,
% which means the table appears from the second run onwards — latexmk does
% that run on its own.

\newcommand{\ie@marks}{}
\newcommand{\ie@markrow}[2]{#1 & #2 & \\ \hline}
\renewcommand{\tb@markentry}[2]{%
  \g@addto@macro\ie@marks{\ie@markrow{#1}{#2}}%
}

\newcommand{\gradingtable}{%
  \ifx\ie@marks\@empty\else
    \begin{center}
      \small
      \begin{tabular}{|c|c|p{2.4cm}|}
        \hline
        \textbf{\ \ سوال\ \ } & \textbf{\ \ بارم\ \ } & \textbf{نمره} \\
        \hline
        \ie@marks
      \end{tabular}
    \end{center}
  \fi
}
\eqcommand{جدول‌نمرات}{gradingtable}

% ------------------------------------------------------------- the cover ---
%
% xepersian installs its own \maketitle for the document class after this
% class is read, so the cover page is defined once every package is loaded.

\AtBeginDocument{%
  \runninghead{\@title}%
  \@ifundefined{@exam}{}{\runningfoot{\@exam}}%
  \renewcommand{\maketitle}{%
    \thispagestyle{plain}
    \begin{center}
      \vspace*{0.5cm}

      {\color{tbaccentline}\rule{0.35\linewidth}{1pt}}

      \vspace{0.6cm}

      {\Huge\bfseries\color{tbaccent}\@title}

      \vspace{0.35cm}

      {\color{tbaccentline}\rule{0.35\linewidth}{1pt}}

      \vspace{0.8cm}

      {\Large
        \ie@line{@exam}
        \ie@line{@semester}
        \@date
      }

      \vspace{0.8cm}

      {\large\bfseries\@author}

      \vspace{0.2cm}

      {\color{tbmuted}\@university}

      \vspace{0.6cm}

      \@ifundefined{@duration}{}{%
        \colorbox{tbaccentsoft}{\color{tbaccent}\textbf{زمان آزمون: \@duration\space دقیقه}}%
      }
      \@ifundefined{@deadline}{}{%
        \colorbox{tbaccentsoft}{\color{tbaccent}\textbf{مهلت تحویل: \@deadline}}%
      }

      \vspace{1cm}

      \begin{minipage}{0.8\linewidth}
        \small
        نام و نام خانوادگی: \hrulefill\hspace{0.6cm} شماره دانشجویی: \hrulefill
      \end{minipage}

      \vspace{0.9cm}

      \gradingtable
    \end{center}
    \newpage
  }%
}

\endinput
