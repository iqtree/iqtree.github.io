<!--jekyll 
docid: 02
icon: info-circle
doctype: tutorial
tags:
- tutorial
sections:
- name: Alignment
  url: alignment
jekyll-->

This developers' guide gives an overview of IQ-TREE code.
<!--more-->

To achieve both high performance and flexibility, IQ-TREE software has been entirely written in object oriented C++. Thus, it faciliates extending with new sequence data types or new models. IQ-TREE code consists of C++ classes, most of which inherits from three basal classes: **Alignment**, **ModelSubst** and **PhyloTree** to handle sequence alignment, model of substitution and phylogenetic tree, respectively.


Alignment
---------