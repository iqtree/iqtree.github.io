---
layout: userdoc
title: "Concordance Factor"
author: M Bui
date:    2018-12-15
docid: 6
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: "Gene and site concordance factor computation."
sections:
  - name: Inferring species tree
    url: inferring-species-tree
  - name: Inferring gene/locus trees
    url: inferring-genelocus-trees
  - name: Gene concordance factor (gCF)
    url: gene-concordance-factor-gcf
  - name: Site concordance factor (sCF)
    url: site-concordance-factor-scf
  - name: Putting it all together
    url: putting-it-all-together

---

Concordance Factor
==================

We provide two measures for quantifying genealogical concordance in phylogenomic datasets: the gene concordance factor (gCF) and the site concordance factor (sCF). For every branch of a reference tree, gCF is defined as the percentage of “decisive” gene trees containing that branch. gCF is already in wide usage, but here we allow to calculate gCF while correctly accounting for variable taxon coverage among the gene trees. sCF is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. sCF is a novel measure that is particularly useful when individual gene alignments are relatively uninformative, such that gene trees are uncertain. gCF and sCF complement classical measures of branch support (e.g. bootstrap) in phylogenetics by providing a full description of underlying disagreement among loci and sites.

If you use this feature please cite: __Minh B.Q., Hahn M., Lanfear R.__ (2018) New methods to calculate concordance factors for phylogenomic datasets. <https://doi.org/10.1101/487801>


> Please first download the beta version 1.7-beta7: <https://github.com/Cibiv/IQ-TREE/releases/tag/v1.7-beta7>.


> Rob Lanfear wrote a very nice [blog post on how to use and interpret concordance factors](http://www.robertlanfear.com/blog/files/concordance_factors.html).
{: .tip}

Inferring species tree
----------------------

First, you need to infer a reference tree (e.g. a species tree), on which the concordance factors will be annotated. The species tree can be reconstructed by a concatenation/supermatrix approach or a coalescent/reconciliation/supertree approach. Here, we will use the concatenation approach in IQ-TREE. 

As an example, you can apply an [edge-linked proportional partition model](Complex-Models) with ultrafast bootstrap (1000 replicates; for comparison with concordance factors):

	iqtree -s ALN_FILE -p PARTITION_FILE --prefix concat -bb 1000 -nt AUTO

where `ALN_FILE` and `PARTITION_FILE` are your input files. Here we use a prefix `concat`, so that all output files (`concat.*`) do not interfere with analyses below. If `--prefix` is omitted, all output files will be `PARTITION_FILE.*`.

Moreover, IQ-TREE v1.7 provides a new convenient feature: if you have a directory with many (locus) alignments, you can specify this directory directly with `-p` option:

	iqtree -p ALN_DIR --prefix concat -bb 1000 -nt AUTO
	
IQ-TREE detects if `-p` argument is a directory and automatically load all alignment files and concatenate them into a supermatrix for the partition analysis.


Inferring gene/locus trees
--------------------

We now construct a set of gene/locus trees. One can manually do a for-loop, but IQ-Tree provides a new convenient option `-S` to compute individual locus trees given a partition file or a directory:

	iqtree -s ALN_FILE -S PARTITION_FILE --prefix loci
	# or
	iqtree -S ALN_DIR --prefix loci

In the second case, IQ-Tree automatically detects that `ALN_DIR` is a directory and will load all alignment files within the directory. So `-S` takes the same argument as `-p` except that it performs model selection (ModelFinder) and tree inference separately for each partition/alignment. The output files are similar to those from a partitioned analysis, except that `loci.treefile` now contains a set of trees.

Note that you should use `-nt` option to specify the number of CPU cores to speedup the computation. (`-nt AUTO` does not work yet).

Gene concordance factor (gCF)
-----------------------------

Given the species tree `concat.treefile` and the set of locus trees `loci.treefile` computed above, you can calculate gCF for each branch of the species tree as the fraction of decisive gene trees concordant with this branch:

	iqtree -t concat.treefile --gcf loci.treefile --prefix concord
 	
Note that `-t` accepts any reference tree (e.g., by coalescent/reconciliation approach) and `--gcf` accepts any set of trees (e.g. locus trees and bootstrap trees), which may contain a subset of taxa from the reference tree. IQ-Tree will write three files:

* `concord.cf.tree`: Newick tree with gCF assigned for each internal branch of the reference tree. If the reference tree already has some branch label (such as bootstrap support in this case), gCF will be appended to the existing label separated by a `/`.
* `concord.cf.branch`: Newick tree with internal branch IDs.
* `concord.cf.stat`: A tab-separated table with gCF and gDF (gene discordance factor) for every internal branch (rows of the table). The ID column can be linked with `concord.cf.branch` file. This file can be read in R to do some plot (see below).

If you omit `--prefix`, all output files will be written to `concat.treefile.*`.


Site concordance factor (sCF)
-----------------------------

Given the species tree `concat.treefile` and the alignment, you can calculate sCF for each branch of the species tree as the fraction of decisive alignment sites supporting that branch:

	iqtree -t concat.treefile -s ALN_FILE --scf 100 --prefix concord
	
`--scf` specifies the number of quartets (randomly sampled around each internal branch) for computing sCF. We recommend at least 100 quartets for stable sCF values. Note that running this command several times may lead to slightly different sCF due to randomness. To make it reproducible, you need to use `-seed` option to provide a random number generator seed.

Instead of `-s`, you can alternatively provide a directory or a partition file. IQ-Tree then computes sCF for the concatenated alignment:

	iqtree -t concat.treefile -p ALN_DIR --scf 100 --prefix concord

Finally, you can combine gCF and sCF within a single run:

	iqtree -t concat.treefile --gcf loci.treefile -p ALN_DIR --scf 100 --prefix concord
	
Here, each branch of `concord.cf.tree` will be assigned (or appended) with `gCF/sCF` values and `concord.cf.stat` will be written with both gCF and sCF values.


Putting it all together
-----------------------


If you have separate alignments for each locus in a folder, then perform the following commands:

	iqtree -p ALN_DIR --prefix concat -bb 1000 -nt AUTO
	iqtree -S ALN_DIR --prefix loci -nt 10
	iqtree -t concat.treefile --gcf loci.treefile -p ALN_DIR --scf 100 --prefix concord

If you have a single concatenated alignment with a partition file that defines loci:

	iqtree -s ALN_FILE -p PARTITION_FILE --prefix concat -bb 1000 -nt AUTO
	iqtree -s ALN_FILE -S PARTITION_FILE --prefix loci -nt 10
	iqtree -t concat.treefile --gcf loci.treefile -s ALN_FILE --scf 100 --prefix concord

Note that you can change `-nt 10` to higher value if you have more CPU cores.

