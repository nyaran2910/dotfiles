---
name: problem-solver
description: >
  Use this skill whenever a user uploads a PDF containing problems/questions (exam, homework, practice sets)
  and asks for explanations, solutions, or commentary. Triggers include: "問題を解説して", "解説を作って",
  "PDFの問題を説明して", "解き方を教えて", "答えと解説をPDFにまとめて", or any request where
  a PDF with problems (math, science, language arts, English, programming, or mixed) is provided and
  the user wants a structured explanation document. Always use this skill when a problem PDF is uploaded
  alongside words like 解説, 解答, まとめ, TeX, PDF出力, 説明 — even if the request is casual.
  Also triggers when the user does NOT specify a PDF but asks for explanations/solutions — in this case,
  automatically scan the working directory for problem PDFs (see Step 1 for auto-detection logic).
---

# Problem Solver Skill

Generate a polished explanation document (TeX → PDF) from a PDF containing exam/practice problems.
TeX is used so that mathematical expressions are rendered beautifully and precisely.

## Overview of Workflow

1. **Extract** problem text from the uploaded PDF
2. **Analyze** each problem and generate structured explanation content
3. **Create** a formatted `.tex` file with full LaTeX math support
4. **Compile** the `.tex` to PDF via tex-writer skill (`make`)
5. **Output** the final PDF path to the user

---

## Step 1: Locate and Extract Text from PDF

### 1-a. PDF の特定

ユーザーが PDF を明示的に指定した場合はそれを使う。**指定がない場合は以下の順序で自動検索する。**

**自動検索の手順（Glob ツールを使用）:**

1. 作業ディレクトリ（`cwd`）を取得する
2. `Problems`, `Probs`, `Problem`, `問題`, `questions`, `Questions` などの名前を含むサブディレクトリを探す:
   ```
   Glob: {Problems,Probs,Problem,問題,questions,Questions}/**/*.pdf  (cwd 以下)
   ```
3. 上記ディレクトリが見つかった場合 → その中の PDF を候補とする
4. 見つからない場合 → cwd 直下の PDF を候補とする:
   ```
   Glob: *.pdf  (cwd)
   ```
5. 候補が複数ある場合: ファイル名に `問題`, `prob`, `question`, `exam`, `test`, `hw`, `homework`,
   `練習`, `課題` などを含むものを優先して選択する
6. それでも複数残る場合はユーザーに選択を求める
7. 候補が 0 件の場合はユーザーに PDF のパスを尋ねる

### 1-b. PDF の読み込み

特定した PDF を Read ツールで読み込み、問題文を抽出する。

- テキストの抽出を試みる
- テキストの有無に関わらず、図が含まれ場合もあるため生成AIのマルチモーダル機能を用いてPDFを画像として読み込む

---

## Step 2: Generate Explanation Content

This skill produces **完全解答 (complete answer)** format — the standard required for university entrance exams and transfer exams. Every solution must include full working-out, not just the final answer.

For each problem, produce these **6 sections in order**:

1. **問題の概要と方針** — What concept is being tested + the overall approach/strategy before writing a single line of solution
2. **解法の考え方** — The reasoning chain: why this method, what to look for, how to set up
3. **解答（途中式・証明含む完全記述）** — The full written solution as it would appear on an exam answer sheet:
   - Show **every step** of working: assumptions, substitutions, transformations, intermediate results
   - For proofs/証明: write in logical connective style (「〜より」「したがって」「ゆえに」etc.)
   - For calculations: show each line of algebra/arithmetic
   - For essays/記述: write complete sentences in full
4. **∴ 最終解答** — The final answer alone, clearly separated in a highlighted box.
5. **採点ポイント** — What partial credit points examiners look for (部分点の取り方)
6. **ポイント・注意点** — Key insights and common mistakes

### Full Working-Out Standards by Problem Type

| Type | Complete Answer Requirements |
|------|------------------------------|
| 数学（計算） | Every algebraic step on its own line. Never skip steps. Show factoring, substitution, etc. |
| 数学（証明） | Write as formal proof: 「〜と仮定する」→ 変形 →「よって〜が成り立つ」。QED相当の締め。 |
| 理科（物理・化学） | Show formula → substitution → unit conversion → result with units |
| 国語・現代文 | Full sentence answers quoting the original text. Explain the logical connection. |
| 英語（和訳） | Full Japanese sentence. Note grammar structures and word choices explicitly. |
| プログラミング | Full working code + line-by-line annotation of logic |
| 混合 | Apply the relevant standard per sub-problem |

---

## Step 3: Create the .tex Document

### Required packages and preamble

```latex
\documentclass[12pt,a4paper]{article}

% Japanese support (lualatex)
\usepackage{luatexja}
% If using pdflatex instead:
% \usepackage[utf8]{inputenc}
% \usepackage{CJKutf8}

% Math
\usepackage{amsmath, amssymb, amsthm}
\usepackage{mathtools}

% Layout & styling
\usepackage{geometry}
\geometry{margin=25mm}
\usepackage{parskip}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{mdframed}
\usepackage{titlesec}
\usepackage{fancyhdr}
\usepackage{hyperref}

% Colors
\definecolor{problemgray}{RGB}{242,242,242}
\definecolor{answergreen}{RGB}{226,239,218}
\definecolor{headingblue}{RGB}{46,116,181}
\definecolor{navydark}{RGB}{31,56,100}

% Section formatting
\titleformat{\section}{\large\bfseries\color{navydark}}{}{0em}{}[\titlerule]
\titleformat{\subsection}{\normalsize\bfseries\color{headingblue}}{}{0em}{}

% Boxed environments
\newmdenv[backgroundcolor=problemgray, linecolor=headingblue,
          linewidth=3pt, topline=false, bottomline=false,
          rightline=false, skipabove=6pt, skipbelow=6pt]{problembox}
\newmdenv[backgroundcolor=answergreen, linecolor=answergreen,
          linewidth=1pt, skipabove=6pt, skipbelow=6pt]{answerbox}

% Header/footer
\pagestyle{fancy}
\fancyhf{}
\rhead{問題解説集}
\lhead{\leftmark}
\cfoot{\thepage}
```

### Document Structure Template

```latex
\begin{document}

% Title page
\begin{titlepage}
  \centering
  \vspace*{3cm}
  {\Huge\bfseries\color{navydark} 問題解説集}\\[1cm]
  {\large ファイル名または日付}\\[2cm]
  \vfill
\end{titlepage}

\tableofcontents
\newpage

% ---- Repeat for each problem ----
\section{問題 1}

\begin{problembox}
問題文をここに再掲。インライン数式は \( f(x) = x^2 \)、
ディスプレイ数式は
\[
  \int_0^1 f(x)\,dx = \frac{1}{3}
\]
\end{problembox}

\subsection{📌 概要と方針}
問われている概念と解法の方向性。

\subsection{💡 解法の考え方}
なぜこの手法を選ぶか、どう設定するか。

\subsection{📝 解答（完全記述）}
各ステップを示す。
\begin{align}
  f(x) &= x^2 + 2x + 1 \\
       &= (x+1)^2
\end{align}
よって $f(x) \geq 0$（$x = -1$ のとき等号成立）。

\subsection{∴ 最終解答}
\begin{answerbox}
\textbf{$\therefore$} $\displaystyle x = \frac{-1 \pm \sqrt{5}}{2}$
\end{answerbox}

\subsection{🎯 採点ポイント}
\begin{itemize}
  \item 途中式の各ステップ
  \item 単位の明記
\end{itemize}

\subsection{⚠️ ポイント・注意点}
よくある間違いや重要な注意点。

\end{document}
```

### Math Notation Quick Reference

| 数式 | LaTeX |
|------|-------|
| 分数 | `\frac{a}{b}` |
| 平方根 | `\sqrt{x}`, `\sqrt[n]{x}` |
| 積分 | `\int_a^b f(x)\,dx` |
| 総和 | `\sum_{i=1}^{n} a_i` |
| 極限 | `\lim_{x \to 0}` |
| 行列 | `\begin{pmatrix} a & b \\ c & d \end{pmatrix}` |
| 連立方程式 | `\begin{cases} x+y=1 \\ x-y=0 \end{cases}` |
| ゆえに | `\therefore` |
| なぜなら | `\because` |
| 論理包含 | `\Rightarrow`, `\Leftrightarrow` |
| 集合 | `\in`, `\subset`, `\cup`, `\cap` |

---

## Step 4: Compile .tex → PDF

**tex-writer スキルを使う。ただし、すべての中間ファイル（.tex / Makefile / .log 等）はエージェントの一時作業ディレクトリ内でのみ扱い、ユーザーの作業ディレクトリには一切書き出さない。**

手順:
1. エージェントの一時作業ディレクトリ（例: `/tmp/problem-solver-<uuid>/`）を `mkdir -p` で作成する
2. その一時ディレクトリ内に `.tex` ファイルを Write で作成する
3. tex-writer スキルを呼び出して Makefile の生成とビルドを委譲する（一時ディレクトリを workdir として渡す）
4. ビルドが成功したら一時ディレクトリ内の PDF を取得する
5. その PDF を **Step 5 で決定した出力先ディレクトリ** にコピーする
6. 一時ディレクトリは削除しても構わない（`rm -rf`）

```bash
# 例
TMPDIR=$(mktemp -d /tmp/problem-solver-XXXX)
# ... Write: $TMPDIR/explanation.tex ...
# ... tex-writer skill builds inside $TMPDIR ...
cp "$TMPDIR/explanation.pdf" "$OUTPUT_DIR/解説.pdf"
rm -rf "$TMPDIR"
```

ユーザーの作業ディレクトリに残るのは **最終 PDF のみ**。

---

## Step 5: Output Files

### 出力先の自動判定

以下の順序で出力先ディレクトリを決定する（Glob ツールを使用）:

1. cwd 直下に `Answers`, `Answer`, `answers`, `answer`, `解答`, `解説`, `Solutions`, `solution`, `Output`, `output` などの名前を含むディレクトリがあるか確認する:
   ```
   Glob: {Answers,Answer,answers,answer,解答,解説,Solutions,solution,Output,output}/  (cwd)
   ```
2. **見つかった場合** → そのディレクトリを出力先とする
3. **見つからない場合** → cwd 直下を出力先とする（サブディレクトリは作らない）

### PDF のコピー

Step 4 で生成した PDF を出力先ディレクトリにコピーする。
ファイル名は `解説.pdf`（デフォルト）または入力 PDF 名をベースにした `<元のファイル名>_解説.pdf` とする。

最後に出力先フルパスをユーザーに伝える。

---

## Quality Checklist

Before finalizing, verify:

- [ ] All problems from the source PDF are covered (none skipped)
- [ ] Each problem has all **6 sections** (概要と方針, 考え方, 完全記述, 最終解答ボックス, 採点ポイント, 注意点)
- [ ] Section 3 (完全記述) shows **every step** — no skipped lines
- [ ] Section 4 (最終解答) is **visually separate** from section 3 (green box, bold, ∴)
- [ ] All math is in proper LaTeX (`$...$` inline, `\[...\]` or `align` for display)
- [ ] Proofs use logical connective language + `\therefore`
- [ ] PDF compiled without fatal errors (log clean, file size > 0)
- [ ] Table of contents renders correctly (ran compiler twice)

---

## Error Handling

| Issue | Fix |
|-------|-----|
| PDF text extraction empty | ユーザーに問題文をテキストで貼り付けてもらうよう依頼する |
| `lualatex` not found | ローカルに TeX Live がインストールされているか確認する（`which lualatex`）。未インストールの場合はユーザーに TeX Live のインストールを案内する |
| Japanese garbled in pdflatex | Switch to lualatex + `\usepackage{luatexja}` |
| `! Undefined control sequence` | Check preamble for missing `\usepackage` |
| Math compile error | Wrap in `$...$` or `\[...\]`; escape `_ ^ { } &` outside math mode |
| PDF missing after compile | Tail `.log` for fatal errors; fix and recompile |
| Overfull hbox | Add `\allowdisplaybreaks` or split equations with `align` |
