<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Command line interface](#command-line-interface)
- [General options](#general-options)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Command line interface
----------------------

    iqtree -s <alignment> [OPTIONS]

Assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please read the [Quick start guide](Quickstart).


General options
---------------

|Option| Usage and meaning |
|------|-------------------|
|-h or -?| Print help usage. |
| -s   | Specify input alignment file in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format. |
| -st  | Specify sequence type: `BIN` for binary, `DNA` for DNA, `AA` for amino-acid, `NT2AA` for converting nucleotide to AA, `CODON` for coding DNA and `MORPH` for morphology. This option is typically not necessary because IQ-TREE automatically detects the sequence type. An exception is `-st CODON` which is always necessary when using codon models (otherwise, IQ-TREE applies DNA models). |
| -q or -spj | Specify partition file in [NEXUS or RAxML-style format](Complex-Models#partition-file-format) for edge-equal [partition model](Complex-Models#partition-models). That means, all partitions share the same set of branch lengths (like `-q` option of RAxML). |
| -spp | Like `-q` but each partition has its own rate ([edge-proportional partition model](Complex-Models#partition-models)). |
| -sp  | Specify partition file for [edge-unlinked partition model](Complex-Models#partition-models). That means, each partition has its own set of branch lengths (like `-M` option of RAxML). |
| -t   | Specify starting tree for tree search. By default, IQ-TREE starts from 100 parsimony trees and BIONJ tree. The special option `-t BIONJ` starts tree search from BIONJ tree and `-t RANDOM` starts tree search from completely random tree. |
| -te  | Like `-t` but fixing user tree. That means, no tree search is performed and IQ-TREE computes the log-likelihood of the fixed user tree. |
| -o   | Specify an outgroup taxon name to root the tree. The output tree in `.treefile` will be rooted accordingly. |
| -pre | Specify a prefix for all output files. By default, the prefix is either the alignment file name (`-s`) or the partition file name (`-q`, `-spp` or `-sp`). |
| -seed| Specify a random number seed to reproduce a previous run. This is normally used for debugging purpose. By default, IQ-TREE draws a random number seed based on the current machine clock. |
| -v   | Turn on verbose mode for printing more messages to screen. This is normally used for debugging purpose. |


Tree search algorithm
---------------------

|Option| Usage and meaning |
|------|-------------------|
| -numpars | Specify number of initial parsimony trees (default: 100) |
| -toppars | Specify number of top parsimony trees of the initial trees for further optimization (default: 20). |
| -numcand | Specify number of candidate trees maintaining during tree search. (defaut: 5). |
| -sprrad  | Specify radius for subtree prunning and regrafting parsimony search (default: 6). |
| -pers    | Specify perturbation strength between 0 and 0 for randomized NNI (default: 0.5). |
| -allnni  | Turn on more thorough nearest-neighbor interchange for ML search (default: off). |
| -numstop | Specify number of unsuccessful iterations to stop (default: 100). |
| -n       | Specify number of iterations to stop. By default, IQ-TREE stops after 100 unsuccessful iterations. |


