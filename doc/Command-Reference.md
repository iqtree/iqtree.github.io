
Command line interface
----------------------

    iqtree -s <alignment> [OPTIONS]

Assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please read the [Quick start guide](Quickstart).


General options
---------------

*  `-?` or `-h`         : Printing help usage.
*  `-s alignment_file`  : Input alignment in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format
*  `-st data_type`      : Specifying sequence type with `BIN` (binary), `DNA`, `AA` (amino-acid), `NT2AA` (converting NT to AA), `CODON`, `MORPH` (morphology). By default IQ-TREE automatically detects the sequence type)
*  `-q partition_file`  : Edge-linked partition model (file in NEXUS/RAxML format)
* `-spp partition_file` : Like `-q` option but allowing partition-specific rates
*  `-sp partition_file` : Edge-unlinked partition model (like `-M` option of RAxML)
*  `-t tree_file`       : Starting tree (default: 100 parsimony trees and BIONJ)
*  `-t BIONJ`           : Starting tree search from BIONJ tree
*  `-t RANDOM`          : Starting tree search from random Yule-Harding tree
*  `-te tree_file`      : Like `-t` but fixing user tree (no tree search performed)
*  `-o outgroup_taxon`  : Outgroup taxon name for writing `.treefile`
*  `-pre PREFIX`        : Using `PREFIX` for output files (default: aln/partition)
*  `-seed number`       : Random seed number, normally used for debugging purpose
*  `-v`                 : Verbose mode, printing more messages to screen
