Introduction
============

What is AliSim?
------------
<div class="hline"></div>

AliSim is a fast, efficient, versatile, and realistic sequence simulator for simulating huge genomic data sets. It is provided as an extension of the [IQ-TREE software](www.iqtree.org) version 2.2

* __Fast__: AliSim is much faster than existing simulation tools. It takes only a few minutes to generate millions of sequences or sites while other existing simulators, namely [Seq-Gen](https://academic.oup.com/bioinformatics/article/13/3/235/423110), [Dawg](https://pubmed.ncbi.nlm.nih.gov/16306390/), and [Indelible](https://academic.oup.com/mbe/article/26/8/1879/980884), and [PhastSim](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7987011/) are unable or require several hours, even a few days.
* __Efficient__:  AliSim consumes far less memory than other simulators. It consumes approximately 1 GB RAM to generate one million sequences with 30 thousand sites while other simulators require tens to hundreds GB of RAM. 
* __Versatile__: AliSim integrates a wide range of evolutionary models available in the IQ-TREE software, including standard, mixture, and partition models. Also, it offers flexible and convenient options for users to perform complex simulations by supporting versatile use cases. 
* __Realistic__: AliSim can simulate realistic MSAs from biologically inspired parameters: it could randomly generate model parameters  from  either empirical distributions (extracted from a large collection of biological datasets) or user-defined lists of numbers; it also allows users to simulate an alignment that mimics the evolutional process of a real biological alignment, a task not supported in other tools.

Key features
------------
<div class="hline"></div>


* __AliSim supports a wide range of evolutionary models__: It supports a vast majority of evolutionary models not available in other existing simulators. AliSim allows users to simulate different data types, including DNA, amino-acid, codon, binary, and multi-state morphological data using more than 200 time-reversible substitution models, around 100 non-reversible models. AliSim also supports complex partition and mixture models. 
  * __Common models__: All [common substitution models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models) with [rate heterogeneity across sites](https://github.com/iqtree/iqtree2/wiki/Substitution-Models#rate-heterogeneity-across-sites) and [ascertainment bias correction](https://github.com/iqtree/iqtree2/wiki/Substitution-Models#ascertainment-bias-correction), e.g., SNP data.
  * __Heterotachy models__: Allowing each branch in the phylogenetic tree may have multiple lengths corresponding to different classes of the [GHOST model](https://doi.org/10.1093/sysbio/syz051). Besides, we offer various options to link, unlink models’ parameters across all classes, or use separate base frequencies for each class. 
  * __Partition models__: Allowing individual models for different genomic loci (e.g., genes or codon positions), mixed data types, mixed rate heterogeneity types, [linked, unlinked, and proportional branch lengths between partitions](https://github.com/iqtree/iqtree2/wiki/Complex-Models#partition-models). Furthermore, AliSim also supports tree mixture models, in which each partition could have a different tree topology.
  * __Mixture models__: [fully customizable site mixture models](https://github.com/iqtree/iqtree2/wiki/Complex-Models#mixture-models), [empirical protein mixture models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models#protein-mixture-models), and [branch-specific models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models#branch-specific-models), which assign different models of sequence evolution to individual branches of a tree.
  
* __AliSim  offers more realistic simulations__, It could simulate an MSA that mimics the evolutionary history of a given MSA. It also copies the gap patterns from the input MSA to the output MSA. Additionally, AliSim natively allows users to generate a random tree under biologically plausible models, such as the [Birth-Death model](https://www.jstor.org/stable/2236051) and the more restrictive [Yule](https://www.jstor.org/stable/92117)-[Harding](https://www.jstor.org/stable/1426329) (by default) or the [Uniform model](https://pubmed.ncbi.nlm.nih.gov/10704639/).
* __AliSim achieves high-performance efficiency__: AliSim is superior to all existing simulation tools regarding  model flexibility, execution times, and memory usage in simulating huge phylogenetic datasets. More specifically, AliSim takes only a few minutes and about 1GB RAM to generate  alignments with millions of sequences or sites on a personal computer, while other software Seq-Gen, Dawg, Indelible, and PhastSim require several hours and/or tens to hundreds GB of RAM. Moreover, the memory usage of AliSim only increases sub-linearly with the number of sequences and remains more or less constant with increasing sequence length.

How to cite AliSim?
--------------------
<div class="hline"></div>

> **To maintain AliSim, support users, it is important for us that you cite the following papers.**

* __L.T. Nhan, B.Q. Minh__ (2021) AliSim: Ultrafast Sequence Alignment  Simulator, ... <https://doi.org/...>


Getting started
===============

Installation
------------
<div class="hline"></div>

Users could download and/or install AliSim from one of the following options:

### Packages and bundles

As an extension of the IQ-Tree software, AliSim could be obtained by installing the IQ-Tree package/bundle following this [Installation Guide](https://github.com/iqtree/iqtree2/wiki/Quickstart).

### Manual download

AliSim for Windows, MacOSX, and Linux can be [downloaded here](http://www.iqtree.org/#download).

* Extract the `.zip` (Windows, MacOSX) or `.tar.gz` (Linux) file to create a directory `iqtree-X.Y.Z-OS`, where `X.Y.Z` is the version number and `OS` is the operating system (Windows, MacOSX, or Linux).
* You will find the executable in the `bin` sub-folder. Copy all files in `bin` folder to your system search path such that you can run IQ-TREE by entering `iqtree2` from the Terminal.

Now you need to open a Terminal (or Console) to run IQ-TREE/AliSim (see the guide for [Windows users](https://github.com/iqtree/iqtree2/wiki/Quickstart#for-windows-users) and [Mac OS X users](https://github.com/iqtree/iqtree2/wiki/Quickstart#for-mac-os-x-users)) then continue with the following Tutorial to see how to run simple and complex simulations with AliSim.

Tutorial
===================

At this step, we assume that you have successfully downloaded and installed IQ-Tree/AliSim. For the next steps, the folder containing your  `iqtree2` executable should be added to your PATH environment variable so that IQ-TREE/AliSim can be invoked by simply entering `iqtree2` at the command-line. Alternatively, you can also copy `iqtree2` binary into your system search.

AliSim is invoked from the command-line with, e.g.,

    iqtree2 --alisim <OUTPUT_PREFIX> -m <MODEL> -t <TREEFILE>

assuming that IQ-TREE can be run by simply entering `iqtree2`. 

>**TIP**: For a quick overview of all supported options in IQ-TREE/AliSim, run the command  `iqtree -h`. 

Input data
----------
<div class="hline"></div>

AliSim takes as input a *phylogenetic tree* and an *evolutionary model*, then simulates an alignment of sequences at the tips of the tree that have evolved along the tree.

The input tree should be in the [PHYLIP format](https://evolution.genetics.washington.edu/phylip/doc/main.html#treefile), which may look like:

    (LngfishAu:0.3544240993,(Rat:0.1905941554,Platypus:0.1328977434):0.0998619427,Opossum:0.0898418080);

This tiny tree contains 4 tips corresponding to 4 species. 

First running example
---------------------
<div class="hline"></div>

From the downloaded folder, there is an example tree called `example.phy.treefile` in PHYLIP format in the folder `example`.
 
You can now start simulating a multiple sequence alignment (assuming that you are now in the same folder with `example.phy.treefile`):

    iqtree2 --alisim Dayhoff_1000 -m Dayhoff -t example.phy.treefile

* `--alisim Dayhoff_1000` is the option to activate AliSim from the IQ-TREE software, and specify the prefix for the output file name as `Dayhoff_1000`.
* `-m Dayhoff` is the option to specify the substitution model is `Dayhoff`. Since `Dayhoff` is a protein model, AliSim automatically detects the sequence type, then generates amino-acid data.
* `-t example.phy.treefile` is the option to specify the input phylogenetic tree. 

At the end of that run, AliSim writes out the simulated MSA into a file named `Dayhoff_1000_0.phy`. The output MSA should contain 17 sequences (corresponding to the number of tips in the input tree). Each sequence consists of 1000 sites. By default, the output file should be in PHYLIP format, as illustrated below. Users could use `-af fasta` to output the simulated MSA in FASTA format.

    17 1000
    Frog       AAATTTGGTCCTGTGATTCAGCAGTGAT...
    Turtle     CTTCCACACCCCAGGACTCAGCAGTGAT...
    Bird       CTACCACACCCCAGGACTCAGCAGTAAT...
    Human      CTACCACACCCCAGGAAACAGCAGTGAT...
    Cow        CTACCACACCCCAGGAAACAGCAGTGAC...
    Whale      CTACCACGCCCCAGGACACAGCAGTGAT...
    Mouse      CTACCACACCCCAGGACTCAGCAGTGAT...
    ...
      
Simulating MSAs that mimic a user-provided MSA
-------------------------------------
<div class="hline"></div>

AliSim allows users to simulate MSAs that mimic the evolutionary history of a given MSA as the below example:
        
      iqtree2 --alisim output_10k -s example.phy --num-alignments 3 --length 10000

* `--alisim output_10k` is the option to activate AliSim from the IQ-TREE software, and specify the prefix for the output file name as `output_10k`.
* `-s example.phy` is the option to supply the input alignment of sequences. 
* `--num-alignments 3` is the option to specify the number of output MSAs is 3. 
* `--length 10000` is the option to specify the sequence length at 10,000 sites. 

In this example, AliSim infers the phylogenetic tree and the substitution model with its parameters from the input MSA `example.phy`. After that, MSAs will be generated one by one based on the inferred tree and the substitution model. By default, AliSim will then copy the gap patterns from the input to the output MSAs. To disable this feature, users could add the option `--no-copy-gaps` to the execution command.

At the end of the run, AliSim will output 3 MSAs in three separate files, namely, `output_10k_0.phy`, `output_10k_1.phy`, and `output_10k_2.phy`. Each MSA contains 17 sequences (equally to the number of sequences in the input MSA). Each sequence contains 10,000 sites.

Simulating MSAs from a random tree
------------------
<div class="hline"></div>

AliSim supports users to produce MSAs from a random tree generated by common models (such as Yule-Harding, Uniform, Caterpillar, Balanced, Birth-Death). Let's have a look at this example:

     iqtree2 --alisim HKY_1000 -t RANDOM{yh,1000} -m HKY{2.0}+F{0.2,0.3,0.1,0.4} -gz

* `--alisim HKY_1000` is the option to activate AliSim from the IQ-TREE software, and specify the prefix for the output file name as `HKY_1000`.
* `-t RANDOM{yh,1000}` is the option to specify the number of tips of the random tree is 1,000, and the model Yule-Harding will be used  to draw the tree randomly.
* `-m HKY+F{0.2,0.3,0.1,0.4}` is the option to specify the substitution model HKY with the evolutionary rates are 2.0 and 1.0, and the base frequencies corresponding to the base A, C, G, T are 0.2, 0.3, 0.1, and 0.4, respectively. 
* `-gz` is the option to compress the output file. 

By default, branch lengths of the random tree are randomly drawn from an exponential distribution with the mean of 0.1. Users could adjust the minimum, the maximum, and the mean of the exponential distribution via the option `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`.

At the end of the run, AliSim will write out the simulated MSA into a compressed file named `HKY_1000_0.phy`. The output MSA should contain 1,000 sequences (corresponding to the given number of tips). Each sequence consists of 1,000 sites.

Simulating MSAs from random parameters generated from empirical distributions or user-defined lists of numbers
------------------
<div class="hline"></div>
By default, if nucleotide frequencies are neither specified nor possible to be inferred from a user-provided MSA, AliSim will randomly generate these frequencies from empirical distributions as the following example. 

     iqtree2 --alisim JC_1000 -t example.phy.treefile -m JC

In this case, AliSim would simulate an MSA based on the JC model. The frequencies of base A, C, G, and T, will be randomly generated from empirical distributions, namely, Generalized-logistic, Exponential-normal, Power-log-normal, Exponential-Weibull. In fact, these distributions and their parameters were estimated from a large collection of empirical datasets [REF](http://google.com). 

In addition to five built-in distributions, namely *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*, users could define their own lists of numbers, then generate other model parameters from these lists by following these steps. Note that user-defined lists of numbers could be generated from different distributions.

Firstly, generating a set of random numbers for each list, then defining the new lists in a file named `custom_distributions.txt` as the following example

    F_A 10000 0.363799 0.313203 0.277533 0.242350 ...
    F_B 10000 0.268955 0.278675 0.290531 0.237410 ...
    F_C 10000 0.320556 0.440894 0.332368 0.227977 ...
    F_D 10000 0.234732 0.309629 0.353117 0.414357 ...
    R_A 5000 2.306336 4.359459 0.249315 0.388073 ...
    R_B 5000 1.257679 0.417313 3.290922 2.301826 ...
    R_C 5000 0.200087 1.336534 3.337547 2.325379 ...
    R_D 5000 0.321134 0.299891 1.315519 0.269172 ...

Each list should be defined in a single line, starting with the list name, followed by the number of random numbers, and ending up with random numbers. These numbers should be separated by space. The given file `custom_distributions.txt` defines 8 new lists. While the first 4 lists consist of 10,000 random numbers for each list, the other lists contain 5,000 random numbers.

Secondly, loading these lists and generating MSA with random parameters with

     iqtree2 --alisim GTR_1000 -t example.phy.treefile -m GTR{1.5,R_A,R_B,0.5,R_C}+F{Generalized_logistic,0.3,F_A,0.2}+I{F_D}+G{F_C} --distribution custom_distributions.txt

In this example, 3 evolutionary rates of GTR models are randomly drawn from the lists `R_A,R_B,R_C` while other rates are specified by the user. Similarly, the frequencies of base A and G are generated from the lists `Generalized_logistic`, and `F_A` whereas the relative frequencies of base C and T are 0.3 and 0.2. These state frequencies are automatically normalized so that they sum to 1. Furthermore, the Invariant Proportion and the Gamma Shape would also be drawn from the appropriate lists named `F_D`, and `F_C`, respectively. 

This feature is not limited to DNA models, users could also use user-defined lists to randomly generate parameters (e.g., evolutionary rates, state frequencies, nonsynonymous/synonymous rate ratio, transition rate, transversion rate, category weight/proportion) for other kinds of models/data (e.g., Protein, Codon, Binary, Morph, Lie Markov, Heterotachy, and Mixture). 

Furthermore, users can also randomly generate branch lengths of the phylogenetic tree from a user-defined list with the option `--branch-distribution DISTRIBUTION_NAME` as below

    iqtree2 --alisim JC_1000 -t RANDOM{bd{0.8,0.2},1000} -m JC --branch-distribution F_A --distribution custom_distributions.txt

In this example, AliSim simulates an MSA from the `JC` model and a random tree generated from the Birth-Death model with the birth rate, and death rate are 0.8, and 0.2, respectively. The branch lengths of the random tree are randomly drawn from the user-defined list `F_A`. In this example, if the user supplies a tree file (instead of a random tree), the branch lengths of the user-provided tree will be overridden by the random lengths from the list `F_A`.

Command reference
=================
All the options available in AliSim are shown below:

| Option | Usage and meaning |
|--------------|------------------------------------------------------------------------------|
|`--alisim <OUTPUT_FILENAME>`| Activate the simulator and specify the prefix for the output filename. |
| `-t <TREE_FILEPATH>`   | Set the path to the input tree. |
| `--seqtype <SEQUENCE_TYPE>`  | Specify the sequence type (BIN, DNA, AA, CODON, MORPH{`<NUMBER_STATES>`}) of the output *(optional)*. `<NUMBER_STATES>` is the number of states to simulate morphological data. <br>*By default, Alisim automatically detects the sequence_type from the model name*. |
| `-m <MODEL>`   | Specify the model name [and its parameters (optional)]. <br> See [Substitution Models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models) and [Complex Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models) for the list of supported models, how to use complex models (mixture, partition, rate heterogeneity across sites, heterotachy, Ascertainment Bias Correction, etc.), and syntax to specify model parameters (rates, base frequencies, omega, kappa, kappa2, etc.) or define new models.|
| `-mdef <MODEL_FILE>`  | Define new models by their parameters. |
| `--fundi <TAXON_1>,...,<TAXON_N>,<RHO>`   | Specifying parameters for the [FunDi model](https://doi.org/10.1093/bioinformatics/btr470), which allows a proportion number of sites (`<RHO>`) in the sequence of each taxon in the given list (`<TAXON_1>,...,<TAXON_N>`), could be permuted with each other. |
| `--indel <INS>,<DEL>`  | Activate Indels (insertion/deletion events) and specify the ratio of the insertion rate `<INS>`, and the deletion rate `<DEL>`, respectively to the substitution rate. |
| `--indel-distribution <INS_DIS>,<DEL_DIS>`  | Specify the distributions for generating the random numbers of sites to insert/delete. By default, a geometric distribution with p of 0.5 is used.|
| `-q <PARTITION_FILE>` or <br>`-p <PARTITION_FILE>` or <br>`-Q <PARTITION_FILE>` | `-q <PARTITION_FILE>`: Edge-equal partition model with equal branch lengths: All partitions share the same set of branch lengths. <br>`-p <PARTITION_FILE>`: Edge-proportional partition model with proportional branch lengths: Like above, but each partition has its own partition specific rate, which rescales all its branch lengths. This model accommodates different evolutionary rates between partitions.<br>`-Q <PARTITION_FILE>`: Edge-unlinked partition model: Each partition has its own set of branch lengths. <br>`<PARTITION_FILE>` could be specified by a RAXML or NEXUS file as described in [https://github.com/iqtree/iqtree2/wiki/Complex-Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models)<br>These options could work well with the **Inference Mode**.<br>In cases **without the Inference Mode**, users must supply a tree-file (with a single tree) when using `-q` or `-p`. While using `-Q`, AliSim requires a multiple-tree file that specifies a supertree (combining all taxa in all partitions) in the first line. Following that, each tree for each partition should be specified in a single line one by one in the input multiple-tree file. Noting that each partition could have a different tree topology. |
| `--distribution FILE` | Supply the distribution definition file, which specifies multiple lists of numbers. These lists could be used to generate random parameters by specifying list names (instead of specific numbers) for model parameters. |
| `--branch-distribution DISTRIBUTION_NAME` |                  Specify a distribution, from which branch lengths of phylogenetic trees will be randomly generated.|
| `--only-unroot-tree` | Only unroot a rooted tree and terminate |
| `--length <SEQUENCE_LENGTH>` | Set the length of the simulated sequences.<br>If an MSA is supplied as input and this option is not set, then AliSim will use the length of the sequences in the input alignment.<br>*Default: 1,000* |
| `--num-alignments <NUMBER_OF_DATASETS>` | Set the number of output datasets.<br>*Default: 1* |
| `--root-seq <ALN_FILE>,<SEQ_NAME>`   | Supply a sequence as the ancestral sequence at the root.<br>AliSim automatically sets the length of the output sequences equally to the length of the ancestral sequence. |
| `--no-copy-gaps` | Disable copying gaps from the input sequences.<br>*Default: FALSE* |
|  `-t RANDOM{<MODEL>,<NUM_TAXA>}` | Specify a `<MODEL>` (yh, u, cat, bal, or bd{`<birth_rate>`,`<death_rate>`} for Yule-Harding, Uniform, Caterpillar, Balanced, or Birth-Death model respectively) and the number of taxa `<NUM_TAXA>` to generate a random tree. specified by the users. The number of taxa could be a fixed number, a list (`<NUM_1>,<NUM_2>,...,<NUM_N>`), or a Uniform distribution `U(<LOWER_BOUND>,<UPPER_BOUND>)`. Note that `<NUM_TAXA>` is only required if an alignment is not provided by `-s <ALIGNMENT_FILE>`. |
|  `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`  | Specify the minimum, the mean, and the maximum length of branches when generating a random tree. |
| `-s <SEQUENCE_ALIGNMENT>` | Specify an input MSA. AliSim will simulate MSAs that mimic that user-provided MSA **(Inference mode)**.<br>Firstly, IQTree infers a phylogenetic tree and a model with its parameters from the input data. Then, AliSim simulates MSA from that tree and the model. |
| `--write-all` | Enable writing internal sequences. |
| `--nt <NUM>` | Set the number of threads to run the simulation. |
| `-seed <NUMBER>` | Specify the seed number. <br>*Default: the clock of the PC*. <br>Be careful! To make the AliSim reproducible, users should specify the seed number. |
| `-gz` | Enable output compression, but it could take a longer running time.<br>*By default, output compression is disabled*. |
| `-af phy|fasta` | Set the format for the output file(s). <br>*Default: phy (PHYLIP format)* |


Compilation guide
=================

For advanced users to compile AliSim source code. 

Downloading source code
-----------------------
<div class="hline"></div>

Users could download the AliSim source code from:

<https://github.com/iqtree/iqtree2/tree/alisim>

Alternatively, if you have `git` installed, you can also clone the source code from GitHub with:

    git clone --branch alisim --single-branch https://github.com/iqtree/iqtree2.git
    

Compiling AliSim
---------------------
<div class="hline"></div>

As AliSim was developed as an extension of the IQ-Tree software, users can easily compile AliSim by following this [Compilation Guide](https://github.com/iqtree/iqtree2/wiki/Compilation-Guide). 

Development team
----------------
<div class="hline"></div>

AliSim is actively developed by:

**Nhan Trong Ly**, _Developer_.

**Bui Quang Minh**, _Advisor_.


Credits and acknowledgments
----------------------------
<div class="hline"></div>

AliSim was developed from the source code of the [IQ-Tree software](https://github.com/iqtree/iqtree2).

This project was supported by [ANU University Research Scholarship](https://www.anu.edu.au/study/scholarships/find-a-scholarship/anu-university-research-scholarships) (International) (738/2018); ANU HDR Fee Remission Merit Scholarship (271/2014); [Vingroup Science and Technology Scholarship Program for Overseas Study for Master’s and Doctoral Degrees](https://scholarships.vinuni.edu.vn/) [Scholar ID: VGRS20042M]; and The Chan-Zuckerberg Initiative grant for open source software for science. We thank [The Center for Integrative Bioinformatics Vienna (CIBIV)](http://www.cibiv.at/) for kindly providing us the computational resource to do this research.


*Thanks for reading our tutorials and using AliSim! We do hope that you will find our simulator useful for your work/research and have great experiences with it. 
If you have any questions or found potential bugs, please feel free to contact us. Thank you very much!*

