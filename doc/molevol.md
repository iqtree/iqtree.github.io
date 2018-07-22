---
layout: userdoc
title: "Tutorial for Workshop on Molecular Evolution"
author: _AUTHOR_
date: _DATE_
docid: 100
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: Tutorial for Workshop on Molecular Evolution.
sections:
- name: Input data
  url: input-data
- name: First example
  url: first-running-example
- name: Model selection
  url: choosing-the-right-substitution-model
- name: Using codon models
  url: using-codon-models
- name: Binary, Morphological, SNPs
  url: binary-morphological-and-snp-data
- name: Ultrafast bootstrap
  url: assessing-branch-supports-with-ultrafast-bootstrap-approximation
- name: Reducing impact of severe model violations with UFBoot
  url: reducing-impact-of-severe-model-violations-with-ufboot
- name: Nonparametric bootstrap
  url: assessing-branch-supports-with--standard-nonparametric-bootstrap
- name: Single branch tests
  url: assessing-branch-supports-with-single-branch-tests
- name: Utilizing multi-core CPUs
  url: utilizing-multi-core-cpus
---

Tutorial for Workshop on Molecular Evolution
===================

<!--more-->

The `iqtree` executable should already be installed on the MBL cluster. If you, however, want to install IQ-TREE to your computer, please first [download](http://www.iqtree.org/#download) and [install](Quickstart) the binary
for your platform. For the next steps, the folder containing your  `iqtree` executable should be added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Alternatively, you can also copy `iqtree` binary into your system search.

>**TIP**: For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 
{: .tip}

Input data
----------
<div class="hline"></div>

IQ-TREE takes as input a *multiple sequence alignment* and will reconstruct an evolutionary tree that is best explained by the alignment. The input alignment can be in various common formats: [Phylip format](http://evolution.genetics.washington.edu/phylip/doc/sequence.html), Fasta, Nexus, ClustalW. IQ-TREE will automatically detect the input file format.

First running example
---------------------
<div class="hline"></div>

Download an [example alignment called `example.phy`](data/example.phy)
 in PHYLIP format. This example contains parts of the mitochondrial DNA sequences of several animals (Source: [Phylogenetic Handbook](http://www.kuleuven.be/aidslab/phylogenybook/home.html)).
 
You can now start to reconstruct a maximum-likelihood tree
from this alignment using `-s` command line option (assuming that you are now in the same folder with `example.phy`):

    iqtree -s example.phy

With this simple command IQ-TREE will first perform ModelFinder (see [choosing the right substitution model](#choosing-the-right-substitution-model) below) to find the best-fit substitution model (i.e. no need to run jModelTest or ProtTest) and then infer a phylogenetic tree using the selected model.
 
At the end of the run IQ-TREE will write several output files including:

* `example.phy.iqtree`: the main report file that is self-readable. You
should look at this file to see the computational results. It also contains a textual representation of the final tree (see below). 
* `example.phy.treefile`: the ML tree in NEWICK format, which can be visualized
by any supported tree viewer programs like FigTree or  iTOL. 
* `example.phy.log`: log file of the entire run (also printed on the screen). To report
bugs, please send this log file and the original alignment file to the authors.

For this example data the resulting maximum-likelihood tree may look like this (extracted from `.iqtree` file):

    NOTE: Tree is UNROOTED although outgroup taxon 'LngfishAu' is drawn at root

	+-------------LngfishAu
	|
	|       +--------------LngfishSA
	+-------|
	|       +------------LngfishAf
	|
	|      +--------------------Frog
	+------|
	       |                     +-----------------Turtle
	       |                  +--|
	       |                  |  |    +------------------------Crocodile
	       |                  |  +----|
	       |                  |       +------------------Bird
	       |               +--|
	       |               |  +---------------------------Sphenodon
	       |         +-----|
	       |         |     +-------------------------------Lizard
	       +---------|
	                 |                   +--------------Human
	                 |                +--|
	                 |                |  |  +------Seal
	                 |                |  +--|
	                 |                |     |  +-----Cow
	                 |                |     +--|
	                 |                |        +-------Whale
	                 |           +----|
	                 |           |    |         +---Mouse
	                 |           |    +---------|
	                 |           |              +------Rat
	                 +-----------|
	                             |  +--------------Platypus
	                             +--|
	                                +-----------Opossum


Here the tree is drawn at the *outgroup* Lungfish which is more accient than other species in this example. However, please note that IQ-TREE always produces an **unrooted tree** as it knows nothing about this biological background; IQ-TREE simply draws the tree this way as `LngfishAu` is the first sequence occuring in the alignment. 


> **QUESTIONS:**
>
> * Does this tree make sense to you?
{: .tip}

During the example run above, IQ-TREE periodically wrote to disk a checkpoint file `example.phy.ckp.gz` (gzip-compressed to save space). This checkpoint file is used to resume an interrupted run, which is handy if you have a very large data sets or time limit on a cluster system. If the run did not finish, invoking IQ-TREE again with the very same command line will recover the analysis from the last stopped point, thus saving all computation time done before. 

If the run successfully completed, running again will issue an error message:

    ERROR: Checkpoint (example.phy.ckp.gz) indicates that a previous run successfully finished
    Use `-redo` option if you really want to redo the analysis and overwrite all output files.
    
This prevents lost of data if you accidentally re-run IQ-TREE. However, if you really want to re-run the analysis and overwrite all previous output files, use `-redo` option: 

    iqtree -s example.phy -redo


Finally, the default prefix of all output files is the alignment file name. You can  
change the prefix using the `-pre` option:

    iqtree -s example.phy -pre myprefix

This prevents output files being overwritten when you perform multiple analyses on the same alignment within the same folder.


Choosing the right substitution model
-------------------------------------
<div class="hline"></div>

IQ-TREE supports a wide range of [substitution models](Substitution-Models) for DNA, protein, codon, binary and morphological alignments. The previous run already determined the best-fit model that minimizes the Bayesian Information Criterion (BIC) score.

> **QUESTIONS:**
>
> * What is the name of the best-fit model? 
> * What do `+I` and `+G` mean?
> * What is the best model according to Akaike Information Criterion (AIC) and the corrected AIC (AICc)?
{: .tip}

Some hints:

* Sometimes you only want to find the best-fit model without doing tree reconstruction, then use option `-m MF`.
* To reduce computational burden, one can use the option `-mset` to restrict the testing procedure to a subset of base models instead of testing the entire set of all available models. For example, `-mset GTR` to only test `GTR+...` models for DNA data, or `-mset WAG,LG` will test only models like `WAG+...` or `LG+...` for protein data.


> For more details about ModelFinder see:
> 
> __S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, and L.S. Jermiin__ (2017) ModelFinder: fast model selection for accurate phylogenetic estimates. _Nat. Methods_, 14:587–589. 
    DOI: [10.1038/nmeth.4285](https://doi.org/10.1038/nmeth.4285)


Assessing branch supports with ultrafast bootstrap approximation
----------------------------------------------------------------
<div class="hline"></div>

To overcome the computational burden required by the nonparametric bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation (UFBoot) ([Minh et al., 2013]; [Hoang et al., in press]) that is  orders of magnitude faster than the standard procedure and provides relatively unbiased branch support values. 

> For more details see
> __D.T. Hoang, O. Chernomor, A. von Haeseler, B.Q. Minh, and L.S. Vinh__ (2018) UFBoot2: Improving the ultrafast bootstrap approximation. *Mol. Biol. Evol.*, 35:518–522. 
    <https://doi.org/10.1093/molbev/msx281>


To run UFBoot, use the option  `-bb`:

    iqtree -s example.phy -m TIM2+I+G -bb 1000

 `-bb`  specifies the number of bootstrap replicates where 1000
is the minimum number recommended. The section  `MAXIMUM LIKELIHOOD TREE` in  `example.phy.iqtree` shows a textual representation of the maximum likelihood tree with branch support values in percentage. The NEWICK format of the tree is printed to the file  `example.phy.treefile`. In addition, IQ-TREE writes the following files:

* `example.phy.contree`: the consensus tree with assigned branch supports where branch lengths are optimized  on the original alignment.
*  `example.phy.splits`: support values in percentage for all splits (bipartitions),
computed as the occurence frequencies in the bootstrap trees. This file is in "star-dot" format.
*  `example.phy.splits.nex`: has the same information as  `example.phy.splits`
but in NEXUS format, which can be viewed with the program [SplitsTree](http://www.splitstree.org) to explore the conflicting signals in the data. So it is more informative than consensus tree, e.g. you can see how highly supported the second best conflicting split is, which had no chance to enter the consensus tree. 

>**NOTE**: UFBoot support values have a different interpretation to the standard bootstrap. Refer to [FAQ: UFBoot support values interpretation](Frequently-Asked-Questions#how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values) for more information.


Finally, the standard nonparametric bootstrap is invoked by  the `-b` option:

    iqtree -s example.phy -m TIM2+I+G -b 100

But we won't do it here due to excessive computations.


Assessing branch supports with single branch tests
--------------------------------------------------
<div class="hline"></div>

IQ-TREE provides an implementation of the SH-like approximate likelihood ratio test ([Guindon et al., 2010]). To perform this test,  run:

    iqtree -s example.phy -m TIM2+I+G -alrt 1000

 `-alrt` specifies the number of bootstrap replicates for SH-aLRT where 1000 is the minimum number recommended. 

IQ-TREE also supports other tests such as the aBayes test ([Anisimova et al., 2011]) and the local bootstrap test ([Adachi and Hasegawa, 1996]). See [single branch tests](Command-Reference#single-branch-tests) for more details.

You can also perform both SH-aLRT and the ultrafast bootstrap within one single run:

    iqtree -s example.phy -m TIM2+I+G -alrt 1000 -bb 1000

The branches of the resulting `.treefile` will be assigned with both SH-aLRT and UFBoot support values, which are readable by any tree viewer program like FigTree, Dendroscope or ETE. You can also look at the textual tree figure in `.iqtree` file:

    NOTE: Tree is UNROOTED although outgroup taxon 'LngfishAu' is drawn at root
    Numbers in parentheses are SH-aLRT support (%) / ultrafast bootstrap support (%)

    +-------------LngfishAu
    |
    |       +--------------LngfishSA
    +-------| (100/100)
    |       +------------LngfishAf
    |
    |      +--------------------Frog
    +------| (99.8/100)
           |                     +-----------------Turtle
           |                  +--| (85/72)
           |                  |  |    +------------------------Crocodile
           |                  |  +----| (96.5/97)
           |                  |       +------------------Bird
           |               +--| (39/51)
           |               |  +---------------------------Sphenodon
           |         +-----| (98.2/99)
           |         |     +-------------------------------Lizard
           +---------| (100/100)
                     |                   +--------------Human
                     |                +--| (92.3/93)
                     |                |  |  +------Seal
                     |                |  +--| (68.3/75)
                     |                |     |  +-----Cow
                     |                |     +--| (99.7/100)
                     |                |        +-------Whale
                     |           +----| (99.1/100)
                     |           |    |         +---Mouse
                     |           |    +---------| (100/100)
                     |           |              +------Rat
                     +-----------| (100/100)
                                 |  +--------------Platypus
                                 +--| (93/98)
                                    +-----------Opossum


> **QUESTIONS**:
> 
> * Discuss the branch supports. What are the unstable branches of the tree?
{: .tip}


Utilizing multi-core CPUs
-------------------------
<div class="hline"></div>

IQ-TREE can utilize multiple CPU cores to speed up the analysis. A complement option `-nt` allows specifying the number of CPU cores to use. Note that for old IQ-TREE versions <= 1.5.X, please change the executable from `iqtree` to `iqtree-omp` for all commands below. For example:

    iqtree -s example.phy -m TIM2+I+G -nt 2


Here, IQ-TREE will use 2 CPU cores to perform the analysis. 

Note that the parallel efficiency is only good for long alignments. A good practice is to use `-nt AUTO` to determine the best number of cores:

    iqtree -s example.phy -m TIM2+I+G -nt AUTO

Then while running IQ-TREE on a computer with 4 physical CPU cores, it may print something like this on to the screen:

    Measuring multi-threading efficiency up to 8 CPU cores
    Threads: 1 / Time: 8.001 sec / Speedup: 1.000 / Efficiency: 100% / LogL: -22217
    Threads: 2 / Time: 4.346 sec / Speedup: 1.841 / Efficiency: 92% / LogL: -22217
    Threads: 3 / Time: 3.381 sec / Speedup: 2.367 / Efficiency: 79% / LogL: -22217
    Threads: 4 / Time: 4.385 sec / Speedup: 1.825 / Efficiency: 46% / LogL: -22217
    BEST NUMBER OF THREADS: 3

Therefore, I would only use 3 cores for this example data. For later analysis with your same data set, you can stick to the determined number.

Partitioned analysis for multi-gene alignments
----------------------------------------------
<div class="hline"></div>

If you used partition model in a publication please cite:

> __O. Chernomor, A. von Haeseler, and B.Q. Minh__ (2016) Terrace aware data structure for phylogenomic inference from supermatrices. _Syst. Biol._, 65:997-1008. 
    <https://doi.org/10.1093/sysbio/syw037>

In the partition model, you can specify a substitution model for each gene/character set. 
IQ-TREE will then estimate the model parameters separately for every partition. Moreover, IQ-TREE provides edge-linked or edge-unlinked branch lengths between partitions:

* `-q partition_file`: all partitions share the same set of branch lengths (like `-q` option of RAxML).
* `-spp partition_file`: like above but allowing each partition to have its own evolution rate.
* `-sp partition_file`: each partition has its own set of branch lengths (like combination of `-q` and `-M` options in RAxML) to account for, e.g. *heterotachy* ([Lopez et al., 2002]).

>**NOTE**: `-spp` is recommended for typical analysis. `-q` is unrealistic and `-sp` is very parameter-rich. One can also perform all three analyses and compare e.g. the BIC scores to determine the best-fit partition model.

IQ-TREE supports RAxML-style and NEXUS partition input file. An example NEXUS partition file:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;

This file contains a  `SETS` block with
 `CharSet` and  `CharPartition` commands to specify individual genes and the partition, respectively.

Please now download a [DNA alignment](data/turtle_nt.phy) originally analysed to study the phylogenetic position of Turtle within Reptiles ([Chiari et al., 2012]). This question was highly debatable some 6 years ago.

First, we will perform an analysis with single model (no partitions) where branch supports are assessed with SH-aLRT and UFBoot:

    iqtree -s turtle_nt.phy -alrt 1000 -bb 1000 -nt AUTO

* Note down the best-fit model and its AIC/BIC scores. 
* Use a tree viewer program (e.g. FigTree) to visualize the resulting tree. Where is Turtle position in the tree? Does it agree with the analysis on `example.phy` done above?

Now download a [partition NEXUS file](data/turtle_nt.nex) containing 248 genes for this Turtle data set. Perform an edge-linked partitioned analysis:

    iqtree -s turtle_nt.phy -alrt 1000 -bb 1000 -spp turtle_nt.nex -nt AUTO

> **QUESTIONS:**
>
> * Is the partition model better than the single model in terms of AIC/BIC scores?
> * Visualize the tree. What is the difference in tree topology compared with the previous tree?
> * Which tree agrees with [Chiari et al., 2012]?
{: .tip}


Choosing the right partitioning scheme
--------------------------------------
<div class="hline"></div>

When there are "short" partitions, it is a good practice to perform PartitionFinder ([Lanfear et al., 2012]), which tries to merge partitions to reduce the number of parameters and improve model fit. When you have many partitions, you can reduce the computational burden with the *relaxed hierarchical clustering algorithm* ([Lanfear et al., 2014]) using `-rcluster` option.

All these techniques are already implemented in ModelFinder. However, we won't however perform this analysis here due to excessive computations. Nevertheless here are a few options for such analysis:

* `-m MFP+MERGE` is to perform PartitionFinder algorithm followed by tree reconstruction.
* `-rcluster 5` is to only examine the top 5% partitioning schemes (similar to the `--rcluster-percent 10` option in PartitionFinder).
* `-mset GTR` to restrict the set of testing models to just GTR. This also helps to save computations.

> **QUESTIONS (if you performed this analysis):**
>
> * How many partitions does not best partitioning scheme have now?
> * What are the AIC/BIC scores?
> * Is there any change in the tree topology?
{: .tip}


Ultrafast bootstrapping with partition model
--------------------------------------------
<div class="hline"></div>

For partitioned analysis, IQ-TREE will by default resample the sites *within* partitions (i.e., 
the bootstrap replicates are generated per partition separately and then concatenated together). However, it is recommended to resample  partitions ([Nei et al., 2001]). This can be done with `-bsam GENE` option. Moreover, IQ-TREE allows an even more complicated
strategy: resampling partitions and then sites within resampled partitions  ([Gadagkar et al., 2005]). This may help to reduce false positives (i.e. wrong branch receiving 100% support). This can be done with `-bsam GENESITE`.

Please now perform ultrafast bootstrap with partition resamplings. 

> **QUESTIONS:**
>
> * Is there any change in tree topology?
> * Do the bootstrap support values get smaller or larger? Why?
{: .tip}


Tree tests
----------
<div class="hline"></div>

We now want to know whether the trees inferred for the Turtle data set have significantly different log-likelihoods or not. This can be conducted with Shimodaira-Hasegawa test ([Shimodaira and Hasegawa, 1999]), or expected likelihood weights ([Strimmer and Rambaut, 2002]).

First, concatenate the trees constructed by single and partition models into one file:

	cat turtle_nt.phy.treefile turtle_nt.nex.treefile >turtle_nt.trees
	
Now pass this file into IQ-TREE via `-z` option:

	iqtree -s turtle_nt.phy -m MODEL_NAME -z turtle_nt.trees -pre turtle_nt.phy.treetest -n 0 -zb 1000 

Options explained:

* Change `MODEL_NAME` to the best-fit model found in the single model run.
* `-pre` is to specify a prefix for output files, so that they do not overwrite previous analysis.
* `-zb` is to specify the number of boostrap replicates for the resampling estimated log-likelihood method (RELL) ([Kishino et al., 1990]).
* `-n 0` is to avoid tree search and estimate model parameters based on an initial parsimony tree.

Now have a look at `turtle_nt.phy.treetest.iqtree`. The results of the tests will be printed to a section called `USER TREES`.

> **Questions:**
> 
> * Do the two trees have significantly different log-likelihoods?
> * How do you do tree tests with partition model? How do the results look like?
{: .tip}


**HINTS**:

 - The KH and SH tests return p-values, thus a tree is rejected if its p-value < 0.05 (marked with a `-` sign).

 - bp-RELL and c-ELW return posterior weights which *are not p-value*. The weights sum up to 1 across the trees tested.

 - The KH test ([Kishino and Hasegawa, 1989]) was designed to test 2 trees and thus has no correction for multiple testing. The SH test ([Shimodaira and Hasegawa, 1999]) fixes this problem.

Identifying most influential genes
-----------------------------

> **NOTE**: This section is optional if you still have time.

Now we want to investigate the cause for such topological difference between trees inferred by single and partition model. One way is to identify genes contributing most phylogenetic signal towards one tree but not the other. 

How can one do this? Well, we can look at the gene-wise log-likelihood differences between the two trees, called T1 and T2. Those genes having the largest lnL(T1)-lnL(T2) will be in favor of T1. Whereas genes showing the largest lnL(T2)-lnL(T1) are favoring T2.

For this purpose, we will do tree tests with partition model and utilize `-wpl` option for writing partition log-likelihoods:


	iqtree -s turtle_nt.phy -spp turtle.nex.best_scheme.nex -z turtle_nt.trees -pre turtle_nt.nex.treetest -n 0 -zb 1000 -wpl

The partition-wise log-likelihoods will be printed to `turtle_nt.nex.treetest.partlh`. 

> **QUESTIONS:**
>
> * What are the two genes that most favor the tree inferred by single model? *HINT*: Use Excel or some R script to process `.partlh` file.
> * Have a look at the paper by ([Brown and Thomson, 2016]). Compare the two genes you found with those from this paper. What is special about these two genes?
{: .tip}


Protein mixture model analysis
----------------

Previous sections only dealt with DNA sequences. We now switch to an interesting protein data set used to examine the position of Microsporidia, a Fungus. Please download the [alignment file here](data/microspo.fa), which is a subset (10 genes) of the full data set ([Brinkmann et al., 2005]). This data set contains some Archaea as outgroup to the remaining Eukaryotes.

First perform a standard model:

	iqtree -s microspo.fa -mset LG -nt AUTO -bb 1000
	
(`-mset LG` to save computations by only testing models `LG+...`).

> **QUESTIONS:**
>
> * Where is the position of Microsporidia, the taxon named `Encephalit_10G`?
> * Does this make sense?
{: .tip}

We will now use the CAT-like protein mixture model called `C10` to `C60` ([Le et al., 2008a]) to analyze the same data set. Moreover, to speed up the analysis we will use the PMSF approximation ([Wang et al., 2018]):

	iqtree -s microspo.fa -nt AUTO -m LG+C10+F+G -bb 1000 -ft microspo.fa.treefile -pre microspo.C10
	
Options explained:

* `-m LG+C10+F+G` is to specify C10+F mixture models (with 11 classes).
* `-ft` is to specify the guide tree for PMSF approximation. Here we just used the tree constructed from single model as it is a reasonable enough tree. Without `-ft`, IQ-TREE will use a full mixture model, which may take a lot of time to finish.

> **QUESTIONS:**
>
> * Where is the position of `Encephalit_10G` now? Does it make sense?
{: .tip}


Where to go from here?
----------------------
<div class="hline"></div>

See [Command Reference](Command-Reference) for a complete list of all options available in IQ-TREE.


[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova et al., 2011]: https://doi.org/10.1093/sysbio/syr041
[Brinkmann et al., 2005]: https://doi.org/10.1080/10635150500234609
[Brown and Thomson, 2016]: https://doi.org/10.1093/sysbio/syw101
[Chiari et al., 2012]: https://doi.org/10.1186/1741-7007-10-65
[Gadagkar et al., 2005]: https://doi.org/10.1002/jez.b.21026
[Guindon et al., 2010]: https://doi.org/10.1093/sysbio/syq010
[Hoang et al., in press]: https://doi.org/10.1093/molbev/msx281
[Kishino et al., 1990]: https://doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: https://doi.org/10.1007/BF02100115
[Lanfear et al., 2012]: https://doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: https://doi.org/10.1186/1471-2148-14-82
[Le et al., 2008a]: https://doi.org/10.1093/bioinformatics/btn445
[Lewis, 2001]: https://doi.org/10.1080/106351501753462876
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Mayrose et al., 2004]: https://doi.org/10.1093/molbev/msh194
[Minh et al., 2013]: https://doi.org/10.1093/molbev/mst024
[Nei et al., 2001]: https://doi.org/10.1073/pnas.051611498
[Shimodaira and Hasegawa, 1999]: https://doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913
[Strimmer and Rambaut, 2002]: https://doi.org/10.1098/rspb.2001.1862
[Wang et al., 2018]: https://doi.org/10.1093/sysbio/syx068
[Yang, 1994]: https://doi.org/10.1007/BF00160154
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

