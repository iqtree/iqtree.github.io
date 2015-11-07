## About IQ-TREE

IQ-TREE is a very efficient maximum likelihood phylogenetic software with following key features among others:
* A novel fast and effective stochastic algorithm to estimate maximum likelihood trees. **IQ-TREE outperforms both RAxML and PhyML** in terms of likelihood while requiring similar amount of computing time (see Nguyen et al., 2015)
* An ultrafast bootstrap approximation to assess branch supports (see Minh et al., 2013).
* Ultrafast and automatic model selection (**10 to 100 times faster than jModelTest and ProtTest**) and best partitioning scheme selection (like PartitionFinder).

The strength of IQ-TREE is the availability of a wide range of models:

* All common substitution models for DNA, protein, codon, binary and morphological data.
* Rate heterogeneity among sites including invariable site [+I] model, discrete Gamma [+G], and FreeRate model [+R].
* Phylogenomic partition models allowing for mixed data types between partitions, linked or unlinked branch lengths, and different rate types (e.g. one partition under GTR+G and another under WAG+I+G).
* Mixture models such as predefined protein mixture models (e.g., LG4X, CAT C10-C60), customizable mixture models (e.g., "MIX{HKY,GTR}"), and frequency/profile mixture models.
* Ascertainment bias correction [+ASC] model for data where constant sites are missing (e.g., SNPs or morphological data).
* New models can be defined and imported via a NEXUS file (see Manual).

## Download 

You can download source code and precompiled executables for Windows, Mac OS X and Linux, each with a sequential and a parallel multi-threaded (OpenMP) version from here:

<https://github.com/Cibiv/IQTree/releases>

## Installation

After you download IQ-TREE please follow the Installation guide here:

<https://github.com/Cibiv/IQTree/wiki/Installation>

## IQ-TREE Web service

For a quick start you can try the IQ-TREE web server, which performs online computation using a dedicated computing cluster. It is very easy to use with as few as just 3 clicks! Try it out at

<http://iqtree.cibiv.univie.ac.at>

## Documentation

Please read carefully before using IQ-TREE the first time or upgrading a new version! 

User Manual and Tutorial 1.0

## User support

If you have questions, feedback, feature requests, and bug reports, please sign up the following Google group (if not done yet) and post a topic to the 

<https://groups.google.com/d/forum/iqtree>

The average response time is one working day.

## Citations

To cite IQ-TREE please use:
* Lam Tung Nguyen, Heiko A. Schmidt, Arndt von Haeseler, and Bui Quang Minh (2015) IQ-TREE: A fast and effective stochastic algorithm for estimating maximum likelihood phylogenies. Mol. Biol. Evol., 32, 268-274. [DOI: 10.1093/molbev/msu300](http://dx.doi.org/10.1093/molbev/msu300)

To cite the ultrafast bootstrap (UFBoot) please use:
* Bui Quang Minh, Minh Anh Thi Nguyen, and Arndt von Haeseler (2013) Ultrafast approximation for phylogenetic bootstrap. Mol. Biol. Evol., 30:1188-1195. [DOI: 10.1093/molbev/mst024](http://dx.doi.org/10.1093/molbev/mst024)

IQ-TREE can use PLL for likelihood computations, if you use "-pll" option please cite:
* T. Flouri, F. Izquierdo-Carrasco, D. Darriba, A.J. Aberer, L.-T. Nguyen, B.Q. Minh, A. von Haeseler, and A. Stamatakis (2015) The phylogenetic likelihood library. Syst. Biol., 64:356-362. [DOI: 10.1093/sysbio/syu084](http://dx.doi.org/10.1093/sysbio/syu084)

### Acknowledgements

IQ-TREE was partially funded by the Austrian Science Fund - FWF (grant no. I760-B17 from 2012-2015) and the University of Vienna (Initiativkolleg I059-N).