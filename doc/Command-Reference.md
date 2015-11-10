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

The standard nonparametric bootstrap ([Felsenstein, 1985]) can be run with:

|Option| Usage and meaning |
|------|-------------------|
| -b   | Specify number of bootstrap replicates (recommended >=100). This will perform both bootstrap and analysis on original alignment and provide a consensus tree. |
| -bc  | Like `-b` but omit analysis on original alignment. |
| -bo  | Like `-b` but only perform bootstrap analysis (no analysis on original alignment and no consensus tree). |


[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
[Nguyen et al., 2015]: http://dx.doi.org/10.1093/molbev/msu300
[Felsenstein, 1985]: https://www.jstor.org/stable/2408678
