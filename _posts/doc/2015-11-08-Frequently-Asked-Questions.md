---
layout: userdoc
title: "Frequently Asked Questions"
author: minh
date:   2015-12-01
categories:
- doc
docid: 04
icon: question-circle
doctype: tutorial
tags:
- tutorial
sections:
- name: How to interpret ultrafast bootstrap (UFBoot) supports?
  url: how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values
- name: How does IQ-TREE treat gap/missing/ambiguous characters?
  url: how-does-iq-tree-treat-gapmissingambiguous-characters
- name: Can I mix DNA and protein data in a partitioned analysis?
  url: can-i-mix-dna-and-protein-data-in-a-partitioned-analysis
---
For common questions and answers.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [How do I interpret ultrafast bootstrap (UFBoot) support values?](#how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values)
- [How does IQ-TREE treat gap/missing/ambiguous characters?](#how-does-iq-tree-treat-gapmissingambiguous-characters)
- [Can I mix DNA and protein data in a partitioned analysis?](#can-i-mix-dna-and-protein-data-in-a-partitioned-analysis)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


How do I interpret ultrafast bootstrap (UFBoot) support values?
---------------------------------------------------------------

The ultrafast bootstrap (UFBoot) feature (`-bb` option) was published in  ([Minh et al., 2013]). One of the main conclusions is, that UFBoot support values are more unbiased: 95% support correspond roughly to a probability of 95% that a clade is true. So this has a different meaning than the normal bootstrap supports (where you start to believe in the clade if it has >80% BS support). For UFBoot, you should only start to believe in a clade if its support is >= 95%. Thus, the interpretations are different and you should not compare BS% with UFBoot% directly. 

Moreover, it is recommended to also perform the SH-aLRT test ([Guindon et al., 2010]) by adding `-alrt 1000` into the IQ-TREE command line. Each branch will then be assigned with SH-aLRT and UFBoot supports. One would typically start to rely on the clade if its SH-aLRT >= 80% and UFboot >= 95%. 


How does IQ-TREE treat gap/missing/ambiguous characters?
---------------------------------------------------------

Gaps (`-`) and missing characters (`?` or `N` for DNA alignments) are treated in the same way as `unknown` characters, which represent no information. The same treatment holds for many other ML software (e.g., RAxML, PhyML). More explicitly,
for a site (column) of an alignment containing `AC-AG-A` (i.e. A for sequence 1, C for sequence 2, `-` for sequence 3, and so on), the site-likelihood
of a tree T is equal to the site-likelihood of the subtree of T restricted to those sequences containing non-gap characters (`ACAGA`).

Ambiguous characters that represent more than one character are also supported: each represented character will have equal likelihood. For DNA the following ambigous nucleotides are supported according to [IUPAC nomenclature](https://en.wikipedia.org/wiki/Nucleic_acid_notation):

| Nucleotide | Meaning |
|------|---------|
| R    | A or G (purine)  |
| Y    | C or T (pyrimidine) |
| W    | A or T (weak) |
| S    | G or C (strong) |
| M    | A or C (amino)|
| K    | G or T (keto)|
| B    | C, G or T (next letter after A) |
| H    | A, C or T (next letter after G) |
| D    | A, G or T (next letter after C) |
| V    | A, G or C (next letter after T) |
| ?, -, ., ~, O, N, X | A, G, C or T (unknown; all 4 nucleotides are equally likely) |

For protein the following ambiguous amino-acids are supported:

| Amino-acid | Meaning |
|------------| --------|
| B | N or D |
| Z | Q or E |
| J | I or L |
| U | unknown AA (although it is the 21st AA) |
| ?, -, ., ~, * or X | unknown AA (all 20 AAs are equally likely) |


Can I mix DNA and protein data in a partitioned analysis?
---------------------------------------------------------

Yes! You can specify this via a NEXUS partition file. In fact, you can mix any data types supported in IQ-TREE, including also codon, binary and morphological data. To do so, each data type should be stored in a separate alignment file. For further information please read [partition file format](../Complex-Models/#partition-file-format). 

[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
