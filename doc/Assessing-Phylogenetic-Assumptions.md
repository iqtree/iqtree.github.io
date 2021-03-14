---
layout: userdoc
title: "Assessing Phylogenetic Assumptions"
author: _AUTHOR_
date: _DATE_
docid: 5
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: This guide is about evaluating the suitability of the data for phylogenetic analysis.
sections:
- name: Likelihood mapping
  url: likelihood-mapping
- name: Tests of symmetry
  url: tests-of-symmetry

---


Assessing phylogenetic assumptions
==================================

It is important to know that phylogenetic models rely on various simplifying assumptions to
ease computations. If your data severely violate these assumptions, it might
cause bias in phylogenetic estimates of tree topologies and other model
parameters. Some common assumptions include _treelikeness_ (all sites
in the alignment have evolved under the same tree), _stationarity_ (nucleotide/amino-acid
frequencies remain constant over time), _reversibility_ (substitutions are equally
likely in both directions), and _homogeneity_ (substitution rates remain constant over time).

This document shows several ways to check some of these assumptions that you
should perform before doing phylogenetic analysis.

Likelihood mapping
------------------
<div class="hline"></div>

Likelihood mapping ([Strimmer and von Haeseler, 1997]) is a visualisation method
to display the phylogenetic information of an alignment. It visualises the _treelikeness_
of all quartets in a single triangular graph and therefore renders a quick
interpretation of the phylogenetic content.

A simple likelihood mapping analysis can be conducted with:

	iqtree -s example.phy -lmap 2000 -n 0

where `-lmap` option specify the number of quartets of taxa that will be drawn randomly
from the alignment. `-n 0` tells IQ-TREE to stop the analysis right after running the
likelihood mapping. IQ-TREE will print the result in the `.iqtree` report file as well
as the likelihood mapping plot `.lmap.svg` (in SVG format) and `.lmap.eps` file (in EPS
figure format).

You can now view the likelihood mapping plot file `example.phy.lmap.svg`, which looks like this:

![Likelihood mapping plot.](images/example.phy.lmap.pdf) 

It shows phylogenetic information of the alignment `example.phy`. 

* Top sub-figure: distribution of quartets depicted by dots on the likelihood mapping plot. 
* Left sub-figure: percentages of quartets falling in each of the three areas. The 
  three areas show support for one of the different groupings like (a,b)-(c,d).
* Right sub-figure: percentages of quartets falling in each of the seven areas. 
  Quartets falling into the three corners are informative and called fully-resolved quartets. 
  Those in three rectangles are partly informative (partly resolved quartets) and those in the center are uninformative
  (unresolved quartets). A good data set should have high number of fully resolved quartets 
  and low number of unresolved quartets. 

The meanings can also be found in the `LIKELIHOOD MAPPING STATISTICS` section of the report file `example.phy.iqtree`:


    LIKELIHOOD MAPPING STATISTICS
    -----------------------------

               (a,b)-(c,d)                              (a,b)-(c,d)      
                    /\                                      /\           
                   /  \                                    /  \          
                  /    \                                  /  1 \         
                 /  a1  \                                / \  / \        
                /\      /\                              /   \/   \       
               /  \    /  \                            /    /\    \      
              /    \  /    \                          / 6  /  \  4 \     
             /      \/      \                        /\   /  7 \   /\    
            /        |       \                      /  \ /______\ /  \   
           /   a3    |    a2  \                    / 3  |    5   |  2 \  
          /__________|_________\                  /_____|________|_____\ 
    (a,d)-(b,c)            (a,c)-(b,d)      (a,d)-(b,c)            (a,c)-(b,d) 

    Division of the likelihood mapping plots into 3 or 7 areas.
    On the left the areas show support for one of the different groupings
    like (a,b|c,d).
    On the right the right quartets falling into the areas 1, 2 and 3 are
    informative. Those in the rectangles 4, 5 and 6 are partly informative
    and those in the center (7) are not informative.
    .....


The [command reference](Command-Reference#likelihood-mapping-analysis) will provide
more options and how to perform 2-, 3-, or 4-cluster likelihood mapping analysis.


Tests of symmetry
-----------------

IQ-TREE provides three matched-pairs tests of symmetry ([Naser-Khdour et al., 2019]) to 
test the two assumptions of stationarity and homogeneity (SRH). 
A simple analysis:

	iqtree2 -s example.phy -p example.nex --symtest-only

will perform the three tests of symmetry on every partition of the alignment
and print the result into a `.symtest.csv` file. `--symtest-only` option tells
IQ-TREE to only perform the tests of symmetry and then exit.
In this example the content of `example.nex.symtest.csv` looks like this:

```
# Matched-pair tests of symmetry
# This file can be read in MS Excel or in R with command:
#    dat=read.csv('example.nex.symtest.csv',comment.char='#')
# Columns are comma-separated with following meanings:
#    Name:    Partition name
#    SymSig:  Number of significant sequence pairs by test of symmetry
#    SymNon:  Number of non-significant sequence pairs by test of symmetry
#    SymPval: P-value for maximum test of symmetry
#    MarSig:  Number of significant sequence pairs by test of marginal symmetry
#    MarNon:  Number of non-significant sequence pairs by test of marginal symmetry
#    MarPval: P-value for maximum test of marginal symmetry
#    IntSig:  Number of significant sequence pairs by test of internal symmetry
#    IntNon:  Number of non-significant sequence pairs by test of internal symmetry
#    IntPval: P-value for maximum test of internal symmetry
Name,SymSig,SymNon,SymPval,MarSig,MarNon,MarPval,IntSig,IntNon,IntPval
part1,44,92,0.475639,50,86,0.722371,4,132,0.23869
part2,43,93,0.142052,49,87,0.205232,5,131,0.169618
part3,53,83,0.00499855,58,78,0.00164132,6,130,0.343127
```

The three important columns are:

* SymPval: a small p-value (say < 0.05) indicates that the assumptions of stationarity 
or homogeneity or both is rejected. In this case, partition `part3` does not comply with these
two assumptions (p-value = 0.00499855), whereas the other two partitions are "good".
* MarPval: a small p-value means that the assumption of stationarity is rejected.  In 
this case, only partition `part3` does not comply with the stationary condition (p-value = 0.00164132).
* IntPval: a small p-value means that the homogeneity assumption is reject. In
this case, no partitions are "bad" according to this test, i.e., they all comply with
the homogeneity assumption.

This little example shows that only `part3` is problematic by not complying with the 
stationary assumption.

Now you may want to perform the phylogenetic analysis excluding all "bad" partitions by:

	iqtree2 -s example.phy -p example.nex --symtest-remove-bad

that will remove all "bad" partitions where SymPval < 0.05 and continue the analysis with the
remaining "good" partitions. You may then compare the trees from "all" partitions
and from "good" only partitions to see if there is significant difference between them 
with [tree topology tests](Advanced-Tutorial#tree-topology-tests).

Other options can be seen when running `iqtree2 -h`:

```
TEST OF SYMMETRY:
  --symtest               Perform three tests of symmetry
  --symtest-only          Do --symtest then exist
  --symtest-remove-bad    Do --symtest and remove bad partitions
  --symtest-remove-good   Do --symtest and remove good partitions
  --symtest-type MAR|INT  Use MARginal/INTernal test when removing partitions
  --symtest-pval NUMER    P-value cutoff (default: 0.05)
  --symtest-keep-zero     Keep NAs in the tests
```


[Strimmer and von Haeseler, 1997]: http://www.pnas.org/content/94/13/6815.long
[Naser-Khdour et al., 2019]: https://doi.org/10.1093/gbe/evz193

