---
layout: userdoc
title: "Complex Models"
author: _AUTHOR_
date: _DATE_
docid: 11
icon: book
doctype: manual
tags:
- manual
description: Complex models such as partition and mixture models.
sections:
- name: Partition models
  url: partition-models
- name: Mixture models
  url: mixture-models
- name: Site-specific frequency models
  url: site-specific-frequency-models
- name: Heterotachy models
  url: heterotachy-models
- name: Branch-specific models (in AliSim only)
  url: branch-specific-models-in-alisim-only
---

Complex models
==============

Complex models such as partition and mixture models.

<!--more-->

This document gives detailed descriptions of complex maximum-likelihood models available in IQ-TREE. It is assumed that you know the [basic substitution models](Substitution-Models) already.


Partition models
----------------
<div class="hline"></div>


Partition models are intended for phylogenomic (e.g., multi-gene) alignments, which allow each partition to have its own substitution models and evolutionary rates. IQ-TREE supports three types of partition models:

1. *Edge-equal* partition model with equal branch lengths: All partitions share the same set of branch lengths.
2. *Edge-proportional* partition model with proportional branch lengths: Like above but each partition has its own partition specific rate, that rescales all its branch lengths. This model accomodates different evolutionary rates between partitions (e.g. between 1st, 2nd, and 3rd codon positions).
3. *Edge-unlinked* partition model: Each partition has its own set of branch lengths. This is the most parameter-rich partition model, that accounts for e.g., *heterotachy* ([Lopez et al., 2002]).

>**TIP**: The edge-equal partition model is typically unrealistic as it does not account for different evolutionary speeds between partitions, whereas the edge-unlinked partition model can be overfitting if there are many short partitions. Therefore, the edge-proportional partition model is recommended for a typical analysis. 
{: .tip}

### Partition file format

To apply partition models users must first prepare a partition file in RAxML-style or NEXUS format. The RAxML-style is defined by the RAxML software and may look like:

    DNA, part1 = 1-100
    DNA, part2 = 101-384

This means two DNA partitions of an alignment, where one groups aligment sites `1-100` into `part1` and `101-384` into `part2`.

The NEXUS format is more complex but more powerful. For example, the above partition scheme may look like:

    #nexus
    begin sets;
        charset part1 = 1-100;
        charset part2 = 101-384;
        charpartition mine = HKY+G:part1, GTR+I+G:part2;
    end;

The first line contains the keyword `#nexus` to indicate a NEXUS file. It has a `sets` block, which contains two character sets (`charset` command) named `part1` and `part2`. Furthermore, with the `charpartition` command we set the model `HKY+G` for `part1` and `GTR+I+G` for `part2`. This is not possible with the RAxML-style format (i.e., one cannot specify `+G` rate model for one partition and `+I+G` rate model for the other partition). 

> **TIP**: IQ-TREE fully supports mixed rate heterogeneity types types between partitions (see above example).
{: .tip}

One can also specify non-consecutive sites of a partition, e.g. under RAxML-style format:

    DNA, part1 = 1-100, 250-384
    DNA, part2 = 101-249\3, 102-249\3
    DNA, part3 = 103-249\3

or under NEXUS format:

    #nexus
    begin sets;
        charset part1 = 1-100 250-384;
        charset part2 = 101-249\3 102-249\3;
        charset part3 = 103-249\3;
    end;

This means, `part2` contains sites 101, 102, 104, 105, 107, ..., 246, 248, 249; whereas `part3` contains sites 103, 106, ..., 247. This is useful to specify partitions corresponding to 1st, 2nd and 3rd codon positions.

Moreover, the NEXUS file allows each partition to come from a separate alignment file (not possible under RAxML-style format) with e.g.:

    #nexus
    begin sets;
        charset part1 = aln1.phy: 1-100\3 201-300;
        charset part2 = aln1.phy: 101-200;
        charset part3 = aln2.phy: *;
        charpartition mine = HKY:part1, GTR+G:part2, WAG+I+G:part3;
    end;

Here, `part1` and `part2` correspond to sub-alignments of `aln1.phy` file and `part3` is the entire alignment file `aln2.phy`. Note that `aln2.phy` is a protein alignment in this example. 

> **TIP**: IQ-TREE fully supports mixed data types between partitions.
{: .tip}

If you want to specify codon model for a partition, use the `CODON` keyword (otherwise, the partition may be detected as DNA):

    #nexus
    begin sets;
        charset part1 = aln1.phy:CODON, 1-300;
        charset part2 = aln1.phy: 301-400;
        charset part3 = aln2.phy: *;
        charpartition mine = GY:part1, GTR+G:part2, WAG+I+G:part3;
    end;

Note that this assumes `part1` has standard genetic code. If not, append `CODON` with [the right genetic code ID](Substitution-Models#codon-models).


### Partitioned analysis

Having prepared a partition file, one is ready to start a partitioned analysis with `-q` (edge-equal), `-spp` (edge-proportional) or `-sp` (edge-unlinked) option. See [this tutorial](Advanced-Tutorial#partitioned-analysis-for-multi-gene-alignments) for more details.

### Partitioned Simulation (with AliSim)

**Example 1**: Simulating mixed data with an ***Edge-equal* partition model**

AliSim allows users to simulate mixed data  (e.g., DNA, Protein, and MORPH) in a single simulation, in which each kind of data will be exported into a different alignment file. Here is an example for mixing DNA, protein, and morphological data:

    #nexus
	begin sets;
	    charset part1 = DNA, 1-200\2;
	    charset part2 = DNA, 2-200\2;
	    charset part3 = MORPH, 1-300;
	    charset part4 = AA, 1-200;
	    charset part5 = MORPH{30}, 1-200\2;
	    charset part6 = MORPH{30}, 2-200\2;
	    charset part7 = DNA, 201-400;
	    charpartition mine = HKY:part1, GTR+G:part2, MK:part3, Dayhoff:part4, MK:part5, ORDERED:part6, GTR+G:part7;
	end;

Here,  `part1`,  `part2`, and `part7` contain three DNA sub-alignments, whereas `part3`,  `part5`, and `part6` contain sub-alignments for morphological data. Besides, `part4` contains an amino-acid alignment with 200 sites. Note that users could specify the parameters for each model of each partition (see [Substitution Models](Substitution-Models)). In this example, for simplicity, we ignore that feature, thus, using randomly generated parameters.

Assuming that the above partition file is named `example_mix.nex` and one would like to simulate an MSA from a single tree in `example.phy.treefile`, one could start the simulation with the following command:

    iqtree2 --alisim partition_mix -q example_mix.nex -t example.phy.treefile

At the end of the run, AliSim will write out the simulated MSA into four output files. The first file named `partition_mix_0_part1_part2_part7.phy` stores the merged 400-site DNA alignment from `part1`, `part2`, and `part7`. Although `part3`, `part5`, and `part6` contain morphological data, `part3` simulates morphological alignments with 32 states while `part5` and `part6` have 30 states. Thus, the simulated alignment of `part3` will be saved to `partition_mix_0_part3.phy` whereas `partition_mix_0_part5_part6.phy`stores the merged alignment of `part5` and `part6`. Lastly, the simulated amino-acid alignment of `part4` should be stored in `partition_mix_0_part4.phy`.

**Example 2**: Simulating mixed data with an ***Edge-proportional* partition model**

Unlike ***Edge-equal***, the ***Edge-proportional*** partition model requires each partition to have its own partition specific rate, which rescales all its branch lengths. One could specify the partition-specific rates by specifying the tree length for each partition in the NEXUS file via `partX{<tree_length>}` as the following example. Note that `<tree_length>` of a partition is equal to the length of the common tree times the `partition_rate` of that partition. For example, assuming the length of the common tree is 2.61045, the partition-specific rate of partition 1 is 0.3, then the `<tree_length>` of `part1` should be 0.783135 (=2.61045 * 0.3):

    #nexus
	begin sets;
	    charset part1 = DNA, 1-200\2;
	    charset part2 = DNA, 2-200\2;
	    charset part3 = MORPH, 1-300;
	    charset part4 = AA, 1-200;
	    charset part5 = MORPH{30}, 1-200\2;
	    charset part6 = MORPH{30}, 2-200\2;
	    charset part7 = DNA, 201-400;
	    charpartition mine = HKY:part1{0.783135}, GTR+G:part2{1.51542}, MK:part3{1.03066}, Dayhoff:part4{0.489315}, MK:part5{0.680204}, ORDERED:part6{1.346}, GTR+G:part7{1.78177};
	end;

After preparing the `example_mix_edge_proportion.nex` file, one could start the simulation by:

    iqtree2 --alisim partition_mix_edge_proportition -p example_mix_edge_proportion.nex -t example.phy.treefile
    
**Example 3**: Simulating mixed data with ***Edge-unlinked* partition model**

AliSim supports tree-mixture models, which allow each partition has its own phylogenetic tree topology with even different sets of taxa as long as the supertree contains all of the taxa in all partitions. 

In this example, we re-use the `example_mix.nex` file to define seven partitions with DNA, amino-acid, and morphological data.

Then, we need to prepare a multiple-tree file. In the ***Edge-unlinked*** partition model, AliSim requires a multiple-tree input file that specifies a supertree (combining all taxa in all partitions) in the first line. Following that, each tree for each partition should be specified in a single line one by one in the input multiple-tree file. Let's have a look at the following multiple tree file named `example_mix_unlinked_partitions.parttrees`:

	(T0:0.0181521877,(((T5:0.1771956842,(T6:0.0614336000,T7:0.2002480501)23:0.1532476871)18:0.0332679438,(T8:0.0677273831,T9:0.0305167387)19:0.1180907531)16:0.0365283318,(T3:0.0681218610,T4:0.0527632742)17:0.1350927217)8:0.0393042588,(T1:0.1523260216,T2:0.0214431611)9:0.0733969175)2;
	(((T4:0.0843970070,T5:0.0286349627)4:0.1220779923,T2:0.0146182510)1:0.2353878387,(T1:0.0238257189,((T6:0.0106472245,T7:0.2282782466)12:0.0946749939,(T8:0.1456716825,T9:0.2407945609)13:0.3296837366)9:0.0160168752)2:0.0450985623,T0:0.0596020470)0;
	(T0:0.0671385689,T1:0.5298317367,((T4:0.0064005330,(T5:0.2918771232,T6:0.0059750004)11:0.1537117251)4:0.1158362293,(T2:0.0349557476,(T3:0.1152013065,(T7:0.2847312268,T8:0.0349557476)9:0.0062939800)7:0.0725670372)5:0.0689155159)3:0.0318828801)0;
	(((T1:0.1313043899,T2:0.0011060947)4:0.2128631786,((T6:0.1987774353,T7:0.1127011763)8:0.0673344553,T3:0.0980829253)5:0.0470003629)1:0.1532476871,((T4:0.0994252273,T5:0.1532476871)10:0.2162823151,(T8:0.0139262067,T9:0.1241328591)11:0.0110931561)2:0.0362405619,T0:0.0297059234)0;
	(T0:0.0277071893,((T2:0.1845160246,T3:0.1448169765)12:0.0055512710,((T8:0.0401971219,T9:0.0016129382)14:0.0176737179,(T6:0.1461017907,T7:0.0972861083)15:0.1624551550)13:0.0079043207)4:0.0484508315,(T1:0.0908818717,(T4:0.0382725621,T5:0.0047091608)11:0.1870802677)5:0.1645065090)3;
	(T0:0.0574475651,T1:0.0081210055,(((T4:0.0832409248,((T8:0.1614450454,T9:0.3540459449)22:0.0964955904,T5:0.0291690094)21:0.0949330586)16:0.0034591445,(T6:0.0339677368,T7:0.0038740828)17:0.0388607991)14:0.0303811454,(T3:0.0703197516,T2:0.0345311185)11:0.1061316504)3:0.0872273846)0;
	(T0:0.0205794913,(((T2:0.1093624747,((T8:0.2017406151,T9:0.0650087691)14:0.0695149183,T7:0.4135166557)9:0.2234926445)6:0.1924148657,T1:0.0614336000)4:0.0287682072,(T5:0.1010601411,T6:0.3194183212)5:0.0385662481)2:0.1671313316,(T3:0.1546463113,T4:0.1139434283)3:0.0321583624)0;
	((((T8:0.0306525160,T9:0.0125563223)16:0.1546463113,T7:0.0102032726)1:0.2501036032,(T1:0.0616186139,(T2:0.1565421027,(T5:0.0018470000,T6:0.0594207233)11:0.0505838082)9:0.0027371197)6:0.1443923474)0:0.4710530702,(T3:0.0372514008,T4:0.0322963887)4:0.0491022996,T0:0.0669430654)2; 

The above tree file contains 8 lines, in which the first line specifies the supertree (consisting of 10 taxa of all partitions), and the 7 remaining lines are the trees corresponding to 7 partitions. Note that taxon 3 (T3) is missing in the tree of `part1`, taxon 9 (T9) is missing in the tree of `part2`.

Now, one could simulate MSAs using the following command:
	
	iqtree2 --alisim partition_mix_unlinked_partition  -Q example_mix.nex -t example_mix_unlinked_partitions.parttrees

At the end of the run, AliSim will write out the simulated MSAs into four output files, as seen in the previous example with the ***Edge-equal*** partition model. However, when you check the merged alignment in the file `partition_mix_unlinked_partition_0_part1_part2_part7.phy`, you should see several gaps `-` in the sequences of taxon 3 (T3), and taxon 9 (T9) as these taxa are missing in the input trees of `part1` and `part2`.

	10 400
	T0         TACGCTTCAATTGCTGCTCTATTTCTATGTAGCCAGTTTTAGTCCTATCGTGG...
	T5         TACAGTCTCTTCGAAGCACTATTGCGCTAAATCCTGTTTTAGTACTGTTATAT...
	T6         TACTCTTGATTTGATGCCCTATTTCGATGTAGCCAGTTTTAGTCCTATCGTGG...
	T7         TATTCTTCAGTTGATGCTCTATTTCAAGGTAGCCAGTTTTTGCGTTATCTCCG...
	T8         GAATTTTCATTTAAGGACCTATATACATGTCGACCGTTATTGCCGTATCCTGG...
	T9         G-C-C-T-C-T-C-C-C-T-A-A-T-A-G-C-C-G-T-A-T-T-G-A-G-T-G...
	T3         -A-T-T-C-T-T-A-G-C-T-T-T-C-T-G-G-C-G-T-T-G-C-T-T-A-A-...
	T4         TACTGTGCCTTTGAAGCCCTTTTTAGCTATAGCCTGTTTTAGTCCTGTTGTGT...
	T1         TACTCCTGATTTGCTGCTCTAGTACCAGGTAGCTAGTTTTAGTCCTATCGTTG...
	T2         TACTGTTCCTTTGCTGCCCTACTTCCCCATAGCCAGTTTTAGTCCTGTTGTGT...


Mixture models
--------------
<div class="hline"></div>

### What is the difference between partition and mixture models?

Mixture models,  like partition models, allow more than one substitution model along the sequences. However, while a partition model assigns each alignment site a given specific model, mixture models do not need this information. A mixture model will compute for each site its probability (or weight) of belonging to each of the mixture classes (also called categories or components). Since the site-to-class assignment is unknown, the site likelihood under mixture models is the weighted sum of site likelihoods per mixture class.

For example, the [discrete Gamma rate heterogeneity](Substitution-Models#rate-heterogeneity-across-sites) is a simple mixture model type. It has several rate categories with equal weight. IQ-TREE also supports a number of [predefined protein mixture models](Substitution-Models#protein-mixture-models) such as the profile mixture models `C10` to `C60` (The ML variants of Bayesian `CAT` models).

Here, we discuss several possibilities to define new mixture models in IQ-TREE.

### Defining mixture models

To start with, the following command:

    iqtree -s example.phy -m "MIX{JC,HKY}"

specifies a mixture model (via the `MIX` keyword in the model string) with two components. The components (1) `JC` model, and (2) `HKY` model, are given in curly brackets and separated with a comma.  IQ-TREE will then estimate the parameters of both mixture components as well as their weights: the proportion of sites belonging to each component. 

>**NOTE**: Do not forget the double-quotes around model string! They prevent interpretation of the curly brackets by the command line shell, i.e., `MIX{JC,HKY}` would otherwise be interpreted as `MIXJC MIXHKY`.

Mixture models can be combined with rate heterogeneity, e.g.:

    iqtree -s example.phy -m "MIX{JC,HKY}+G4"

Here, we specify two mixture components and four Gamma rate categories. Effectively, this means that there are eight mixture components. Each site has a probability belonging to either `JC` or `HKY` and to one of the four rate categories.


### Profile mixture models

Sometimes one only wants to model the changes in nucleotide or amino-acid frequencies along the sequences while keeping the substitution rate matrix the same. This can be specified in IQ-TREE via `FMIX{...}` model syntax. For convenience the mixture components can be defined in a NEXUS file like this (example corresponds to [the CF4 model](Substitution-Models#protein-mixture-models) of ([Wang et al., 2008])): 

    #nexus
    begin models;
        frequency Fclass1 = 0.02549352 0.01296012 0.005545202 0.006005566 0.01002193 0.01112289 0.008811948 0.001796161 0.004312188 0.2108274 0.2730413 0.01335451 0.07862202 0.03859909 0.005058205 0.008209453 0.03210019 0.002668138 0.01379098 0.2376598;
        frequency Fclass2 = 0.09596966 0.008786096 0.02805857 0.01880183 0.005026264 0.006454635 0.01582725 0.7215719 0.003379354 0.002257725 0.003013483 0.01343441 0.001511657 0.002107865 0.006751404 0.04798539 0.01141559 0.000523736 0.002188483 0.004934972;
        frequency Fclass3 = 0.01726065 0.005467988 0.01092937 0.3627871 0.001046402 0.01984758 0.5149206 0.004145081 0.002563289 0.002955213 0.005286931 0.01558693 0.002693098 0.002075771 0.003006167 0.01263069 0.01082144 0.000253451 0.001144787 0.004573568;
        frequency Fclass4 = 0.1263139 0.09564027 0.07050061 0.03316681 0.02095119 0.05473468 0.02790523 0.009007538 0.03441334 0.005855319 0.008061884 0.1078084 0.009019514 0.05018693 0.07948 0.09447839 0.09258897 0.01390669 0.05367769 0.01230413;

        frequency CF4model = FMIX{empirical,Fclass1,Fclass2,Fclass3,Fclass4};
    end;

>**NOTE**: The amino-acid order in this file is: A   R   N   D   C   Q   E   G   H   I   L   K   M   F   P   S   T   W   Y   V.

Here, the NEXUS file contains a `models` block to define new models. More explicitly, we define four AA profiles `Fclass1` to `Fclass4`, each containing 20 AA frequencies. Then, the frequency mixture is defined with

    FMIX{empirical,Fclass1,Fclass2,Fclass3,Fclass4}

This means, we have five components: the first corresponds to empirical AA frequencies to be inferred from the  data and the remaining four components are specified in this NEXUS file. Please save this to a file, say, `mymodels.nex`. One can now start the analysis with:

    iqtree -s some_protein.aln -mdef mymodels.nex -m JTT+CF4model+G

The `-mdef` option specifies the NEXUS file containing user-defined models. Here, the `JTT` matrix is applied for all alignment sites and one varies the AA profiles along the alignment. One can use the NEXUS syntax to define all other profile mixture models such as `C10` to `C60`.


### NEXUS model file

In fact, IQ-TREE uses this NEXUS model file internally to define all [protein mixture models](Substitution-Models#protein-mixture-models). In addition to defining state frequencies, one can specify the entire model with rate matrix and state frequencies together. For example, the LG4M model ([Le et al., 2012]) can be defined by:

    #nexus
    begin models;
        model LG4M1 =
            0.269343
            0.254612 0.150988
            0.236821 0.031863 0.659648
            ....;
        ....
        model LG4M4 = ....;
        
        model LG4M = MIX{LG4M1,LG4M2,LG4M3,LG4M4}*G4;
    end;

Here, we first define the four matrices `LG4M1`, `LG4M2`, `LG4M3` and `LG4M4` in PAML format (see [protein models](Substitution-Models#protein-models)). Then `LG4M` is defined as mixture model with these four components *fused* with Gamma rate heterogeneity (via `*G4` syntax instead of `+G4`). This means that, in total, we have 4 mixture components instead of 16. The first component `LG4M1` is rescaled by the rate of the lowest Gamma rate category. The fourth component `LG4M4` corresponds to the highest rate.

Note that both `frequency` and `model` commands can be embedded into a single model file.

In AliSim, users could easily simulate MSAs with mixture models as described above by the following commands.

    iqtree2 --alisim MIX_JC_HKY_G_1000 -m "MIX{JC,HKY}+G4" -t example.phy.treefile
    iqtree2 --alisim JTT_CF4_G_1000 -mdef mymodels.nex -m "JTT+CF4model+G" -t example.phy.treefile


Site-specific frequency models
------------------------------
<div class="hline"></div>

Starting with version 1.5.0, IQ-TREE provides a new posterior mean site frequency (PMSF) model as a rapid approximation to the time and memory consuming profile mixture models `C10` to `C60` ([Le et al., 2008a]; a variant of PhyloBayes' `CAT` model). The PMSF are the amino-acid profiles for each alignment site computed from an input mixture model and a guide tree. The PMSF model is much faster and requires much less RAM than `C10` to `C60` (see table below), regardless of the number of mixture classes. Our extensive simulations and empirical phylogenomic data analyses demonstrate that the PMSF models can effectively ameliorate long branch attraction artefacts.

If you use this model in a publication please cite:

> __H.C. Wang, B.Q. Minh, S. Susko and A.J. Roger__ (2018) Modeling site heterogeneity with posterior mean site frequency profiles accelerates accurate phylogenomic estimation. _Syst. Biol._, 67:216-235. <https://doi.org/10.1093/sysbio/syx068>

Here is an example of computation time and RAM usage for an Obazoa data set (68 sequences, 43615 amino-acid sites) from [Brown et al. (2013)] using 16 CPU cores: 


| Models    | CPU time      | Wall-clock time |	RAM usage |
|-----------|--------------:|----------------:|----------:|
| `LG+F+G`     |   43h:38m:23s |   3h:37m:23s    |   1.8 GB  |
| `LG+C20+F+G` |  584h:25m:29s	|  46h:39m:06s    |	 38.8 GB  |
| `LG+C60+F+G` | 1502h:25m:31s | 125h:15m:29s    | 112.8 GB  |
| `LG+PMSF+G`  |   73h:30m:37s |    5h:7m:27s    |	  2.2 GB  |


### Example usages

To use the PMSF model you have to provide a *guide tree*, which, for example, can be obtained by a quicker analysis under the simpler `LG+F+G` model. The guide tree can then be specified via `-ft` option, for example:

    iqtree -s <alignment> -m LG+C20+F+G -ft <guide_tree>

Here, IQ-TREE will perform two phases. In the first phase, IQ-TREE estimates mixture model parameters given the guide tree and then infers the site-specific frequency profile (printed to `.sitefreq` file). In the second phase, IQ-TREE will conduct typical analysis using the inferred frequency model instead of the mixture model to save RAM and running time. Note that without `-ft` option, IQ-TREE will conduct the analysis under the specified mixture model.

The PMSF model allows one, for the first time, to conduct nonparametric bootstrap under such complex models, for example (with 100 bootstrap replicates):

    iqtree -s <alignment> -m LG+C20+F+G -ft <guide_tree> -b 100


Please note that the first phase still consumes as much RAM as the mixture model. To overcome this, you can perform the first phase in a high-memory server and the second phase in a normal PC as follows:

    iqtree -s <alignment> -m LG+C20+F+G -ft <guide_tree> -n 0

This will stop the analysis after the first phase and also write a `.sitefreq` file. You can now copy this `.sitefreq` file to another low-memory machine and run with the same alignment:

    iqtree -s <alignment> -m LG+C20+F+G -fs <file.sitefreq> -b 100

This will omit the first phase and thus need much less RAM. 

Finally, note that for long (phylogenomic) alignments you can utilize the multicore IQ-TREE version to further save the computing times with, say, 24 cores by:

    # For IQ-TREE version <= 1.5.X
    iqtree-omp -nt 24 -s <alignment> -m LG+C20+F+G -fs <file.sitefreq>

    # For IQ-TREE version >= 1.6.0
    iqtree -nt 24 -s <alignment> -m LG+C20+F+G -fs <file.sitefreq>

See also [the list of relevant command line options](Command-Reference#site-specific-frequency-model-options). 


Heterotachy models
------------------
<div class="hline"></div>

Sequence data that have evolved under *heterotachy*, i.e., rate variation across sites and lineages ([Lopez, Casane, and Philippe, 2002](http://mbe.oxfordjournals.org/content/19/1/1.full)), are known to mislead phylogenetic inference ([Kolaczkowski and Thornton, 2004](https://doi.org/10.1038/nature02917)). To address this issue we introduce the General Heterogeneous evolution On a Single Topology (GHOST) model. More specifically, GHOST is an *edge-unlinked mixture model* consisting of several site classes, each having a separate set of model parameters and edge lengths on the same tree topology. Thus, GHOST naturally accounts for heterotachous evolution. In contrast to an [edge-unlinked partition model](#partition-models), the GHOST model does not require the *a priori* data partitioning, a possible source of model misspecification. 

Extensive simulations show that the GHOST model can accurately recover the tree topology, branch lengths, substitution rate and base frequency parameters from heterotachously-evolved sequences. Moreover, we compare the GHOST model to the partition model and show that, owing to the minimization of model constraints, the GHOST model is able to offer unique biological insights when applied to empirical data.


If you use this model in a publication please cite:

> __S.M. Crotty, B.Q. Minh, N.G. Bean, B.R. Holland, J. Tuke, L.S. Jermiin and A. von Haeseler__ (2019) GHOST: Recovering historical signal from heterotachously-evolved sequence alignments. *Syst. Biol.*, in press. <https://doi.org/10.1093/sysbio/syz051>



### Quick usages (for phylogenetic Inference with IQ-Tree)

Make sure that you have IQ-TREE version 1.6.0 or later. The GHOST model with `k` mixture classes is executed by adding `+Hk` to the model option (`-m`). For example if one wants to fit a GHOST model with 4 classes in conjunction with the `GTR` model of DNA evolution to sequences contained in `data.fst`, one would use the following command:

    iqtree -s data.fst -m GTR+H4

By default the above command will link GTR parameters across all classes. If you want to unlink GTR parameters, so that IQ-TREE estimates them separately for each class, replace `+H4` by `*H4`: 

    iqtree -s data.fst -m GTR*H4

Note that this infers one set of empirical base frequencies and apply those to all classes. If one wishes to infer separate base frequencies for each class then the `+FO` option is required:

    iqtree -s data.fst -m GTR+FO*H4

The `-wspm` option will generate a `.siteprob` output file. This contains the probability of each site belonging to each class:

    iqtree -s data.fst -m GTR+FO*H4 -wspm


### Quick usages (for phylogenetic Simulation with AliSim)

If one wants to simulate sequences based on a GHOST model with 4 classes in conjunction with the `GTR` model of DNA evolution, one would use the following command:

    iqtree2 --alisim GTR_plus_H4_1000 -m GTR+H4 -t example.phy.treefile

If one has an MSA `example.phy` and would like to simulate three MSAs that mimic that input MSA. In this example, we assume that the input MSA has evolved based on the GHOST model with 4 classes in conjunction with the `GTR` model. Therefore, AliSim firstly infers the phylogenetic tree and estimates the parameters for the GHOST model before simulating sequences. To do that, one would use the following command:

    iqtree2 --alisim GTR_plus_H4_inference_1000 -m GTR+H4 -s example.phy

If you want to unlink GTR parameters so that AliSim could use them separately for each class, replace `+H4` by `*H4`: 

    iqtree2 --alisim GTR_time_H4_1000 -m GTR*H4 -t example.phy.treefile

Similar to the previous example, one could use inference mode with this model by:

    iqtree2 --alisim GTR_time_H4_inference_1000 -m GTR*H4 -s example.phy

If one wishes to use separate base frequencies for each class, then the `+FO` option is required:

    iqtree2 --alisim GTR_FO_time_H4_inference_1000 -m GTR+FO*H4 -s example.phy

Branch-specific models (in AliSim only)
----------------------------

AliSim supports branch-specific models, which assign different models of sequence evolution to individual branches of a tree.

To use branch-specific models, users should specify the models for individual branches with the syntax `[&model=<model>]` in the input tree file. The model parameters should be separated by a forward slash `/` if the user wants to specify them. 

**Example 1**: assuming the input tree file `input_tree.treefile` is described as following 

	(A:0.1,(B:0.1,C:0.2[&model=HKY]),(D:0.3,E:0.1[&model=GTR{0.5/1.7/3.4/2.3/1.9}+F{0.2/0.3/0.4/0.1}+I{0.2}+G{0.5}]):0.2);

Then, simulate an MSA by

      iqtree2 --alisim output_1k -t input_tree.treefile -m JC
    
In this example, AliSim uses the `JC` model to simulate an MSA along the input tree. However, at the branch connecting taxon C to its ancestral, the `HKY` with random parameters should be used to simulate the sequence of taxon C. Similarly, the `GTR` model with the parameters specified above will be used to generate the sequence of taxon E.
  
To apply Heterotachy (GHOST) model for an individual branch, in addition to the model name, users must also supply a set of branch-lengths containing `n` lengths corresponding to `n` categories of the model via the syntax `lengths=<length_0>,...,<length_n>` as the following example. 

**Example 2**: assuming the tree file `input_tree.treefile` is described as following

	(A:0.1,(B:0.1,C:0.2[&model=HKY{2.0}*H4,lengths=0.1/0.2/0.15/0.3]),(D:0.3,E:0.1):0.2);

Then, simulate an MSA by

      iqtree2 --alisim output_1k -t input_tree.treefile -m JC
    
In this example, the JC model will be used to simulate an MSA along the input tree. However, at the branch connecting taxon C to its ancestral, the GHOST model with 4 categories will be used with 4 branch lengths 0.1, 0.2, 0.15, and 0.3, to generate the sequence of taxon C.

Additionally, at a rooted tree, users may want to generate the root sequence with particular state frequencies and then simulate new sequences from that root sequence based on a specific model. To do so, the user should supply a rooted tree, then specify a model and state frequencies  (with the syntax `[&model=<model>,freqs=<freq_0,...,<freq_n>]`) as the following example.

**Example 3**: assuming the tree file `input_tree.treefile` is described as following

	(A:0.1,(B:0.1,C:0.2),(D:0.3,E:0.1):0.2):0.3[&model=GTR,freqs=0.2/0.3/0.1/0.4];

Then, simulate an MSA by

      iqtree2 --alisim output_1k -t input_tree.treefile -m JC
    
In this example, a random sequence is firstly generated for the root node based on the user-specified frequencies (`0.2/0.3/0.1/0.4`). Then, the `GTR` model with random parameters will be used to simulate the sequence for the children node of the root node. Finally, AliSim traverses the tree and using the JC model to simulate sequences for the other nodes of the tree.

[Brown et al. (2013)]: https://doi.org/10.1098/rspb.2013.1755
[Lartillot and Philippe, 2004]: https://doi.org/10.1093/molbev/msh112
[Le et al., 2008a]: https://doi.org/10.1093/bioinformatics/btn445
[Le et al., 2012]: https://doi.org/10.1093/molbev/mss112
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Wang et al., 2008]: https://doi.org/10.1186/1471-2148-8-331


