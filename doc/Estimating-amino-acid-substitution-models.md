---
layout: userdoc
title: "Estimating amino acid substitution models"
author: Cuong Dang
date: 2021-10-16
docid: 8
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: Estimating amino acid substitution models.
sections:
- name: Estimating non-reversible models from a bunch of separate MSAs
  url: Estimating non-reversible models from a bunch of separate MSAs
- name: Estimating non-reversible models from one concatenated MSA (clade-specific dataset)
  url: Estimating non-reversible models from one concatenated MSA (clade-specific dataset)
- name: Testing root positions
  url: testing-root-positions
---


Estimating amino acid substitution models
==========================

Why do you need this? (motivation) from abstract, from modified from user-perspective.

This tutorial provides a rooting approach using non-reversible models ([Dang et al., 2021]), which will be useful when an outgroup is lacking. Please make sure that you use the latest version of IQ-TREE for full features.


Choose an example input that is small enough to run < 5 min.

Estimating a model from a sinle (concatenated) alignment
--------------------------------------------------

### Estimating a reversible model

### Estimating a non-reversible model

In this case, users can assess root position with rootstrap supports (-B 1000 option) as written [that this tutorial](REF).


Estimating a model from a folder of alignments
----------------------------------------------

### Estimating a reversible model

Allowing each alignment to have a separate tree (-S option)

Each alignment is a gene of a common set of species (-p option) 
-> partition analysis


### Estimating a non-reversible model

We first demonstrate the estimation of a non-reversible model for Pfam dataset ([El-Gebali et al., 2018]). Please first download the file Pfam_datasets.zip from https://doi.org/10.6084/m9.figshare.14516712. This is a subset of the Pfam dataset, which contained 6654 separate MSAs for training and 6654 separate MSAs for test. The estimation (training) then can be accomplished with two commands in IQ-TREE 2. The first command is:

	iqtree2 -seed 1 -T 36 -S train_pfam -mset LG,WAG,JTT -cmax 4
	
where `-seed 1` option set the random seed, `-T 36` option let IQ-TREE utilize up to 36 CPU threads, `-T AUTO` will automatically detect the best number of threads, `-S train_pfam` option specifies the directory of training data; `-mset LG,WAG,JTT` option defines the initial candidate matrices to reduce computational burden; `-cmax 4` option restricts up to four categories for the rate heterogeneity across sites. This will run ModelFinder to find the best model for each MSA in the folder `train_pfam`. The best models and the best trees will be saved to `train_pfam.best_model.nex` and to `train_pfam.treefile`, respectively.  These two files will be used as the input for the second command that estimate a join non-reversible matrix:

	iqtree2 -seed 1 -T 36 -S train_pfam.best_model.nex -te train_pfam.treefile --model-joint NONREV+FO --init-model LG -pre pfam6654.NONREV
	
where`--init-model LG` option specifies the initial matrix; `-pre pfam6654.NONREV` option specifies the names of output files. We can obtain the resulting matrix (`NQ.pfam`) which is included in file `pfam6654.NONREV.iqtree` with the command:

	grep -A 21 "can be used as input for IQ-TREE" pfam6654.NONREV.iqtree | tail -n20 > NQ.pfam

You can open `NQ.pfam` in a text viewer, it is a 20x20 matrix. This file can then be used with IQ-TREE (e.g. `-m NQ.pfam`).

Estimating a model from one concatenated alignment
--------------------------------------------------

### Estimating a reversible model

### Estimating a non-reversible model


We will now estimate a non-reversible model for a clade-specific dataset. Please download the file 05_clades.zip from https://doi.org/10.6084/m9.figshare.14516712. There are five datasets in the zip: plant, mammal, insect, bird, yeast. We will demonstrate using plant, the smallest dataset. In each dataset folder, you will see three files named: 

* `alignment.nex` contains the alignment in NEXUS format.
* `train.nex` contains the training partitions  in NEXUS format.
* `test.nex` contains the test partitions in NEXUS format in NEXUS format.

We used `-p` option instead of `-S` option to estimate an edge-linked partition model with a single tree topology shared across all loci. This -p option is typically used with concatenation tree estimation that assumes a single species tree but rescale the branch lengths of the locus trees. It was shown to perform best among other partition models ([Duchêne et al., 2019]). The three commands are:

	# step 1: infer an single edge-linked tree with reversible models as initial models
	iqtree2 --seed 1 -T AUTO -s plant/alignment.nex -p plant/train.nex -m MFP -mset LG,WAG,JTT -cmax 4 --prefix plant/train
	
	# step 2: estimate a join non-reversible matrix across all loci
	iqtree2 -seed 1 -T AUTO -s plant/alignment.nex -p plant/train.best_model.nex -te plant/train.treefile --model-joint NONREV+FO --prefix plant/NONREV+FO
	
	# step 3: extract the resulting non-reversible matrix
	grep -A 21 "can be used as input for IQ-TREE" plant/NONREV+FO.iqtree | tail -n20 > NQ.plant

[Dang et al., 2021]: https://doi.org/10.1101/2021.10.18.464754
[Naser-Khdour et al., 2021]: https://doi.org/10.1093/sysbio/syab067
[El-Gebali et al., 2018]: https://doi.org/10.1093/nar/gky995
[Duchêne et al., 2019]: https://doi.org/10.1093/molbev/msz291
[Ran et al., 2018]: https://doi.org/10.1098/rspb.2018.1012
