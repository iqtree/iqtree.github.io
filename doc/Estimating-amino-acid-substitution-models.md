---
layout: userdoc
title: "Estimating amino acid substitution models"
author: _AUTHOR_
date: _DATE_
docid: 12
icon: info-circle
doctype: manual
tags:
- tutorial
description: Estimating amino acid substitution models.
sections:
- name: Estimating a model from a single concatenated alignment
  url: estimating-a-model-from-a-single-concatenated-alignment
- name: Estimating a model from a folder of alignments
  url: estimating-a-model-from-a-folder-of-alignments
- name: Estimating a non-reversible model
  url: estimating-a-non-reversible-model  
- name: Estimating linked exchangeabilities
  url: estimating-linked-exchangeabilities
---


Estimating amino acid substitution models
==========================

Amino acid substitution models are a key component in phylogenetic analyses of protein sequences. Most, if not all, analyses use [empirical amino-acid models](Substitution-Models#protein-models), which were obtained from protein databases; but there has been no useful tool to estimate them for modern datasets at hand. Therefore, we introduced QMaker ([Minh et al., 2021]) as a fast and convenient tool as part of IQ-TREE version 2 to infer a replacement matrix Q for any set of protein alignments. 

If you use QMaker or new models (Q.pfam, Q.plant, Q.mammal, Q.bird, Q.insect, Q.yeast), please cite:

>  Bui Quang Minh, Cuong Cao Dang, Le Sy Vinh, and Robert Lanfear (2021), QMaker: Fast and Accurate Method to Estimate Empirical Models of Protein Evolution. _Systematic Biology_ 70: 1046–1060. <https://doi.org/10.1093/sysbio/syab010>

Estimating a model from a single concatenated alignment
-------------------------------------------------------

We first demonstrate the estimation of a reversible model for a clade-specific dataset. Please download and extract the [sample training data](data/plant_10loci.zip). This example data was subsampled from a plant dataset ([Ran et al., 2018]). There are two files in the downloaded folder: 

* `alignment.nex` contains the alignment in NEXUS format.
* `train.nex` contains the training partitions  in NEXUS format.

The estimation (training) then can be accomplished with three commands in IQ-TREE. The first command is:

	# step 1: infer an single edge-linked tree with reversible models as initial models
	iqtree2 --seed 1 -T AUTO -s alignment.nex -p train.nex -m MFP -mset LG,WAG,JTT -cmax 4 --prefix train_plant

- `-seed 1` sets the random seed.
- `-T AUTO` sets the number of computing threads to automatically detection, `-T 10` will let IQ-TREE utilize up to 10 CPU threads.
- `-s alignment.nex` specifies the NEXUS file containing the concatenated alignment.
- `-p train.nex` specifies the NEXUS file containing the training loci, `-p` option will estimate an edge-linked partition model with a single tree topology shared across all loci. This -p option is typically used with concatenation tree estimation that assumes a single species tree but rescale the branch lengths of the locus trees. It was shown to perform best among other partition models ([Duchêne et al., 2019]).
Note: If you don't have the partition file `train.nex`, simply ignore the `-p` option.
- `-mset LG,WAG,JTT` defines the initial candidate matrices to reduce computational burden.
- `-cmax 4` restricts up to four categories for the rate heterogeneity across sites.
- `--prefix train_plant` or `-pre train_plant` sets the name of the output files. 

This will run ModelFinder to find the best model for each loci. The best models and the best trees will be saved to `train_plant.best_model.nex` and to `train_plant.treefile`, respectively. These two files will be used as the input for the second command that estimate a join reversible matrix:

	# step 2: estimate a join non-reversible matrix across all loci
	iqtree2 -seed 1 -T AUTO -s alignment.nex -p train_plant.best_model.nex -te train_plant.treefile --init-model LG --model-joint GTR20+FO --prefix plant_GTR20_FO
- `--init-model LG` option specifies the initial matrix
- `-p train_plant.best_model.nex` and `-te train_plant.treefile` options specify the best models and trees found in step 1.

The resulting matrix (`Q.plant`) which is included in the file `plant_GTR20_FO.iqtree` can be obtained with the command:

	# step 3: extract the resulting reversible matrix
	grep -A 21 "can be used as input for IQ-TREE" plant_GTR20_FO.iqtree | tail -n20 > Q.plant

We can  open `Q.plant` in a text viewer as below, or use with IQ-TREE (e.g. `-m Q.plant` option). The `Q.plant` is in PAML format, it contains the lower diagonal part of the AA exchange rates matrix and 20 AA frequencies.

    0.120955
    0.048462 0.458565
    0.436023 0.037551 4.799928
    0.470505 1.707355 0.338537 0.000100
    0.261114 3.736017 0.605443 0.147890 0.286279
    0.837596 0.016734 0.388965 5.815020 0.000100 4.138646
    1.939708 1.199364 0.911021 1.413132 0.681747 0.419571 0.886564
    0.232927 3.431828 4.195096 1.867861 1.850593 4.826298 0.328092 0.170808
    0.118245 0.101767 0.246939 0.041486 0.186430 0.018556 0.000100 0.000100 0.015294
    0.137216 0.190052 0.000100 0.000100 0.362263 0.642152 0.028449 0.025460 0.554159 2.930110
    0.135127 5.915805 3.499350 0.090416 0.000100 2.539190 1.229355 0.196033 0.301659 0.149798 0.013760
    0.359701 0.983896 0.049506 0.000100 0.380313 0.236000 0.389444 0.000100 0.031711 5.188215 4.848803 0.701453
    0.203942 0.034729 0.000100 0.000100 1.671509 0.000100 0.000100 0.048554 0.091040 1.015749 3.012478 0.000154 0.873360
    1.317722 0.441669 0.000100 0.128632 0.000100 1.357928 0.123957 0.048531 0.824914 0.000100 0.502828 0.122503 0.000100 0.000100
    3.425467 1.067776 4.114253 0.435618 2.788606 0.280845 0.104001 1.549784 0.361033 0.041339 0.384561 0.290811 0.188779 0.615963 2.474679
    4.260751 0.715157 2.261495 0.178679 0.000100 0.277338 0.227034 0.186275 0.000100 1.909182 0.041874 0.966718 3.385793 0.072074 0.806596 4.938908
    0.245284 0.698218 0.000100 0.000100 1.273897 0.161369 0.000100 0.405661 0.536027 0.012605 0.896675 0.000100 0.341461 0.993273 0.031731 0.131122 0.000100
    0.012568 0.009986 0.621948 0.200102 2.122422 0.031013 0.010158 0.000100 5.748250 0.031443 0.000100 0.000100 0.156847 7.335297 0.173676 0.241389 0.000100 1.228204
    2.630085 0.043992 0.071593 0.042649 0.326353 0.036449 0.277692 0.162678 0.140434 9.733184 1.730443 0.035985 1.921040 0.678498 0.149578 0.089526 0.989870 0.000100 0.234116
    
    0.076028 0.051084 0.039819 0.051496 0.012072 0.038467 0.064409 0.052997 0.017632 0.064148 0.102707 0.073142 0.019406 0.048651 0.034180 0.077354 0.046007 0.011774 0.033201 0.085428

The amino-acid order in this file is:

     A   R   N   D   C   Q   E   G   H   I   L   K   M   F   P   S   T   W   Y   V
    Ala Arg Asn Asp Cys Gln Glu Gly His Ile Leu Lys Met Phe Pro Ser Thr Trp Tyr Val


Estimating a model from a folder of alignments
----------------------------------------------

We will now estimate a reversible model from a folder of alignments. Please first download the file [plant_10alignments.zip](data/plant_10alignments.zip). There is a sub-folder named `train_plant` in the downloaded folder. We use `-S` option instead of `-s` and `-p` options to allow each alignment having a separate tree. This -S option is typically used with a folder of alignments. The three commands are:

	# step 1: infer a  separate tree for each alignment with reversible models as initial models
	iqtree2 -seed 1 -T AUTO -S train_plant -mset LG,WAG,JTT -cmax 4 -pre train_plant
	
	# step 2: estimate a join reversible matrix across all alignments
	iqtree2 -seed 1 -T AUTO -S train_plant.best_model.nex -te train_plant.treefile --model-joint GTR20+FO --init-model LG -pre train_plant.GTR20

	# step 3: extract the resulting reversible matrix
	grep -A 21 "can be used as input for IQ-TREE" train_plant.GTR20.iqtree | tail -n20 > Q.plant


Estimating a non-reversible model
---------------------------------

QMaker assumes time-reversible models, an assumption designed for computational convenience but not for biological reality. A variant of QMaker, called nQMaker ([Dang et al., 2022]), can estimate _non-reversible_ models and _rooted_ trees from any set of protein alignments.

If you use nQMaker or any new non-reversible models (NQ.pfam, NQ.plant, NQ.mammal, NQ.bird, NQ.insect, NQ.yeast), please cite:

> Cuong Cao Dang, Bui Quang Minh, Hanon McShea, Joanna Masel, Jennifer Eleanor James, Le Sy Vinh, and Robert Lanfear (2022), nQMaker: estimating time non-reversible amino acid substitution models. Systematic Biology 71: 1110–1123. <https://doi.org/10.1101/2021.10.18.464754>


To estimate a non-reversible model for a concatenated alignment, you can use `--model-joint NONREV+FO` option instead of `--model-joint GTR20+FO`:

	# step 1: infer an single edge-linked tree with reversible models as initial models
	iqtree2 --seed 1 -T AUTO -s alignment.nex -p train.nex -m MFP -mset LG,WAG,JTT -cmax 4 --prefix train_plant
	
	# step 2: estimate a join non-reversible matrix across all loci
	iqtree2 -seed 1 -T AUTO -s alignment.nex -p train_plant.best_model.nex -te train_plant.treefile --model-joint NONREV+FO --prefix plant_NONREV_FO
	
	# step 3: extract the resulting non-reversible matrix
	grep -A 22 "can be used as input for IQ-TREE" plant_NONREV_FO.iqtree | tail -n21 > NQ.plant

The resulting `NQ.plant` matrix may now look like:

    -1.061624 0.007785 0.002655 0.022039 0.006589 0.014742 0.062839 0.090131 0.001704 0.002323 0.003087 0.001751 0.012195 0.012809 0.041760 0.320267 0.210023 0.003323 0.000857 0.244743
    0.008289 -1.080907 0.020365 0.000987 0.026624 0.177551 0.001802 0.086672 0.075705 0.009088 0.021643 0.491866 0.024868 0.000653 0.006541 0.072228 0.039720 0.013123 0.000986 0.002196
    0.004032 0.019786 -1.313687 0.267488 0.005393 0.008927 0.032858 0.067708 0.062829 0.023892 0.000094 0.252395 0.000094 0.000094 0.000094 0.438096 0.096599 0.000094 0.027919 0.005295
    0.041666 0.003896 0.227284 -0.890796 0.000094 0.000094 0.400738 0.099378 0.050443 0.002720 0.000094 0.007025 0.000094 0.000094 0.000094 0.027181 0.013001 0.000094 0.009413 0.007395
    0.051903 0.094902 0.010786 0.000094 -0.893500 0.026469 0.000094 0.037475 0.106883 0.010559 0.070577 0.000094 0.000094 0.102084 0.000094 0.236907 0.000094 0.012537 0.099632 0.032222
    0.013065 0.194182 0.039046 0.017941 0.000305 -1.075698 0.292962 0.027675 0.095402 0.001329 0.081175 0.209181 0.004369 0.000094 0.062599 0.012804 0.017520 0.000094 0.000094 0.005861
    0.064413 0.000094 0.012826 0.355911 0.000094 0.181070 -0.822679 0.053530 0.003000 0.000094 0.002512 0.097327 0.005370 0.000094 0.005713 0.002772 0.012020 0.000094 0.000094 0.025650
    0.187614 0.053999 0.033263 0.066321 0.009740 0.014380 0.058840 -0.621387 0.003268 0.000094 0.005951 0.015482 0.000094 0.000544 0.000094 0.145278 0.009973 0.000144 0.000094 0.016213
    0.033332 0.235841 0.278083 0.091410 0.023465 0.257662 0.049843 0.011802 -1.428426 0.004130 0.053383 0.021902 0.000094 0.007900 0.054172 0.039777 0.000094 0.000094 0.250585 0.014858
    0.023950 0.001632 0.004395 0.002772 0.003342 0.000717 0.000094 0.000837 0.000094 -1.493125 0.272227 0.010394 0.124246 0.059446 0.000094 0.003597 0.087965 0.000297 0.003057 0.893969
    0.026527 0.011287 0.000094 0.000094 0.002177 0.021633 0.001975 0.000094 0.012033 0.226203 -0.745614 0.000094 0.089496 0.149580 0.006638 0.026123 0.003215 0.013687 0.002033 0.152631
    0.017415 0.341123 0.171696 0.006194 0.000094 0.105871 0.089788 0.009665 0.007083 0.009163 0.002472 -0.829488 0.013473 0.000094 0.003097 0.013503 0.038477 0.000094 0.000094 0.000094
    0.000094 0.043168 0.007303 0.000094 0.011450 0.011888 0.047858 0.000094 0.004725 0.350677 0.567158 0.061171 -1.532577 0.026166 0.000094 0.027269 0.182166 0.012220 0.014137 0.164845
    0.007119 0.004300 0.000094 0.000094 0.023494 0.000094 0.002681 0.008815 0.000094 0.054752 0.348000 0.001664 0.026142 -0.836377 0.000094 0.051269 0.011247 0.006273 0.217177 0.072974
    0.115066 0.035090 0.000094 0.011471 0.000094 0.046128 0.005991 0.007020 0.013780 0.000094 0.071513 0.009870 0.000094 0.000094 -0.550036 0.167147 0.048381 0.001156 0.005462 0.011491
    0.238188 0.080851 0.127209 0.032161 0.040145 0.018437 0.014191 0.071781 0.006455 0.002646 0.050029 0.035037 0.001082 0.032565 0.125243 -1.151350 0.243892 0.000094 0.012692 0.018650
    0.361018 0.036699 0.129824 0.003747 0.000094 0.010391 0.015700 0.012775 0.000630 0.135648 0.002005 0.101363 0.080632 0.000094 0.013000 0.417972 -1.388325 0.000094 0.000094 0.066546
    0.014117 0.017973 0.000094 0.000094 0.025311 0.008866 0.000094 0.034917 0.015069 0.000094 0.068188 0.000094 0.000094 0.037263 0.000094 0.016805 0.000094 -0.251399 0.012044 0.000094
    0.000094 0.000094 0.010861 0.001684 0.031664 0.000094 0.001058 0.000094 0.132692 0.000094 0.000094 0.000094 0.000094 0.405258 0.006474 0.003214 0.000094 0.007815 -0.601659 0.000094
    0.203068 0.005150 0.004281 0.000094 0.003602 0.000454 0.018986 0.008201 0.003052 0.638676 0.198251 0.009524 0.040070 0.033033 0.008064 0.000094 0.062714 0.000094 0.007267 -1.244676

    0.076646 0.049413 0.038372 0.049451 0.010780 0.037824 0.063761 0.052468 0.015186 0.065770 0.104298 0.072672 0.019435 0.049968 0.035179 0.078294 0.045874 0.013490 0.033377 0.087742

> HINT: To assess the statistical support of the root position with bootstraping (-B 1000 option), users can use [this tutorial](Rootstrap).

To estimate a non-reversible model from a folder of alignments:

	# step 1: infer a separate tree for each alignment with reversible models as initial models
	iqtree2 -seed 1 -T AUTO -S train_plant -mset LG,WAG,JTT -cmax 4 -pre train_plant
	
	# step 2: estimate a join non-reversible matrix across all alignments
	iqtree2 -seed 1 -T AUTO -S train_plant.best_model.nex -te train_plant.treefile --model-joint NONREV+FO --init-model LG -pre train_plant.NONREV

	# step 3: extract the resulting non-reversible matrix
	grep -A 22 "can be used as input for IQ-TREE" train_plant.NONREV.iqtree | tail -n21 > NQ.plant


Estimating linked exchangeabilities
-----------------------------------

Starting with version 2.3.1, IQ-TREE allows users to estimate linked exchangeabilities under [profile mixture models](Substitution-Models#protein-mixture-models).

To start with, we show an example:

    iqtree2 -s <alignment> -m GTR20+C60+G4 --link-exchange-rates -te  <guide_tree> -me 0.99

Here, IQ-TREE applies a (freely-estimated) 20x20 rate matrix `GTR20` with the
[profile mixture model](Substitution-Models#protein-mixture-models) `C60` (other model such as C10 can also be used) and Gamma rate heterogeneity across sites. The option `--link-exchange-rates` tells
IQ-TREE to link GTR20 rates across all 60 mixture classes: without this option
IQ-TREE will estimate 60 GTR20 matrices!

The other options are not mandatory but meant to speed up this process:

* `-te` option is to provide a _guide tree_, which is fixed throughout the estimation. This guide tree can be obtained previously from, for example, LG+C60+G or the simpler LG+G. Without this option, IQ-TREE will invoke a full tree search intertwined with model estimation, which may become very time consuming for large datasets.

* `-me 0.99` is to set the log-likelihood difference threshold of determining convergence: higher value will make the optimisation faster. Simulations have shown that changing this parameter has no significant effect on exchangeability estimation.


This command will produce an output file with suffix `.GTRPMIX.nex`. This file contains the optimized exchangeabilities in NEXUS format, that can be applied in later analyses (without re-estimating them) to reconstruct a tree, for example:

    iqtree2 -s <alignment> -mdef <.GTRPMIX.nex file> -m GTRPMIX+C60+G4


The optimizer in IQ-TREE by default initializes exchangeability rates to be all equal, which are the least biased but may make the subsequent optimization quite slow. If users have a good guess of the rate values, the option `--gtr20-model` can be used. For example, `--gtr20-model LG` will intialize the exchangeability to that
of the LG model before optimization. Choosing good starting values can make estimation considerably faster. Apart from LG, users can specify any matrix, including those defined by the `-mdef` option with a [NEXUS model file](Complex-Models#nexus-model-file). Another use of this option is to _test the robustness_ of the optimizer with different starting points.

Note that the user can estimate exchangeabilities jointly with weights of the profiles, branch lengths, and rates. This can be very time-consuming. If the goal is to optimize exchangeabilities, one can fix the other parameters to reasonable estimates (for eg. fixing branch lengths and rates has been shown to perform adequately for the estimation of exchangeabilities).

Because these routines can be computationally expensive, two exchangeability matrices estimated from large concatenated phylogenomic-supermatrices under the C60 profile mixture model are provided to be used for phylogenetic analyses. One, called Eukaryotic Linked Mixture (ELM), is designed for phylogenetic analysis of proteins encoded by nuclear genomes of eukaryotes, and the other, Eukaryotic and Archeal Linked mixture (EAL), for reconstructing relationships between eukaryotes and Archaea, see [Protein models](Substitution-Models#protein-models).

If you use this routine in a publication please cite:

> __H. Banos et al.__ (2024) GTRpmix: A linked general-time reversible model for profile mixture models. _BioRxiv_. <https://doi.org/10.1101/2024.03.29.587376>


[Dang et al., 2022]: https://doi.org/10.1093/sysbio/syac007
[Minh et al., 2021]: https://doi.org/10.1093/sysbio/syab010
[Naser-Khdour et al., 2021]: https://doi.org/10.1093/sysbio/syab067
[El-Gebali et al., 2018]: https://doi.org/10.1093/nar/gky995
[Duchêne et al., 2019]: https://doi.org/10.1093/molbev/msz291
[Ran et al., 2018]: https://doi.org/10.1098/rspb.2018.1012
