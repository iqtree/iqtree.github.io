This tutorial gives users a quick starting guide. You can either download the binary
for your platform from the IQ-TREE website or the source code (see [[Installation]]). For the next steps, the folder containing your  `iqtree` executable should added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Instructions for how to set the PATH variable in a specific operating system can be easily found on the Internet. For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 


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

IQ-TREE supports a wide range of substitution models for binary, DNA, protein, codon and morphological alignments. If the substitution model is not specified, IQ-TREE will use the default model (e.g. HKY for DNA, WAG for protein). In case you do not know which model is appropriate for your data,  IQ-TREE can automatically determine the best-fit model 
for your alignment using the `-m TEST` option. For example:

    iqtree -s example.phy -m TEST

`-m` is the option to specify the model name to use during the analysis. `TEST`
is a key word telling IQ-TREE to perform the model test procedure and select the best-fit model. The remaining analysis
will be done using the selected model. More specifically, IQ-TREE computes the log-likelihoods
of the initial parsimony tree for many different models and the Akaike information criterion (AIC), corrected Akaike information criterion (AICc), and the Bayesian information criterion (BIC).
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

Here, IQ-TREE will stop after finishing the model selection. The name of the best-fit model will be printed on the screen.
Note that if the file `*.model` exists and is correct, IQ-TREE will reuse the computed log-likelihoods  to speed up the model selection procedure. 


Codon models
------------

Since version 1.0 IQ-TREE supports basic codon models (GY, MG, and ECM). You need to input a protein-coding DNA alignment and specify codon data by option `-st CODON` (Otherwise, IQ-TREE applies DNA model because it detects that your alignment has DNA sequences):

    iqtree -s coding_gene.phy -st CODON 

If your alignment length is not divisible by 3, an error message will occur. IQ-TREE will group sites 1,2,3 into codon site 1; site 4,5,6 to codon site 2; etc. Moreover, any codon, which has at least one gap/unknown/ambiguous nucleotide, will be treated as unknown codon character.

If you are not sure which model to use, simply add `-m TEST`, which also works for codon alignments: 

    iqtree -s coding_gene.phy -st CODON -m TEST

By default IQ-TREE uses the standard genetic code.
You can change to other genetic code (see <http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi>) with following options:

| Option | Genetic code |
|--------|--------------|
|`-st CODON1` | The Standard Code (same as `-st CODON`)|
| `-st CODON2` | The Vertebrate Mitochondrial Code |
| `-st CODON3` | The Yeast Mitochondrial Code |
| `-st CODON4` | The Mold, Protozoan, and Coelenterate Mitochondrial Code and the Mycoplasma/Spiroplasma Code |
| `-st CODON5` | The Invertebrate Mitochondrial Code |
| `-st CODON6` | The Ciliate, Dasycladacean and Hexamita Nuclear Code |
| `-st CODON9` | The Echinoderm and Flatworm Mitochondrial Code |
| `-st CODON10` | The Euplotid Nuclear Code |
| `-st CODON11` | The Bacterial, Archaeal and Plant Plastid Code |
| `-st CODON12` | The Alternative Yeast Nuclear Code |
| `-st CODON13` | The Ascidian Mitochondrial Code |
| `-st CODON14` | The Alternative Flatworm Mitochondrial Code |
| `-st CODON16` | Chlorophycean Mitochondrial Code |
| `-st CODON21` | Trematode Mitochondrial Code |
| `-st CODON22` | Scenedesmus obliquus Mitochondrial Code |
| `-st CODON23` | Thraustochytrium Mitochondrial Code |
| `-st CODON24` | Pterobranchia Mitochondrial Code |
| `-st CODON25` | Candidate Division SR1 and Gracilibacteria Code |


Morphological or SNP data
-------------------------

Since version 1.0 IQ-TREE supports discrete morphological alignment by  `-st MORPH` option:

    iqtree -s morphology.phy -st MORPH

IQ-TREE implements to two morphological ML models (MK and ORDERED; see Lewis 2001), where MK is the default model.
MK is a Juke-Cantor-like model. ORDERED model considers only transitions between states $i\rightarrow i-1$, $i\rightarrow i$, and $i \rightarrow i+1$. Morphological data typically do not have constant (uninformative) sites. 
In such case, you should apply ascertainment bias correction model by e.g.:
 
    iqtree -s morphology.phy -st MORPH -m MK+ASC

You can again select best-fit model with  `-m TEST` (which also consider +G):

    iqtree -s morphology.phy -st MORPH -m TEST

For SNP data (DNA) that typically do not contain constant sites, you can explicitly tell model to include
ascertainment bias correction:

    iqtree -s SNP_data.phy -m GTR+ASC

You can explicitly tell model testing to only include  `+ASC` model with:

    iqtree -s SNP_data.phy -m TEST+ASC


Assessing branch supports with ultrafast bootstrap approximation
----------------------------------------------------------------

To overcome the computational burden required by the nonparametric bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation (UFBoot) that is  orders of magnitude faster than the standard procedure and provide unbias branch support values. To run UFBoot, use the option  `-bb`:

    iqtree -s example.phy -m TIM+I+G -bb 1000

 `-bb`  specifies the number of bootstrap replicates where 1000
is the minimum number recommended. The section  `MAXIMUM LIKELIHOOD TREE` in  `example.phy.iqtree` shows a textual representation of the maximum likelihood tree with branch support values in percentage. The NEWICK format of the tree is printed to the file  `example.phy.treefile`. In addition, IQ-TREE writes the following files:

* `example.phy.contree`: the consensus tree with assigned branch supports where branch lengths are optimized  on the original alignment.
*  `example.phy.splits`: support values in percentage for all splits (bipartitions),
computed as the occurence frequencies in the bootstrap trees. This file is in "star-dot" format.
*  `example.phy.splits.nex`: has the same information as  `example.phy.splits`
but in NEXUS format, which can be viewed with SplitsTree program. 


Assessing branch supports with  standard nonparametric bootstrap
----------------------------------------------------------------

The standard nonparametric bootstrap is invoked by  the  `-b` option:

    iqtree -s example.phy -m TIM+I+G -b 100

 `-b` specifies the number of bootstrap replicates where 100
is the minimum recommended number. The output files are similar to those produced by the UFBoot procedure. 



Assessing branch supports with single branch tests
--------------------------------------------------

IQ-TREE provides an implementation of the SH-like approximate likelihood ratio test [guindon2010]. To perform this test,  run:

    iqtree -s example.phy -m TIM+I+G -alrt 1000

 `-alrt` specifies the number of bootstrap replicates for SH-aLRT where 1000 is the minimum number recommended. 

IQ-TREE also provides a fast implementation of the local bootstrap probabilities method [adachi1996b], 
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
IQ-TREE will then estimate the model parameters and branch lengths separately for every partition. 
**Since version 1.3.X IQ-TREE supports RAxML-style partition input file**, which looks like:

    DNA, part1 = 1-100
    DNA, part2 = 101-384

If your partition file is called  `example.partitions`, the partition analysis can be run with:


    iqtree -s example.phy -q example.partitions -m GTR+I+G


Note that using RAxML-style partition file, all partitions will use the same rate heterogeneity model given in `-m` option (`+I+G` in this example). If you want to specify, say, `+G` for the first partition and `+I+G` for the second partition, then you need to create a NEXUS file which is more flexible. This file contains a  `SETS` block with
 `CharSet` and  `CharPartition` commands to specify individual genes and the partition, respectively.
For example:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;


If your NEXUS file is called  `example.nex`, then use the option  `-sp` to input the file as following:

    iqtree -s example.phy -sp example.nex

Here, IQ-TREE partitions the alignment  `example.phy` into 2 sub-alignments named  `part1` and  `part2`
containing sites (columns) 1-100 and 101-384, respectively. Moreover, IQ-TREE applies the
subtitution models  `HKY+G` and  `GTR+I+G` to  `part1` and  `part2`, respectively. Substitution model parameters and trees with branch lengths can be found in the result file  `example.nex.iqtree`. 

Moreover, the  `CharSet` command allows to specify non-consecutive sites using comma-separated list of ranges with e.g.:

    charset part1 = 1-100 200-384;

That means,  `part1` contains sites 1-100 and 200-384 of the alignment. Another example is:

    charset part1 = 1-100\3;

for extracting sites 1,4,7,...,100 from the alignment. This is useful for getting codon positions from the protein-coding alignment.

IQ-TREE also allows combining sub-alignments from different alignment files. For example:

    #nexus
    begin sets;
        charset part1 = part1.phy: 1-100\3 201-300\3;
        charset part2 = part2.phy: 101-300;
        charpartition mine = HKY:part1, GTR+G:part2;
    end;

Here,  `part1` and  `part2` contain sub-alignments from alignment files  `part1.phy` and  `part2.phy`, respectively. The `:` is needed to separate the alignment file name and site specification. Because the alignment file names are now specified in this NEXUS file, you can omit the  `-s` option:

    iqtree -sp example.nex


Note that 
 `part1.phy` and  `part2.phy` does not need to contain the same set of sequences. For instance, if some sequence occurs
in   `part1.phy` but not in   `part2.phy`, IQ-TREE will treat the corresponding parts of sequence
in  `part2.phy` as missing data. For your convenience IQ-TREE writes the concatenated alignment
into the file  `example.nex.conaln`.

Since version 0.9.6 IQ-TREE supports partition models with joint and proportional branch lengths between genes. This is
to reduce the number of parameters in case of model overfitting for the full partition model. For example:


    iqtree -spp example.nex


applies a proportional partition model. That means, we have only one set of branch lengths for species tree 
but allow each gene to evolve under a specific rate (scaling factor) normalized to the average of 1.

A partition model with joint branch lengths is specified by:


    iqtree -spj example.nex

 
(i.e., all gene-specific rates are equal to 1). 
 
 
Choosing the right partitioning scheme
--------------------------------------

Since version 0.9.6 IQ-TREE implements a greedy strategy [lanfear2012] that starts with the full partition model and sequentially
merges two genes until the model fit does not increase any further:

  iqtree -sp example.nex -m TESTLINK


After the best partition is found IQ-TREE will immediately start the tree reconstruction under the best-fit partition model.
Sometimes you only want to find the best-fit partition model without doing tree reconstruction, then run:

  iqtree -sp example.nex -m TESTONLYLINK



Ultrafast bootstrapping with partition model
--------------------------------------------

IQ-TREE can perform the ultrafast bootstrap with partition models by e.g.,

    iqtree -sp example.nex -bb 1000

Here, IQ-TREE will resample the sites \emph{within} subsets of the partitions (i.e., 
the bootstrap replicates are generated per subset separately and then concatenated together).
The same holds true if you do the standard nonparametric bootstrap. 

Since version 0.9.6 IQ-TREE supports the gene-resampling strategy: 


    iqtree -sp example.nex -bb 1000 -bspec GENE


is to resample genes instead of sites. Moreover, IQ-TREE allows an even more complicated
strategy: resampling genes and sites within resampled genes:


    iqtree -sp example.nex -bb 1000 -bspec GENESITE



Utilizing multi-core CPUs
-------------------------

We also have a specialized version of IQ-TREE (`iqtree-omp`), which uses the OpenMP library, allows running analyses with multiple CPU cores.
You can download the binary from the software website or compile the source code
yourself (see [[Installation]]).  A complement option `-nt` allows specifying the number of CPU to be used. For example:


  iqtree-omp -s example.phy -nt 2


Here, IQ-TREE will use 2 CPU cores to perform the analysis. 

> Note that the parallel efficiency is only good long alignments. Because the speedup gain depends on the alignment length, a good practice is to try this version with increasing number of cores until no substantial reduction of running time is observed. 

For example, on my computer (Linux, Intel Core i5-2500K, 3.3 GHz, quad cores) I observed the following 
wall-clock running time for this  example alignment:

| No. cores | Wall-clock time |
|-----------|-----------------|
| 1         | 21.465 sec      |
| 2         | 13.627 sec      |
| 3         | 11.119 sec      |
| 4         | 10.807 sec      |

Therefore, I would only use 2 cores for this specific alignment.

