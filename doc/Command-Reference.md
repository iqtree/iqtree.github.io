<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Command line interface](#command-line-interface)
- [General options](#general-options)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Command line interface
----------------------

    iqtree -s <alignment> [OPTIONS]

Assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please change `iqtree` to the actually path to the executable or read the [Quick start guide](Quickstart).


General options
---------------

General options are mainly intended for specifying input and output files:

|Option| Usage and meaning |
|------|-------------------|
|-h or -?| Print help usage. |
| -s   | Specify input alignment file in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format. |
| -st  | Specify sequence type: `BIN` for binary, `DNA` for DNA, `AA` for amino-acid, `NT2AA` for converting nucleotide to AA, `CODON` for coding DNA and `MORPH` for morphology. This option is typically not necessary because IQ-TREE automatically detects the sequence type. An exception is `-st CODON` which is always necessary when using codon models (otherwise, IQ-TREE applies DNA models). |
| -q or -spj | Specify partition file in [NEXUS or RAxML-style format](Complex-Models#partition-file-format) for edge-equal [partition model](Complex-Models#partition-models). That means, all partitions share the same set of branch lengths (like `-q` option of RAxML). |
| -spp | Like `-q` but each partition has its own rate ([edge-proportional partition model](Complex-Models#partition-models)). |
| -sp  | Specify partition file for [edge-unlinked partition model](Complex-Models#partition-models). That means, each partition has its own set of branch lengths (like `-M` option of RAxML). |
| -t   | Specify a file containing starting tree for tree search. The special option `-t BIONJ` starts tree search from BIONJ tree and `-t RANDOM` starts tree search from completely random tree. *DEFAULT: 100 parsimony trees + BIONJ tree* |
| -te  | Like `-t` but fixing user tree. That means, no tree search is performed and IQ-TREE computes the log-likelihood of the fixed user tree. |
| -o   | Specify an outgroup taxon name to root the tree. The output tree in `.treefile` will be rooted accordingly. *DEFAULT: first taxon in alignment* |
| -pre | Specify a prefix for all output files. *DEFAULT: either alignment file name (`-s`) or partition file name (`-q`, `-spp` or `-sp`) |
| -seed| Specify a random number seed to reproduce a previous run. This is normally used for debugging purpose. *DEFAULT: based on current machine clock* |
| -v   | Turn on verbose mode for printing more messages to screen. This is normally used for debugging purpose. *DFAULT: OFF* |


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

>**TIP**: One can combine all these tests (also including UFBoot `-bb` option) in a single IQ-TREE run. Each branch in the resulting tree will be assigned with several support values separated by slash (`/`).


Tree topology tests
-------------------

|Option| Usage and meaning |
|------|-------------------|
| -z  | Specify a file containing a set of trees. IQ-TREE will compute the log-likelihoods of all trees. |
| -zb | Specify the number of RELL ([Kishino et al., 1990]) replicates (>=1000) to perform several tree topology tests for all trees passed via `-z`. The tests include bootstrap proportion (BP), KH test ([Kishino and Hasegawa, 1989]), SH test ([Shimodaira and Hasegawa, 1999]) and expected likelihood weights (ELW) ([Strimmer and Rambaut, 2002]). |
| -zw | Used together with `-zb` to additionally perform the weighted-KH and weighted-SH tests. |




Constructing consensus tree
---------------------------

|Option| Usage and meaning |
|------|-------------------|
| -t   | Specify a file containing a set of trees. |
| -con | Compute consensus tree of the trees passed via `-t`. Resulting consensus tree is written to `.contree` file |
| -net | Compute consensus network of the trees passed via `-t`. Resulting consensus network is written to `.nex` file |
| -minsup| Specify a minimum threshold  (between 0 and 1) to keep branches in the consensus tree. `-minsup 0.5` |means to compute majority-rule consensus tree. *DEFAULT: 0 to compute extended majority-rule consensus |
| -bi   | Specify a burnin, which is the number beginning trees passed via `-t` to discard before consensus construction. This is useful e.g. when summarizing trees from MrBayes analysis. |
| -sup | Specify an input "target" tree file. That means, support values are first extracted from the trees passed via `-t`, and then mapped onto the target tree. Resulting tree with assigned support values is written to `.suptree` file. This option is useful to map and compare support values from different approaches onto a single tree. |
| -suptag | Specify name of a node in `-sup` target tree. The corresponding node of `.suptree` will then be assigned with IDs of trees where this node appears. Special option `-suptag ALL` will assign such IDs for all nodes of the target tree. |


Computing Robinson-Foulds distance
----------------------------------

|Option| Usage and meaning |
|------|-------------------|
| -t   | Specify a file containing a set of trees. |
| -rf_all| Compute all-to-all RF distances between all trees passed via `-t` |
| -rf_adj| Compute RF distances between adjacent trees  passed via `-t` |
| -rf  | Specify the second set of trees. IQ-TREE computes all pairwise RF distances between two tree sets passed via `-t` and `-rf` |


Generating random trees
-----------------------

|Option| Usage and meaning |
|------|-------------------|
| -r <num_taxa>        Create a random tree under Yule-Harding model.
| -ru <num_taxa>       Create a random tree under Uniform model.
| -rcat <num_taxa>     Create a random caterpillar tree.
| -rbal <num_taxa>     Create a random balanced tree.
| -rcsg <num_taxa>     Create a random circular split network.
| -rlen <min_len> <mean_len> <max_len>  
                       min, mean, and max branch lengths of random trees.

Miscellaneous options
---------------------

|Option| Usage and meaning |
|------|-------------------|
| -wt                  Write locally optimal trees into .treels file
| -fixbr               Fix branch lengths of <treefile>.
                       Used with -n 0 to compute log-likelihood of <treefile>
| -wsl                 Writing site log-likelihoods to .sitelh file
| -wslg                Writing site log-likelihoods per Gamma category
| -fconst f1,...,fN    Add constant patterns into alignment (N=#nstates)


[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova and Gascuel 2006]: http://dx.doi.org/10.1080/10635150600755453
[Anisimova et al., 2011]: http://dx.doi.org/10.1093/sysbio/syr041
[Felsenstein, 1985]: https://www.jstor.org/stable/2408678
[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Kishino et al., 1990]: http://dx.doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: http://dx.doi.org/10.1007/BF02100115
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
[Nguyen et al., 2015]: http://dx.doi.org/10.1093/molbev/msu300
[Shimodaira and Hasegawa, 1999]: http://dx.doi.org/10.1093/oxfordjournals.molbev.a026201
[Strimmer and Rambaut, 2002]: http://dx.doi.org/10.1098/rspb.2001.1862
