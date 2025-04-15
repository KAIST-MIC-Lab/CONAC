"""
latexdiff.py
- COMMIT1: new commit hash.
- COMMIT2: old commit hash.

OUTPUT:
- diff.pdf

- Myeongseok Ryu
- 2025.04.14
"""

import os
import subprocess

COMMIT1 = "6aeb18adc1837a672b27f840c0d8db9bda24ddea" # new
COMMIT2 = "732664d84fa6e31b4a6167434ca7f8a5d4d41687" # old
TEX_FILE_NAME = "{tex_file_name}"

SAVE_DIR = "."

def run_terminal_command(command):
    print(f"$ {command}")
    os.system(command)

def compile_tex(file_name):
    run_terminal_command("pdflatex -interaction=batchmode {file_name}")
    run_terminal_command("bibtex {file_name[:-4]}.aux")
    run_terminal_command("pdflatex -interaction=batchmode {file_name}")
    run_terminal_command("pdflatex -interaction=batchmode {file_name}")

def clean_up():
    print("Cleaning up...")
    run_terminal_command("rm tmp1.tex")
    run_terminal_command("rm tmp2.tex")
    run_terminal_command("rm tmp1.pdf")
    run_terminal_command("rm tmp2.pdf")
    run_terminal_command("rm diff.tex")
    run_terminal_command("rm *.aux")
    run_terminal_command("rm *.log")
    run_terminal_command("rm *.out")
    run_terminal_command("rm *.bbl")
    run_terminal_command("rm *.blg")
    run_terminal_command("rm *.run.xml")
    run_terminal_command("rm *.toc")   
    run_terminal_command("rm *.synctex.gz")
    run_terminal_command("rm *.fdb_latexmk")
    run_terminal_command("rm *.fls")
    run_terminal_command("rm *.spl")
    run_terminal_command("rm *.dvi")

def main():
    print(f"""  
        *** LATEXDIFF ***
        Myeonsgeok Ryu

        INPUT OPTIONS:
        - r: current working tree
        - h: HEAD
        - p: relatively previous
        """)

    # -----------------------------
    # Get input arguments
    # -----------------------------
    tex_file_name = input(f"Enter the tex file name (default: {TEX_FILE_NAME}): ")

    if tex_file_name == "":
        tex_file_name = TEX_FILE_NAME

    commit1     = input(f"Enter the first commit hash of new one (r/H/SHA): ")
        
    if commit1 == "":
        ValueError("Please enter the commit hash.")
    elif commit1 == "p":
        ValueError("option p is not available for the first commit.")
    elif commit1 == "h":
        commit1 = "HEAD"

    commit2     = input(f"Enter the second commit hash of old one (r/p/SHA): ")

    if commit2 == "":
        ValueError("Please enter the second commit hash.")
    elif commit2 == "p":
        commit2 = subprocess.check_output(["git", "rev-parse", f"{commit1}^"]).decode("utf-8").strip()
    elif commit2 == "h":
        commit2 = "HEAD"
    
    try:
        # -----------------------------
        # checkout the commit
        # -----------------------------
        if commit1 == "r":
            run_terminal_command(f"cp {tex_file_name} tmp1.tex")
        else:
            run_terminal_command(f"git show {commit1}:{tex_file_name} > tmp1.tex")
            run_terminal_command(f"git show {commit1}:{tex_file_name} > tmp1.tex")

        run_terminal_command(f"git show {commit2}:{tex_file_name} > tmp2.tex")

        compile_tex("tmp1.tex")
        compile_tex("tmp2.tex")
        run_terminal_command(f"latexdiff --flatten tmp2.tex tmp1.tex > diff.tex")
        compile_tex("diff.tex")

        clean_up()

        print("Done! The diff file is saved as diff.tex.")
    
    except Exception as e:
        print("An error occurred while processing the LaTeX files.")
        print(f"Error: {e}")

        clean_up()

if __name__ == "__main__":
    main()