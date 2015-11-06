# About IQ-TREE

IQ-TREE is a very efficient maximum likelihood phylogenetic software with following key features among others:
* A novel fast and effective stochastic algorithm to estimate maximum likelihood trees. IQ-TREE outperforms both RAxML and PhyML in terms of likelihood while requiring similar amount of computing time (see Nguyen et al., 2015)
* An ultrafast bootstrap approximation to assess branch supports (see Minh et al., 2013).
* Ultrafast and automatic model selection (10 to 100 times faster than jModelTest and ProtTest) and best partitioning scheme selection (like PartitionFinder).

The strength of IQ-TREE is the availability of a wide range of models:

* All common substitution models for DNA, protein, codon, binary and morphological data.
* Rate heterogeneity among sites including invariable site [+I] model, discrete Gamma [+G], and FreeRate model [+R].
* Phylogenomic partition models allowing for mixed data types between partitions, linked or unlinked branch lengths, and different rate types (e.g. one partition under GTR+G and another under WAG+I+G).
* Mixture models such as predefined protein mixture models (e.g., LG4X, CAT C10-C60), customizable mixture models (e.g., "MIX{HKY,GTR}"), and frequency/profile mixture models.
* Ascertainment bias correction [+ASC] model for data where constant sites are missing (e.g., SNPs or morphological data).
* New models can be defined and imported via a NEXUS file (see Manual).

# Documentation

Please read carefully before using IQ-TREE the first time or upgrading a new version! 

User Manual and Tutorial 1.0

# User support

If you have questions, feedback, feature requests, and bug reports, please sign up the following Google group (if not done yet) and post a topic to the 

[IQ-TREE Google group](https://groups.google.com/d/forum/iqtree)

The average response time is one working day.
