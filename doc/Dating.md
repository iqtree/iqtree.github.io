---
layout: userdoc
title: "Phylogenetic Dating"
author: _AUTHOR_
date: _DATE_
docid: 6
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: "Building time tree with node dates on phylogenetic trees."
sections:
  - name: Inferring time tree with tip dates
    url: inferring-time-tree-with-tip-dates
  - name: Calibrating tree using ancestral dates
    url: calibrating-tree-using-ancestral-dates
  - name: Dating an existing tree
    url: dating-an-existing-tree
---

Phylogenetic Dating
===================

Since IQ-TREE 2.0.3, we integrate the least square dating (LSD) method to build a time tree when you have date information for tips or ancestral nodes. So if you use this feature please cite: 

__Thu-Hien To, Matthieu Jung, Samantha Lycett, Olivier Gascuel__ (2016)
Fast dating using least-squares criteria and algorithms. _Syst. Biol._ 65:82-97.
<https://doi.org/10.1093/sysbio/syv068>

We will now walk through examples but the full options are:

```
TIME TREE RECONSTRUCTION:
  --date FILE          Dates of tips or ancestral nodes
  --date TAXNAME       Extract dates from taxon names after last '|'
  --date-tip STRING    Tip dates as a real number or YYYY-MM-DD
  --date-root STRING   Root date as a real number or YYYY-MM-DD
  --dating STRING      Dating method: LSD for least square dating (default)
```

>**DISCLAIMER**: This is a new feature and might still have bugs. So any suggestions and bug reports are much welcome.

Inferring time tree with tip dates
----------------------------------

This is a common scenario e.g. in virus datasets where you have sampling time for many sequences. You need first to prepare a _date file_, which comprises several lines, each with a taxon name (from your sequence alignment) and its date separated by spaces, tabs or blanks. Note that it is not required to have dates for all tips. For example, this date file is part of the new corona virus dataset:

```
hCoV-19/Wuhan-Hu-1         2019-12-31
hCoV-19/China/WF0028       2020-02
hCoV-19/USA/WA-S88         2020-03-01
hCoV-19/USA/CA-CDPH-UC1	   2020
hCoV-19/Italy/SPL1         2020-01-29
hCoV-19/Spain/Valencia5	   2020-02-27
hCoV-19/Australia/QLD01	   2020-01-28
hCoV-19/Vietnam/CM295      2020-03-06
hCoV-19/bat/Yunnan         2013-07-24
hCoV-19/pangolin/Guangdong 2019
```

The date information here can be uncertain. For example, `hCoV-19/China/WF0028` was sampled in February 2020 and `hCoV-19/USA/CA-CDPH-UC1` was sampled in 2020. If you have a taxon sampled in Feb or Mar 2018, you can add this line:

```
TaxonXXX  2018-02-01:2018-03-31
```

Now run IQ-TREE with:

	iqtree -s ALN_FILE --date DATE_FILE
	
where `ALN_FILE` is the sequence alignment and `DATE_FILE` is the date file. This single command line will perform three steps: (1) find the best-fit model using ModelFinder, (2) find the maximum likelihood (ML) tree with branch lengths in number of substitutions per site, and (3) rescale the branch lengths of the ML tree to build a time tree with dated ancestral node. As output IQ-TREE will additional print three files:

* `ALN_FILE.timetree.lsd`: The report of LSD.
* `ALN_FILE.timetree.nex`: Time tree file in NEXUS format, that can be viewed nicely in FigTree (Click on "Node Labels" on the left tab and choose "Display" as "date" in FigTree).
* `ALN_FILE.timetree.nwk`: Time tree file in NEWICK format.

This command will automatically detect the best root position (according to LSD criterion). However, if the root is incorrectly inferred, it may produce wrong dates. Therefore, it is advisable to provide outgroup taxa if possible. In this example, we have this information, so you can use `-o` option:

	iqtree -s ALN_FILE --date DATE_FILE -o "hCoV-19/bat/Yunnan,hCoV-19/pangolin/Guangdong"

to instruct IQ-TREE that the root is on the branch separating `bat` and `pangolin` sequences from the rest.


Alternatively you can also append the dates into the sequence names of the alignment file using the `|` separator, such as (assuming a FASTA file here):

```
>hCoV-19/Wuhan-Hu-1|2019-12-31
......
>hCoV-19/China/WF0028|2020-02
......
>hCoV-19/USA/WA-S88|2020-03-01
......
>hCoV-19/USA/CA-CDPH-UC1|2020
......
>hCoV-19/Italy/SPL1|2020-01-29
......
>hCoV-19/Spain/Valencia5|2020-02-27
......
>hCoV-19/Australia/QLD01|2020-01-28
......
>hCoV-19/Vietnam/CM295|2020-03-06
......
>hCoV-19/bat/Yunnan|2013-07-24
......
>hCoV-19/pangolin/Guangdong|2019
......
```

Then run IQ-TREE:

	iqtree -s ALN_FILE --date TAXNAME -o "hCoV-19/bat/Yunnan,hCoV-19/pangolin/Guangdong"

The special keyword `TAXNAME` for the `--date` option instructs IQ-TREE to automatically extract the dates from the taxon names.


Calibrating tree using ancestral dates
--------------------------------------

Another scenario is that we have sequences from present day and want to calibrate the dates of the ancestral nodes. This will only work if you have  fossil date record of at least one ancestral node in the tree. Then you again need to prepare a date file which looks like:

```
taxon1,taxon2	      -50
taxon3,taxon4,taxon5  -100
taxon6                -10
```

which, for example, mean that the most recent common ancestor (MRCA) of `taxon1` and `taxon2` was 50 mya (million year ago) and the MRCA of `taxon3`, `taxon4`, `taxon5` was 100 mya. Now run IQ-TREE:

    iqtree -s ALN_FILE --date DATE_FILE --date-tip 0
    
This means that except for `taxon6`, all other taxa have the date of 0 for presence. 

If you know the root date, then you can set it via `--date-root` option or add the following line into the date line (assuming that root is dated 200 mya):

```
root  -200
```

Dating an existing tree
-----------------------

If you already have a tree, you can use option `-te TREE_FILE` to ask IQ-TREE to load and fix this tree topology. This will work with the scenarios above, i.e., IQ-TREE will date the user-defined tree instead of the ML tree. To further speed up the process: If you know the model already, you set can it via `-m` option; or in a partitioned analysis, you can provide a partition file with specified models.

