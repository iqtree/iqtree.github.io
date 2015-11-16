#! /bin/bash

if [ "$2" == "" ]; then
	echo "Usage: $0 source_dir dest_dir files"
	exit 1
fi

source_dir=$1
dest_dir=`cd $2; pwd`
files=$3

cd $source_dir

doc_dir="/IQ-TREE/doc/"

for f in *.md; do
    if [ "$f" == "Home.md" -o "$f" == "_Footer.md" -o "$f" == "_Sidebar.md" ]; then
        continue
    fi
    datef=`git log --date=short $f | grep Date: | tail -n 1 | awk '{print $2}'`
    destf=$dest_dir/$datef-$f
    
    echo -n -e "---\nlayout: userdoc\ntitle: \"" > $destf
    echo $f | sed 's/\..*/\"/' | sed 's/-/ /g' >> $destf
    git log $f | grep Author: | head -n 1 | sed 's/Author/author/' | sed 's/ <.*//' >> $destf
    git log --date=short $f | grep Date: | head -n 1 | sed 's/Date/date/' >> $destf
    echo -e "categories:\n- doc" >> $destf
    # insert jekyll headers
    grep '<!--jekyll' -A 100 $f | grep 'jekyll-->' -B 100 | grep -v 'jekyll' >> $destf
    echo "---" >> $destf 
    skip=0
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [ "${line:0:10}" == '<!--jekyll' ]; then
            #omit this line
            skip=1
            continue
        fi
        if [ "${line:0:9}" == 'jekyll-->' ]; then
            #omit this line
            skip=0
            continue
        fi
        if [ $skip -eq 1 ]; then
            continue
        fi
        newl=`echo "$line" | grep '](Home' | sed 's/](Home/](..\//g'`
        if [ "$newl" != "" ]; then
            line="$newl"
        fi
        newl=`echo "$line" | grep '](images' | sed 's/](images/](..\/assets\/img\/doc/g'`
        if [ "$newl" != "" ]; then
            line="$newl"
        fi
        newl=`echo "$line" | grep '](' | grep -v '](\#' | grep -v '](http' | sed 's/](/](..\//g'`
        if [ "$newl" == "" ]; then
            echo "$line" >> $destf
        else
            echo "$newl" >> $destf
        fi
    done < $f
    

    echo "$source_dir/$f ---> $destf"
    #exit 0
done

