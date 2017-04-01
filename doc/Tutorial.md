<!--jekyll 
docid: 02
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: This tutorial gives a beginner's guide.
sections:
- name: Input data
  url: input-data
- name: First example
  url: first-running-example
- name: Model selection
  url: choosing-the-right-substitution-model
- name: New model selection
  url: new-model-selection
- name: Codon models
  url: codon-models
- name: Binary, Morphological, SNPs
  url: binary-morphological-and-snp-data
- name: Ultrafast bootstrap
  url: assessing-branch-supports-with-ultrafast-bootstrap-approximation
- name: Nonparametric bootstrap
  url: assessing-branch-supports-with--standard-nonparametric-bootstrap
- name: Single branch tests
  url: assessing-branch-supports-with-single-branch-tests
- name: Utilizing multi-core CPUs
  url: utilizing-multi-core-cpus
jekyll-->

Beginner's tutorial
===================

This tutorial gives a beginner's guide. 
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Input data](#input-data)
- [First running example](#first-running-example)
- [Choosing the right substitution model](#choosing-the-right-substitution-model)
- [New model selection](#new-model-selection)
- [Codon models](#codon-models)
- [Binary, morphological and SNP data](#binary-morphological-and-snp-data)
- [Assessing branch supports with ultrafast bootstrap approximation](#assessing-branch-supports-with-ultrafast-bootstrap-approximation)
- [Assessing branch supports with  standard nonparametric bootstrap](#assessing-branch-supports-with--standard-nonparametric-bootstrap)
- [Assessing branch supports with single branch tests](#assessing-branch-supports-with-single-branch-tests)
- [Utilizing multi-core CPUs](#utilizing-multi-core-cpus)
- [Where to go from here?](#where-to-go-from-here)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Please first [download](Home#download) and [install](Quickstart) the binary
for your platform . For the next steps, the folder containing your  `iqtree` executable should be added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Alternatively, you can also copy `iqtree` binary into your system search.

>**TIP**: For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 

Input data
----------

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

>**TIP**: If you have raw sequences, you need to first apply alignment programs like [MAFFT](http://mafft.cbrc.jp/alignment/software/) or [ClustalW](http://www.clustal.org) to align the sequences, before feeding them into IQ-TREE.

First running example
---------------------

From the download there is an example alignment called `example.phy`
 in PHYLIP format. This example contains parts of the mitochondrial DNA sequences of several animals (Source: [Phylogenetic Handbook](http://www.kuleuven.be/aidslab/phylogenybook/home.html)).
 
You can now start to reconstruct a maximum-likelihood tree
from this alignment by entering (assuming that you are now in the same folder with `example.phy`):

    iqtree -s example.phy

`-s` is the option to specify the name of the alignment file that is always required by
IQ-TREE to work. At the end of the run IQ-TREE will write several output files:

* `example.phy.iqtree`: the main report file that is self-readable. You
should look at this file to see the computational results. It also contains a textual representation of the final tree (see below). 
* `example.phy.treefile`: the ML tree in NEWICK format, which can be visualized
by any supported tree viewer programs like FigTree or  iTOL. 
* `example.phy.log`: log file of the entire run (also printed on the screen). To report
bugs, please send this log file and the original alignment file to the authors.

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

Finally, the default prefix of all output files is the alignment file name. However,  you can always 
change the prefix using the `-pre` option, e.g.:

    iqtree -s example.phy -pre myprefix

This prevents output files to be overwritten when you perform multiple analyses on the same alignment within the same folder. 


Choosing the right substitution model
-------------------------------------

IQ-TREE supports a wide range of [substitution models](Substitution-Models) for DNA, protein, codon, binary and morphological alignments. If the model is not specified, IQ-TREE will use the default model (
HKY for DNA, WAG for protein). In case you do not know which model is appropriate for your data,  IQ-TREE can automatically determine the best-fit model 
for your alignment using the `-m TEST` option. For example:

    iqtree -s example.phy -m TEST

`-m` is the option to specify the model name to use during the analysis. `TEST`
is a key word telling IQ-TREE to perform the model test procedure and select the best-fit model. The remaining analysis
will be done using the selected model. More specifically, IQ-TREE computes the log-likelihoods
of the initial parsimony tree for many different models and the *Akaike information criterion* (AIC), *corrected Akaike information criterion* (AICc), and the *Bayesian information criterion* (BIC).
Then IQ-TREE chooses the model that minimizes the BIC score (you can also change to AIC or AICc by 
adding the option `-AIC` or `-AICc`, respectively.
Here, IQ-TREE will write an additional file:

* `example.phy.model`: log-likelihoods for all models tested.

If you now look at `example.phy.iqtree` you will see that IQ-TREE selected the model `TIM2`
with Invar+Gamma rate heterogeneity. So `TIM2+I+G` is the best-fit model
for this example data. Thus, for additional analyses you do not have to perform the model test again and can use the selected model as follows.


    iqtree -s example.phy -m TIM2+I+G

Sometimes you only want to find the best-fit model without doing tree reconstruction, then run:

    iqtree -s example.phy -m TESTONLY

Here, IQ-TREE will stop after finishing the model selection. Note that if the file `*.model` exists and is correct, IQ-TREE will reuse the computed log-likelihoods  to speed up the model selection procedure. 

New model selection
-------------------

The previous section described the "standard" model selection to automatically select the best-fit model for the data before performing tree reconstruction. This "standard" procedure includes four rate heterogeneity types: homogeneity, `+I`, `+G` and `+I+G`. However, there is no reason to believe that the evolutionary rates follow a Gamma distribution. Therefore, we have recently introduced the FreeRate (`+R`) heterogeneity ([Yang, 1995]) into IQ-TREE. The `+R` model generalizes the Gamma model by relaxing the "Gamma constraints", where the site rates and proportions are inferred independently from the data. Another advantage is that `+R` allows to automatically determine the number of rate categories, which is impossible with `+G` where the default of 4 categories is used. This can be important especially for phylogenomic data, where 4 categories may "underfit" the data.

Therefore, we recommend a new *ModelFinder* procedure that additionally considers `+R` rate heterogeneity. This can be invoked simply with e.g.:

    iqtree -s example.phy -m MF
    # for IQ-TREE version <= 1.5.3 use -m TESTNEWONLY 

It will also automatically determine the optimal number of rate categories. By default, the maximum number of categories is 10 due to computational reasons. If the sequences of your alignment are long enough, then you can increase this upper limit with the `cmax` option:

    iqtree -s example.phy -m MF -cmax 15

will test `+R2` to `+R15` instead of at most `+R10`.

To reduce computational burden, one can use the option `-mset` to restrict the testing procedure to a subset of base models instead of testing the entire set of all available models. For example, `-mset WAG,LG` will test only models like `WAG+...` or `LG+...`. Another useful option in this respect is `-msub` for AA data sets. With `-msub nuclear` only general AA models are included, whereas with `-msub viral` only AA models for viruses are included.

If you have enough computational resource, you can perform a thorough and more accurate analysis that invokes a full tree search for each model considered via the `-mtree` option:

    iqtree -s example.phy -m MF -mtree

Finally, if you want to immediately perform tree reconstruction after model selection, then use `-m MFP`:

    iqtree -s example.phy -m MFP


Codon models
------------

IQ-TREE supports a number of [codon models](Substitution-Models#codon-models). You need to input a protein-coding DNA alignment and specify codon data by option `-st CODON` (Otherwise, IQ-TREE applies DNA model because it detects that your alignment has DNA sequences):

    iqtree -s coding_gene.phy -st CODON 

If your alignment length is not divisible by 3, IQ-TREE will stop with an error message. IQ-TREE will group sites 1,2,3 into codon site 1; sites 4,5,6 to codon site 2; etc. Moreover, any codon, which has at least one gap/unknown/ambiguous nucleotide, will be treated as unknown codon character.

If you are not sure which model to use, simply add `-m TEST`, which also works for codon alignments: 

    iqtree -s coding_gene.phy -st CODON -m TEST

By default IQ-TREE uses the standard genetic code. If you want to change the genetic code, please refer to [codon models guide](Substitution-Models#codon-models).


Binary, morphological and SNP data
---------------------------------

IQ-TREE supports discrete morphological alignments by  `-st MORPH` option:

    iqtree -s morphology.phy -st MORPH

IQ-TREE implements to two morphological ML models: [MK and ORDERED](Substitution-Models#binary-and-morphological-models). Morphological data typically do not have constant (uninformative) sites. 
In such cases, you should apply [ascertainment bias correction](Substitution-Models#ascertainment-bias-correction) model by e.g.:
 
    iqtree -s morphology.phy -st MORPH -m MK+ASC

You can again select the best-fit model with  `-m TEST` (which also considers +G):

    iqtree -s morphology.phy -st MORPH -m TEST

For SNP data (DNA) that typically do not contain constant sites, you can explicitly tell the model to include
ascertainment bias correction:

    iqtree -s SNP_data.phy -m GTR+ASC

You can explicitly tell model testing to only include  `+ASC` model with:

    iqtree -s SNP_data.phy -m TEST+ASC


Assessing branch supports with ultrafast bootstrap approximation
----------------------------------------------------------------

To overcome the computational burden required by the nonparametric bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation (UFBoot) ([Minh et al., 2013]) that is  orders of magnitude faster than the standard procedure and provides relatively unbiased branch support values. To run UFBoot, use the option  `-bb`:

    iqtree -s example.phy -m TIM2+I+G -bb 1000

 `-bb`  specifies the number of bootstrap replicates where 1000
is the minimum number recommended. The section  `MAXIMUM LIKELIHOOD TREE` in  `example.phy.iqtree` shows a textual representation of the maximum likelihood tree with branch support values in percentage. The NEWICK format of the tree is printed to the file  `example.phy.treefile`. In addition, IQ-TREE writes the following files:

* `example.phy.contree`: the consensus tree with assigned branch supports where branch lengths are optimized  on the original alignment.
*  `example.phy.splits`: support values in percentage for all splits (bipartitions),
computed as the occurence frequencies in the bootstrap trees. This file is in "star-dot" format.
*  `example.phy.splits.nex`: has the same information as  `example.phy.splits`
but in NEXUS format, which can be viewed with the program SplitsTree. 

>**TIP**: UFBoot support values have a different interpretation to the standard bootstrap. Refer to [FAQ: UFBoot support values interpretation](Frequently-Asked-Questions#how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values) for more information.


Assessing branch supports with  standard nonparametric bootstrap
----------------------------------------------------------------

The standard nonparametric bootstrap is invoked by  the  `-b` option:

    iqtree -s example.phy -m TIM2+I+G -b 100

 `-b` specifies the number of bootstrap replicates where 100
is the minimum recommended number. The output files are similar to those produced by the UFBoot procedure. 



Assessing branch supports with single branch tests
--------------------------------------------------

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

A specialized version of IQ-TREE (`iqtree-omp`) can utilize multiple CPU cores to speed up the analysis.
To obtain this version please refer to the [quick starting guide](Quickstart).  A complement option `-nt` allows specifying the number of CPU cores to use. For example:


    iqtree-omp -s example.phy -m TIM2+I+G -nt 2


Here, IQ-TREE will use 2 CPU cores to perform the analysis. 

Note that the parallel efficiency is only good for long alignments. A good practice is to use `-nt AUTO` to determine the best number of cores:

    iqtree-omp -s example.phy -m TIM2+I+G -nt AUTO

Then while running IQ-TREE may print something like this on to the screen:

    Measuring multi-threading efficiency up to 8 CPU cores
    Threads: 1 / Time: 8.001 sec / Speedup: 1.000 / Efficiency: 100% / LogL: -22217
    Threads: 2 / Time: 4.346 sec / Speedup: 1.841 / Efficiency: 92% / LogL: -22217
    Threads: 3 / Time: 3.381 sec / Speedup: 2.367 / Efficiency: 79% / LogL: -22217
    Threads: 4 / Time: 4.385 sec / Speedup: 1.825 / Efficiency: 46% / LogL: -22217
    BEST NUMBER OF THREADS: 3

Therefore, I would only use 3 cores for this example data. For later analysis with your same data set, you can stick to the determined number.

Where to go from here?
----------------------------

Once confident enough you can go on with a **[more advanced tutorial](Advanced-Tutorial)**, which covers topics like phylogenomic (multi-gene) analyses using partition models or mixture models.


[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova et al., 2011]: http://dx.doi.org/10.1093/sysbio/syr041
[Gadagkar et al., 2005]: http://dx.doi.org/10.1002/jez.b.21026
[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Lanfear et al., 2012]: http://dx.doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: http://dx.doi.org/10.1186/1471-2148-14-82
[Lewis, 2001]: http://dx.doi.org/10.1080/106351501753462876
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

