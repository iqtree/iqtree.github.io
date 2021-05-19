---
layout: userdoc
title: "Advanced Tutorial"
author: _AUTHOR_
date: _DATE_
docid: 4
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: Recommended for experienced users to explore more features.
sections:
  - name: Partitioned analysis
    url: partitioned-analysis-for-multi-gene-alignments
  - name: Partitioning with mixed data
    url: partitioned-analysis-with-mixed-data
  - name: Partition scheme selection
    url: choosing-the-right-partitioning-scheme
  - name: Bootstrapping partition model
    url: ultrafast-bootstrapping-with-partition-model
  - name: Constrained tree search
    url: constrained-tree-search
  - name: Tree topology tests
    url: tree-topology-tests
  - name: Testing constrained tree
    url: testing-constrained-tree
  - name: Consensus construction and bootstrap value assignment
    url: consensus-construction-and-bootstrap-value-assignment
  - name: User-defined models
    url: user-defined-substitution-models
  - name: Inferring site-specific rates
    url: inferring-site-specific-rates
---

Advanced tutorial
=================

Recommended for experienced users to explore more features.
<!--more-->

To get started, please read the [Beginner's Tutorial](Tutorial) first if not done so yet.

Partitioned analysis for multi-gene alignments
----------------------------------------------
<div class="hline"></div>

If you used partition model in a publication please cite:

> __O. Chernomor, A. von Haeseler, and B.Q. Minh__ (2016) Terrace aware data structure for phylogenomic inference from supermatrices. _Syst. Biol._, 65:997-1008. 
    <https://doi.org/10.1093/sysbio/syw037>

In the partition model, you can specify a substitution model for each gene/character set. 
IQ-TREE will then estimate the model parameters separately for every partition. Moreover, IQ-TREE provides edge-linked or edge-unlinked branch lengths between partitions:

* `-q partition_file`: all partitions share the same set of branch lengths (like `-q` option of RAxML).
* `-p partition_file` (`-spp` in version 1.x): like above but allowing each partition to have its own evolution rate.
* `-Q partition_file` (`-sp` in version 1.x): each partition has its own set of branch lengths (like combination of `-q` and `-M` options in RAxML) to account for, e.g. *heterotachy* ([Lopez et al., 2002]).

>**NOTE**: `-p` is recommended for typical analysis. `-q` is unrealistic and `-Q` is very parameter-rich. One can also perform all three analyses and compare e.g. the BIC scores to determine the best-fit partition model.

IQ-TREE supports RAxML-style and NEXUS partition input file. The RAxML-style partition file may look like:

    DNA, part1 = 1-100
    DNA, part2 = 101-384

If your partition file is called  `example.partitions`, the partition analysis can be run with:


    iqtree -s example.phy -p example.partitions -m GTR+I+G
    # for version 1.x change -p to -spp


Note that using RAxML-style partition file, all partitions will use the same rate heterogeneity model given in `-m` option (`+I+G` in this example). If you want to specify, say, `+G` for the first partition and `+I+G` for the second partition, then you need to create the more flexible NEXUS partition file. This file contains a  `SETS` block with
 `CharSet` and  `CharPartition` commands to specify individual genes and the partition, respectively.
For example:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;


If your NEXUS file is called  `example.nex`, then you can use the option  `-p` to input the file as following:

    iqtree -s example.phy -p example.nex
    # for version 1.x change -p to -spp

Here, IQ-TREE partitions the alignment  `example.phy` into 2 sub-alignments named  `part1` and  `part2`
containing sites (columns) 1-100 and 101-384, respectively. Moreover, IQ-TREE applies the
subtitution models  `HKY+G` and  `GTR+I+G` to  `part1` and  `part2`, respectively. Substitution model parameters and trees with branch lengths can be found in the result file  `example.nex.iqtree`. 

Moreover, the  `CharSet` command allows to specify non-consecutive sites with e.g.:

    charset part1 = 1-100 200-384;

That means,  `part1` contains sites 1-100 and 200-384 of the alignment. Another example is:

    charset part1 = 1-100\3;

for extracting sites 1,4,7,...,100 from the alignment. This is useful for getting codon positions from the protein-coding alignment. 



Partitioned analysis with mixed data
------------------------------------
<div class="hline"></div>

IQ-TREE also allows combining sub-alignments from different alignment files, which is helpful if you want to combine mixed data (e.g. DNA and protein) in a single analysis. Here is an example for mixing DNA, protein and codon models:

    #nexus
    begin sets;
        charset part1 = dna.phy: 1-100 201-300;
        charset part2 = dna.phy: 101-200;
        charset part3 = prot.phy: 1-400;
        charset part4 = prot.phy: 401-600;
        charset part5 = codon.phy:CODON, *;
        charpartition mine = HKY:part1, GTR+G:part2, LG+G:part3, WAG+I+G:part4, GY:part5;
    end;

Here,  `part1` and  `part2` contain sub-alignments from alignment file `dna.phy`, whereas `part3` and `part4` are loaded from alignment file `prot.phy` and `part5` from `codon.phy`. The `:` is needed to separate the alignment file name and site specification. Note that, for convenience `*` in `part5` specification means that `part5` corresponds to the entire alignment `codon.phy`.

>**TIP**: For `part5` the `CODON` keyword is specified so that IQ-TREE will apply a codon model. Moreover, this implicitly assumes the standard genetic code. If you want to use another genetic code, append `CODON` with the [code ID described here](Substitution-Models#codon-models)
{: .tip}

Because the alignment file names are now specified in this NEXUS file, you can omit the  `-s` option:

    iqtree -p example.nex
    # for version 1.x change -p to -spp


Note that 
 `aln.phy` and  `prot.phy` does not need to contain the same set of sequences. For instance, if some sequence occurs
in   `aln.phy` but not in   `prot.phy`, IQ-TREE will treat the corresponding parts of sequence
in  `prot.phy` as missing data. For your convenience IQ-TREE writes the concatenated alignment
into the file  `example.nex.conaln`.

 
Choosing the right partitioning scheme
--------------------------------------
<div class="hline"></div>

ModelFinder implements a greedy strategy ([Lanfear et al., 2012]) that starts with the full partition model and subsequentially
merges two genes until the model fit does not increase any further:

    iqtree -s example.phy -p example.nex -m MFP+MERGE
    # for version 1.x change -p to -spp


Note that this command considers the FreeRate heterogeneity model (see [model selection tutorial](Tutorial#choosing-the-right-substitution-model)). If you want to resemble PartitionFinder by just considering the invariable site and Gamma rate heterogeneity (thus saving computation times), then run:

    iqtree -s example.phy -p example.nex -m TESTMERGE
    # for version 1.x change -p to -spp

After ModelFinder found the best partition, IQ-TREE will immediately start the tree reconstruction under the best-fit partition model.
Sometimes you only want to find the best-fit partition model without doing tree reconstruction, then run:

    iqtree -s example.phy -p example.nex -m MF+MERGE
    # for version 1.x change -p to -spp

To resemble PartitionFinder and save time:

    iqtree -s example.phy -p example.nex -m TESTMERGEONLY
    # for version 1.x change -p to -spp


To reduce the computational burden IQ-TREE implements the *relaxed hierarchical clustering algorithm* ([Lanfear et al., 2014]), which is invoked via `-rcluster` option:

    iqtree -s example.phy -p example.nex -m MF+MERGE -rcluster 10
    # for version 1.x change -p to -spp


to only examine the top 10% partition merging schemes (similar to the `--rcluster-percent 10` option in PartitionFinder).



Ultrafast bootstrapping with partition model
--------------------------------------------
<div class="hline"></div>

IQ-TREE can perform the ultrafast bootstrap with partition models by e.g.,

    iqtree -s example.phy -p example.nex -B 1000
    # for version 1.x change -p to -spp and -B to -bb

Here, IQ-TREE will resample the sites *within*  partitions (i.e., 
the bootstrap replicates are generated per partition separately and then concatenated together).
The same holds true if you do the standard nonparametric bootstrap. 

IQ-TREE supports the partition-resampling strategy as suggested by ([Nei et al., 2001]): 


    iqtree -s example.phy -p example.nex -B 1000 --sampling GENE
    # for version 1.x change -p to -spp and -B to -bb and --sampling to -bsam


to resample partitions instead of sites. Moreover, IQ-TREE allows an even more complicated
strategy: resampling partitions and then sites within resampled partitions  ([Gadagkar et al., 2005]; [Seo et al., 2005]). This may help to reduce false positives (i.e. wrong branch receiving 100% support):


    iqtree -s example.phy -p example.nex -B 1000 --sampling GENESITE
    # for version 1.x change -p to -spp and -B to -bb and --sampling to -bsam



Constrained tree search
-----------------------
<div class="hline"></div>

IQ-TREE supports constrained tree search via `-g` option, so that the resulting tree must obey a constraint tree topology. The constraint tree can be multifurcating and need not to contain all species. To illustrate, let's return to the [first running example](Tutorial#first-running-example), where we want to force Human grouping with Seal whereas Cow with Whale. If you use the following constraint tree (NEWICK format):

    ((Human,Seal),(Cow,Whale));

Save this to a file `example.constr0` and run:

    iqtree -s example.phy -m TIM2+I+G -g example.constr0 --prefix example.constr0
    # for version 1.x change --prefix to -pre
    
(We use a prefix in order not to overwrite output files of the previous run). The resulting part of the tree extracted from `example.constr0.iqtree` looks exactly like a normal unconstrained tree search:


            +--------------Human
         +--|
         |  |  +------Seal
         |  +--|
         |     |  +-----Cow
         |     +--|
         |        +-------Whale
    +----|
    |    |         +---Mouse
    |    +---------|
    |              +------Rat


This is the correct behavior: although Human and Seal are not monophyletic, this tree indeed satisfies the constraint, because the induced subtree separates (Human,Seal) from (Cow,Whale). This comes from the fact that the tree is _unrooted_. If you want them to be sister groups, then you need to include _outgroup_ taxa into the constraint tree. For example:

    ((Human,Seal),(Cow,Whale),Mouse);

Save this to `example.constr1` and run:

    iqtree -s example.phy -m TIM2+I+G -g example.constr1 --prefix example.constr1
    # for version 1.x change --prefix to -pre

The resulting part of the tree is then:

               +---------------Human
            +--|
            |  +------Seal
         +--|
         |  |  +-----Cow
         |  +--|
         |     +-------Whale
    +----|
    |    |         +---Mouse
    |    +---------|
    |              +------Rat


which shows the desired effect.

>**NOTE**: While this option helps to enforce the tree based on prior knowledge, it is advised to always perform tree topology tests to make sure that the resulting constrained tree is NOT significantly worse than an unconstrained tree! See [tree topology tests](#tree-topology-tests) and [testing constrained tree](#testing-constrained-tree) below for a guide how to check this.

Tree topology tests
-------------------
<div class="hline"></div>

IQ-TREE can compute log-likelihoods of a set of trees passed via the `-z` option:

    iqtree -s example.phy -z example.treels -m GTR+G

assuming that `example.treels` is an existing file containing a set of trees in NEWICK format. IQ-TREE  first reconstructs an ML tree. Then, it will compute the log-likelihood of the  trees in `example.treels` based on the estimated parameters done for the ML tree. `example.phy.iqtree` will have a section called `USER TREES` that lists the tree IDs and the corresponding log-likelihoods.
The trees with optimized branch lengths can be found in `example.phy.treels.trees`
If you only want to evaluate the trees without reconstructing the ML tree, you can run:

    iqtree -s example.phy -z example.treels -n 0

Here, the number of search iterations is set to 0 (`-n 0`), such that model parameters are quickly estimated from an initial parsimony tree, which is normally accurate enough for our purpose. If you, however, prefer to estimate model parameters based on a tree (e.g. reconstructed previously), use `-te <treefile>` option.  

IQ-TREE also supports several tree topology tests using the RELL approximation ([Kishino et al., 1990]). This includes bootstrap proportion (BP), Kishino-Hasegawa test ([Kishino and Hasegawa, 1989]), Shimodaira-Hasegawa test ([Shimodaira and Hasegawa, 1999]), expected likelihood weights ([Strimmer and Rambaut, 2002]):

    iqtree -s example.phy -z example.treels -n 0 -zb 1000


Here, `-zb` specifies the number of RELL replicates, where 1000 is the recommended minimum number. The `USER TREES` section of `example.phy.iqtree` will list the results of BP, KH, SH, and ELW methods. 

If you also want to perform the weighted KH and weighted SH tests, simply add `-zw` option:

    iqtree -s example.phy -z example.treels -n 0 -zb 1000 -zw

Starting with version 1.4.0 IQ-TREE supports approximately unbiased (AU) test ([Shimodaira, 2002]) via `-au` option:

    iqtree -s example.phy -z example.treels -n 0 -zb 1000 -zw -au

This will perform all above tests plus the AU test.

Finally, note that IQ-TREE will automatically detect duplicated tree topologies and omit them during the evaluation.

>**HINTS**:
>
> - The KH, SH and AU tests return p-values, thus a tree is rejected if its p-value < 0.05 (marked with a `-` sign).
>
> - bp-RELL and c-ELW return posterior weights which *are not p-value*. The weights sum up to 1 across the trees tested.
>
> - The KH test ([Kishino and Hasegawa, 1989]) was designed to test 2 trees and thus has no correction for multiple testing. The SH test ([Shimodaira and Hasegawa, 1999]) fixes this problem.
>
> - However, the SH test becomes too conservative (i.e., rejecting fewer trees than expected) when testing many trees. The AU test ([Shimodaira, 2002]) fixes this problem and is thus recommended as replacement for both KH and SH tests.
{: .tip}



Testing constrained tree
------------------------
<div class="hline"></div>

We now illustrate an example to use the AU test (see above) to test trees from unconstrained versus constrained search, which is helpful to know if a constrained search is sensible or not. Thus:

1. Perform an unconstrained search:
        
        iqtree -s example.phy -m TIM2+I+G --prefix example.unconstr
        # for version 1.x change --prefix to -pre
        
2. Perform a constrained search, where `example.constr1` file contains: `((Human,Seal),(Cow,Whale),Mouse);`:
    
        iqtree -s example.phy -m TIM2+I+G -g example.constr1 --prefix example.constr1
        # for version 1.x change --prefix to -pre
        
3. Perform another constrained search, where `example.constr2` file contains `((Human,Cow,Whale),Seal,Mouse);`: 

        iqtree -s example.phy -m TIM2+I+G -g example.constr2 --prefix example.constr2
        # for version 1.x change --prefix to -pre

4. Perform the last constrained search, where `example.constr3` file contains `((Human,Mouse),(Cow,Rat),Opossum);`: 

        iqtree -s example.phy -m TIM2+I+G -g example.constr3 --prefix example.constr3
        # for version 1.x change --prefix to -pre

5. Concatenate all trees into a file:
    
        # for Linux or macOS
        cat example.unconstr.treefile example.constr1.treefile example.constr2.treefile example.constr3.treefile > example.treels
        
        # for Windows
        type example.unconstr.treefile example.constr1.treefile example.constr2.treefile example.constr3.treefile > example.treels
        
    
6. Test the set of trees:
    
        iqtree -s example.phy -m TIM2+I+G -z example.treels -n 0 -zb 1000 -au


Now look at the resulting `.iqtree` file:

    USER TREES
    ----------

    See example.phy.trees for trees with branch lengths.

    Tree      logL    deltaL  bp-RELL    p-KH     p-SH    c-ELW     p-AU
    -------------------------------------------------------------------------
      1   -21152.617   0.000  0.7110 + 0.7400 + 1.0000 + 0.6954 + 0.7939 + 
      2   -21156.802   4.185  0.2220 + 0.2600 + 0.5910 + 0.2288 + 0.3079 + 
      3   -21158.579   5.962  0.0670 + 0.1330 + 0.5130 + 0.0758 + 0.1452 + 
      4   -21339.596 186.980  0.0000 - 0.0000 - 0.0000 - 0.0000 - 0.0000 - 

    deltaL  : logL difference from the maximal logl in the set.
    bp-RELL : bootstrap proportion using RELL method (Kishino et al. 1990).
    p-KH    : p-value of one sided Kishino-Hasegawa test (1989).
    p-SH    : p-value of Shimodaira-Hasegawa test (2000).
    c-ELW   : Expected Likelihood Weight (Strimmer & Rambaut 2002).
    p-AU    : p-value of approximately unbiased (AU) test (Shimodaira, 2002).

    Plus signs denote the 95% confidence sets.
    Minus signs denote significant exclusion.
    All tests performed 1000 resamplings using the RELL method.

One sees that the AU test does not reject the first 3 trees (denoted by `+` sign below the `p-AU` column), whereas the last tree is significantly excluded (`-` sign). All other tests also agree with this. Therefore, groupings of `(Human,Mouse)` and `(Cow,Rat)` do not make sense. Whereas the phylogenetic position of `Seal` based on 3 first trees is still undecidable. This is in agreement with the SH-aLRT and ultrafast bootstrap supports [done in the Tutorial](Tutorial#assessing-branch-supports-with-single-branch-tests). 


Consensus construction and bootstrap value assignment
-----------------------------------------------------
<div class="hline"></div>

IQ-TREE can construct an extended majority-rule consensus tree from a set of trees written in NEWICK or NEXUS format (e.g., produced
by MrBayes):


    iqtree -con mytrees


To build a majority-rule consensus tree, simply set the minimum support threshold to 0.5:


    iqtree -con mytrees -minsup 0.5


If you want to specify a burn-in (the number of beginning trees to ignore from the trees file), use `-bi` option:


    iqtree -con mytrees -minsup 0.5 -bi 100


to skip the first 100 trees in the file.

IQ-TREE can also compute a consensus network and print it into a NEXUS file by:


    iqtree -net mytrees


Finally, a useful feature is to read in an input tree and a set of trees, then IQ-TREE can assign the
support value onto the input tree (number of times each branch in the input tree occurs in the set of trees). This option is useful if you want to compute the support values for an ML tree based on alternative topologies. 


    iqtree -sup input_tree set_of_trees


User-defined substitution models
--------------------------------
<div class="hline"></div>

Users can specify any DNA model using a 6-letter code that defines which rates should be equal. 
For example, `010010` corresponds to the HKY model and `012345` to the GTR model.
In fact, IQ-TREE  uses this specification internally to simplify the coding. The 6-letter code is specified via the `-m` option, e.g.:


    iqtree -s example.phy -m 010010+G


Moreover, with the `-m` option one can input a file which contains the 6 rates (A-C, A-G, A-T, C-G, C-T, G-T) and 4 base frequencies (A, C, G, T).  For example:

    iqtree -s example.phy -m mymodel+G


where `mymodel` is a file containing the 10 entries described above, in the correct order. The entries can be seperated by either empty space(s) or newline character. One can even specify the rates within `-m` option by e.g.:


    iqtree -s example.phy -m 'TN{2.0,3.0}+G8{0.5}+I{0.15}'


That means, we use Tamura-Nei model with fixed transition-transversion rate ratio of 2.0 and purine/pyrimidine rate ratio of 3.0. Moreover, we
use 8-category Gamma-distributed site rates with the shape parameter (alpha) equal to 0.5 and a proportion of invariable sites p-inv=0.15.

By default IQ-TREE computes empirical state frequencies from the alignment by counting, but one can also estimate the frequencies by maximum-likelihood
with `+Fo` in the model name:


    iqtree -s example.phy -m GTR+G+Fo


For amino-acid alignments, IQ-TREE use the empirical frequencies specified in the model. If you want frequencies as counted from the alignment, use `+F`, for example:


    iqtree -s myprotein_alignment -m WAG+G+F


Note that all model specifications above can be used in the partition model NEXUS file.



Inferring site-specific rates
------------------------------
<div class="hline"></div>

IQ-TREE allows to infer site-specific evolutionary rates if a [site-rate heterogeneity model such as Gamma or FreeRate](Substitution-Models#rate-heterogeneity-across-sites) is the best model. Here, IQ-TREE will estimate model parameters and then apply an empirical Bayesian approach to assign site-rates as the mean over rate categories, weighted by the posterior probability of the site falling into each category. This approach is provided in IQ-TREE because such empirical Bayesian approach was shown to be most accurate ([Mayrose et al., 2004]). An example run:

    iqtree -s example.phy --rate
    # for version 1.x change --rate to -wsr
    
IQ-TREE will write an output file `example.phy.rate` that looks like:

    Site    Rate    Category        Categorized_rate
    1       0.26625 2       0.24393
    2       0.99345 3       0.81124
    3       2.69275 4       2.91367
    4       0.25822 2       0.24393
    5       0.25822 2       0.24393
    6       0.42589 2       0.24393
    7       0.30194 2       0.24393
    8       0.72790 3       0.81124
    9       0.25822 2       0.24393
    10      0.09177 1       0.03116

The 1st column is site index of the alignment (starting from 1), the 2nd column `Rate` shows the mean site-specific rate as explained above, and the 3rd and 4th columns show the category index and rate of the Gamma rate category with the highest probability for this site (1 for slow and 4 for fast rate).

The above run will perform a full tree search. To speed up you can use `-n 0` to only use a parsimony tree for site rate estimates. Or if you have already infered an ML tree, you can specify it to improve the rate estimate:


    iqtree -s example.phy -t ml.treefile -n 0 --rate 
    # for version 1.x change --rate to -wsr

where `-t` is the option to input a fixed tree topology and `ml.treefile` is the ML tree reconstructed previously. 

If you already know the best-fit model for the alignment, you can use specify it via `-m` option to omit model selection and hence speed it up:

    iqtree -s example.phy -m GTR+R10 -n 0 --rate 
    # for version 1.x change --rate to -wsr

Finally, IQ-TREE 2 allows to estimate rates by maximum likelihood via `--mlrate` option:

    iqtree -s example.phy -n 0 --mlrate 

This will print an output file `example.phy.mlrate` that looks like:

	# Site-specific subtitution rates determined by maximum likelihood
	# This file can be read in MS Excel or in R with command:
	#   tab=read.table('example.phy.mlrate',header=TRUE)
	# Columns are tab-separated with following meaning:
	#   Site:   Alignment site ID
	#   Rate:   Site rate estimated by maximum likelihood
	Site    Rate
	1       2.51550
	2       12.89129
	3       34.31350
	4       2.44313
	5       2.44313
	6       4.41889
	7       2.69577
	8       9.27503
	9       2.44313
	10      0.00001

Where to go from here?
----------------------
<div class="hline"></div>

See [Command Reference](Command-Reference) for a complete list of all options available in IQ-TREE.

[Gadagkar et al., 2005]: https://doi.org/10.1002/jez.b.21026
[Kishino et al., 1990]: https://doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: https://doi.org/10.1007/BF02100115
[Lanfear et al., 2012]: https://doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: https://doi.org/10.1186/1471-2148-14-82
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Nei et al., 2001]: https://doi.org/10.1073/pnas.051611498
[Seo et al., 2005]: https://doi.org/10.1073/pnas.0408313102
[Shimodaira and Hasegawa, 1999]: https://doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913
[Strimmer and Rambaut, 2002]: https://doi.org/10.1098/rspb.2001.1862
[Mayrose et al., 2004]: https://doi.org/10.1093/molbev/msh194
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

