\ProvidesClass{weekschedule}[2024/12/07 Weekly Schedule Class]

\LoadClass{article}
\pagestyle{empty}

% Basic packages and settings
\RequirePackage[margin=1in]{geometry}
\RequirePackage{ifthen}
\RequirePackage{amssymb}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\renewcommand{\familydefault}{\sfdefault}

% No paragraph indentation for clean alignment
\setlength{\parindent}{0pt}

\RequirePackage{tikz}
\RequirePackage{tabularx}


\RequirePackage{xcolor}
\definecolor{darkgray}{rgb}{0.35, 0.35, 0.35} % Define dark gray
\color{darkgray} % Set all text to dark gray

% Update TikZ defaults
\RequirePackage{tikz}
\tikzset{every path/.style={draw=darkgray}}
\tikzset{every node/.style={text=darkgray}}



% Panel heights (fixed)
\newlength{\TitleHeight}\setlength{\TitleHeight}{1cm}
\newlength{\FooterHeight}\setlength{\FooterHeight}{1cm}
\newlength{\BodyHeight}\setlength{\BodyHeight}{18cm}
\newlength{\ScheduleWidth}\setlength{\ScheduleWidth}{6cm}
\newlength{\RightPanelWidth}\setlength{\RightPanelWidth}{8cm}

% Week info
\newcommand{\WeekStartDate}{}
\newcommand{\WeekEndDate}{}
\newcommand{\WeekStartDay}{}
\newcommand{\WeekEndDay}{}

\newcommand{\SetupWeek}[4]{
  \renewcommand{\WeekStartDate}{#1}%
  \renewcommand{\WeekEndDate}{#2}%
  \renewcommand{\WeekStartDay}{#3}%
  \renewcommand{\WeekEndDay}{#4}%
}

% Heading toggles
\newif\ifShowScheduleHeading
\ShowScheduleHeadingtrue
\newif\ifShowDailyToDosHeading
\ShowDailyToDosHeadingtrue
\newif\ifShowNotesHeading
\ShowNotesHeadingtrue

% Page layout environments
\newenvironment{PageLayout}{
  \clearpage
  \noindent
  \raggedright
}{\par}

\newenvironment{TitlePanel}{
  \vspace*{0pt}\noindent\raggedright
  \begin{minipage}[t][\TitleHeight][t]{\textwidth}
}{
  \end{minipage}\vspace{0pt}
}

\newenvironment{BodyPanel}{
  \noindent\raggedright
  \begin{minipage}[t][\BodyHeight][t]{\textwidth}
}{
  \end{minipage}
}

\newenvironment{FooterPanel}{
  \noindent\raggedright
  \begin{minipage}[t][\FooterHeight][t]{\textwidth}
}{
  \end{minipage}
}

% Hour formatter
\newcommand{\TwoDigitHour}[1]{\ifnum#1<10 0#1\else #1\fi}

% Extract first char
\makeatletter
\def\GetFirstChar#1{\expandafter\GetFirstCharAux#1\relax}
\def\GetFirstCharAux#1#2\relax{#1}
\makeatother

% Day name formatting
\newcommand{\FormatDayName}[2]{%
  \ifthenelse{\equal{#2}{long}}{#1}{%
    \uppercase{\GetFirstChar{#1}}%
  }%
}

% Schedule TikZ
\newsavebox{\ScheduleBox}
\savebox{\ScheduleBox}{
  \begin{tikzpicture}[x=1pt,y=1pt]
    \def\spacing{6mm}
    % Hours at (0cm,...) with anchor=west: no extra braces
    % Lines start at 0.5cm
    \foreach \i in {0,...,32} {
      \pgfmathtruncatemacro{\hours}{6 + floor((32-\i)/2)}
      \pgfmathtruncatemacro{\half}{mod(\i,2)}

      \draw[gray] (0.5cm,\i*\spacing) -- (\ScheduleWidth,\i*\spacing);

      \ifnum\half=0
        \node[anchor=west] at (0cm,\i*\spacing) {\sffamily \scriptsize \TwoDigitHour{\hours}};
      \fi
    }
  \end{tikzpicture}
}

% To-do bullets
\newsavebox{\ToDoBox}
\savebox{\ToDoBox}{
  \begin{tikzpicture}[x=1pt,y=1pt]
    \foreach \idx in {0,...,8} {
      \pgfmathsetmacro{\currentY}{9-1-(\idx*1.0)}
      \node[anchor=west] at (0pt,\currentY cm) {$\square$};
    }
  \end{tikzpicture}
}

% PrintDailyPage
\newcommand{\PrintDailyPage}[3][]{%
  \begin{PageLayout}
    \begin{TitlePanel}
      {\Large \textbf{\FormatDayName{#2}{#1}}\hspace{1em} #3}
    \end{TitlePanel}
    \begin{BodyPanel}
      % tabular with three columns: schedule, spacer, right panel
      \begin{tabular}{@{}p{\ScheduleWidth}p{1cm}p{\RightPanelWidth}@{}}
        % Left column (schedule)
        \begin{minipage}[t][\BodyHeight][t]{\ScheduleWidth}
          \ifShowScheduleHeading
            {\bf Schedule}\\
            %\rule{\linewidth}{0.4pt}
            \\[0.5em]
          \fi
          \usebox{\ScheduleBox}
        \end{minipage}
        &
        % Middle column (1cm space) - empty
        %
        &
        % Right column (to-dos and notes)
        \begin{minipage}[t][\BodyHeight][t]{\RightPanelWidth}
          \ifShowDailyToDosHeading
            {\bf Daily To-Do's}\\
            %\rule{\linewidth}{0.4pt}
            \\[0.5em]
          \fi
          \vspace{0.5em}
          \usebox{\ToDoBox}

          \vfill

          \ifShowNotesHeading
            {\bf Notes}\\
            %\rule{\linewidth}{0.5pt}\\[1em]
            \\ [0.5em]
          \fi
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
        \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
          \rule{\textwidth}{0.1pt}\\[1em]
        \end{minipage}\\
      \end{tabular}
    \end{BodyPanel}
    \begin{FooterPanel}\end{FooterPanel}
  \end{PageLayout}
}

% Weekly pages
\newcommand{\PrintWeeklyTodoPage}{
  \begin{PageLayout}
    \begin{TitlePanel}
      {\large \textbf{To-do's for the week of \WeekStartDate{} - \WeekEndDate{}}}
    \end{TitlePanel}
    \begin{BodyPanel}
      \begin{itemize}
        \item[] $\square$
        \item[] $\square$
        \item[] $\square$
        \item[] $\square$
        \item[] $\square$
        \item[] $\square$
        \item[] $\square$
      \end{itemize}
    \end{BodyPanel}
    \begin{FooterPanel}\end{FooterPanel}
  \end{PageLayout}
}

\newcommand{\PrintWeeklySummaryPage}{
  \begin{PageLayout}
    \begin{TitlePanel}
      {\large \textbf{Summary for the week of \WeekStartDate{} - \WeekEndDate{}}}
    \end{TitlePanel}
    \begin{BodyPanel}
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
      \rule{\textwidth}{0.1pt}\\[1em]
    \end{BodyPanel}
    \begin{FooterPanel}\end{FooterPanel}
  \end{PageLayout}
}

\newcommand{\PrintWeek}{
  %\ifthenelse{\equal{\WeekStartDay}{Monday}}{\PrintWeeklyTodoPage}{}
  \ifthenelse{\equal{\WeekEndDay}{Sunday}}{\AtEndDocument{\PrintWeeklySummaryPage}}{}
}
\endinput
