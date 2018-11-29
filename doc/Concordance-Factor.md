---
layout: userdoc
title: "Concordance Factor"
author: _AUTHOR_
date: _DATE_
docid: 6
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: "Gene and site concordance factor computation."
sections:
  - name: Inferring gene trees and concatenation tree
    url: inferring-gene-trees-and-concatenation-tree
  - name: Gene concordance factor (gCF)
    url: gene-concordance-factor-gcf
  - name: Site concordance factor (sCF)
    url: site-concordance-factor-scf
---

Concordance Factor
==================

We provide two measures for quantifying genealogical concordance in phylogenomic datasets: the gene concordance factor (gCF) and the site concordance factor (sCF). For every branch of a reference tree, gCF is defined as the percentage of “decisive” gene trees containing that branch. gCF is already in wide usage, but here we allow to calculate gCF while correctly accounting for variable taxon coverage among the gene trees. sCF is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. sCF is a novel measure that is particularly useful when individual gene alignments are relatively uninformative, such that gene trees are uncertain. gCF and sCF complement classical measures of branch support (e.g. bootstrap) in phylogenetics by providing a full description of underlying disagreement among loci and sites.


> Please first download the beta version 1.7-beta6: <https://github.com/Cibiv/IQ-TREE/releases/tag/v1.7-beta6>.

Inferring gene trees and concatenation tree
-------------------------------------------

For gCF one needs a set of (gene) trees. One can manually do a for-loop, but IQ-Tree provides a new convenient option `-S` to compute individual gene trees given a partition file or a directory:

	iqtree -S ALN_DIR 

In this case, IQ-Tree automatically detects that `ALN_DIR` is a directory and will load all alignment files within the directory. It can also be a partition file in a normal [partitioned analysis](Advanced-Tutorial):

	iqtree -s ALN_FILE -S PARTITION_FILE

IQ-Tree will then perform separate ModelFinder and tree inference for each partition/alignment. The output files are similar to those from a partitioned analysis, except that `ALN_DIR.treefile` or `PARTITION_FILE.treefile` now contains a set of trees, which can be used as source trees for gCF computation (next section). Note that you can (and should) use `-nt` option to specify the number of CPU cores to speedup the computation.

Next, you can compute a concatenation tree using an edge-linked proportional partition model, which can be used as reference tree for gCF and sCF computation (next sections):

	iqtree -p ALN_DIR --prefix concat -bb 1000
	# or
	iqtree -s ALN_FILE -p PARTITION_FILE --prefix concat -bb 1000
	

Here we use a prefix `concat`, so that all output files (`concat.*`) do not interfere with `-S` analaysis above. Moreover, we perform an ultrafast bootstrap with 1000 replicates for comparison with gCF and sCF.


Gene concordance factor (gCF)
-----------------------------

gCF assigns the fraction of source trees concordant with each branch of a reference tree:

	iqtree -t REFERENE_TREE --gcf SOURCE_TREES
 	
The reference tree can be a concatenation tree (e.g., `concat.treefile` inferred above) or a species tree (e.g., inferred by coalescence/reconciliation approach) or any other tree. The set of source trees can be gene/locus trees (e.g., `ALN_DIR.treefile` or `PARTITION_FILE.treefile` inferred above), bootstrap trees, or any other trees, which may contain a subset of taxa from the reference tree. IQ-Tree will write three files:

* `REFERENCE_TREE.cf.tree`: Newick tree with gCF assigned for each internal branch. If `REFERENCE_TREE` already has some branch label (such as bootstrap supports), gCF will be appended to the existing label separated by a `/`.
* `REFERENCE_TREE.cf.branch`: Newick tree with internal branch IDs.
* `REFERENCE_TREE.cf.stat`: A tab-separated table with gCF and gDF (gene discordance factor) for every internal branch (rows of the table). The ID column can be linked with `REFERENCE_TREE.cf.branch` file. This file can be read in R to do some plot (see below).

As seen above, the prefix for output files is `REFERENCE_TREE`. If you want to change this, use `--prefix` option:

	iqtree -t REFERENE_TREE --gcf SOURCE_TREES --prefix OUT_PREFIX


Site concordance factor (sCF)
-----------------------------

sCF assign the fraction of decisive alignment sites supporting a branch in the reference tree:

	iqtree -t REFERENCE_TREE -s ALN_FILE --scf 100
	
`--scf` specifies the number of quartets (randomly sampled around each internal branch) for computing sCF. We recommend at least 100 quartets for stable sCF values. Note that running this command several times may lead to slightly different sCF due to randomness. To make it reproducible, you need to use `-seed` option to provide a random number generator seed.

Instead of `-s`, you can alternatively provide a directory or a partition file. IQ-Tree then computes sCF over the concatenated alignment:

	iqtree -t REFERENCE_TREE -p ALN_DIR --scf 100

Finally, one can compute gCF and sCF within a single run:

	iqtree -t REFERENE_TREE --gcf SOURCE_TREES -p ALN_DIR --scf 100
	
And each branch will be assigned with `gCF/sCF` values.


