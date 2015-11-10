
Command line interface
----------------------

    iqtree -s <alignment> [OPTIONS]

Assuming that IQ-TREE can be run by simply entering `iqtree`. If not, please read the [Quick start guide](Quickstart).


General options
---------------

| Option | Meaning |
|-----------------------|-----------------------------|
|  `-?` or `-h`             | Printing help usage |
|  `-s alignment_file`       | Input alignment in PHYLIP/FASTA/NEXUS/CLUSTAL/MSF format |
|  `-st data_type`      | BIN, DNA, AA, NT2AA, CODON, MORPH (default: auto-detect) |
|  `-q partition_file`  | Edge-linked partition model (file in NEXUS/RAxML format) |
| `-spp partition_file` | Like `-q` option but allowing partition-specific rates |
|  `-sp partition_file` | Edge-unlinked partition model (like `-M` option of RAxML) |
|  `-t start_tree_file | BIONJ | RANDOM` | Starting tree (default: 100 parsimony trees and BIONJ) |
|  `-te user_tree_file` | Like `-t` but fixing user tree (no tree search performed) |
|  `-o outgroup_taxon`  | Outgroup taxon name for writing `.treefile` |
|  `-pre PREFIX`        | Using `PREFIX` for output files (default: aln/partition) |
|  `-seed number`       | Random seed number, normally used for debugging purpose |
|  `-v, -vv, -vvv`        | Verbose mode, printing more messages to screen |
