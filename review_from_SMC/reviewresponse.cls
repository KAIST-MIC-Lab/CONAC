\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{reviewresponse}[2025/01/16 v2.0.1 class for writing rebuttal letters for reviews of submitted papers]
% Author: Karl-Ludwig Besser
% Email: karl-ludwig.besser@liu.se

\RequirePackage{kvoptions}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}


\RequirePackage[breakable,skins]{tcolorbox}
\RequirePackage{xcolor}


\newcommand*{\journal}[1]{\renewcommand*{\@journal}{#1}}
\newcommand*{\@journal}{}
\newcommand*{\editorname}[1]{\renewcommand*{\@editorname}{#1}}
\newcommand*{\@editorname}{}
\newcommand*{\manuscript}[1]{\renewcommand*{\@manuscript}{#1}}
\newcommand*{\@manuscript}{}

\newcommand*{\thetitle}{\@title}
\newcommand*{\theauthor}{\@author}
\newcommand*{\thedate}{\@date}
\newcommand*{\theeditor}{\@editorname}
\newcommand*{\themanuscript}{\@manuscript}

\newcommand{\listprioH}{}
\newcommand{\listprioM}{}
\newcommand{\listprioL}{}

%%% Colors
\definecolor{colorcommentfg}{RGB}{0,63,87}
\definecolor{colorcommentbg}{HTML}{e0f0f6}
\definecolor{colorcommentframe}{RGB}{0,112,155}

\colorlet{colorchangebg}{black!2}
\colorlet{colorchangeframe}{black!20}

\colorlet{colorconcludingresponsefg}{black!80}
\colorlet{colorconcludingresponsebg}{black!2}
\colorlet{colorconcludingresponseframe}{black!20}
%%%


%%% General Settings
\setlength{\parindent}{0pt}
\setlength{\parskip}{.3em plus .2em minus .3em}
\renewcommand{\baselinestretch}{1.5}

\widowpenalty10000
\clubpenalty10000
%%%

%%% Counters
\newcounter{reviewer}
\setcounter{reviewer}{0}
\newcounter{revcomment}[reviewer]
\setcounter{revcomment}{0}
%%%

%%% Commands
\renewcommand*{\maketitle}{%
	\begin{titlepage}
		\begin{center}
			\vspace*{1cm}
			\large{Responses to Reviewers' Comments for Manuscript \@manuscript}\\
			
			\vspace{1cm}
			\textbf{\LARGE{\@title}}\\
			\vspace{1cm}
			\large{Addressed Comments for Publication to}
			
			\Large{\@journal}
			
			\large{by}
			
			{\large{\@author}}
		\end{center}
	\end{titlepage}
}

\newcommand*{\generalhowto}{
	\clearpage
	% \@ifundefined{pdfbookmark}{}{%
	% 	\pdfbookmark[1]{Reponse to the Editor}{hyperref@editor}%
	% }%
	\section*{General Approach of How to Answering Comments}
}

\newcommand*{\editor}{
	\clearpage
	\addcontentsline{toc}{section}{Author's Response to the Editor} % Add to TOC
	\@ifundefined{pdfbookmark}{}{%
		\pdfbookmark[1]{Reponse to the Editor}{hyperref@editor}%
	}%
	\section*{Authors' Response to the Editor}
}

\newcommand*{\reviewer}{
	\clearpage
	\refstepcounter{reviewer}%
	\addcontentsline{toc}{section}{Reviewer \arabic{reviewer}} % Add to TOC
	\@ifundefined{pdfbookmark}{}{%
		\pdfbookmark[1]{Reviewer \arabic{reviewer}}{hyperref@reviewer\arabic{reviewer}}%
	}%
	\section*{Authors' Response to Reviewer~\arabic{reviewer}}
}
%%%

%%% Blocks %%%
\newenvironment{generalcomment}{%
	\addcontentsline{toc}{subsection}{General Comments}%
	\begin{tcolorbox}[attach title to upper, title={General Comments}, after title={.\enskip}, fonttitle={\bfseries}, coltitle={colorcommentfg}, colback={colorcommentbg}, colframe={colorcommentframe},bookmark={General Comments}]
	}{\end{tcolorbox}}


% colors for priority levels
\definecolor{prio1}{HTML}{D32F2F} % High: Red
\definecolor{prio2}{HTML}{F57C00} % Medium: Orange
\definecolor{prio3}{HTML}{1976D2} % Low: Blue

\renewcommand{\therevcomment}{\the\value{reviewer}.\the\value{revcomment}}

\newenvironment{revcomment}[2][3]{% 
    \refstepcounter{revcomment}
    
    \edef\currentrevno{\the\value{reviewer}}
    \edef\currentcomno{\the\value{revcomment}}
    
    \edef\@currentlabel{\currentrevno.\currentcomno}
    \def\currlabel{rev:r\currentrevno c\currentcomno}
    \label{\currlabel}
    
    \addcontentsline{toc}{subsection}{Comment \currentcomno}

    \ifnum#1=1
        \def\priotxt{High Priority} \colorlet{prioframe}{prio1} \colorlet{priobg}{prio1!5}
    \else\ifnum#1=2
        \def\priotxt{Medium Priority} \colorlet{prioframe}{prio2} \colorlet{priobg}{prio2!5}
    \else
        \def\priotxt{Low Priority} \colorlet{prioframe}{prio3} \colorlet{priobg}{prio3!5}
    \fi\fi

    \begin{tcolorbox}[
        adjusted title={Reviewer \currentrevno{} Comment \currentcomno{} \hfill [\priotxt]}, 
        fonttitle={\bfseries}, 
        colback={priobg}, 
        colframe={prioframe},
        coltitle={white}, 
        bookmark={Reviewer \currentrevno{} Comment \currentcomno},
        #2
    ]
}{\end{tcolorbox}}

\newenvironment{howtoanswer}[1][{}]{%
	\textbf{How to answer:} #1\par
}{\vspace{1em plus 0.2em minus 1.5em}}

\newenvironment{revresponse}[1][{Thank you for the comment.}]{%
	\textbf{Response:} #1\par
}{\vspace{4em plus 0.2em minus 1.5em}}

\newenvironment{concludingresponse}[1][]{%
	\begin{tcolorbox}[attach title to upper, breakable, title={Concluding Response #1}, after title={.\enskip}, fonttitle={\bfseries}, coltitle={colorconcludingresponsefg}, colback={colorconcludingresponsebg}, colframe={colorconcludingresponseframe},]
	}{\end{tcolorbox}}

\newenvironment{changes}{\begin{tcolorbox}[breakable,colback={colorchangebg}, colframe={colorchangeframe},enhanced jigsaw,]
	}{\end{tcolorbox}}

\newcommand{\printpartbibliography}[1]{\begin{refsegment}\nocite{#1}\printbibliography[heading=none,segment=\therefsegment]\end{refsegment}}


\providecommand*{\revcommentautorefname}{Comment}
\AddToHook{package/hyperref/after}{
	\hypersetup{
		bookmarksopen,
		pdfcreator={LaTeX with the reviewresponse package},
	}
}
\AddToHook{begindocument/before}{
	\IfPackageLoadedTF{hyperref}{
		\hypersetup{
			pdfauthor={\@author},
			pdftitle={Review Response -- \@title{}},
			pdfkeywords={\@journal{}, \@manuscript{}, review response}
		}
	}{}
}
\AddToHook{begindocument/end}{\def\sectionautorefname{Reviewer}}