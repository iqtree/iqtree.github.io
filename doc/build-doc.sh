#! /bin/bash

dest_dir="."

files="Front.md Home.md Quickstart.md Web-Server-Tutorial.md Tutorial.md Advanced-Tutorial.md Assessing-Phylogenetic-Assumptions.md Concordance-Factor.md Dating.md Rootstrap.md AliSim.md Command-Reference.md Substitution-Models.md Complex-Models.md Polymorphism-Aware-Models.md Compilation-Guide.md Frequently-Asked-Questions.md Back.md"

#generate pdf
cd $dest_dir
pdf="iqtree-doc.pdf"
cat $files | sed 's/]([a-zA-Z\-]*#/](#/g' | sed 's/(Quickstart)/(#getting-started)/g' | sed 's/(Web-Server-Tutorial)/(#web-server-tutorial)/g' |  sed 's/(Tutorial)/(#beginners-tutorial)/g' | sed 's/(Advanced-Tutorial)/(#advanced-tutorial)/g' | sed 's/(Command-Reference)/(#command-reference)/g' | sed 's/(Substitution-Models)/(#substitution-models)/g' | sed 's/(Complex-Models)/(#complex-models)/g' | sed 's/(Polymorphism-Aware-Models)/(#polymorphism-aware-models)/g' | sed 's/(Compilation-Guide)/(#compilation-guide)/g' | sed 's/(Frequently-Asked-Questions)/(#frequently-asked-questions)/g' | sed 's/{:.*}//g' > iqtree-doc.md
pandoc iqtree-doc.md --number-sections --listings --pdf-engine=xelatex -o $pdf
echo "Generated $dest_dir/$pdf"
rm iqtree-doc.md
