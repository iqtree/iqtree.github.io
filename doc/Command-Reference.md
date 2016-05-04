<!--jekyll
docid: 12
icon: book
doctype: manual
tags:
- manual
sections:
  - name: General options
    url: general-options
  - name: Checkpointing to resume stopped run
    url: checkpointing-to-resume-stopped-run
  - name: Likelihood mapping analysis
    url: likelihood-mapping-analysis
  - name: Automatic model selection
    url: automatic-model-selection
  - name: Specifying substitution models
    url: specifying-substitution-models
  - name: Rate heterogeneity
    url: rate-heterogeneity
  - name: Tree search parameters
    url: tree-search-parameters
  - name: Ultrafast bootstrap parameters
    url: ultrafast-bootstrap-parameters
  - name: Nonparametric bootstrap
    url: nonparametric-bootstrap
  - name: Single branch tests
    url: single-branch-tests
  - name: Tree topology tests
    url: tree-topology-tests
  - name: Constructing consensus tree
    url: constructing-consensus-tree
  - name: Robinson-Foulds distance
    url: computing-robinson-foulds-distance
  - name: Generating random trees
    url: generating-random-trees
  - name: Miscellaneous options
    url: miscellaneous-options
jekyll-->
Commprehensive documentation of command-line options.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [General options](#general-options)
- [Checkpointing to resume stopped run](#checkpointing-to-resume-stopped-run)
- [Likelihood mapping analysis](#likelihood-mapping-analysis)
- [Automatic model selection](#automatic-model-selection)
- [Specifying substitution models](#specifying-substitution-models)
- [Rate heterogeneity](#rate-heterogeneity)
- [Tree search parameters](#tree-search-parameters)
- [Ultrafast bootstrap parameters](#ultrafast-bootstrap-parameters)
- [Nonparametric bootstrap](#nonparametric-bootstrap)
- [Single branch tests](#single-branch-tests)
- [Tree topology tests](#tree-topology-tests)
- [Constructing consensus tree](#constructing-consensus-tree)
- [Computing Robinson-Foulds distance](#computing-robinson-foulds-distance)
- [Generating random trees](#generating-random-trees)
- [Miscellaneous options](#miscellaneous-options)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


IQ-TREE is invoked from the command-line with e.g.:

    iqtree -s <alignment> [OPTIONS]

assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please change `iqtree` to the actual path of the executable or read the [Quick start guide](Quickstart).


General options
---------------

General options are mainly intended for specifying input and output files:

|Option| Usage and meaning |
|------|-------------------|
|-h or -?| Print help usage. |
| -s   | Specify input alignment file in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format. |
| -st  | Specify sequence type: `BIN` for binary, `DNA` for DNA, `AA` for amino-acid, `NT2AA` for converting nucleotide to AA, `CODON` for coding DNA and `MORPH` for morphology. This option is typically not necessary because IQ-TREE automatically detects the sequence type. An exception is `-st CODON` which is always necessary when using codon models (otherwise, IQ-TREE applies DNA models). |
| -q or  -spj | Specify partition file in [NEXUS or RAxML-style format](Complex-Models#partition-file-format) for edge-equal [partition model](Complex-Models#partition-models). That means, all partitions share the same set of branch lengths (like `-q` option of RAxML). |
| -spp | Like `-q` but each partition has its own rate ([edge-proportional partition model](Complex-Models#partition-models)). |
| -sp  | Specify partition file for [edge-unlinked partition model](Complex-Models#partition-models). That means, each partition has its own set of branch lengths (like `-M` option of RAxML). |
| -t   | Specify a file containing starting tree for tree search. The special option `-t BIONJ` starts tree search from BIONJ tree and `-t RANDOM` starts tree search from completely random tree. *DEFAULT: 100 parsimony trees + BIONJ tree* |
| -te  | Like `-t` but fixing user tree. That means, no tree search is performed and IQ-TREE computes the log-likelihood of the fixed user tree. |
| -o   | Specify an outgroup taxon name to root the tree. The output tree in `.treefile` will be rooted accordingly. *DEFAULT: first taxon in alignment* |
| -pre | Specify a prefix for all output files. *DEFAULT: either alignment file name (`-s`) or partition file name (`-q`, `-spp` or `-sp`)* |
| -seed| Specify a random number seed to reproduce a previous run. This is normally used for debugging purposes. *DEFAULT: based on current machine clock* |
| -v   | Turn on verbose mode for printing more messages to screen. This is normally used for debugging purposes. *DFAULT: OFF* |

Checkpointing to resume stopped run
-----------------------------------

Starting with version 1.4.0 IQ-TREE supports checkpointing: If an IQ-TREE run was interrupted for some reason, rerunning it with the same command line and input data will automatically resume the analysis from the last stopped point. The previous log file will then be appended. If a run successfully finished, IQ-TREE will deny to rerun and issue an error message. A few options that control checkpointing behavior:

|Option| Usage and meaning |
|------|-------------------|
| -redo | Redo the entire analysis no matter if it was stopped or successful. WARNING: This option will overwrite all existing output files. |
| -cptime | Specify the minimum checkpoint time interval in seconds (default: 20s) | 

>**NOTE**: IQ-TREE writes a checkpoint file with name suffix `.ckp.gz` in gzip format. Please do not delete or modify this file!

Likelihood mapping analysis
---------------------------

Starting with version 1.4.0, IQ-TREE implements the likelihood mapping approach  ([Strimmer and von Haeseler, 1997]) to assess the phylogenetic information of an input alignment. The detailed results will be printed to `.iqtree` report file. The likelihood mapping plots will be printed to `.lmap.svg` and `.lmap.eps` files. 

Compared with the original implementation in TREE-PUZZLE, IQ-TREE is much faster and supports many more substitution models (including partition and mixture models). 


|Option| Usage and meaning |
|------|-------------------|
| -lmap | Specify the number of quartets to be randomly drawn. If you specify `-lmap ALL`, all unique quartets will be drawn, instead.|
| -lmclust | Specify a NEXUS file containing taxon clusters (see below for example) for quartet mapping analysis. |
| -wql | Write quartet log-likelihoods into `.lmap.quartetlh` file (typically not needed). |

>**TIP**: The number of quartets specified via `-lmap` is recommended to be at least 25 times the number of sequences in the alignment, such that each sequence is covered ~100 times in the set of quartets drawn.

An example NEXUS cluster file (where A, B, C, etc. are sequence names):

    #NEXUS
    begin sets;
        taxset Cluster1 = A B C;
        taxset Cluster2 = D E;
        taxset Cluster3 = F G H I;
        taxset Cluster4 = J;
        taxset IGNORED = X;
    end;

Here, `Cluster1` to `Cluster4` are four user-defined clusters of sequences. Note that users can give any names to the clusters instead of `Cluster1`, etc. If a cluster is named `ignored` or `IGNORED` the sequences included will be ignored in the likelihood mapping analysis.

If you provide a cluster file it has to contain between 1 and 4 clusters (plus an optional `IGNORED` or `ignored` cluster), which will tell IQ-TREE to perform an unclustered (default without a cluster file) or a clustered analysis with 2, 3 or 4 groups, respectively.

The names given to the clusters in the cluster file will be used to label the corners of the triangle diagrams.


Automatic model selection
-------------------------

All testing approaches are specified via `-m TEST...` option:

|Option| Usage and meaning |
|------|-------------------|
| -m TESTONLY | Perform standard model selection like jModelTest (for DNA) and ProtTest (for protein). Moreover, IQ-TREE also works for codon, binary and morphogical data. |
| -m TEST | Like `-m TESTONLY` but immediately followed by tree reconstruction using the best-fit model found. So this performs both model selection and tree inference within a single run. |
| -m TESTNEWONLY | Perform the new model selection that additionally includes FreeRate model compared with `-m TESTONLY`. *Recommended as replacement for `-m TESTONLY`*. Note that `LG4X` is a FreeRate model, but by default is not included because it is also a protein mixture model. To include it, use `-madd` option (see table below).  |
| -m TESTNEW | Like `-m TESTNEWONLY` but immediately followed by tree reconstruction using the best-fit model found. |
| -m TESTMERGEONLY | Select best-fit partitioning scheme like PartitionFinder. |
| -m TESTMERGE | Like `-m TESTMERGEONLY` but immediately followed by tree reconstruction using the best partitioning scheme found. |
| -m TESTNEWMERGEONLY | Like `-m TESTMERGEONLY` but additionally includes FreeRate model. |
| -m TESTNEWMERGE | Like `-m TESTNEWMERGEONLY` but immediately followed by tree reconstruction using the best partitioning scheme found. |

>**TIP**: During model section run, IQ-TREE will write a file with suffix `.model` that stores information of all models tested so far. Thus, if IQ-TREE is interrupted for whatever reason, restarting the run will load this file to reuse the computation. Thus, this file acts like a checkpoint to resume the model selection.

Several parameters can be set to e.g. reduce computations:

|Option| Usage and meaning |
|------|-------------------|
| -rcluster | Specify the percentage for the relaxed clustering algorithm ([Lanfear et al., 2014]). This is similar to `--rcluster-percent` option of PartitionFinder. For example, with `-rcluster 10` only the top 10% partition schemes are considered to save computations. |
| -mset | Specify the name of a program (`raxml`, `phyml` or `mrbayes`) to restrict to only those models supported by the specified program. Alternatively, one can specify a comma-separated list of base models. For example, `-mset WAG,LG,JTT` will restrict model selection to WAG, LG, and JTT instead of all 18 AA models to save computations. |
| -msub | Specify either `nuclear`, `mitochondrial`, `chloroplast` or `viral` to restrict to those AA models designed for specified source. |
| -mfreq | Specify a comma-separated list of frequency types for model selection. *DEFAULT: `-mfreq FU,F` for protein models (FU = AA frequencies given by the protein matrix, F = empirical AA frequencies from the data), `-mfreq ,F1x4,F3x4,F` for codon models* |
| -mrate | Specify a comma-separated list of rate heterogeneity types for model selection. *DEFAULT: `-mrate E,I,G,I+G` for standard procedure, `-mrate E,I,G,I+G,R` for new selection procedure* |
| -cmin | Specify minimum number of categories for FreeRate model. *DEFAULT: 2* |
| -cmax | Specify maximum number of categories for FreeRate model. It is recommended to increase if alignment is long enough. *DEFAULT: 10* |
| –merit | Specify either `AIC`, `AICc` or `BIC` for the optimality criterion to apply for new procedure. *DEFAULT: all three criteria are considered* |
| -mtree | Turn on full tree search for each model considered, to obtain more accurate result. Only recommended if enough computational resources are available. *DEFAULT: fixed starting tree* |
| -mredo | Ignore `.model` file computed earlier. *DEFAULT: `.model` file (if exists) is loaded to reuse previous computations* |
| -madd | Specify a comma-separated list of mixture models to additionally consider for model selection. For example, `-madd LG4M,LG4X` to additionally include these two [protein mixture models](Substitution-Models/#protein-models). |
| -mdef | Specify a [NEXUS model file](Complex-Models#nexus-model-file) to define new models. |

>**NOTE**: Some of the above options require a comma-separated list, which should not contain any empty space!

Specifying substitution models
------------------------------

`-m` is a powerful option to specify substitution models, state frequency and rate heterogeneity type. The general syntax is:

    -m MODEL+FreqType+RateType

where `MODEL` is a model name, `+FreqType` (optional) is the frequency type and `+RateType` (optional) is the rate heterogeneity type. 

The following `MODEL`s are available:

| DataType | Model names |
|----------|-------------|
| DNA      | JC/JC69, F81, K2P/K80, HKY/HKY85, TN/TrN/TN93, TNe, K3P/K81, K81u, TPM2, TPM2u, TPM3, TPM3u, TIM, TIMe, TIM2, TIM2e, TIM3, TIM3e, TVM, TVMe, SYM, GTR and 6-digit specification. See [DNA models](Substitution-Models#dna-models) for more details. |
| Protein  | BLOSUM62, cpREV, Dayhoff, DCMut, FLU, HIVb, HIVw, JTT, JTTDCMut, LG, mtART, mtMAM, mtREV, mtZOA, Poisson, PMB, rtREV, VT, WAG. Many protein mixture models are also supported: C10,...,C60, EX2, EX3, EHO, UL2, UL3, EX_EHO, LG4M, LG4X, CF4 (`-mwopt` option can be used to turn on optimizing weights of mixture models). See [Protein models](Substitution-Models#protein-models) for more details. |
| Codon | MG, MGK, MG1KTS, MG1KTV, MG2K, GY, GY1KTS, GY1KTV, GY2K, ECMK07/KOSI07, ECMrest, ECMS05/SCHN05 and combined empirical-mechanistic models. See [Codon models](Substitution-Models#codon-models) for more details. |
| Binary | JC2, GTR2. See [Binary and morphological models](Substitution-Models#binary-and-morphological-models) for more details. |
| Morphology| MK, ORDERED. See [Binary and morphological models](Substitution-Models#binary-and-morphological-models) for more details. |

The following `FreqType`s are supported:

| FreqType | Meaning |
|----------|---------|
| +F       | Empirical state frequency observed from the data. |
| +FO      | State frequency optimized by maximum-likelihood from the data. |
| +FQ      | Equal state frequency. |
| +F1x4    | See [Codon frequencies](Substitution-Models#codon-frequencies). |
| +F3x4    | See [Codon frequencies](Substitution-Models#codon-frequencies). |

Rate heterogeneity
------------------

The following `RateType`s are supported:

| RateType | Meaning |
|----------|---------|
| +I       | Allowing for a proportion of invariable sites. |
| +G       | Discrete Gamma model ([Yang, 1994]) with default 4 rate categories. The number of categories can be changed with e.g. `+G8`. |
| +I+G     | Invariable site plus discrete Gamma model ([Gu et al., 1995]). |
| +R       | FreeRate model ([Yang, 1995]; [Soubrier et al., 2012]) that generalizes `+G` by relaxing the assumption of Gamma-distributed rates. The number of categories can be specified with e.g. `+R6`. *DEFAULT: 4 categories* |

See [Rate heterogeneity across sites](Substitution-Models#rate-heterogeneity-across-sites) for more details.

Further options:

|Option| Usage and meaning |
|------|-------------------|
| -a   | Specify the Gamma shape parameter (default: estimate) |
| -gmedian | Perform the *median* approximation for Gamma rate heterogeneity instead of the default *mean* approximation ([Yang, 1994]) |
| -i   | Specify the proportion of invariable sites (default: estimate) |
|  --opt-gamma-inv | Perform more thorough estimation for +I+G model parameters |
| -wsr | Write per-site rates to `.rate` file | 

Optionally, one can specify [Ascertainment bias correction](Substitution-Models#ascertainment-bias-correction) by appending `+ASC` to the model string. [Advanced mixture models](Complex-Models#mixture-models) can also be specified via `MIX{...}` and `FMIX{...}` syntax. Option `-mwopt` can be used to turn on optimizing weights of mixture models.


Tree search parameters
----------------------

The new IQ-TREE search algorithm ([Nguyen et al., 2015]) has several parameters that can be changed with:

|Option| Usage and meaning |
|------|-------------------|
| -numpars | Specify number of initial parsimony trees. *DEFAULT: 100* |
| -toppars | Specify number of top parsimony trees of initial ones for further search. *DEFAULT: 20* |
| -numcand | Specify number of top candidate trees to maintain during tree search. *DEFAULT: 5* |
| -sprrad  | Specify radius for subtree prunning and regrafting parsimony search. *DEFAULT: 6* |
| -pers    | Specify perturbation strength (between 0 and 1) for randomized nearest neighbor interchange (NNI). *DEFAULT: 0.5* |
| -allnni  | Turn on more thorough and slower NNI search. It means that IQ-TREE will consider all possible NNIs instead of only those in the vicinity of previously applied NNIs. *DEFAULT: OFF* |
| -numstop | Specify number of unsuccessful iterations to stop. *DEFAULT: 100* |
| -n       | Specify number of iterations to stop. This option overrides `-numstop` criterion. |

>**NOTICE**: While the default parameters were empirically determined to work well under our extensive benchmark ([Nguyen et al., 2015]), it might not hold true for all data sets. If in doubt that tree search is still stuck in local optima, one should repeat analysis with at least 10 IQ-TREE runs. Moreover, our experience showed that `-pers` and `-numstop` are the most relevant options to change in such case. For example, data sets with many short sequences should be analyzed with smaller perturbation strength (`-pers`) and larger `-numstop`.


Ultrafast bootstrap parameters
------------------------------

The ultrafast bootstrap (UFBoot) approximation ([Minh et al., 2013]) has several parameters that can be changed with:

|Option| Usage and meaning |
|------|-------------------|
| -bb  | Specify number of bootstrap replicates (>=1000). |
| -wbt | Turn on writing bootstrap trees to `.ufboot` file. *DEFAULT: OFF* |
| -wbtl| Like `-wbt` but bootstrap trees written with branch lengths. *DEFAULT: OFF* |
| -nm  | Specify maximum number of iterations to stop. *DEFAULT: 1000* |
| -bcor| Specify minimum correlation coefficient for UFBoot convergence criterion. *DEFAULT: 0.99* |
| -nstep| Specify iteration interval checking for UFBoot convergence. *DEFAULT: every 100 iterations* |
| -beps | Specify a small epsilon to break tie in RELL evaluation for bootstrap trees. *DEFAULT: 0.5* |


Nonparametric bootstrap
-----------------------

The slow standard nonparametric bootstrap ([Felsenstein, 1985]) can be run with:

|Option| Usage and meaning |
|------|-------------------|
| -b   | Specify number of bootstrap replicates (recommended >=100). This will perform both bootstrap and analysis on original alignment and provide a consensus tree. |
| -bc  | Like `-b` but omit analysis on original alignment. |
| -bo  | Like `-b` but only perform bootstrap analysis (no analysis on original alignment and no consensus tree). |


Single branch tests
-------------------

The following single branch tests are faster than all bootstrap analysis and recommended for extremely large data sets (e.g., >10,000 taxa):

|Option| Usage and meaning |
|------|-------------------|
| -alrt| Specify number of replicates (>=1000) to perform SH-like approximate likelihood ratio test (SH-aLRT) ([Guindon et al., 2010]). If number of replicates is set to 0 (`-alrt 0`), then the parametric aLRT test ([Anisimova and Gascuel 2006]) is performed, instead of SH-aLRT. |
| -abayes| Perform approximate Bayes test ([Anisimova et al., 2011]). |
| -lbp  | Specify number of replicates (>=1000) to perform fast local bootstrap probability method ([Adachi and Hasegawa, 1996]). |

>**TIP**: One can combine all these tests (also including UFBoot `-bb` option) within a single IQ-TREE run. Each branch in the resulting tree will be assigned several support values separated by slash (`/`), where the order of support values is stated in the `.iqtree` report file.


Tree topology tests
-------------------

IQ-TREE provides a number of tests for significant topological differences between trees:

|Option| Usage and meaning |
|------|-------------------|
| -z  | Specify a file containing a set of trees. IQ-TREE will compute the log-likelihoods of all trees. |
| -zb | Specify the number of RELL ([Kishino et al., 1990]) replicates (>=1000) to perform several tree topology tests for all trees passed via `-z`. The tests include bootstrap proportion (BP), KH test ([Kishino and Hasegawa, 1989]), SH test ([Shimodaira and Hasegawa, 1999]) and expected likelihood weights (ELW) ([Strimmer and Rambaut, 2002]). |
| -zw | Used together with `-zb` to additionally perform the weighted-KH and weighted-SH tests. |
| -au | Perform the approximately unbiased (AU) test ([Shimodaira, 2002]). |

>**NOTE**: The AU test implementation in IQ-TREE is much more efficient than the original CONSEL by supporting SSE, AVX and multicore parallelization. Moreover, it is more appropriate than CONSEL for partition analysis by bootstrap resampling sites *within* partitions, whereas CONSEL is not partition-aware.

Constructing consensus tree
---------------------------

IQ-TREE provides a fast implementation of consensus tree construction for post analysis:

|Option| Usage and meaning |
|------|-------------------|
| -t   | Specify a file containing a set of trees. |
| -con | Compute consensus tree of the trees passed via `-t`. Resulting consensus tree is written to `.contree` file. |
| -net | Compute consensus network of the trees passed via `-t`. Resulting consensus network is written to `.nex` file. |
| -minsup| Specify a minimum threshold  (between 0 and 1) to keep branches in the consensus tree. `-minsup 0.5` means to compute majority-rule consensus tree. *DEFAULT: 0 to compute extended majority-rule consensus.* |
| -bi   | Specify a burn-in, which is the number of beginning trees passed via `-t` to discard before consensus construction. This is useful e.g. when summarizing trees from MrBayes analysis. |
| -sup | Specify an input "target" tree file. That means, support values are first extracted from the trees passed via `-t`, and then mapped onto the target tree. Resulting tree with assigned support values is written to `.suptree` file. This option is useful to map and compare support values from different approaches onto a single tree. |
| -suptag | Specify name of a node in `-sup` target tree. The corresponding node of `.suptree` will then be assigned with IDs of trees where this node appears. Special option `-suptag ALL` will assign such IDs for all nodes of the target tree. |


Computing Robinson-Foulds distance
----------------------------------

IQ-TREE provides a fast implementation of Robinson-Foulds distance computation for post analysis:

|Option| Usage and meaning |
|------|-------------------|
| -t   | Specify a file containing a set of trees. |
| -rf_all| Compute all-to-all RF distances between all trees passed via `-t` |
| -rf_adj| Compute RF distances between adjacent trees  passed via `-t` |
| -rf  | Specify a second set of trees. IQ-TREE computes all pairwise RF distances between two tree sets passed via `-t` and `-rf` |


Generating random trees
-----------------------

|Option| Usage and meaning |
|------|-------------------|
| -r | Specify number of taxa. IQ-TREE will create a random tree under Yule-Harding model with specified number of taxa |
| -ru | Like `-r`, but a random tree is created under uniform model. |
| -rcat | Like `-r`, but a random caterpillar tree is created. |
| -rbal | Like `-r`, but a random balanced tree is created. |
| -rcsg | Like `-r`, bur a random circular split network is created. |
| -rlen | Specify three numbers: minimum, mean and maximum branch lengths of the random tree. *DEFAULT: `-rlen 0.001 0.1 0.999`* |


Miscellaneous options
---------------------

|Option| Usage and meaning |
|------|-------------------|
| -wt  | Turn on writing all locally optimal trees into `.treels` file. *DEFAULT: OFF* |
| -fixbr| Turn on fixing branch lengths of tree passed via `-t` or `-te`. This is useful to evaluate the log-likelihood of an input tree with fixed tolopogy and branch lengths. *DEFAULT: OFF* |
| -wsl | Turn on writing site log-likelihoods to `.sitelh` file in [TREE-PUZZLE](http://www.tree-puzzle.de) format. Such file can then be passed on to [CONSEL](http://www.sigmath.es.osaka-u.ac.jp/shimo-lab/prog/consel/) for further tree tests. *DEFAULT: OFF* |
| -wslg | Turn on writing site log-likelihoods per rate category. *DEFAULT: OFF* |
| -fconst| Specify a list of comma-separated integer numbers. The number of entries should be equal to the number of states in the model (e.g. 4 for DNA and 20 for protein). IQ-TREE will then add a number of constant sites accordingly. For example, `-fconst 10,20,15,40` will add 10 constant sites of all A, 20 constant sites of all C, 15 constant sites of all G and 40 constant sites of all T into the alignment. |



[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova and Gascuel 2006]: http://dx.doi.org/10.1080/10635150600755453
[Anisimova et al., 2011]: http://dx.doi.org/10.1093/sysbio/syr041
[Felsenstein, 1985]: https://www.jstor.org/stable/2408678
[Gu et al., 1995]: http://mbe.oxfordjournals.org/content/12/4/546.abstract
[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Kishino et al., 1990]: http://dx.doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: http://dx.doi.org/10.1007/BF02100115
[Lanfear et al., 2014]: http://dx.doi.org/10.1186/1471-2148-14-82
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
[Nguyen et al., 2015]: http://dx.doi.org/10.1093/molbev/msu300
[Shimodaira and Hasegawa, 1999]: http://dx.doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: http://dx.doi.org/10.1080/10635150290069913
[Soubrier et al., 2012]: http://dx.doi.org/10.1093/molbev/mss140
[Strimmer and Rambaut, 2002]: http://dx.doi.org/10.1098/rspb.2001.1862
[Strimmer and von Haeseler, 1997]: http://www.pnas.org/content/94/13/6815.long
[Yang, 1994]: http://dx.doi.org/10.1007/BF00160154
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract
