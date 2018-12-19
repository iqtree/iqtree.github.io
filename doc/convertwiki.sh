#! /bin/bash

if [ "$2" == "" ]; then
	echo "Usage: $0 source_dir dest_dir [-redo]"
	exit 1
fi

source_dir=$1
dest_dir=`cd $2; pwd`

cd $source_dir

file_changed=0

files="Front.md Home.md Quickstart.md Web-Server-Tutorial.md Tutorial.md Advanced-Tutorial.md Concordance-Factor.md Command-Reference.md Substitution-Models.md Complex-Models.md Polymorphism-Aware-Models.md Compilation-Guide.md Frequently-Asked-Questions.md"

for f in *.md workshop/*.md; do
    if [ "$f" == "_Footer.md" -o "$f" == "_Sidebar.md" ]; then
        continue
    fi
    if [ ${f:0:8} == "workshop" ]; then
        destf=$dest_dir/../$f
    else
        destf=$dest_dir/$f
    fi

    # ignore file that is not changed
    if [ "$3" != "-redo" -a $f -ot $destf ]; then
        continue
    fi

    let file_changed++

    AUTHOR=`git log $f | grep Author: | sed 's/.* <//' | sed 's/@.*//' | sed 's/\./ /g' | sort | uniq | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g' | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1'`
    DATE=`git log --date=short $f | grep Date: | head -n 1 | sed 's/Date://'`

    sed "s/_AUTHOR_/$AUTHOR/" $f | sed "s/_DATE_/$DATE/" | sed 's/\.\.\//\.\.\/doc\//g'  > $destf

    echo "$source_dir/$f ---> $destf"
    #exit 0
done

echo "$file_changed files changed and converted"

#generate pdf
cd $dest_dir
pdf="iqtree-doc.pdf"
if [ $file_changed -gt 0 -o ! -f $pdf ]; then
    cat $files | sed 's/]([a-zA-Z\-]*#/](#/g' | sed 's/(Quickstart)/(#getting-started)/g' | sed 's/(Web-Server-Tutorial)/(#web-server-tutorial)/g' |  sed 's/(Tutorial)/(#beginners-tutorial)/g' | sed 's/(Advanced-Tutorial)/(#advanced-tutorial)/g' | sed 's/(Command-Reference)/(#command-reference)/g' | sed 's/(Substitution-Models)/(#substitution-models)/g' | sed 's/(Complex-Models)/(#complex-models)/g' | sed 's/(Polymorphism-Aware-Models)/(#polymorphism-aware-models)/g' | sed 's/(Compilation-Guide)/(#compilation-guide)/g' | sed 's/(Frequently-Asked-Questions)/(#frequently-asked-questions)/g' | sed 's/{:.*}//g' > iqtree-doc.md
    pandoc iqtree-doc.md --number-sections --listings --pdf-engine=xelatex -o $pdf
    echo "Generated $dest_dir/$pdf"
fi
