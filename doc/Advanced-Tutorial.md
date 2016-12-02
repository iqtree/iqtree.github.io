<!--jekyll 
docid: 03
icon: info-circle
doctype: tutorial
tags:
- tutorial
sections:
  - name: Partitioned analysis
    url: partitioned-analysis-for-multi-gene-alignments
  - name: Partitioning with mixed data
    url: partitioned-analysis-with-mixed-data
  - name: Partition scheme selection
    url: choosing-the-right-partitioning-scheme
  - name: Bootstrapping partition model
    url: ultrafast-bootstrapping-with-partition-model
  - name: Tree topology tests
    url: tree-topology-tests
  - name: User-defined models
    url: user-defined-substitution-models
  - name: Consensus construction and bootstrap value assignment
    url: consensus-construction-and-bootstrap-value-assignment
  - name: Computing Robinson-Foulds distance
    url: computing-robinson-foulds-distance-between-trees
  - name: Generating random trees
    url: generating-random-trees
jekyll-->

Advanced tutorial
=================

Recommended for experienced users to explore more features.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Partitioned analysis for multi-gene alignments](#partitioned-analysis-for-multi-gene-alignments)
- [Partitioned analysis with mixed data](#partitioned-analysis-with-mixed-data)
- [Choosing the right partitioning scheme](#choosing-the-right-partitioning-scheme)
- [Ultrafast bootstrapping with partition model](#ultrafast-bootstrapping-with-partition-model)
- [Tree topology tests](#tree-topology-tests)
- [User-defined substitution models](#user-defined-substitution-models)
- [Consensus construction and bootstrap value assignment](#consensus-construction-and-bootstrap-value-assignment)
- [Computing Robinson-Foulds distance between trees](#computing-robinson-foulds-distance-between-trees)
- [Generating random trees](#generating-random-trees)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


To get started, please read the [Beginner's Tutorial](Tutorial) first if not done so yet.

Partitioned analysis for multi-gene alignments
----------------------------------------------

In the partition model, you can specify a substitution model for each gene/character set. 
IQ-TREE will then estimate the model parameters separately for every partition. Moreover, IQ-TREE provides edge-linked or edge-unlinked branch lengths between partitions:

* `-q partition_file`: all partitions share the same set of branch lengths (like `-q` option of RAxML).
* `-spp partition_file`: like above but allowing each partition to have its own evolution rate.
* `-sp partition_file`: each partition has its own set of branch lengths (like combination of `-q` and `-M` options in RAxML) to account for, e.g. *heterotachy* ([Lopez et al., 2002]).

>**TIP**: `-spp` is recommended for typical analysis. `-q` is unrealistic and `-sp` is very parameter-rich. One can also perform all three analyses and compare e.g. the BIC scores to determine the best-fit partition model.

IQ-TREE supports RAxML-style and NEXUS partition input file. The RAxML-style partition file may look like:

    DNA, part1 = 1-100
    DNA, part2 = 101-384

If your partition file is called  `example.partitions`, the partition analysis can be run with:


    iqtree -s example.phy -q example.partitions -m GTR+I+G


Note that using RAxML-style partition file, all partitions will use the same rate heterogeneity model given in `-m` option (`+I+G` in this example). If you want to specify, say, `+G` for the first partition and `+I+G` for the second partition, then you need to create the more flexible NEXUS partition file. This file contains a  `SETS` block with
 `CharSet` and  `CharPartition` commands to specify individual genes and the partition, respectively.
For example:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;


If your NEXUS file is called  `example.nex`, then you can use the option  `-spp` to input the file as following:

    iqtree -s example.phy -spp example.nex

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

IQ-TREE also allows combining sub-alignments from different alignment files, which is helpful if you want to combine mixed data (e.g. DNA and protein) in a single analysis. Here is an example for mixing DNA, protein and codon models:

    #nexus
    begin sets;
        charset part1 = dna.phy: 1-100 201-300;
        charset part2 = dna.phy: 101-200;
        charset part3 = prot.phy: 1-400;
        charset part4 = prot.phy: 401-600;
        charset part5 = codon.phy: *;
        charpartition mine = HKY:part1, GTR+G:part2, LG+G:part3, WAG+I+G:part4, GY:part5;
    end;

Here,  `part1` and  `part2` contain sub-alignments from alignment file `dna.phy`, whereas `part3` and `part4` are loaded from alignment file `prot.phy` and `part5` from `codon.phy`. The `:` is needed to separate the alignment file name and site specification. Note that, for convenience `*` in `part5` specification means that `part5` corresponds to the entire alignment `codon.phy`. 

Because the alignment file names are now specified in this NEXUS file, you can omit the  `-s` option:

    iqtree -sp example.nex


Note that 
 `aln.phy` and  `prot.phy` does not need to contain the same set of sequences. For instance, if some sequence occurs
in   `aln.phy` but not in   `prot.phy`, IQ-TREE will treat the corresponding parts of sequence
in  `prot.phy` as missing data. For your convenience IQ-TREE writes the concatenated alignment
into the file  `example.nex.conaln`.

 
Choosing the right partitioning scheme
--------------------------------------

IQ-TREE implements a greedy strategy ([Lanfear et al., 2012]) that starts with the full partition model and subsequentially
merges two genes until the model fit does not increase any further:

    iqtree -sp example.nex -m TESTMERGE


After the best partition is found IQ-TREE will immediately start the tree reconstruction under the best-fit partition model.
Sometimes you only want to find the best-fit partition model without doing tree reconstruction, then run:

    iqtree -sp example.nex -m TESTONLYMERGE


To reduce the computational burden IQ-TREE implements the *relaxed hierarchical clustering algorithm* ([Lanfear et al., 2014]). Use

    iqtree -sp example.nex -m TESTONLYMERGE -rcluster 10

to only examine the top 10% partition merging schemes (similar to the `--rcluster-percent 10` option in PartitionFinder).

Finally, it is recommended to use the [new testing procedure](#new-model-selection):

    iqtree -s example.phy -sp example.nex -m TESTNEWMERGEONLY

that additionally includes the FreeRate model (`+R`) into the candidate rate heterogeneity types.


Ultrafast bootstrapping with partition model
--------------------------------------------

IQ-TREE can perform the ultrafast bootstrap with partition models by e.g.,

    iqtree -spp example.nex -bb 1000

Here, IQ-TREE will resample the sites *within* subsets of the partitions (i.e., 
the bootstrap replicates are generated per subset separately and then concatenated together).
The same holds true if you do the standard nonparametric bootstrap. 

IQ-TREE supports the gene-resampling strategy: 


    iqtree -spp example.nex -bb 1000 -bspec GENE


to resample genes instead of sites. Moreover, IQ-TREE allows an even more complicated
strategy: resampling genes and sites within resampled genes, which may reduce false positives of the standard bootstrap resampling ([Gadagkar et al., 2005]):


    iqtree -spp example.nex -bb 1000 -bspec GENESITE



Tree topology tests
-------------------

IQ-TREE can compute log-likelihoods of a set of trees passed via the `-z` option:

    iqtree -s example.phy -z example.treels -m GTR+G

assuming that `example.treels` contains the trees in NEWICK format. IQ-TREE  first reconstructs an ML tree. Then, it will compute the log-likelihood of the  trees in `example.treels` based on the estimated parameters done for the ML tree. `example.phy.iqtree` will have a section called `USER TREES` that lists the tree IDs and the corresponding log-likelihoods.
The trees with optimized branch lengths can be found in `example.phy.treels.trees`
If you only want to evaluate the trees without reconstructing the ML tree, you can run:

    iqtree -s example.phy -z example.treels -n 0

Here, IQ-TREE performs a very quick tree reconstruction using only 1 iteration  and uses that tree to estimate the model parameters, which are normally accurate enough for our purpose.

IQ-TREE also supports several tree topology tests using the RELL approximation ([Kishino et al., 1990]). This includes bootstrap proportion (BP), Kishino-Hasegawa test ([Kishino and Hasegawa, 1989]), Shimodaira-Hasegawa test ([Shimodaira and Hasegawa, 1999]), expected likelihood weights ([Strimmer and Rambaut, 2002]):

    iqtree -s example.phy -z example.treels -n 1 -zb 1000


Here, `-zb` specifies the number of RELL replicates, where 1000 is the recommended minimum number. The `USER TREES` section of `example.phy.iqtree` will list the results of BP, KH, SH, and ELW methods. 

If you also want to perform the weighted KH and weighted SH tests, simply add `-zw` option:

    iqtree -s example.phy -z example.treels -n 1 -zb 1000 -zw

Starting with version 1.4.0 IQ-TREE supports approximately unbiased (AU) test ([Shimodaira, 2002]) via `-au` option:

    iqtree -s example.phy -z example.treels -n 1 -zb 1000 -zw -au

This will perform all above tests plus the AU test.

Finally, note that IQ-TREE will automatically detect duplicated tree topologies and omit them during the evaluation.


User-defined substitution models
--------------------------------

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


Consensus construction and bootstrap value assignment
-----------------------------------------------------

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



Computing Robinson-Foulds distance between trees
------------------------------------------------

IQ-TREE implements a very fast Robinson-Foulds (RF) distance computation using hash table, which is a lot faster  than PHYLIP package. For example, you can run:


    iqtree -rf tree_set1 tree_set2


to compute the pairwise RF distances between 2 sets of trees. If you want to compute the all-to-all RF distances of a set of trees, use:


    iqtree -rf_all tree_set



Generating random trees
-----------------------

IQ-TREE provides several random tree generation models. For example, to generate a 100-taxon random tree into the file `100.tree` under the Yule Harding model, use the following command:


    iqtree -r 100 100.tree 


Here, the branch lengths follow an exponential distribution with mean of 0.1.
If you want to change the branch length distribution, run e.g:


    iqtree -r 100 -rlen 0.05 0.2 0.3 100.tree 


to set the minimum, mean, and maximum branch lengths as 0.05, 0.2, and 0.3, respectively. If you want to generate trees under uniform model instead, use `-ru` option:


    iqtree -ru 100 100.tree 


If you want to generate a random tree for your alignment, simply add the `-s <alignment>` option to the command line:


    iqtree -s example.phy -r 44 example.random.tree 


Note that, you still need to specify the `-r` option with the correct number of taxa that is contained in the alignment. 


[Gadagkar et al., 2005]: http://dx.doi.org/10.1002/jez.b.21026
[Kishino et al., 1990]: http://dx.doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: http://dx.doi.org/10.1007/BF02100115
[Lanfear et al., 2012]: http://dx.doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: http://dx.doi.org/10.1186/1471-2148-14-82
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Shimodaira and Hasegawa, 1999]: http://dx.doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: http://dx.doi.org/10.1080/10635150290069913
[Strimmer and Rambaut, 2002]: http://dx.doi.org/10.1098/rspb.2001.1862
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract
