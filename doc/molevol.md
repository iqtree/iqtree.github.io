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

IQ-TREE takes as input a *multiple sequence alignment* and will reconstruct an evolutionary tree that is best explained by the input data. The input alignment can be in various common formats. For example the [PHYLIP format](http://evolution.genetics.washington.edu/phylip/doc/sequence.html) which may look like:

    7 28
    Frog       AAATTTGGTCCTGTGATTCAGCAGTGAT
    Turtle     CTTCCACACCCCAGGACTCAGCAGTGAT
    Bird       CTACCACACCCCAGGACTCAGCAGTAAT
    Human      CTACCACACCCCAGGAAACAGCAGTGAT
    Cow        CTACCACACCCCAGGAAACAGCAGTGAC
    Whale      CTACCACGCCCCAGGACACAGCAGTGAT
    Mouse      CTACCACACCCCAGGACTCAGCAGTGAT

This tiny alignment contains 7 DNA sequences from several animals with the sequence length of 28 nucleotides. IQ-TREE also supports other file formats such as FASTA, NEXUS, CLUSTALW. The FASTA file for the above example may look like this:

    >Frog       
    AAATTTGGTCCTGTGATTCAGCAGTGAT
    >Turtle     
    CTTCCACACCCCAGGACTCAGCAGTGAT
    >Bird       
    CTACCACACCCCAGGACTCAGCAGTAAT
    >Human      
    CTACCACACCCCAGGAAACAGCAGTGAT
    >Cow        
    CTACCACACCCCAGGAAACAGCAGTGAC
    >Whale      
    CTACCACGCCCCAGGACACAGCAGTGAT
    >Mouse      
    CTACCACACCCCAGGACTCAGCAGTGAT

>**NOTE**: If you have raw sequences, you need to first apply alignment programs like [MAFFT](http://mafft.cbrc.jp/alignment/software/) or [ClustalW](http://www.clustal.org) to align the sequences, before feeding them into IQ-TREE.

First running example
---------------------
<div class="hline"></div>

From the download there is an example alignment called `example.phy`
 in PHYLIP format. This example contains parts of the mitochondrial DNA sequences of several animals (Source: [Phylogenetic Handbook](http://www.kuleuven.be/aidslab/phylogenybook/home.html)).
 
You can now start to reconstruct a maximum-likelihood tree
from this alignment by entering (assuming that you are now in the same folder with `example.phy`):

    iqtree -s example.phy

`-s` is the option to specify the name of the alignment file that is always required by
IQ-TREE to work. At the end of the run IQ-TREE will write several output files including:

* `example.phy.iqtree`: the main report file that is self-readable. You
should look at this file to see the computational results. It also contains a textual representation of the final tree (see below). 
* `example.phy.treefile`: the ML tree in NEWICK format, which can be visualized
by any supported tree viewer programs like FigTree or  iTOL. 
* `example.phy.log`: log file of the entire run (also printed on the screen). To report
bugs, please send this log file and the original alignment file to the authors.

>**NOTE**: Starting with version 1.5.4, with this simple command IQ-TREE will by default perform ModelFinder (see [choosing the right substitution model](#choosing-the-right-substitution-model) below) to find the best-fit substitution model and then infer a phylogenetic tree using the selected model.

For this example data the resulting maximum-likelihood tree may look like this (extracted from `.iqtree` file):

    NOTE: Tree is UNROOTED although outgroup taxon 'LngfishAu' is drawn at root

    +--------------LngfishAu
    |
    |        +--------------LngfishSA
    +--------|
    |        +--------------LngfishAf
    |
    |      +-------------------Frog
    +------|
           |               +-----------------Turtle
           |         +-----|
           |         |     |      +-----------------------Sphenodon
           |         |     |   +--|
           |         |     |   |  +--------------------------Lizard
           |         |     +---|
           |         |         |      +---------------------Crocodile
           |         |         +------|
           |         |                +------------------Bird
           +---------|
                     |                  +----------------Human
                     |               +--|
                     |               |  |  +--------Seal
                     |               |  +--|
                     |               |     |   +-------Cow
                     |               |     +---|
                     |               |         +---------Whale
                     |          +----|
                     |          |    |         +------Mouse
                     |          |    +---------|
                     |          |              +--------Rat
                     +----------|
                                |   +----------------Platypus
                                +---|
                                    +-------------Opossum


This makes sense as the mammals (`Human` to `Opossum`) form a clade, whereas the reptiles (`Turtle` to `Crocodile`) and `Bird` form a separate sister clade. Here the tree is drawn at the *outgroup* Lungfish which is more accient than other species in this example. However, please note that IQ-TREE always produces an **unrooted tree** as it knows nothing about this biological background; IQ-TREE simply draws the tree this way as `LngfishAu` is the first sequence occuring in the alignment. 

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

NOTE: If you use model selection please cite the following paper:

> __S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, and L.S. Jermiin__ (2017) ModelFinder: fast model selection for accurate phylogenetic estimates. _Nat. Methods_, 14:587–589. 
    DOI: [10.1038/nmeth.4285](https://doi.org/10.1038/nmeth.4285)

IQ-TREE supports a wide range of [substitution models](Substitution-Models) for DNA, protein, codon, binary and morphological alignments. If you do not know which model is appropriate for your data, you can use ModelFinder to determine the best-fit model:

    #for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -m MFP
    
    #for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -m TESTNEW
    

`-m` is the option to specify the model name to use during the analysis. The special `MFP` key word stands for _ModelFinder Plus_, which tells IQ-TREE to perform ModelFinder and the remaining analysis using the selected model. ModelFinder computes the log-likelihoods
of an initial parsimony tree for many different models and the *Akaike information criterion* (AIC), *corrected Akaike information criterion* (AICc), and the *Bayesian information criterion* (BIC).
Then ModelFinder chooses the model that minimizes the BIC score (you can also change to AIC or AICc by 
adding the option `-AIC` or `-AICc`, respectively).

>**TIP**: Starting with version 1.5.4, `-m MFP` is the default behavior. Thus, this run is equivalent to `iqtree -s example.phy`.
> If you want to resembles jModelTest/ProtTest, then use option `-m TEST` or `-m TESTONLY` instead.
{: .tip}


Here, IQ-TREE will write an additional file:

* `example.phy.model`: log-likelihoods for all models tested. It serves as a checkpoint file to recover an interrupted model selection.

If you now look at `example.phy.iqtree` you will see that IQ-TREE selected `TIM2+I+G4` as the best-fit model for this example data. Thus, for additional analyses you do not have to perform the model test again and can use the selected model:

    iqtree -s example.phy -m TIM2+I+G

Sometimes you only want to find the best-fit model without doing tree reconstruction, then run:

    #for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -m MF
    
    #for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -m TESTNEWONLY

By default, the maximum number of categories is limitted to 10 due to computational reasons. If your sequence alignment is long enough, then you can increase this upper limit with the `cmax` option:

    #for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -m MF -cmax 15
    
    #for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -m TESTNEWONLY -cmax 15

will test `+R2` to `+R15` instead of at most `+R10`.

To reduce computational burden, one can use the option `-mset` to restrict the testing procedure to a subset of base models instead of testing the entire set of all available models. For example, `-mset WAG,LG` will test only models like `WAG+...` or `LG+...`. Another useful option in this respect is `-msub` for AA data sets. With `-msub nuclear` only general AA models are included, whereas with `-msub viral` only AA models for viruses are included.

If you have enough computational resource, you can perform a thorough and more accurate analysis that invokes a full tree search for each model considered via the `-mtree` option:

    #for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -m MF -mtree

    #for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -m TESTNEWONLY -mtree


Assessing branch supports with ultrafast bootstrap approximation
----------------------------------------------------------------
<div class="hline"></div>

To overcome the computational burden required by the nonparametric bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation (UFBoot) ([Minh et al., 2013]; [Hoang et al., in press]) that is  orders of magnitude faster than the standard procedure and provides relatively unbiased branch support values. Citation for UFBoot:

> __D.T. Hoang, O. Chernomor, A. von Haeseler, B.Q. Minh, and L.S. Vinh__ (2017) UFBoot2: Improving the ultrafast bootstrap approximation. *Mol. Biol. Evol.*, 35:518–522. 
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



Assessing branch supports with  standard nonparametric bootstrap
----------------------------------------------------------------
<div class="hline"></div>

The standard nonparametric bootstrap is invoked by  the  `-b` option:

    iqtree -s example.phy -m TIM2+I+G -b 100

 `-b` specifies the number of bootstrap replicates where 100
is the minimum recommended number. The output files are similar to those produced by the UFBoot procedure. 



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


From this figure, the branching patterns within reptiles are poorly supported (e.g. `Sphenodon` with SH-aLRT: 39%, UFBoot: 51% and `Turtle` with SH-aLRT: 85%, UFBoot: 72%) as well as the phylogenetic position of `Seal` within mammals (SH-aLRT: 68.3%, UFBoot: 75%). Other branches appear to be well supported.


Utilizing multi-core CPUs
-------------------------
<div class="hline"></div>

IQ-TREE can utilize multiple CPU cores to speed up the analysis. A complement option `-nt` allows specifying the number of CPU cores to use. Note that for old IQ-TREE versions <= 1.5.X, please change the executable from `iqtree` to `iqtree-omp` for all commands below. For example:

    iqtree -s example.phy -m TIM2+I+G -nt 2


Here, IQ-TREE will use 2 CPU cores to perform the analysis. 

Note that the parallel efficiency is only good for long alignments. A good practice is to use `-nt AUTO` to determine the best number of cores:

    iqtree -s example.phy -m TIM2+I+G -nt AUTO

Then while running IQ-TREE may print something like this on to the screen:

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

IQ-TREE supports RAxML-style and NEXUS partition input file. The RAxML-style partition file may look like:

    DNA, part1 = 1-100
    DNA, part2 = 101-384

An example NEXUS partition file:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;

This file contains a  `SETS` block with
 `CharSet` and  `CharPartition` commands to specify individual genes and the partition, respectively.

Please now download a [DNA alignment](data/turtle_nt.phy) originally analysed to study the phylogenetic position of Turtle within Reptiles ([Chiari et al., 2012]). This question was highly debatable some 5 years ago.

First, we will perform an analysis with single model (no partitions) where branch supports are assessed with ultrafast bootstrap and choose `protopterus` as outgroup taxon:

    iqtree -s turtle_nt.phy -o protopterus -bb 1000

* Note down the best-fit model and its AIC/BIC scores. 
* Use a tree viewer program (e.g. FigTree) to visualize the resulting tree. Where is Turtle position in the tree? Does it agree with the analysis on `example.phy` done above?

Now download a [partition NEXUS file](data/turtle_nt.nex) containing 248 genes for this Turtle data set. Perform an edge-linked partitioned analysis:

    iqtree -s turtle_nt.phy -o protopterus -bb 1000 -spp turtle_nt.nex

Questions:

* Is the partition model better than the single model in terms of AIC/BIC scores?
* Visualize the tree. What is the difference in tree topology compared with the previous tree?
* Which tree agrees with [Chiari et al., 2012]?


Choosing the right partitioning scheme
--------------------------------------
<div class="hline"></div>

Som

ModelFinder implements a greedy strategy ([Lanfear et al., 2012]) that starts with the full partition model and subsequentially
merges two genes until the model fit does not increase any further:

    # for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -spp example.nex -m MFP+MERGE



Note that this command considers the FreeRate heterogeneity model (see [model selection tutorial](Tutorial#choosing-the-right-substitution-model)). If you want to resemble PartitionFinder by just considering the invariable site and Gamma rate heterogeneity (thus saving computation times), then run:

    iqtree -s example.phy -spp example.nex -m TESTMERGE

> **WARNING**: All these commands with `-m ...MERGE...` will always perform an edge-unlinked partition scheme finding even if `-spp` option is used. Only in the next phase of tree reconstruction, then an edge-linked partition model is used. We plan to implement the edge-linked partition finding in version 1.6.

After ModelFinder found the best partition, IQ-TREE will immediately start the tree reconstruction under the best-fit partition model.
Sometimes you only want to find the best-fit partition model without doing tree reconstruction, then run:

    # for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -spp example.nex -m MF+MERGE

    # for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -spp example.nex -m TESTNEWMERGEONLY

    # to resemble PartitionFinder and save time:
    iqtree -s example.phy -spp example.nex -m TESTMERGEONLY


To reduce the computational burden IQ-TREE implements the *relaxed hierarchical clustering algorithm* ([Lanfear et al., 2014]), which is invoked via `-rcluster` option:

    # for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -spp example.nex -m MF+MERGE -rcluster 10

    # for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -spp example.nex -m TESTNEWMERGEONLY -rcluster 10

to only examine the top 10% partition merging schemes (similar to the `--rcluster-percent 10` option in PartitionFinder).



Ultrafast bootstrapping with partition model
--------------------------------------------
<div class="hline"></div>

IQ-TREE can perform the ultrafast bootstrap with partition models by e.g.,

    iqtree -s example.phy -spp example.nex -bb 1000

Here, IQ-TREE will resample the sites *within*  partitions (i.e., 
the bootstrap replicates are generated per partition separately and then concatenated together).
The same holds true if you do the standard nonparametric bootstrap. 

IQ-TREE supports the partition-resampling strategy as suggested by ([Nei et al., 2001]): 


    iqtree -s example.phy -spp example.nex -bb 1000 -bspec GENE


to resample partitions instead of sites. Moreover, IQ-TREE allows an even more complicated
strategy: resampling partitions and then sites within resampled partitions  ([Gadagkar et al., 2005]). This may help to reduce false positives (i.e. wrong branch receiving 100% support):


    iqtree -s example.phy -spp example.nex -bb 1000 -bspec GENESITE



Constrained tree search
-----------------------
<div class="hline"></div>

Starting with version 1.5.0, IQ-TREE supports constrained tree search via `-g` option, so that the resulting tree must obey a constraint tree topology. The constraint tree can be multifurcating and need not to contain all species. To illustrate, let's return to the [first running example](Tutorial#first-running-example), where we want to force Human grouping with Seal whereas Cow with Whale. If you use the following constraint tree (NEWICK format):

    ((Human,Seal),(Cow,Whale));

Save this to a file `example.constr0` and run:

    iqtree -s example.phy -m TIM2+I+G -g example.constr0 -pre example.constr0
    
(We use a prefix in order not to overwrite output files of the previous run). The resulting part of the tree extracted from `example.constr0.iqtree` looks exactly like a normal unconstrained tree search:


            +--------------Human
         +--|
         |  |  +------Seal
         |  +--|
         |     |  +-----Cow
         |     +--|
         |        +-------Whale
    +----|
    |    |         +---Mouse
    |    +---------|
    |              +------Rat


This is the correct behavior: although Human and Seal are not monophyletic, this tree indeed satisfies the constraint, because the induced subtree separates (Human,Seal) from (Cow,Whale). This comes from the fact that the tree is _unrooted_. If you want them to be sister groups, then you need to include _outgroup_ taxa into the constraint tree. For example:

    ((Human,Seal),(Cow,Whale),Mouse);

Save this to `example.constr1` and run:

    iqtree -s example.phy -m TIM2+I+G -g example.constr1 -pre example.constr1

The resulting part of the tree is then:

               +---------------Human
            +--|
            |  +------Seal
         +--|
         |  |  +-----Cow
         |  +--|
         |     +-------Whale
    +----|
    |    |         +---Mouse
    |    +---------|
    |              +------Rat


which shows the desired effect.

>**NOTE**: While this option helps to enforce the tree based on prior knowledge, it is advised to always perform tree topology tests to make sure that the resulting constrained tree is NOT significantly worse than an unconstrained tree! See [tree topology tests](#tree-topology-tests) and [testing constrained tree](#testing-constrained-tree) below for a guide how to check this.

Tree topology tests
-------------------
<div class="hline"></div>

IQ-TREE can compute log-likelihoods of a set of trees passed via the `-z` option:

    iqtree -s example.phy -z example.treels -m GTR+G

assuming that `example.treels` is an existing file containing a set of trees in NEWICK format. IQ-TREE  first reconstructs an ML tree. Then, it will compute the log-likelihood of the  trees in `example.treels` based on the estimated parameters done for the ML tree. `example.phy.iqtree` will have a section called `USER TREES` that lists the tree IDs and the corresponding log-likelihoods.
The trees with optimized branch lengths can be found in `example.phy.treels.trees`
If you only want to evaluate the trees without reconstructing the ML tree, you can run:

    iqtree -s example.phy -z example.treels -n 0

Here, the number of search iterations is set to 0 (`-n 0`), such that model parameters are quickly estimated from an initial parsimony tree, which is normally accurate enough for our purpose. If you, however, prefer to estimate model parameters based on a tree (e.g. reconstructed previously), use `-te <treefile>` option.  

IQ-TREE also supports several tree topology tests using the RELL approximation ([Kishino et al., 1990]). This includes bootstrap proportion (BP), Kishino-Hasegawa test ([Kishino and Hasegawa, 1989]), Shimodaira-Hasegawa test ([Shimodaira and Hasegawa, 1999]), expected likelihood weights ([Strimmer and Rambaut, 2002]):

    iqtree -s example.phy -z example.treels -n 0 -zb 1000


Here, `-zb` specifies the number of RELL replicates, where 1000 is the recommended minimum number. The `USER TREES` section of `example.phy.iqtree` will list the results of BP, KH, SH, and ELW methods. 

If you also want to perform the weighted KH and weighted SH tests, simply add `-zw` option:

    iqtree -s example.phy -z example.treels -n 0 -zb 1000 -zw

Starting with version 1.4.0 IQ-TREE supports approximately unbiased (AU) test ([Shimodaira, 2002]) via `-au` option:

    iqtree -s example.phy -z example.treels -n 0 -zb 1000 -zw -au

This will perform all above tests plus the AU test.

Finally, note that IQ-TREE will automatically detect duplicated tree topologies and omit them during the evaluation.

>**NOTE**: There is a discrepancy between IQ-TREE and CONSEL for the AU test: IQ-TREE implements the least-square estimate for p-values whereas CONSEL provides the maximum-likelihood estimate (MLE) for p-values. Hence, the AU p-values might be slightly different. We plan to implement MLE for AU p-values in IQ-TREE version 1.6.


>**HINTS**:
>
> - The KH, SH and AU tests return p-values, thus a tree is rejected if its p-value < 0.05 (marked with a `-` sign).
>
> - bp-RELL and c-ELW return posterior weights which *are not p-value*. The weights sum up to 1 across the trees tested.
>
> - The KH test ([Kishino and Hasegawa, 1989]) was designed to test 2 trees and thus has no correction for multiple testing. The SH test ([Shimodaira and Hasegawa, 1999]) fixes this problem.
>
> - However, the SH test becomes too conservative (i.e., rejecting fewer trees than expected) when testing many trees. The AU test ([Shimodaira, 2002]) fixes this problem and is thus recommended as replacement for both KH and SH tests.
{: .tip}



Testing constrained tree
------------------------
<div class="hline"></div>

We now illustrate an example to use the AU test (see above) to test trees from unconstrained versus constrained search, which is helpful to know if a constrained search is sensible or not. Thus:

1. Perform an unconstrained search:
        
        iqtree -s example.phy -m TIM2+I+G -pre example.unconstr
        
2. Perform a constrained search, where `example.constr1` file contains: `((Human,Seal),(Cow,Whale),Mouse);`:
    
        iqtree -s example.phy -m TIM2+I+G -g example.constr1 -pre example.constr1
        
3. Perform another constrained search, where `example.constr2` file contains `((Human,Cow,Whale),Seal,Mouse);`: 

        iqtree -s example.phy -m TIM2+I+G -g example.constr2 -pre example.constr2

4. Perform the last constrained search, where `example.constr3` file contains `((Human,Mouse),(Cow,Rat),Opossum);`: 

        iqtree -s example.phy -m TIM2+I+G -g example.constr3 -pre example.constr3

5. Concatenate all trees into a file:
    
        # for Linux or macOS
        cat example.unconstr.treefile example.constr1.treefile example.constr2.treefile example.constr3.treefile > example.treels
        
        # for Windows
        type example.unconstr.treefile example.constr1.treefile example.constr2.treefile example.constr3.treefile > example.treels
        
    
6. Test the set of trees:
    
        iqtree -s example.phy -m TIM2+I+G -z example.treels -n 0 -zb 1000 -au


Now look at the resulting `.iqtree` file:

    USER TREES
    ----------

    See example.phy.trees for trees with branch lengths.

    Tree      logL    deltaL  bp-RELL    p-KH     p-SH    c-ELW     p-AU
    -------------------------------------------------------------------------
      1   -21152.617   0.000  0.7110 + 0.7400 + 1.0000 + 0.6954 + 0.7939 + 
      2   -21156.802   4.185  0.2220 + 0.2600 + 0.5910 + 0.2288 + 0.3079 + 
      3   -21158.579   5.962  0.0670 + 0.1330 + 0.5130 + 0.0758 + 0.1452 + 
      4   -21339.596 186.980  0.0000 - 0.0000 - 0.0000 - 0.0000 - 0.0000 - 

    deltaL  : logL difference from the maximal logl in the set.
    bp-RELL : bootstrap proportion using RELL method (Kishino et al. 1990).
    p-KH    : p-value of one sided Kishino-Hasegawa test (1989).
    p-SH    : p-value of Shimodaira-Hasegawa test (2000).
    c-ELW   : Expected Likelihood Weight (Strimmer & Rambaut 2002).
    p-AU    : p-value of approximately unbiased (AU) test (Shimodaira, 2002).

    Plus signs denote the 95% confidence sets.
    Minus signs denote significant exclusion.
    All tests performed 1000 resamplings using the RELL method.

One sees that the AU test does not reject the first 3 trees (denoted by `+` sign below the `p-AU` column), whereas the last tree is significantly excluded (`-` sign). All other tests also agree with this. Therefore, groupings of `(Human,Mouse)` and `(Cow,Rat)` do not make sense. Whereas the phylogenetic position of `Seal` based on 3 first trees is still undecidable. This is in agreement with the SH-aLRT and ultrafast bootstrap supports [done in the Tutorial](Tutorial#assessing-branch-supports-with-single-branch-tests). 


Consensus construction and bootstrap value assignment
-----------------------------------------------------
<div class="hline"></div>

IQ-TREE can construct an extended majority-rule consensus tree from a set of trees written in NEWICK or NEXUS format (e.g., produced
by MrBayes):


    iqtree -con mytrees


To build a majority-rule consensus tree, simply set the minimum support threshold to 0.5:


    iqtree -con mytrees -minsup 0.5


If you want to specify a burn-in (the number of beginning trees to ignore from the trees file), use `-bi` option:


    iqtree -con mytrees -minsup 0.5 -bi 100


to skip the first 100 trees in the file.

IQ-TREE can also compute a consensus network and print it into a NEXUS file by:


    iqtree -net mytrees


Finally, a useful feature is to read in an input tree and a set of trees, then IQ-TREE can assign the
support value onto the input tree (number of times each branch in the input tree occurs in the set of trees). This option is useful if you want to compute the support values for an ML tree based on alternative topologies. 


    iqtree -sup input_tree set_of_trees


User-defined substitution models
--------------------------------
<div class="hline"></div>

Users can specify any DNA model using a 6-letter code that defines which rates should be equal. 
For example, `010010` corresponds to the HKY model and `012345` to the GTR model.
In fact, IQ-TREE  uses this specification internally to simplify the coding. The 6-letter code is specified via the `-m` option, e.g.:


    iqtree -s example.phy -m 010010+G


Moreover, with the `-m` option one can input a file which contains the 6 rates (A-C, A-G, A-T, C-G, C-T, G-T) and 4 base frequencies (A, C, G, T).  For example:

    iqtree -s example.phy -m mymodel+G


where `mymodel` is a file containing the 10 entries described above, in the correct order. The entries can be seperated by either empty space(s) or newline character. One can even specify the rates within `-m` option by e.g.:


    iqtree -s example.phy -m 'TN{2.0,3.0}+G8{0.5}+I{0.15}'


That means, we use Tamura-Nei model with fixed transition-transversion rate ratio of 2.0 and purine/pyrimidine rate ratio of 3.0. Moreover, we
use 8-category Gamma-distributed site rates with the shape parameter (alpha) equal to 0.5 and a proportion of invariable sites p-inv=0.15.

By default IQ-TREE computes empirical state frequencies from the alignment by counting, but one can also estimate the frequencies by maximum-likelihood
with `+Fo` in the model name:


    iqtree -s example.phy -m GTR+G+Fo


For amino-acid alignments, IQ-TREE use the empirical frequencies specified in the model. If you want frequencies as counted from the alignment, use `+F`, for example:


    iqtree -s myprotein_alignment -m WAG+G+F


Note that all model specifications above can be used in the partition model NEXUS file.



Inferring site-specific rates
------------------------------
<div class="hline"></div>

IQ-TREE allows to infer site-specific evolutionary rates if a [site-rate heterogeneity model such as Gamma or FreeRate](Substitution-Models#rate-heterogeneity-across-sites) is specified. Here, IQ-TREE will estimate model parameters and then apply an empirical Bayesian approach to assign site-rates as the mean over rate categories, weighted by the posterior probability of the site falling into each category. This approach is provided in IQ-TREE because such empirical Bayesian approach was shown to be most accurate ([Mayrose et al., 2004]). An example run:

    iqtree -s example.phy -m GTR+G -wsr -n 0
    
`-wsr` option stands for writing site rates and the number of search iterations is set to 0, such that model parameters are quickly estimated from an initial parsimony tree. IQ-TREE will write an output file `example.phy.rate` that looks like:

    Site    Rate    Category        Categorized_rate
    1       0.26625 2       0.24393
    2       0.99345 3       0.81124
    3       2.69275 4       2.91367
    4       0.25822 2       0.24393
    5       0.25822 2       0.24393
    6       0.42589 2       0.24393
    7       0.30194 2       0.24393
    8       0.72790 3       0.81124
    9       0.25822 2       0.24393
    10      0.09177 1       0.03116

The 1st column is site index of the alignment (starting from 1), the 2nd column `Rate` shows the mean site-specific rate as explained above, and the 3rd and 4th columns show the category index and rate of the Gamma rate category with the highest probability for this site (1 for slow and 4 for fast rate).

For better site-rate estimates it is recommended to use more than the default 4 rate categories ([Mayrose et al., 2004]). Moreover, one should use a more reasonable tree rather than the parsimony tree. For example:

    iqtree -s example.phy -m GTR+G16 -te ml.treefile -wsr 

where `-te` is the option to input a fixed tree topology and `ml.treefile` is the ML tree reconstructed previously. 

Moreover, we recommend to apply the FreeRate model whenever it fits the data better than the Gamma rate model. This is because the Gamma model constrains the rates to come from a Gamma distribution and thus the highest rate may not be _high enough_ to accomodate the most fast-evolving sites in the alignment. On the contrary, the FreeRate model allows the rates to freely vary. Moreover, FreeRate allows to automatically determine the best number of rate categories, a feature missing in the Gamma model. The following command: 

    # for IQ-TREE version >= 1.5.4:
    iqtree -s example.phy -te ml.treefile -wsr 

    # for IQ-TREE version <= 1.5.3:
    iqtree -s example.phy -m TESTNEW -te ml.treefile -wsr 

will apply ModelFinder to find the best fit model and then infer the site-specific rates based on a given tree file within a single run! If you omit `-te` option, then IQ-TREE will reconstruct an ML tree and use it to infer site-specific rates.


Where to go from here?
----------------------
<div class="hline"></div>

See [Command Reference](Command-Reference) for a complete list of all options available in IQ-TREE.


[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova et al., 2011]: https://doi.org/10.1093/sysbio/syr041
[Chiari et al., 2012]: https://doi.org/10.1186/1741-7007-10-65
[Gadagkar et al., 2005]: https://doi.org/10.1002/jez.b.21026
[Guindon et al., 2010]: https://doi.org/10.1093/sysbio/syq010
[Hoang et al., in press]: https://doi.org/10.1093/molbev/msx281
[Kishino et al., 1990]: https://doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: https://doi.org/10.1007/BF02100115
[Lanfear et al., 2012]: https://doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: https://doi.org/10.1186/1471-2148-14-82
[Lewis, 2001]: https://doi.org/10.1080/106351501753462876
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Mayrose et al., 2004]: https://doi.org/10.1093/molbev/msh194
[Minh et al., 2013]: https://doi.org/10.1093/molbev/mst024
[Nei et al., 2001]: https://doi.org/10.1073/pnas.051611498
[Shimodaira and Hasegawa, 1999]: https://doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913
[Strimmer and Rambaut, 2002]: https://doi.org/10.1098/rspb.2001.1862
[Yang, 1994]: https://doi.org/10.1007/BF00160154
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

