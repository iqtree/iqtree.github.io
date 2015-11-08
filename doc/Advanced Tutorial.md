
This advanced tutorial is intended for more experienced users. For beginners please read the normal [[Tutorial]] first.


Tree topology tests
-------------------

IQ-TREE can compute log-likelihoods of a set of trees passed via `-z` option:

    iqtree -s example.phy -z example.treels -m GTR+G

assuming that `example.treels` contains the trees in NEWICK format. IQ-TREE  first reconstruct an ML tree. Then, it will compute the log-likelihood of the  trees in `example.treels` based on the estimated parameters done for the ML tree. `example.phy.iqtree` will have a section called `USER TREES` that lists the tree IDs and the corresponding log-likelihoods.
The trees with optimized branch lengths can be found in `example.phy.treels.trees`
If you only want to evaluate the trees without reconstructing the ML tree, you can run:

    iqtree -s example.phy -z example.treels -n 1

Here, IQ-TREE performs a very quick tree reconstruction using only 1 iteration  and uses that tree to estimate the model parameters, which are normally accurate enough for our purpose.

IQ-TREE also supports several tree topology tests using the RELL approximation ([kishino1990]). This includes bootstrap proportion (BP), Kishino-Hasegawa test ([kishino1989]), Shimodaira-Hasegawa test [shimodaira1999], expected likelihood weights [strimmer2002], weighted-KH (WKH), and weighted-SH (WSH) tests. The trees are passed via `-z` option:


    iqtree -s example.phy -z example.treels -n 1 -zb 1000


Here, `-zb` specifies the number of RELL replicates, where 1000 is the recommended minimum number. The `USER TREES` section of `example.phy.iqtree` will list the results of BP, KH, SH, and ELW methods. If you also want to perform the WKH and WSH, simply add `-zw` option:


    iqtree -s example.phy -z example.treels -n 1 -zb 1000 -zw


Finally, note that IQ-TREE will automatically detect duplicated tree topologies and omit them during the evaluation.


User-defined substitution models
--------------------------------

Users can specify an arbitrary DNA models using a 6-letter specification that constrains which rates to be equal. 
For example, `010010` corresponds to the HKY model and `012345` the GTR model.
In fact, the IQ-TREE  uses this specification internally to simplify the coding. The 6-letter code is specified via `-m` option, e.g.:


    iqtree -s example.phy -m 010010+G


Moreover, with the `-m` option one can input a file name which contains the 6 rates (A-C, A-G, A-T, C-G, C-T, G-T) and 4 base frequencies (A, C, G, T).  For example:

    iqtree -s example.phy -m mymodel+G


where `mymodel` is a file containing the 10 entries described above, in the correct order. The entries can be seperated by either empty space(s) or newline character. One can even specify the rates within `-m` option by e.g.:


    iqtree -s example.phy -m 'TN{2.0,3.0}+G8{0.5}+I{0.15}'


That means, we use Tamura-Nei model with fixed transition-transversion rate ratio of 2.0 and purine/pyrimidine rate ratio of 3.0. Moreover, we
use an 8-category Gamma-distributed site rates with the shape parameter (alpha) of 0.5 and a proportion of invariable sites p-inv=0.15.

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


    iqtree -con mytrees -t 0.5


If you want to specify a burn-in (the number of beginning trees to ignore from the trees file), use `-bi` option:


    iqtree -con mytrees -t 0.5 -bi 100


to skip the first 100 trees in the file.

IQ-TREE can also compute a consensus network and print it into a NEXUS file by:


    iqtree -net mytrees


Finally, an useful feature is to read in an input tree and a set of trees, then IQ-TREE can assign the
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

