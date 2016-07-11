<!--jekyll 
docid: 02
icon: info-circle
doctype: tutorial
tags:
- tutorial
sections:
- name: First example
  url: first-running-example
- name: Model selection
  url: choosing-the-right-substitution-model
- name: New model selection
  url: new-model-selection
- name: Codon models
  url: codon-models
- name: Binary, Morphological, SNPs
  url: binary-morphological-and-snp-data
- name: Ultrafast bootstrap
  url: assessing-branch-supports-with-ultrafast-bootstrap-approximation
- name: Nonparametric bootstrap
  url: assessing-branch-supports-with--standard-nonparametric-bootstrap
- name: Single branch tests
  url: assessing-branch-supports-with-single-branch-tests
- name: Partitioned analysis
  url: partitioned-analysis-for-multi-gene-alignments
- name: Partitioning with mixed data
  url: partitioned-analysis-with-mixed-data
- name: Partition scheme selection
  url: choosing-the-right-partitioning-scheme
- name: Bootstrapping partition model
  url: ultrafast-bootstrapping-with-partition-model
- name: Utilizing multi-core CPUs
  url: utilizing-multi-core-cpus
jekyll-->
This tutorial gives users a quick starting guide. 
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [First running example](#first-running-example)
- [Choosing the right substitution model](#choosing-the-right-substitution-model)
- [New model selection](#new-model-selection)
- [Codon models](#codon-models)
- [Binary, morphological and SNP data](#binary-morphological-and-snp-data)
- [Assessing branch supports with ultrafast bootstrap approximation](#assessing-branch-supports-with-ultrafast-bootstrap-approximation)
- [Assessing branch supports with  standard nonparametric bootstrap](#assessing-branch-supports-with--standard-nonparametric-bootstrap)
- [Assessing branch supports with single branch tests](#assessing-branch-supports-with-single-branch-tests)
- [Partitioned analysis for multi-gene alignments](#partitioned-analysis-for-multi-gene-alignments)
- [Partitioned analysis with mixed data](#partitioned-analysis-with-mixed-data)
- [Choosing the right partitioning scheme](#choosing-the-right-partitioning-scheme)
- [Ultrafast bootstrapping with partition model](#ultrafast-bootstrapping-with-partition-model)
- [Utilizing multi-core CPUs](#utilizing-multi-core-cpus)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Please first [download](Home#download) and [install](Quickstart) the binary
for your platform . For the next steps, the folder containing your  `iqtree` executable should be added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Alternatively, you can also copy `iqtree` binary into your system search.

>**TIP**: For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 


First running example
---------------------

From the download there is an example alignment called `example.phy`
 in PHYLIP format (IQ-TREE also supports FASTA, NEXUS, CLUSTAL and MSF files). You can now start to reconstruct a maximum-likelihood tree
from this alignment by entering (assuming that you are now in the same folder with `example.phy`):

    iqtree -s example.phy

`-s` is the option to specify the name of the alignment file that is always required by
IQ-TREE to work. At the end of the run IQ-TREE will write several output files:

* `example.phy.iqtree`: the main report file that is self-readable. You
should look at this file to see the computational results. It also contains a textual representation of the final tree. 
* `example.phy.treefile`: the ML tree in NEWICK format, which can be visualized
by any supported tree viewer programs like FigTree or  iTOL. 
* `example.phy.log`: log file of the entire run (also printed on the screen). To report
bugs, please send this log file and the original alignment file to the authors.

The default prefix of all output files is the alignment file name. However,  you can always 
change the prefix using the `-pre` option, e.g.:

    iqtree -s example.phy -pre myprefix

This prevents output files to be overwritten when you perform multiple analyses on the same alignment within the same folder. 


Choosing the right substitution model
-------------------------------------

IQ-TREE supports a wide range of [substitution models](Substitution-Models) for DNA, protein, codon, binary and morphological alignments. If the model is not specified, IQ-TREE will use the default model (
HKY for DNA, WAG for protein). In case you do not know which model is appropriate for your data,  IQ-TREE can automatically determine the best-fit model 
for your alignment using the `-m TEST` option. For example:

    iqtree -s example.phy -m TEST

`-m` is the option to specify the model name to use during the analysis. `TEST`
is a key word telling IQ-TREE to perform the model test procedure and select the best-fit model. The remaining analysis
will be done using the selected model. More specifically, IQ-TREE computes the log-likelihoods
of the initial parsimony tree for many different models and the *Akaike information criterion* (AIC), *corrected Akaike information criterion* (AICc), and the *Bayesian information criterion* (BIC).
Then IQ-TREE chooses the model that minimizes the BIC score (you can also change to AIC or AICc by 
adding the option `-AIC` or `-AICc`, respectively.
Here, IQ-TREE will write an additional file:

* `example.phy.model`: log-likelihoods for all models tested.

If you now look at `example.phy.iqtree` you will see that IQ-TREE selected the model `TIM`
with Invar+Gamma rate heterogeneity. So `TIM+I+G` is the best-fit model
for this example data. Thus, for additional analyses you do not have to perform the model test again and can use the selected model as follows.


    iqtree -s example.phy -m TIM+I+G

Sometimes you only want to find the best-fit model without doing tree reconstruction, then run:

    iqtree -s example.phy -m TESTONLY

Here, IQ-TREE will stop after finishing the model selection. Note that if the file `*.model` exists and is correct, IQ-TREE will reuse the computed log-likelihoods  to speed up the model selection procedure. 

New model selection
-------------------

The previous section described the "standard" model selection to automatically select the best-fit model for the data before performing tree reconstruction. This "standard" procedure includes four rate heterogeneity types: homogeneity, `+I`, `+G` and `+I+G`. However, there is no reason to believe that the evolutionary rates follow a Gamma distribution. Therefore, we have recently introduced the FreeRate (`+R`) model ([Yang, 1995]) into IQ-TREE. The `+R` model generalizes the Gamma model by relaxing the "Gamma constraints", where the site rates and proportions are inferred independently from the data. 

Therefore, we recommend a new testing procedure that includes `+R` as the 5th rate heterogeneity type. This can be invoked simply with e.g.:

    iqtree -s example.phy -m TESTNEWONLY

It will also automatically determine the optimal number of rate categories. By default, the maximum number of categories is 10 due to computational reasons. If the sequences of your alignment are long enough, then you can increase this upper limit with the `cmax` option:

    iqtree -s example.phy -m TESTNEWONLY -cmax 15

will test `+R2` up to `+R15` instead of at most `+R10`.

To reduce computational burden, one can use the option `-mset` to restrict the testing procedure to a subset of base models instead of testing the entire set of all available models. For example, `-mset WAG,LG` will test only models like `WAG+...` or `LG+...`. Another useful option in this respect is `-msub` for AA data sets. With `-msub nuclear` only general AA models are included, whereas with `-msub viral` only AA models for viruses are included.

Finally, if you have enough computational resource, you can perform a thorough and more accurate analysis that invokes a full tree search for each model considered via the `-mtree` option:

    iqtree -s example.phy -m TESTNEWONLY -mtree


Codon models
------------

IQ-TREE supports a number of [codon models](Substitution-Models#codon-models). You need to input a protein-coding DNA alignment and specify codon data by option `-st CODON` (Otherwise, IQ-TREE applies DNA model because it detects that your alignment has DNA sequences):

    iqtree -s coding_gene.phy -st CODON 

If your alignment length is not divisible by 3, IQ-TREE will stop with an error message. IQ-TREE will group sites 1,2,3 into codon site 1; sites 4,5,6 to codon site 2; etc. Moreover, any codon, which has at least one gap/unknown/ambiguous nucleotide, will be treated as unknown codon character.

If you are not sure which model to use, simply add `-m TEST`, which also works for codon alignments: 

    iqtree -s coding_gene.phy -st CODON -m TEST

By default IQ-TREE uses the standard genetic code. If you want to change the genetic code, please refer to [codon models guide](Substitution-Models#codon-models).


Binary, morphological and SNP data
---------------------------------

IQ-TREE supports discrete morphological alignments by  `-st MORPH` option:

    iqtree -s morphology.phy -st MORPH

IQ-TREE implements to two morphological ML models: [MK and ORDERED](Substitution-Models#binary-and-morphological-models). Morphological data typically do not have constant (uninformative) sites. 
In such cases, you should apply [ascertainment bias correction](Substitution-Models#ascertainment-bias-correction) model by e.g.:
 
    iqtree -s morphology.phy -st MORPH -m MK+ASC

You can again select the best-fit model with  `-m TEST` (which also considers +G):

    iqtree -s morphology.phy -st MORPH -m TEST

For SNP data (DNA) that typically do not contain constant sites, you can explicitly tell the model to include
ascertainment bias correction:

    iqtree -s SNP_data.phy -m GTR+ASC

You can explicitly tell model testing to only include  `+ASC` model with:

    iqtree -s SNP_data.phy -m TEST+ASC


Assessing branch supports with ultrafast bootstrap approximation
----------------------------------------------------------------

To overcome the computational burden required by the nonparametric bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation (UFBoot) ([Minh et al., 2013]) that is  orders of magnitude faster than the standard procedure and provides relatively unbiased branch support values. To run UFBoot, use the option  `-bb`:

    iqtree -s example.phy -m TIM+I+G -bb 1000

 `-bb`  specifies the number of bootstrap replicates where 1000
is the minimum number recommended. The section  `MAXIMUM LIKELIHOOD TREE` in  `example.phy.iqtree` shows a textual representation of the maximum likelihood tree with branch support values in percentage. The NEWICK format of the tree is printed to the file  `example.phy.treefile`. In addition, IQ-TREE writes the following files:

* `example.phy.contree`: the consensus tree with assigned branch supports where branch lengths are optimized  on the original alignment.
*  `example.phy.splits`: support values in percentage for all splits (bipartitions),
computed as the occurence frequencies in the bootstrap trees. This file is in "star-dot" format.
*  `example.phy.splits.nex`: has the same information as  `example.phy.splits`
but in NEXUS format, which can be viewed with the program SplitsTree. 

>**TIP**: UFBoot support values have a different interpretation to the standard bootstrap. Refer to [FAQ: UFBoot support values interpretation](Frequently-Asked-Questions#how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values) for more information.


Assessing branch supports with  standard nonparametric bootstrap
----------------------------------------------------------------

The standard nonparametric bootstrap is invoked by  the  `-b` option:

    iqtree -s example.phy -m TIM+I+G -b 100

 `-b` specifies the number of bootstrap replicates where 100
is the minimum recommended number. The output files are similar to those produced by the UFBoot procedure. 



Assessing branch supports with single branch tests
--------------------------------------------------

IQ-TREE provides an implementation of the SH-like approximate likelihood ratio test ([Guindon et al., 2010]). To perform this test,  run:

    iqtree -s example.phy -m TIM+I+G -alrt 1000

 `-alrt` specifies the number of bootstrap replicates for SH-aLRT where 1000 is the minimum number recommended. 

IQ-TREE also provides a fast implementation of the local bootstrap probabilities method ([Adachi and Hasegawa, 1996]), 
which we call Fast-LBP. Fast-LBP computes the branch support by comparing the tree log-likelihood
with the log-likelihoods of the two alternative nearest-neighbor-interchange (NNI) trees around the branch of interest.
However, Fast-LBP is different from LBP where we compute the log-likelihoods of the two alternative NNI trees
by only reoptimizing five branches around the branch of interest (Similar idea is used in the SH-aLRT test).
To perform Fast-LBP, simply run:

    iqtree -s example.phy -m TIM+I+G -lbp 1000


You can also perform both tests:

    iqtree -s example.phy -m TIM+I+G -alrt 1000 -lbp 1000

The branches of the resulting ML tree are assigned with both SH-aLRT and Fast-LBP support values.
Finally, you can also combine the ultrafast bootstrap approximation with single branch tests within one single run:

    iqtree -s example.phy -m TIM+I+G -bb 1000 -alrt 1000 -lbp 1000


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



Utilizing multi-core CPUs
-------------------------

A specialized version of IQ-TREE (`iqtree-omp`) can utilize multiple CPU cores to speed up the analysis.
To obtain this version please refer to the [quick starting guide](Quickstart).  A complement option `-nt` allows specifying the number of CPU to be used. For example:


    iqtree-omp -s example.phy -nt 2


Here, IQ-TREE will use 2 CPU cores to perform the analysis. 

>**NOTICE**: the parallel efficiency is only good for long alignments. A good practice is to test with increasing number of cores until no substantial reduction of wall-clock time is observed. 

For example, on my computer (Linux, Intel Core i5-2500K, 3.3 GHz, quad cores) I observed the following 
wall-clock running time for this  example alignment:

| No. cores | Wall-clock time |
|-----------|-----------------|
| 1         | 21.465 sec      |
| 2         | 13.627 sec      |
| 3         | 11.119 sec      |
| 4         | 10.807 sec      |

Therefore, I would only use 2 cores, which seems to balance the trade-off between the number of cores and waiting time.



[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Gadagkar et al., 2005]: http://dx.doi.org/10.1002/jez.b.21026
[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Lanfear et al., 2012]: http://dx.doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: http://dx.doi.org/10.1186/1471-2148-14-82
[Lewis, 2001]: http://dx.doi.org/10.1080/106351501753462876
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

