About IQ-TREE
-------------

IQ-TREE is a very efficient maximum likelihood phylogenetic software with following key features among others:
* A novel fast and effective stochastic algorithm to estimate maximum likelihood trees. **IQ-TREE outperforms both RAxML and PhyML** in terms of likelihood while requiring similar amount of computing time ([Nguyen et al., 2015])
* An ultrafast bootstrap approximation to assess branch supports ([Minh et al., 2013]).
* Ultrafast and automatic model selection (**10 to 100 times faster than jModelTest and ProtTest**) and best partitioning scheme selection (like PartitionFinder).

The strength of IQ-TREE is the **availability of a wide range of models**:

* All common [substitution models](Substitution Models) for DNA, protein, codon, binary and morphological data with possibility of [rate heterogeneity among sites](Substitution Models#rate-heterogeneity-across-sites) and [ascertainment bias correction](Substitution Models#ascertainment-bias-correction).
* [Phylogenomic partition models](Complex Models#partition-models) allowing for mixed data types, linked or unlinked branch lengths, and different rate types.
* Mixture models such as [empirical protein mixture models](Substitution Models#protein-models) and [customizable mixture models](Complex Models#mixture-models).


Download
--------

The latest IQ-TREE version 1.3.10 (October 16, 2015) is available for three popular platforms with a sequential and a parallel multicore version:

| [[images/windows.png]] Windows | [[images/macosx.png]] Mac OS X | [[images/linux.png]] Linux |
|------------|--------------|--------------|
| [64-bit sequential Windows](../releases/download/v1.3.10/iqtree-1.3.10-Windows.zip) | [64-bit sequential MacOSX](../releases/download/v1.3.10/iqtree-1.3.10-MacOSX.zip) | [64-bit sequential Linux](../releases/download/v1.3.10/iqtree-1.3.10-Linux.tar.gz) |
| [64-bit multicore Windows](../releases/download/v1.3.10/iqtree-omp-1.3.10-Windows.zip) | [64-bit multicore MacOSX](../releases/download/v1.3.10/iqtree-omp-1.3.10-MacOSX.zip) | [64-bit multicore Linux](../releases/download/v1.3.10/iqtree-omp-1.3.10-Linux.tar.gz) |
| [32-bit sequential Windows](../releases/download/v1.3.10/iqtree32-1.3.10-Windows.zip) | | |
| [32-bit multicore Windows](../releases/download/v1.3.10/iqtree32-omp-1.3.10-Windows.zip) | | |

Please follow [**Getting started guide**](Quickstart) once you downloaded IQ-TREE.

See [Release notes](../releases) for more details of this version or to download older versions.

If you want to obtain and build IQ-TREE source code, please refer to [Compilation guide](Compilation-Guide).



IQ-TREE web service
-------------------

For a quick start you can also try the IQ-TREE web server, which performs online computation using a dedicated computing cluster. It is very easy to use with as few as just 3 clicks! Try it out at

<http://iqtree.cibiv.univie.ac.at>


Documentation
-------------

* [Getting started guide](Quickstart): recommended for users who just downloaded IQ-TREE.

* [Beginner's tutorial](Tutorial): recommended for users starting to use IQ-TREE.

* [Advanced tutorial](Advanced Tutorial): recommended for more experienced users who want to explore more features of IQ-TREE.

* [[Substitution Models]] and [[Complex Models]]: learn more about maximum-likelihood models available in IQ-TREE.

* [Frequently asked questions (FAQ)](Frequently-Asked-Questions): recommended to have a look before you post a question in the [IQ-TREE group](https://groups.google.com/d/forum/iqtree).

* [Compilation guide](Compilation guide): for advanced users who wants to compile IQ-TREE from source code.


User support
------------

If you have questions, feedback, feature requests, and bug reports, please sign up the following Google group (if not done yet) and post a topic to the 

<https://groups.google.com/d/forum/iqtree>

The average response time is one working day.

Citations
---------

To cite IQ-TREE please use:
* L.-T. Nguyen, H.A. Schmidt, A. von Haeseler, and B.Q. Minh (2015) IQ-TREE: A fast and effective stochastic algorithm for estimating maximum likelihood phylogenies. *Mol. Biol. Evol.*, 32, 268-274. [DOI: 10.1093/molbev/msu300](http://dx.doi.org/10.1093/molbev/msu300)

For the ultrafast bootstrap (UFBoot) please cite:
* B.Q. Minh, M.A.T. Nguyen, and A. von Haeseler (2013) Ultrafast approximation for phylogenetic bootstrap. *Mol. Biol. Evol.*, 30:1188-1195. [DOI: 10.1093/molbev/mst024](http://dx.doi.org/10.1093/molbev/mst024)

IQ-TREE can use PLL for likelihood computations, if you use `-pll` option please cite:
* T. Flouri, F. Izquierdo-Carrasco, D. Darriba, A.J. Aberer, L.-T. Nguyen, B.Q. Minh, A. von Haeseler, and A. Stamatakis (2015) The phylogenetic likelihood library. *Syst. Biol.*, 64:356-362. [DOI: 10.1093/sysbio/syu084](http://dx.doi.org/10.1093/sysbio/syu084)


#### Credits and Acknowledgements

Some parts of the code were taken from the following packages/libraries: [Phylogenetic likelihood library](http://www.libpll.org), [TREE-PUZZLE](http://www.tree-puzzle.de), 
[BIONJ](http://dx.doi.org/10.1093/oxfordjournals.molbev.a025808), [Nexus Class Libary](http://dx.doi.org/10.1093/bioinformatics/btg319), [Eigen library](http://eigen.tuxfamily.org/),
[SPRNG library](http://www.sprng.org), [Zlib library](http://www.zlib.net), [vectorclass library](http://www.agner.org/optimize/).


IQ-TREE was partially funded by the Austrian Science Fund - FWF (grant no. I760-B17 from 2012-2015) and the University of Vienna (Initiativkolleg I059-N).


[Nguyen et al., 2015]: http://dx.doi.org/10.1093/molbev/msu300
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024

