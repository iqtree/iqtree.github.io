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
    if [ "$f" == "Home.md" -o "$f" == "_Footer.md" ]; then
        continue
    fi
    datef=`git log --date=short $f | grep Date: | tail -n 1 | awk '{print $2}'`
    destf=$dest_dir/$datef-$f
    
    if [ "$f" == "_Sidebar.md" ]; then
        tail +9 $f | sed 's/](/](\/IQ-TREE\/doc\//g' > $destf
    else
        echo -n -e "---\nlayout: userdoc\ntitle: \"" > $destf
        echo $f | sed 's/\..*/\"/' | sed 's/-/ /g' >> $destf
        echo -e "categories:\n- doc" >> $destf
        git log $f | grep Author: | head -n 1 | sed 's/Author/author/' | sed 's/ <.*//' >> $destf
        git log --date=short $f | grep Date: | head -n 1 | sed 's/Date/date/' >> $destf
        echo "---" >> $destf 
        while IFS='' read -r line || [[ -n "$line" ]]; do
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
    fi
    

    echo "$source_dir/$f ---> $destf"
    #exit 0
done

