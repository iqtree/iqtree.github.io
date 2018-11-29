---
layout: userdoc
title: "Introduction"
author: _AUTHOR_
date: _DATE_
docid: 0
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: ""
sections:
  - name: Why IQ-TREE?
    url: why-iq-tree
  - name: Key features
    url: key-features
  - name: Free web server
    url: free-web-server
  - name: User support
    url: user-support
  - name: Documentation
    url: documentation
  - name: How to cite IQ-TREE?
    url: how-to-cite-iq-tree
  - name: Development team
    url: development-team
  - name: Credits and acknowledgements
    url: credits-and-acknowledgements

---

<!--more-->

Introduction
============

Why IQ-TREE?
------------
<div class="hline"></div>

Thanks to the recent advent of next-generation sequencing techniques, the amount of phylogenomic/transcriptomic data have been rapidly accumulated. This extremely facilitates resolving many "deep phylogenetic" questions in the tree of life. At the same time it poses major computational challenges to analyze such big data, where most phylogenetic software cannot handle. Moreover, there is a need to develop more complex probabilistic models to adequately capture realistic aspects of genomic sequence evolution.

This trends motivated us to develop the IQ-TREE software with a strong emphasis on phylogenomic inference. Our goals are:

* __Accuracy__: Proposing novel computational methods that perform better than existing approaches.
* __Speed__: Allowing fast analysis on big data sets and utilizing high performance computing platforms.
* __Flexibility__: Facilitating the inclusion of new (phylogenomic) models and sequence data types.
* __Versatility__: Implementing a broad range of commonly-used maximum likelihood analyses.

IQ-TREE has been developed since 2011 and freely available at <http://www.iqtree.org/> as open-source software under the [GNU-GPL license version 2](http://www.gnu.org/licenses/licenses.en.html). It is actively maintained by the core development team (see below) and a number of collabrators.

The name IQ-TREE comes from the fact that it is the successor of [**IQ**PNNI](http://www.cibiv.at/software/iqpnni/) and [**TREE**-PUZZLE](http://www.tree-puzzle.de/) software.


Key features
------------
<div class="hline"></div>


* __Efficient search algorithm__: Fast and effective stochastic algorithm to reconstruct phylogenetic trees by maximum likelihood. IQ-TREE compares favorably to RAxML and PhyML in terms of likelihood while requiring similar amount of computing time ([Nguyen et al., 2015]).
* __Ultrafast bootstrap__: An ultrafast bootstrap approximation (UFBoot) to assess branch supports. UFBoot is 10 to 40 times faster than RAxML rapid bootstrap and obtains less biased support values ([Minh et al., 2013]; [Hoang et al., 2018]).
* __Ultrafast model selection__: An ultrafast and automatic model selection (ModelFinder) which is 10 to 100 times faster than jModelTest and ProtTest. ModelFinder also finds best-fit partitioning scheme like PartitionFinder.
* __Big Data Analysis__: Supporting huge datasets with thousands of sequences or millions of alignment sites via [checkpointing](Command-Reference#checkpointing-to-resume-stopped-run), safe numerical and low memory mode. [Multicore CPUs](Tutorial#utilizing-multi-core-cpus) and [parallel MPI system](Compilation-Guide#compiling-mpi-version) are utilized to speedup analysis.
* __Phylogenetic testing__: Several fast branch tests like SH-aLRT and aBayes test ([Anisimova et al., 2011]) and tree topology tests like the approximately unbiased (AU) test ([Shimodaira, 2002]).


The strength of IQ-TREE is the availability of a wide variety of phylogenetic models:

* __Common models__: All [common substitution models](Substitution-Models) for DNA, protein, codon, binary and morphological data with [rate heterogeneity among sites](Substitution-Models#rate-heterogeneity-across-sites) and [ascertainment bias correction](Substitution-Models#ascertainment-bias-correction) for e.g. SNP data.
* __[Partition models](Complex-Models#partition-models)__: Allowing individual models for different genomic loci (e.g. genes or codon positions), mixed data types, mixed rate heterogeneity types, linked or unlinked branch lengths between partitions.
* __Mixture models__: [fully customizable mixture models](Complex-Models#mixture-models) and [empirical protein mixture models](Substitution-Models#protein-mixture-models) and.
* __Polymorphism-aware models__: Accounting for *incomplete lineage sorting* to infer species tree from genome-wide population data ([Schrempf et al., 2016]). 


Free web server
---------------
<div class="hline"></div>

For a quick start you can also try the IQ-TREE web server, which performs online computation using a dedicated computing cluster. It is very easy to use with as few as just 3 clicks! Try it out at

<http://iqtree.cibiv.univie.ac.at>

User support
------------
<div class="hline"></div>

Please refer to the [user documentation](http://www.iqtree.org/doc/) and [frequently asked questions](http://www.iqtree.org/doc/Frequently-Asked-Questions). If you have further questions, feedback, feature requests, and bug reports, please sign up the following Google group (if not done yet) and post a topic to the 

<https://groups.google.com/d/forum/iqtree>

_The average response time is two working days._


Documentation
-------------
<div class="hline"></div>

IQ-TREE has an extensive documentation with several tutorials and manual:

* [Getting started guide](Quickstart): recommended for users who just downloaded IQ-TREE.
* [Web Server Tutorial](Web-Server-Tutorial): A quick starting guide for the IQ-TREE Web Server.
* [Beginner's tutorial](Tutorial): recommended for users starting to use IQ-TREE.
* [Advanced tutorial](Advanced-Tutorial): recommended for more experienced users who want to explore more features of IQ-TREE.
* [Command Reference](Command-Reference): Comprehensive documentation of command-line options available in IQ-TREE.
* [Substitution Models](Substitution-Models): All common substitution models and usages.
* [Complex Models](Complex-Models): Complex models such as partition and mixture models.
* [Polymorphism Aware Models](Polymorphism-Aware-Models): Polymorphism-aware phylogenetic Models (PoMo) related documentation.
* [Compilation guide](Compilation-Guide): for advanced users who wants to compile IQ-TREE from source code.
* [Frequently asked questions (FAQ)](Frequently-Asked-Questions): recommended to have a look before you post a question in the [IQ-TREE group](https://groups.google.com/d/forum/iqtree).



How to cite IQ-TREE?
--------------------
<div class="hline"></div>

> **To maintain IQ-TREE, support users and secure fundings, it is important for us that you cite the following papers, whenever the corresponding features were applied for your analysis.**
>
> * Example 1: *We obtained branch supports with the ultrafast bootstrap (Hoang et al., 2018) implemented in the IQ-TREE software (Nguyen et al., 2015).* 
>
> * Example 2: *We inferred the maximum-likelihood tree using the edge-linked partition model in IQ-TREE (Chernomor et al., 2016; Nguyen et al., 2015).*


If you performed the ultrafast bootstrap (UFBoot) please cite:

* __D.T. Hoang, O. Chernomor, A. von Haeseler, B.Q. Minh, and L.S. Vinh__ (2018) UFBoot2: Improving the ultrafast bootstrap approximation. *Mol. Biol. Evol.*, 35:518–522. [DOI: 10.1093/molbev/msx281](https://doi.org/10.1093/molbev/msx281)

If you used posterior mean site frequency model please cite:

* __H.C. Wang, B.Q. Minh, S. Susko and A.J. Roger__ (2018) Modeling site heterogeneity with posterior mean site frequency profiles accelerates accurate phylogenomic estimation. _Syst. Biol._, 67:216-235. [DOI: 10.1093/sysbio/syx068](https://doi.org/10.1093/sysbio/syx068)

If you used ModelFinder please cite:

* __S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, and L.S. Jermiin__ (2017) ModelFinder: Fast Model Selection for Accurate Phylogenetic Estimates, *Nature Methods*, 14:587–589. [DOI: 10.1038/nmeth.4285](https://doi.org/10.1038/nmeth.4285)

If you performed tree reconstruction please cite:

* __L.-T. Nguyen, H.A. Schmidt, A. von Haeseler, and B.Q. Minh__ (2015) IQ-TREE: A fast and effective stochastic algorithm for estimating maximum likelihood phylogenies. *Mol. Biol. Evol.*, 32:268-274. [DOI: 10.1093/molbev/msu300](https://doi.org/10.1093/molbev/msu300)

If you used partition models e.g., for phylogenomic analysis please cite:

* __O. Chernomor, A. von Haeseler, and B.Q. Minh__ (2016) Terrace aware data structure for phylogenomic inference from supermatrices. *Syst. Biol.*, 65:997-1008. [DOI: 10.1093/sysbio/syw037](https://doi.org/10.1093/sysbio/syw037)

If you used the polymorphism-aware models please cite:

* __D. Schrempf, B.Q. Minh, N. De Maio, A. von Haeseler, and C. Kosiol__ (2016) Reversible polymorphism-aware phylogenetic models and their application to tree inference. *J. Theor. Biol.*, 407:362–370. [DOI: 10.1016/j.jtbi.2016.07.042](https://doi.org/10.1016/j.jtbi.2016.07.042)


If you used the [IQ-TREE web server](http://iqtree.cibiv.univie.ac.at/) please cite:

* __J. Trifinopoulos, L.-T. Nguyen, A. von Haeseler, and B.Q. Minh__ (2016) W-IQ-TREE: a fast online phylogenetic tool for maximum likelihood analysis. *Nucleic Acids Res.*, 44 (W1):W232-W235. [DOI: 10.1093/nar/gkw256](https://doi.org/10.1093/nar/gkw256)


Development team
----------------
<div class="hline"></div>

IQ-TREE is actively developed by:

**Bui Quang Minh**, _Team leader_, Designs and implements software core, ultrafast bootstrap, model selection.

**Olga Chernomor**, _Developer_, Implements partition models.

**Heiko A. Schmidt**, _Developer_, Integrates TREE-PUZZLE features.

**Dominik Schrempf**, _Developer_, Implements polymorphism-aware models (PoMo).

**Michael Woodhams**, _Developer_, Implements Lie Markov models.

**Diep Thi Hoang**, _Developer_, Improves ultrafast bootstrap.

**Arndt von Haeseler**, _Advisor_, Provides advice and financial support.

Past members:

**Lam Tung Nguyen**, _Developer_, Implemented tree search algorithm.

**Jana Trifinopoulos**, _Developer_, Implemented web service.


Credits and acknowledgements
----------------------------
<div class="hline"></div>

Some parts of the code were taken from the following packages/libraries: [Phylogenetic likelihood library](http://www.libpll.org), [TREE-PUZZLE](http://www.tree-puzzle.de), 
[BIONJ](https://doi.org/10.1093/oxfordjournals.molbev.a025808), [Nexus Class Libary](https://doi.org/10.1093/bioinformatics/btg319), [Eigen library](http://eigen.tuxfamily.org/),
[SPRNG library](http://www.sprng.org), [Zlib library](http://www.zlib.net), gzstream library, [vectorclass library](http://www.agner.org/optimize/), [GNU scientific library](https://www.gnu.org/software/gsl/).


IQ-TREE was partially funded by the [Austrian Science Fund - FWF](http://www.fwf.ac.at/) (grant no. I760-B17 from 2012-2015 and and I 2508-B29 from 2016-2019) and the [University of Vienna](https://www.univie.ac.at/) (Initiativkolleg I059-N).


[Anisimova et al., 2011]: https://doi.org/10.1093/sysbio/syr041
[Guindon et al., 2010]: https://doi.org/10.1093/sysbio/syq010
[Hoang et al., 2018]: https://doi.org/10.1093/molbev/msx281
[Minh et al., 2013]: https://doi.org/10.1093/molbev/mst024
[Nguyen et al., 2015]: https://doi.org/10.1093/molbev/msu300
[Schrempf et al., 2016]: https://doi.org/10.1016/j.jtbi.2016.07.042
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913


