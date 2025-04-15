"""
latexdiff.py
- COMMIT1: Default hash for the first commit (most recent).
- COMMIT2: Default hash for the second commit.
- `latexdiff` and `pdflatex` must be installed and available in the system PATH.
Note:
- Ensure that the `manuscript.tex` file exists in the specified commits.
- The script performs cleanup by removing intermediate files generated during 
    the process.

- Myeongseok Ryu
- 2025.04.14
"""

import os

COMMIT1 = "6aeb18adc1837a672b27f840c0d8db9bda24ddea" # recent
COMMIT2 = "1e867d3f66016f2603fbf7f1138cdaa9d0be86cb"

SAVE_DIR = "."

def main():

    print(f"       LATEXDIFF       ")
    print(f"                       ")

    commit1     = input(f"Enter the first commit hash (default: {COMMIT1}, or r: current working tree): ")
    commit2     = input(f"Enter the second commit hash (default: {COMMIT2}): ")
    # save_dir    = input(f"Enter the save directory (default: {SAVE_DIR}): ")
        
    if commit1 == "":
        commit1 = COMMIT1
    elif commit1 == "r":
        commit1 = "HEAD"
    if commit2 == "":
        commit2 = COMMIT2

    print(f"Loading manuscript.tex from first commit...")
    print(f"$ git show {commit1}:manuscript.tex > manuscript1.tex")
    os.system(f"git show {commit1}:manuscript.tex > manuscript1.tex")

    print(f"Loading manuscript.tex from second commit...")
    print(f"$ git show {commit2}:manuscript.tex > manuscript2.tex")
    os.system(f"git show {commit2}:manuscript.tex > manuscript2.tex")

    os.system("pdflatex -interaction=batchmode manuscript1.tex")
    os.system("bibtex manuscript1.aux")
    os.system("pdflatex -interaction=batchmode manuscript1.tex")
    os.system("pdflatex -interaction=batchmode manuscript1.tex")

    os.system("pdflatex -interaction=batchmode manuscript2.tex")
    os.system("bibtex manuscript2.aux")
    os.system("pdflatex -interaction=batchmode manuscript2.tex")
    os.system("pdflatex -interaction=batchmode manuscript2.tex")

    print("Running latexdiff...")
    print(f"$ latexdiff --flatten ./manuscript2.tex manuscript1.tex > diff.tex")
    os.system(f"latexdiff --flatten manuscript2.tex manuscript1.tex > diff.tex")

    # return

    print("Running pdflatex...")
    print(f"$ pdflatex diff.tex")
    os.system("pdflatex -interaction=batchmode -interaction=nonstopmode diff.tex")
    os.system("bibtex diff.aux")
    os.system("pdflatex -interaction=batchmode -interaction=nonstopmode diff.tex")
    os.system("pdflatex -interaction=batchmode -interaction=nonstopmode diff.tex")

    print("Cleaning up...")
    os.system("rm manuscript1.tex")
    os.system("rm manuscript2.tex")
    os.system("rm diff.tex")
    os.system("rm *.aux")
    os.system("rm *.log")
    os.system("rm *.out")
    os.system("rm *.bbl")
    os.system("rm *.blg")
    os.system("rm *.run.xml")
    os.system("rm *.toc")   
    os.system("rm *.synctex.gz")
    os.system("rm *.fdb_latexmk")
    os.system("rm *.fls")
    os.system("rm *.spl")

    print("Done! The diff file is saved as diff.tex.")

if __name__ == "__main__":
    main()