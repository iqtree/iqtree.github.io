
Command line interface
----------------------

    iqtree -s <alignment> [OPTIONS]

Assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please read the [Quick start guide](Quickstart).


General options
---------------

| Option | Usage and meaning |
|--------|-------------------|
| -h  | Printing help usage. |
| -s  | Input alignment in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format. |
| -st | Specifying sequence type with `BIN` (binary), `DNA`, `AA` (amino-acid), `NT2AA` (converting NT to AA), `CODON`, `MORPH` (morphology). By default IQ-TREE automatically detects the sequence type. |
| `-q`  | Edge-linked partition model (file in NEXUS/RAxML format). |
|`-spp` | Like `-q` option but allowing partition-specific rates. |
| `-sp` | Edge-unlinked partition model (like `-M` option of RAxML). |
| `-t`  | Starting tree for tree search instead of the default of 100 parsimony trees and BIONJ. `-t BIONJ` starts tree search from BIONJ tree. `-t RANDOM ` starts tree search from random Yule-Harding tree. |
| `-te` | Like `-t` but fixing user tree (no tree search performed). |
| `-o`  | Outgroup taxon name for writing `.treefile`. |
| `-pre`| Using `PREFIX` for output files (default: aln/partition). |
| `-seed`| Random seed number, normally used for debugging purpose. |
| `-v`   | Verbose mode, printing more messages to screen. |
