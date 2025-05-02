---
layout: userdoc
title: "Concordance Factor"
author: Minh Bui, Rob Lanfear, Nhan Ly-Trong
date:    2024-05-27
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

Since IQ-TREE 2, we provide two measures for quantifying genealogical concordance in phylogenomic datasets: the gene concordance factor (gCF) and the site concordance factor (sCF). For every branch of a reference tree, gCF is defined as the percentage of “decisive” gene trees containing that branch. gCF is already in wide usage, but here we allow to calculate gCF while correctly accounting for variable taxon coverage among the gene trees. sCF is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. sCF is a novel measure that is particularly useful when individual gene alignments are relatively uninformative, such that gene trees are uncertain. gCF and sCF complement classical measures of branch support (e.g. bootstrap) in phylogenetics by providing a full description of underlying disagreement among loci and sites.

If you use this feature please cite: 

__Minh B.Q., Hahn M.W., Lanfear R.__ (2020) New methods to calculate concordance factors for phylogenomic datasets. _Molecular Biology and Evolution_, 37:2727–2733. <https://doi.org/10.1093/molbev/msaa106>

For sCF we recommend that you use the more accurate version of sCF based on maximum likelihood (`--scfl` option instead of `--scf`) that is available since IQ-TREE v2.2.2. In that case please cite:

__Mo Y.K., Lanfear R., Hahn M.W., and Minh B.Q.__ (2022) Updated site concordance factors minimize effects of homoplasy and taxon sampling. _Bioinformatics_, in press. <https://doi.org/10.1093/bioinformatics/btac741>

> HINT: See [very nice tips on how to use and interpret concordance factors](http://www.robertlanfear.com/blog/files/concordance_factors.html) written by Rob Lanfear.
{: .tip}

Inferring species tree
----------------------

First, you need to infer a reference tree (e.g. a species tree), on which the concordance factors will be annotated. The species tree can be reconstructed by a concatenation/supermatrix approach or a coalescent/reconciliation/supertree approach. Here, we will use the concatenation approach in IQ-TREE. 

As an example, you can apply an [edge-linked proportional partition model](Complex-Models) with ultrafast bootstrap (1000 replicates; for comparison with concordance factors):

	iqtree3 -s ALN_FILE -p PARTITION_FILE --prefix concat -B 1000 -T AUTO

where `ALN_FILE` and `PARTITION_FILE` are your input files. `-T AUTO` is to detect the best number of CPU cores. Here we use a prefix `concat`, so that all output files (`concat.*`) do not interfere with analyses below. If `--prefix` is omitted, all output files will be `PARTITION_FILE.*`.

Moreover, IQ-TREE 3 provides a new convenient feature: if you have a directory with many (locus) alignments, you can specify this directory directly with `-p` option:

	iqtree3 -p ALN_DIR --prefix concat -B 1000 -T AUTO
	
IQ-TREE detects if `-p` argument is a directory and automatically load all alignment files and concatenate them into a supermatrix for the partition analysis.


Inferring gene/locus trees
--------------------

We now construct a set of gene/locus trees. One can manually do a for-loop, but IQ-TREE 3 provides a new convenient option `-S` to compute individual locus trees given a partition file or a directory:

	iqtree3 -s ALN_FILE -S PARTITION_FILE --prefix loci -T AUTO
	# or
	iqtree3 -S ALN_DIR --prefix loci -T AUTO

In the second case, IQ-TREE automatically detects that `ALN_DIR` is a directory and will load all alignment files within the directory. So `-S` takes the same argument as `-p` except that it performs model selection (ModelFinder) and tree inference separately for each partition/alignment. The output files are similar to those from a partitioned analysis, except that `loci.treefile` now contains a set of trees.

Gene concordance factor (gCF)
-----------------------------

Given the species tree `concat.treefile` and the set of locus trees `loci.treefile` computed above, you can calculate gCF for each branch of the species tree as the fraction of decisive gene trees concordant with this branch:

	iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord
 	
Note that `-t` accepts any reference tree (e.g., by coalescent/reconciliation approach) and `--gcf` accepts any set of trees (e.g. locus trees and bootstrap trees), which may contain a subset of taxa from the reference tree. IQ-Tree will write three files:

* `concord.cf.tree`: Newick tree with gCF assigned for each internal branch of the reference tree. If the reference tree already has some branch label (such as bootstrap support in this case), gCF will be appended to the existing label separated by a `/`.
* `concord.cf.branch`: Newick tree with internal branch IDs.
* `concord.cf.stat`: A tab-separated table with gCF and gDF (gene discordance factor) for every internal branch (rows of the table). The ID column can be linked with `concord.cf.branch` file. This file can be read in R to do some plot (see below).

If you omit `--prefix`, all output files will be written to `concat.treefile.*`.


Site concordance factor (sCF)
-----------------------------

>**NOTE**: From version 2.2.2 IQ-TREE provides a new and more accurate sCF based on likelihood via `--scfl` option ([Mo et al., 2022]), whereas the original sCF is based on parsimony. You can download [this version from here](https://github.com/iqtree/iqtree2/releases/tag/v2.2.2).
 
Given the species tree `concat.treefile` and the alignment, you can calculate sCF for each branch of the species tree as the fraction of decisive alignment sites supporting that branch:

	# for version 2.2.2 or above
	iqtree3 -te concat.treefile -s ALN_FILE --scfl 100 --prefix concord
	# older versions
	iqtree2 -t concat.treefile -s ALN_FILE --scf 100 --prefix concord -T 10
	
`--scf` specifies the number of quartets (randomly sampled around each internal branch) for computing sCF. We recommend at least 100 quartets for stable sCF values. Note that running this command several times may lead to slightly different sCF due to randomness. To make it reproducible, you need to use `-seed` option to provide a random number generator seed.

Note that the `--scfl` option from IQ-TREE v2.2.2 will invoke model selection with ModelFinder and also tree search if you don't specify a tree with `-te` option. If you already have a best-fit model from a previous run, you can ignore ModelFinder (and thus speed up this run) by provide the model with `-m` option.

Instead of `-s`, you can alternatively provide a directory or a partition file. IQ-Tree then computes sCF for the concatenated alignment:

	# for version 2.2.2 or above
	iqtree3 -te concat.treefile -p ALN_DIR --scfl 100 --prefix concord
	# older versions
	iqtree2 -t concat.treefile -p ALN_DIR --scf 100 --prefix concord -T 10

Finally, you can combine gCF and sCF within a single run:

	# only for the original sCF
	iqtree3 -t concat.treefile --gcf loci.treefile -p ALN_DIR --scf 100 --prefix concord -T 10
	
Here, each branch of `concord.cf.tree` will be assigned (or appended) with `gCF/sCF` values and `concord.cf.stat` will be written with both gCF and sCF values.


Putting it all together
-----------------------


If you have separate alignments for each locus in a folder, then perform the following commands:

	# infer a concatenation-based species tree with 1000 ultrafast bootstrap and an edge-linked partition model
	iqtree3 -p ALN_DIR --prefix concat -B 1000 -T AUTO
	
	# infer the locus trees
	iqtree3 -S ALN_DIR --prefix loci -T AUTO
	
	# compute gene concordance factors
	iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord
	
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -p ALN_DIR --scfl 100 --prefix concord2

If you have a single concatenated alignment with a partition file that defines loci:

	# infer a concatenation-based species tree with 1000 ultrafast bootstrap and an edge-linked partition model
	iqtree3 -s ALN_FILE -p PARTITION_FILE --prefix concat -B 1000 -T AUTO

	# infer the locus trees
	iqtree3 -s ALN_FILE -S PARTITION_FILE --prefix loci -T AUTO

	# compute gene concordance factors
	iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord
	
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -s ALN_FILE --scfl 100 --prefix concord2
	

Note that you can adjust `-T 10` if you have fewer/larger CPU cores.


Calculating concordance factors on very large datasets
-----------------------------------------------------

If you have a dataset which takes a long time to analyse on your machine, there are a couple of adjustments you can make to the above process to keep things as fast as possible. 

Specifically, because the new version of the site concordance factor uses likelihoods, we can make sure to re-use as much information as possible. 

So, suppose that in the first step of the analysis you ran the command as above:

	iqtree3 -s ALN_FILE -p PARTITION_FILE --prefix concat -B 1000 -T AUTO

That command will have figured out for you the model of evolution, all the parameters of that model, and the branch lengths of the corresponding tree. We can re-use all of that useful information in the final step. It just takes a little bit of effort to find what you need.

First we'll get the model parameters we need. If you take a look at the end of the `concat.iqtree` file you will find a little section called `ALISIM COMMAND`. You can find it like this on mac/linux (or just open the `concat.iqtree` file in a text editor and scroll to the end:

	tail concat.iqtree

You should see something like this:

	ALISIM COMMAND
	--------------
	--alisim simulated_MSA -t concat.treefile -m "Q.plant+I{0.177536}+R8{0.147295,0.0935335,0.114418,0.190578,0.108376,0.538389,0.113777,0.804005,0.0898871,1.30004,0.137297,1.95653,0.0958285,3.48597,0.0155849,6.09904}" --length 432014

That bit after the `-m` (not including the `--length` stuff) is what you need to specify the Maximum Likelihood model parameters when you run the `--scfl` command. Note that it's vital that you use the model from YOUR analysis, not the example provided here. (That's why this bit is an a longer and more detailed section at the end of the tutorial.)

We also want to re-use the branch lengths we calculated in step 1, and we can do that easily with the `-blfix` option.

To put all of that together, we are going to change the final command of the tutorial above, where we calculate the site concordance factors from one of these two options (depending on if your alignments are per-locus, or all concatentated):


	# simple command, with per-locus alignments
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -p ALN_DIR --scfl 100 --prefix concord2

	# simple command, with concatenated alignments
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -s ALN_FILE --scfl 100 --prefix concord2

To one of these, where we add the two extra commands via `-blfix` and `-m`, to fix all the parameters we already calculated. A reminder - do NOT use the exact commandlines above. You have to replace everything after the `-m` with what you found in your own `concat.iqtree` file:

	# faster analysis, using pre-computed model parameters, with per-locus alignments
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -p ALN_DIR --scfl 100 --prefix concord2 -blfix -m "Q.plant+I{0.177536}+R8{0.147295,0.0935335,0.114418,0.190578,0.108376,0.538389,0.113777,0.804005,0.0898871,1.30004,0.137297,1.95653,0.0958285,3.48597,0.0155849,6.09904}"

	# faster analysis, using pre-computed model parameters, with concatenated alignments
	# compute site concordance factor using likelihood with v2.2.2
	iqtree3 -te concat.treefile -s ALN_FILE --scfl 100 --prefix concord2 -blfix -m "Q.plant+I{0.177536}+R8{0.147295,0.0935335,0.114418,0.190578,0.108376,0.538389,0.113777,0.804005,0.0898871,1.30004,0.137297,1.95653,0.0958285,3.48597,0.0155849,6.09904}"

All this does is tells IQ-TREE to use the model parameters and branch lengths you already calculated. On large datasets this can save a lot of analysis time.

[Mo et al., 2022]: https://doi.org/10.1093/bioinformatics/btac741