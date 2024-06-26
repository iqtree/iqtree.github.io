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
* __Ultrafast model selection__: An ultrafast and automatic model selection (ModelFinder) which is 10 to 100 times faster than jModelTest and ProtTest. ModelFinder also finds best-fit partitioning scheme like PartitionFinder ([Kalyaanamoorthy et al., 2017]).
* __Simulating sequences__: A fast sequence alignment simulator (AliSim) which is much more realistic than Seq-Gen and INDELible ([Ly-Trong et al., 2023]). 
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

Please refer to the [user documentation](http://www.iqtree.org/doc/) and 
[frequently asked questions](http://www.iqtree.org/doc/Frequently-Asked-Questions). 

If you find a bug (e.g. when IQ-TREE prints a crash message) or want to request a new feature,
please post an issue on GitHub: <https://github.com/iqtree/iqtree2/issues>. For other
questions and feedback, please ask in GitHub discussions: <https://github.com/iqtree/iqtree2/discussions>


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

> To maintain IQ-TREE, support users and secure fundings, it is important for us that 
> you cite the following papers, whenever the corresponding features were applied for your analysis.**
>
> Example 1: We obtained branch supports with the ultrafast bootstrap (Hoang et al., 2018) 
> implemented in the IQ-TREE 2 software (Minh et al., 2020).
>
> Example 2: We used IQ-TREE 2 (Minh et al., 2020) to infer the maximum-likelihood tree using the edge-linked 
> partition model (Chernomor et al., 2016).

General citation for IQ-TREE 2:

* B.Q. Minh, H.A. Schmidt, O. Chernomor, D. Schrempf, M.D. Woodhams, A. von Haeseler, R. Lanfear (2020) 
  IQ-TREE 2: New models and efficient methods for phylogenetic inference in the genomic era.
  *Mol. Biol. Evol.*, 37:1530-1534. <https://doi.org/10.1093/molbev/msaa015>

When using tree mixture models (MAST) please cite:

* T.K.F. Wong, C. Cherryh, A.G. Rodrigo, M.W. Hahn, B.Q. Minh, R. Lanfear (2024)
  MAST: Phylogenetic Inference with Mixtures Across Sites and Trees.
  _Syst. Biol._, in press. <https://doi.org/10.1093/sysbio/syae008>

When computing concordance factors please cite:

* Y.K. Mo, R. Lanfear, M.W. Hahn, B.Q. Minh (2023)
  Updated site concordance factors minimize effects of homoplasy and taxon sampling.
  _Bioinformatics_, 39:btac741. <https://doi.org/10.1093/bioinformatics/btac741>

When using AliSim to simulate alignments please cite:

* N. Ly-Trong, S. Naser-Khdour, R. Lanfear, B.Q. Minh (2022)
  AliSim: A Fast and Versatile Phylogenetic Sequence Simulator for the Genomic Era.
  *Mol. Biol. Evol.*, 39:msac092. <https://doi.org/10.1093/molbev/msac092>

When estimating amino-acid Q matrix please cite:

* B.Q. Minh, C. Cao Dang, L.S. Vinh, R. Lanfear (2021)
  QMaker: Fast and accurate method to estimate empirical models of protein evolution.
  _Syst. Biol._, 70:1046–1060. <https://doi.org/10.1093/sysbio/syab010>

When using the heterotachy GHOST model "+H" please cite:

* S.M. Crotty, B.Q. Minh, N.G. Bean, B.R. Holland, J. Tuke, L.S. Jermiin, A. von Haeseler (2020)
  GHOST: Recovering Historical Signal from Heterotachously Evolved Sequence Alignments.
  _Syst. Biol._, 69:249-264. <https://doi.org/10.1093/sysbio/syz051>

When using the tests of symmetry please cite:

* S. Naser-Khdour, B.Q. Minh, W. Zhang, E.A. Stone, R. Lanfear (2019) 
  The Prevalence and Impact of Model Violations in Phylogenetic Analysis. 
  *Genome Biol. Evol.*, 11:3341-3352. <https://doi.org/10.1093/gbe/evz193>

When using polymorphism-aware models please cite:

* D. Schrempf, B.Q. Minh, A. von Haeseler, C. Kosiol (2019) 
  Polymorphism-aware species trees with advanced mutation models, bootstrap, and rate heterogeneity. 
  *Mol. Biol. Evol.*, 36:1294–1301. <https://doi.org/10.1093/molbev/msz043>

For the ultrafast bootstrap (UFBoot) please cite:

* D.T. Hoang, O. Chernomor, A. von Haeseler, B.Q. Minh, and L.S. Vinh (2018) 
  UFBoot2: Improving the ultrafast bootstrap approximation. 
  *Mol. Biol. Evol.*, 35:518–522. <https://doi.org/10.1093/molbev/msx281>

When using posterior mean site frequency model (PMSF) please cite:

* H.C. Wang, B.Q. Minh, S. Susko, A.J. Roger (2018) 
  Modeling site heterogeneity with posterior mean site frequency profiles 
  accelerates accurate phylogenomic estimation. 
  *Syst. Biol.*, 67:216–235. <https://doi.org/10.1093/sysbio/syx068>

When using ModelFinder please cite:

* S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, L.S. Jermiin (2017) 
  ModelFinder: Fast model selection for accurate phylogenetic estimates. 
  *Nat. Methods*, 14:587-589. <https://doi.org/10.1038/nmeth.4285>

When using partition models please cite:

* O. Chernomor, A. von Haeseler, B.Q. Minh (2016) 
  Terrace aware data structure for phylogenomic inference from supermatrices. 
  *Syst. Biol.*, 65:997-1008. <https://doi.org/10.1093/sysbio/syw037>

When using IQ-TREE web server please cite:

* J. Trifinopoulos, L.-T. Nguyen, A. von Haeseler, B.Q. Minh (2016) 
  W-IQ-TREE: a fast online phylogenetic tool for maximum likelihood analysis.
  *Nucleic Acids Res.*, 44:W232-W235. <https://doi.org/10.1093/nar/gkw256>

When using IQ-TREE version 1 please cite:

* L. Nguyen, H.A. Schmidt, A. von Haeseler, B.Q. Minh (2015)
  IQ-TREE: A Fast and Effective Stochastic Algorithm for Estimating Maximum-Likelihood Phylogenies.
  _Mol. Biol. and Evol._, 32:268-274. <https://doi.org/10.1093/molbev/msu300>


Development team
----------------
<div class="hline"></div>

IQ-TREE is actively developed by:

**Bui Quang Minh**, _Team leader_, Designs and implements software core, tree search, ultrafast bootstrap, model selection.

**Robert Lanfear**, _Co-leader_, Model selection.

**Olga Chernomor**, _Developer_, Implements partition models.

**Heiko A. Schmidt**, _Developer_, Integrates TREE-PUZZLE features.

**Dominik Schrempf**, _Developer_, Implements polymorphism-aware models (PoMo).

**Michael Woodhams**, _Developer_, Implements Lie Markov models.

**Diep Thi Hoang**, _Developer_, Improves ultrafast bootstrap.

**Arndt von Haeseler**, _Advisor_.

Past members:

**Lam Tung Nguyen**, _Developer_, Implemented tree search algorithm.

**Jana Trifinopoulos**, _Developer_, Implemented web service.


Credits and acknowledgements
----------------------------
<div class="hline"></div>

Some parts of the code were taken from the following packages/libraries: [Phylogenetic likelihood library](http://www.libpll.org), [TREE-PUZZLE](http://www.tree-puzzle.de), 
[BIONJ](https://doi.org/10.1093/oxfordjournals.molbev.a025808), [Nexus Class Libary](https://doi.org/10.1093/bioinformatics/btg319), [Eigen library](http://eigen.tuxfamily.org/),
[SPRNG library](http://www.sprng.org), [Zlib library](http://www.zlib.net), gzstream library, [vectorclass library](http://www.agner.org/optimize/), [GNU scientific library](https://www.gnu.org/software/gsl/).


IQ-TREE was funded by the [Austrian Science Fund](http://www.fwf.ac.at/) (grant no. I760-B17 from 2012-2015 and I 2508-B29 from 2016-2017), the [University of Vienna](https://www.univie.ac.at/) (Initiativkolleg I059-N from 2012-2015), the [Australian National University](https://www.anu.edu.au) (2018-onwards), [Chan-Zuckerberg Initiative](https://chanzuckerberg.com) (2020).

[Ly-Trong et al., 2023]: https://doi.org/10.1093/bioinformatics/btad540
[Anisimova et al., 2011]: https://doi.org/10.1093/sysbio/syr041
[Guindon et al., 2010]: https://doi.org/10.1093/sysbio/syq010
[Hoang et al., 2018]: https://doi.org/10.1093/molbev/msx281
[Kalyaanamoorthy et al., 2017]: https://doi.org/10.1038/nmeth.4285
[Minh et al., 2013]: https://doi.org/10.1093/molbev/mst024
[Nguyen et al., 2015]: https://doi.org/10.1093/molbev/msu300
[Schrempf et al., 2016]: https://doi.org/10.1016/j.jtbi.2016.07.042
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913


