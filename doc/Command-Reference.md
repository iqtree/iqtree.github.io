
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
| -st  | Specify sequence type: `BIN` (binary), `DNA`, `AA` (amino-acid), `NT2AA` (converting NT to AA), `CODON` or `MORPH` (morphology). By default IQ-TREE automatically detects the sequence type. |
| -q   | Specify partition file (NEXUS or RAxML-style format) for edge-equal partition model. That means, all partitions share the same set of branch lengths (like `-q` option of RAxML). |
| -spp | Like `-q` but each partition has its own rate (edge-proportional partition model). |
| -sp  | Specify partition file for edge-unlinked partition model. That means, each partition has its own set of branch lengths (like `-M` option of RAxML). |
| -t   | Specify starting tree for tree search. By default, IQ-TREE starts from 100 parsimony trees and BIONJ tree. The special option `-t BIONJ` starts tree search from BIONJ tree and `-t RANDOM` starts tree search from random Yule-Harding tree. |
| -te  | Like `-t` but fixing user tree. That means, no tree search is performed and IQ-TREE computes the log-likelihood of the fixed user tree. |
| -o   | Specify an outgroup taxon name to root the tree. The output tree in `.treefile` will be rooted accordingly. |
| -pre | Specify a prefix for all output files. By default, the prefix is either the alignment file name (`s`) or the partition file name (`-q`, `-spp` or `-sp`). |
| -seed| Specify a random number seed to reproduce a previous run. This is normally used for debugging purpose. By default, IQ-TREE draws a random number seed from the current machine clock. |
| -v   | Turn on verbose mode for printing more messages to screen. This is normally used for debugging purpose. |
