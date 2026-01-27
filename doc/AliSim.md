---
layout: userdoc
title: "Simulating sequence alignments"
author: Heiko Schmidt, Minh Bui, Nhan Ly-Trong
date:    2025-02-21
docid: 9
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: Simulating sequence alignments
sections:
- name: Simulating an alignment from a tree and model
  url: simulating-an-alignment-from-a-tree-and-model
- name: Simulating other datatypes
  url: simulating-other-datatypes
- name: Non-reversible models
  url: non-reversible-models
- name: Rate heterogeneity across sites
  url: rate-heterogeneity-across-sites
- name: Customizing output alignments
  url: customizing-output-alignments
- name: Insertion and deletion models
  url: insertion-and-deletion-models
- name: Specifying model parameters
  url: specifying-model-parameters
- name: Mimicking a real alignment
  url: mimicking-a-real-alignment
- name: Simulating along a random tree
  url: simulating-along-a-random-tree
- name: Branch-specific models
  url: branch-specific-models
- name: Partition models
  url: partition-models
- name: Mixture models
  url: mixture-models
- name: Heterotachy GHOST model
  url: heterotachy-ghost-model
- name: Functional divergence model
  url: functional-divergence-model
- name: Pre-define mutations
  url: pre-define-mutations
- name: Parallel sequence simulations
  url: parallel-sequence-simulations
- name: Command reference
  url: command-reference  
---


Simulating sequence alignments
==============================

Sequence simulators play an important role in phylogenetics. Simulated data has many applications, such as evaluating the performance of different methods, hypothesis testing with parametric bootstraps, and, more recently, generating data for training machine-learning applications. Many sequence simulation programs exist, but the most feature-rich programs tend to be rather slow, and the fastest programs tend to be feature-poor. Here, we introduce AliSim, a new tool that can efficiently simulate biologically realistic alignments under a large range of complex evolutionary models. To achieve high performance across a wide range of simulation conditions, AliSim implements an adaptive approach that combines the commonly-used rate matrix and probability matrix approach. AliSim takes 1.3 hours and 1.3 GB RAM to simulate alignments with one million sequences or sites, while popular software Seq-Gen, Dawg, and INDELible require two to five hours and 50 to 500 GB of RAM. 


To use AliSim please make sure that you download the IQ-TREE version 2.4.0 or later.

If you use AliSim please cite:

- Nhan Ly-Trong, Giuseppe M.J. Barca, Bui Quang Minh (2023) 
  AliSim-HPC: parallel sequence simulator for phylogenetics.
  Bioinformatics, Volume 39, Issue 9, btad540.
  <https://doi.org/10.1093/bioinformatics/btad540>

For the original algorithms of AliSim please cite:

- Nhan Ly-Trong, Suha Naser-Khdour, Robert Lanfear, Bui Quang Minh (2022)
  AliSim: A Fast and Versatile Phylogenetic Sequence Simulator for the Genomic Era.
  _Molecular Biology and Evolution_, Volume 39, Issue 5, msac092.
  <https://doi.org/10.1093/molbev/msac092>



Simulating an alignment from a tree and model
-------------------------------------------

Similar to other software, AliSim can simulate a multiple sequence alignment from a given tree with branch lengths and a model with:

    iqtree3 --alisim <OUTPUT_PREFIX> -m <MODEL> -t <TREEFILE>

The `-m` option specifies a model, and `-t` option specifies a tree file in the standard [Newick format](https://evolution.genetics.washington.edu/phylip/doc/main.html#treefile). This will print the output alignment into `OUTPUT_PREFIX.phy` file in Phylip format.

For example, if you want to simulate a DNA alignment under the [Jukes-Cantor model](http://doi.org/10.1016/B978-1-4832-3211-9.50009-7) for the following tree `tree.nwk`:

    (A:0.3544,(B:0.1905,C:0.1328):0.0998,D:0.0898);

You can run IQ-TREE with:

    iqtree3 --alisim alignment -m "JC" -t tree.nwk

this will print the simulated alignment to `alignment.phy`. 


The output MSA should contain 4 sequences of 1000 sites, each, for example:

    4 1000
    A       AAATTTGGTCCTGTGATTCAGCAGTGAT...
    B       CTTCCACACCCCAGGACTCAGCAGTGAT...
    C       CTACCACACCCCAGGACTCAGCAGTAAT...
    D       CTACCACACCCCAGGAAACAGCAGTGAT...


Importantly, we note that AliSim uses a random number seed corresponding to the current CPU clock of the running computer. If you run two AliSim commands at the same time, it may generate two identical alignments, which may not be the desired outcome. In that case, you can use -seed option to specify the random number seed:

    iqtree3 --alisim alignment_123 -m "JC" -t tree.nwk -seed 123

`-seed` option has another advantage of reproducing the same alignment when rerunning IQ-TREE.

**NOTE**: AliSim fully supports multifurcating input trees, e.g., `(A:0.3544,(B:0.1905,C:0.1328,D:0.0898):0.05,E:0.1);`

Simulating other datatypes
--------------------------

Apart from the DNA data, AliSim can also simulate other types of data under amino-acid, codon, binary, and multi-state morphological models.

### Amino-acid models

AliSim supports all common [empirical amino-acid models](Substitution-Models#protein-models). For example, to simulate an alignment under the [LG model](https://doi.org/10.1093/molbev/msn067):

    iqtree3 --alisim alignment_aa -m "LG" -t tree.nwk

### Codon models

AliSim offers several [codon models](Substitution-Models#codon-substitution-rates). For example:
    
    iqtree3 --alisim alignment_codon -m "MG{2.0}+F1X4{0.2/0.3/0.4/0.1}" -t tree.nwk

This simulates an alignment under MG model with Nonsynonymous/synonymous (dn/ds) rate ratio of 2.0 and unequal nucleotide frequencies (0.2,0.3,0.4,0.1 for nucleotide A, C, G, T, respectively) but equal nucleotide frequencies over three codon positions.

### Binary and morphological models

AliSim supports some [binary and morphological models](Substitution-Models#binary-and-morphological-models). For example:

    iqtree3 --alisim alignment_bin -m "JC2" -t tree.nwk
 
will simulate a binary alignment under Jukes-Cantor-type binary model.
 
To simulate morphological alignments, users should specify the number of states with `-st MORPH{<NUM_STATES>}`  option: 

    iqtree3 --alisim alignment_morph -m "MK" -t tree.nwk -st "MORPH{20}"

This simulates a morphological alignment (with 20 states) under MK model.

AliSim also supports An ascertainment bias correction (`+ASC`) model ([Lewis, 2001](https://doi.org/10.1080/106351501753462876)) to simulate sequences without constant sites, for example:

    iqtree3 --alisim alignment_morph_asc -m "MK+ASC" -t tree.nwk -st "MORPH{20}"


Non-reversible models
--------------------------------------

Apart from the standard reversible models, AliSim also provides non-reversible models such as [Lie Markov DNA models](Substitution-Models#lie-markov-models), for DNA and NONREV for amino-acid. 

As an example, to simulate an alignment under the 12.12 model (equivalent to UNREST (unrestricted model)):

    iqtree3 --alisim alignment_lie_markov -m "12.12{0.5/0.6/0.9/0.2/0.1/0.4/0.7/0.8/0.3/0.15/0.65}+F{0.1/0.2/0.4/0.3}" -t tree.nwk

**NOTE:** Users can specify base frequencies with `+F{...}`. Without this, AliSim randomly generates the state frequencies from empirical distributions (See [Specifying model parameters](#specifying-model-parameters)). 


Rate heterogeneity across sites
-------------------------------

AliSim supports all common rate heterogeneity across sites models, such as allowing for a proportion of invariable sites, continuous/discrete [Gamma distribution](https://doi.org/10.1007/BF00160154) rates, Distribution-free ([Yang, 1995](http://www.genetics.org/content/139/2/993.abstract); [Soubrier et al., 2012](https://doi.org/10.1093/molbev/mss140)) rates, for example:

To simulate an alignment with a proportion of invariable sites, users can use `+I{<invar_proportion>}` as follows.

     iqtree3 --alisim alignment_I -t tree.nwk -m "JC+I{0.2}"

This simulates a new alignment under the [Jukes-Cantor model](http://doi.org/10.1016/B978-1-4832-3211-9.50009-7) with 20% of sites being invariant.

To simulate a new alignment with rate heterogeneity across sites under continuous Gamma distribution, users can specify `+GC{<shape>}` where `<shape>` is the Gamma shape parameter  like the following example.

     iqtree3 --alisim alignment_GC -t tree.nwk -m "JC+GC{0.5}"
     
Similarly, to apply a discrete Gamma distribution for rate heterogeneity across sites, users can employ `+Gk{<shape>}` where `k` is the number of rate categories, for example:

     iqtree3 --alisim alignment_G4 -t tree.nwk -m "JC+G4{0.5}"
  
This simulates a new alignment with 4 discrete rates based on a Gamma distribution with a Gamma shape of 0.5.    

Users can specify the Free-rate model for rate heterogeneity via `+Rk{w1/r1/.../wk/rk}` where `k` is the number of rate categories, `w1, ..., wk` are the weights, and `r1, ..., rk` the rates for each category, for example:

     iqtree3 --alisim alignment_R3 -t tree.nwk -m "JC+R3{0.5,1.5,0.2,0.7,0.3,2.0}"

This specifies three rates of 1.5, 0.7, and 2.0 with the weights of 0.5, 0.2, and 0.3, respectively, for rate heterogeneity.
     
Note that users can combine the Gamma or Free-rate distribution with the proportion of invariant sites, for example:

     iqtree3 --alisim alignment_G4 -t tree.nwk -m "JC+G4{0.5}+I{0.2}"

to simulate a new alignment with 20% sites are constant while the other sites evolve under 4 discrete Gamma rates (with a Gamma shape of 0.5).

Customizing output alignments
-----------------------------

AliSim provides a number of options to customize the output such as setting the alignment format, length, compression, and simulating more than one alignment.

Users can use `--length` option to change the length of the root sequence:

    iqtree3 --alisim alignment_5000 -m "JC" -t tree.nwk --length 5000

will simulate an alignment with 5000 sites. Users could also output the alignment in FASTA format with `--out-format` option:

    iqtree3 --alisim alignment -m "JC" -t tree.nwk --out-format fasta
    
will print the alignment to `alignment.fa` file.

To generate multiple alignments, users could use `--num-alignments` option:    

    iqtree3 --alisim alignment -m "JC" -t tree.nwk --num-alignments 3

This will output three alignments into `alignment_1.phy`, `alignment_2.phy`, and `alignment_3.phy`, respectively. 

If users want to compress the output file, they could try `-gz` option:

    iqtree3 --alisim alignment -m "JC" -t tree.nwk -gz

This will compress the output file, but it could take a longer running time.

Insertion and deletion models
------------------------------
    
AliSim can also simulate insertions and deletions, for example:

    iqtree3 --alisim alignment_indel -m "JC" -t tree.nwk --indel 0.03,0.1
    
`--indel` option specifies the insertion and deletion rates (separated by a comma) relative to the substitution rates. Here, it means that, on average, we have 3 insertion and 10 deletion events per every 100 substitution events. Apart from the normal output file `alignment_indel.phy`, AliSim also exports an additional file `alignment_indel_withoutgaps.fa` containing sequences without gaps. If not needing the additional output file, one could disable that feature by `--no-export-sequence-wo-gaps`. By default, AliSim assumes that the size of indels follows a Zipfian distribution (as defined in [INDELible](https://doi.org/10.1093/molbev/msp098)) with an empirical exponent of 1.7 and a maximum indel sizes of 100 . If wanting to change this distribution, one can use `--indel-size` option:

    iqtree3 --alisim alignment_indel_size -m "JC" -t tree.nwk --indel 0.1,0.05 --indel-size "GEO{5},GEO{4}"

It means that the insertion size follows a Geometric distribution with mean of 5 and variance of 20, whereas deletion size also follows the Geometric distribution but with mean of 4 and variance of 12. *Note that the variance is computed from mean*. Apart from this distribution, AliSim also supports [Negative Binomial distribution, Zipfian distribution, and Lavalette distribution](https://doi.org/10.1093/molbev/msp098) as following examples:

    iqtree3 --alisim alignment_indel_size -m "JC" -t tree.nwk --indel 0.1,0.05 --indel-size "NB{5/20},POW{1.5/10}"

To specify a Negative Binomial distribution (with mean of 5 and variance of 20) and a Zipfian distribution (with exponent `a` of 1.5 and `max` of 10) for the insertion size, and deletion size, respectively. Or to specify Lavalette distribution (with parameter `a` of 1.5 and `max` of 10) for both insertion and deletion size, users could use:

    iqtree3 --alisim alignment_indel_size -m "JC" -t tree.nwk --indel 0.1,0.05 --indel-size "LAV{1.5/10},LAV{1.5/10}"

NOTE: When using `--length` option with indel models, the output
alignment can be longer due to gaps inserted into the root sequence.

Specifying model parameters
---------------------------

Apart from the simple Juke-Cantor models with no parameters, AliSim also supports all other more complex models available in IQ-TREE. For example:

     iqtree3 --alisim alignment_HKY -t tree.nwk -m "HKY{2.0}+F{0.2/0.3/0.1/0.4}"

This simulates a new alignment under the [HKY model](https://dx.doi.org/10.1007%2FBF02101694) with a transition/transversion ratio of 2 and nucleotide frequencies of 0.2, 0.3, 0.1, 0.4 for A, C, G, T, respectively.

By default, if nucleotide frequencies are neither specified nor possible to be inferred from a user-provided alignment, AliSim will randomly generate these frequencies from empirical distributions as the following example. 

     iqtree3 --alisim alignment_HKY -t tree.nwk -m "HKY{2.0}"

In this case, AliSim would simulate an alignment from the HKY model. The frequencies of base A, C, G, and T, will be randomly generated from empirical distributions, namely, Generalized-logistic, Exponential-normal, Power-log-normal, Exponential-Weibull. These distributions and their parameters were estimated from a large collection of empirical datasets ([Naser-Khdour et al. 2021](https://doi.org/10.1101/2021.09.22.461455)). 

Besides, AliSim allows users to simulate alignnments with DNA error model by adding `+E{<Error_Probability>}` into the `<model>` when specifying the model with `-m <model>`. For example:

     iqtree3 --alisim alignment_HKY_error -t tree.nwk -m "HKY{2.0}+F{0.2/0.3/0.1/0.4}+E{0.01}"
   
This simulates a new alignment under the HKY model as the above example, but with a sequencing error probability of 0.01. That means the nucleotide of 1% sites of the simulated sequences is randomly changed to another nucleotide. 



### Using user-defined parameter distributions
    
In addition to five built-in distributions, namely *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*, users could define their own lists of numbers, then generate other model parameters from these lists by following these steps. Note that user-defined lists of numbers could be generated from different distributions.

Firstly, generating a set of random numbers for each list, then defining the new lists in a new file (e.g.,`custom_distributions.txt`) as the following example.


    
    F_A 0.363799 0.313203 0.277533 0.24235 0.260252
    F_B 0.321134 0.299891 0.315519 0.269172 0.258165 
    F_C 0.287641 0.309442 0.264017 0.23103
    F_D 0.200087 0.336534 0.337547 0.325379 0.335034 
    F_E 0.306336 0.359459 0.249315 0.388073 
    F_F 0.345694 0.338733 0.305404 0.294181 
    I_A 0.257679 0.417313 0.290922 0.301826 0.292324 0.33887
    I_B 0.179902 0.122071 0.348381 0.33887 0.228999
    I_C 0.377297 0.296036 0.044523 0.262098 0.295087
    R_A 10.363799 20.313203 10.277533 5.24235 3.26025
    R_B 6.321134 0.299891 10.315519 0.269172 04.258165
    R_C 10.287641 8.309442 20.264017 03.23103 04.178778
    R_D 9.200087 10.336534 30.337547 03.325379 0.335034
    R_E 2.306336 4.359459 0.249315 0.388073 04.296979
    R_F 4.345694 06.338733 02.305404 02.294181 04.303477
    R_G 3.257679 07.417313 03.290922 04.301826 03.292324
    N_A -0.363799 -0.313203 -0.277533 0.24235 -0.260252
    N_B 0.321134 -0.299891 -01.315519 -0.269172 -0.258165
    N_C 0.287641 -0.309442 0.264017 -0.23103 0.178778



Each list should be defined in a single line, starting with the list name, followed by random numbers. These numbers should be separated by space. The given file `custom_distributions.txt` defines 8 new lists. Each list could have a different number of random elements.

Secondly, loading these lists and generating a new alignment with random parameters with

     iqtree3 --alisim alignment_GTR_custom -t tree.nwk -m "GTR{1.5/R_A/R_B/0.5/R_C}+F{Generalized_logistic/0.3/F_A/0.2}+I{F_D}+G{F_C}" --distribution custom_distributions.txt

In this example, 3 substitution rates of GTR models are randomly drawn from the `R_A,R_B,R_C` lists while the user specifies other rates. Similarly, the frequencies of base A and G are generated from `Generalized_logistic` distribution and the list `F_A` whereas the relative frequencies of base C and T are 0.3 and 0.2. These state frequencies are automatically normalized so that they sum to 1. Furthermore, the Invariant Proportion and the Gamma Shape are drawn from the appropriate lists named `F_D`, and `F_C`, respectively. 

Users can also use user-defined lists to randomly generate other parameters (e.g., substitution rates, state frequencies, nonsynonymous/synonymous rate ratio, transition rate, transversion rate, category weight/proportion) for other kinds of models/data (e.g., Protein, Codon, Binary, Morph, Lie Markov, Heterotachy, and Mixture). 

Mimicking a real alignment
--------------------------
<div class="hline"></div>

AliSim allows users to simulate alignments that mimic the evolutionary history of a given alignment as the below example:
        
      iqtree3 --alisim alignment_mimic -s example.phy 

* `-s example.phy` is the option to supply the input alignment. 

In this example, AliSim internally runs IQ-TREE to infer a phylogenetic tree and the best-fit substitution model (using [ModelFinder](https://doi.org/10.1038/nmeth.4285)) with its parameters from the input alignment `example.phy`. After that, AliSim simulates a new alignment with the same length as the original alignment based on the inferred tree and model and copies the gaps from the input alignment `example.phy` to the output alignment `alignment_mimic.phy`. To disable this feature, use `--no-copy-gaps` option.

Additionally, for simulations under a mixture models and/or discrete rate heterogeneity (under [Gamma](https://doi.org/10.1007/BF00160154)/[Free-rate](http://www.genetics.org/content/139/2/993.abstract) distributions), e.g.

      iqtree3 --alisim alignment_mimic -s example.phy -m "MIX{GTR{2/3/4/5/6}+F{0.2/0.3/0.4/0.1},HKY{2}+F{0.3/0.2/0.1/0.4},JC}+G{0.5}"

The above mixture consists of three model components. AliSim randomly assigns a model component of the mixture to each site according to the site posterior probability distribution of the mixture. For site-frequency mixture models, AliSim assigns site frequency as the mean frequency of the posterior distribution ([Wang et al. 2018](https://doi.org/10.1093/sysbio/syx068)) (default). Or the user can use `--site-freq SAMPLING` to sample site-frequencies from the posterior probability distribution of the mixture, or use `--site-freq MODEL` to employ the frequencies specified for each model component.

Similarly, for discrete rate heterogeneity (based on Gamma/Free-rate distributions), AliSim assigns site rate as the mean rate of the posterior distribution (by default). Or  the user can use `--site-rate SAMPLING` to sample site-specific rate from the posterior probability distribution of rate categories, or `--site-rate MODEL` to sample site-specific rate from the weight (prior distribution) of rate categories.

NOTE: 

* When mimicking an alignment and specifying `--length` option without an [insertion-deletion model](#insertion-and-deletion-models), the output alignment might be shorter or longer than the original alignment. If shorter, AliSim will copy the gap patterns from the original alignment from site 1 to the last site index in the output alignment. If longer, AliSim can only copy gaps from site 1 to the last site of the original alignment. All remaining sites until the end of the output alignment won't contain any gaps.

* When mimicking an alignment with an [insertion-deletion model](#insertion-and-deletion-models), AliSim will set the root sequence length to the original alignment length if `--length` is not specified (otherwise it is equal to `--length` option). Moreover, AliSim will ignore the gaps from the original alignment and generate gaps according to the indel model.

Simulating along a random tree
------------------
<div class="hline"></div>

AliSim can simulate alignments along a random tree under biologically plausible processes such as Yule-Harding, and Birth-Death with the option `-t RANDOM{<MODEL>/<NUM_TAXA>}` as the following example:

    # simulate 1000-taxon alignment under Yule-Harding random tree model 
    iqtree3 --alisim alignment_yh -t "RANDOM{yh/1000}"
    
    # simulate 1000-taxon alignment under Birth-Death model with birth rate of 0.1 and death rate of 0.05
    iqtree3 --alisim alignment_bd -t "RANDOM{bd{0.1/0.05}/1000}"
    

* `-t RANDOM{yh/1000}` tells AliSim to generate a random tree with 1000 taxa under the Yule-Harding model, with branch lengths following a exponential distribution with a mean of 0.1.
* `-t RANDOM{bd{0.1/0.05}/1000}`: tells AliSim to generate a random tree with 1000 taxa under the Birth-Death model (with birth rate of 0.1 and death rate of 0.05), with branch lengths following a exponential distribution with a mean of 0.1.

For other model, uses can specify `u`, `cat`, or `bal` for Uniform, Caterpillar, or Balanced model, respectively).

`<NUM_TAXA>` can be a fixed number, or a list `{<NUM_1>/<NUM_2>/.../<NUM_N>}`, or a Uniform distribution `U{<LOWER_BOUND>/<UPPER_BOUND>}` where the number of taxa is randomly generated from the given list or distribution.

In the above examples, AliSim generates `alignment_yh.phy` or `alignment_bd.phy` under the Jukes-Cantor DNA model. If you want to change the model, use -m option as [described above](#specifying-model-parameters).


For the distribution of branch lengths, users could adjust the minimum, mean and maximum of the exponential distribution via the option `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`.

Furthermore, users can also randomly generate branch lengths of the phylogenetic tree from a user-defined list (or a built-in distribution, such as *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*) with `--branch-distribution` option:

    iqtree3 --alisim alignment_yh_custom_branch -t "RANDOM{yh/1000}" --branch-distribution F_A --distribution custom_distributions.txt

In this example, the branch lengths of the random tree are randomly drawn from the user-defined list `F_A`. Besides, if the user supplies a tree file (instead of a random tree), the branch lengths of the user-provided tree will be overridden by the random lengths from the list `F_A`.

Branch-specific models
----------------------------

AliSim supports branch-specific models, which assign different evolutionary models to individual branches of a tree.

To use branch-specific models, users should specify the models for individual branches with the syntax `[&model=<model>]` in the input tree file, say for example, `input_tree.nwk`:

	(A:0.1,(B:0.1,C:0.2[&model=HKY]),(D:0.3,E:0.1[&model=GTR{0.5/1.7/3.4/2.3/1.9}+F{0.2/0.3/0.4/0.1}+I{0.2}+G{0.5}]):0.2);

Then, simulate an alignment by

      iqtree3 --alisim alignment_example_1 -t input_tree.nwk -m "JC"
    
Here, AliSim uses the [Juke-Cantor model](http://doi.org/10.1016/B978-1-4832-3211-9.50009-7) to simulate an alignment along the input tree. However, the `HKY` with random parameters is used to simulate the sequence of taxon C. Similarly, the `GTR` model with the specified parameters is used to generate the sequence of taxon E.

**NOTE:** 

- A branch-specific model is only applied to a specific branch, meaning that it will not be inherited by descendant branches. To apply a new model to an entire subtree, one needs to specify that branch-specific model at all descendant branches. 
- If rate heterogeneity models are specified for multiple branches, they operate independently. For example, specifying `+G{0.5}` on two branches results in separate, independent rate-to-site assignments for those branches.
  
To mimic heterotachy (rate heterogeneity across branches), users can supply a set of branch-lengths containing `n` lengths corresponding to the `n` categories of the model via `lengths=<length_1>,...,<length_n>`, for example:

	(A:0.1,(B:0.1,C:0.2[&model=HKY{2.0}*H4,lengths=0.1/0.2/0.15/0.3]),(D:0.3,E:0.1):0.2);

Then, simulate an alignment by

      iqtree3 --alisim alignment_example_2 -t input_tree.nwk -m "JC"
    
Here, AliSim simulates a new alignment using the Juke-Cantor model. However, at the branch connecting taxon C to its ancestral node, the [GHOST model](https://doi.org/10.1093/sysbio/syz051) with 4 categories is used with 4 branch lengths 0.1, 0.2, 0.15, and 0.3 to generate the sequence of taxon C.

Additionally, in a rooted tree, users may want to generate the root sequence with particular state frequencies and then simulate new sequences from that root sequence based on a specific model. To do so, one should supply a rooted tree, then specify a model and state frequencies  (with `[&model=<model>,freqs=<freq_0,...,<freq_n>]`) for example:

	(A:0.1,(B:0.1,C:0.2),(D:0.3,E:0.1):0.2):0.3[&model=GTR,freqs=0.2/0.3/0.1/0.4];

Then, simulate an alignment by

      iqtree3 --alisim alignment_example_3 -t input_tree.nwk -m "JC"
    
Here, AliSim first generates a random sequence at the root based on the user-specified frequencies (`0.2, 0.3, 0.1, 0.4` for A, C, G, T, respectively). Then, it uses the `GTR` model with random parameters to simulate a sequence for the child node of the root. For the remaining branches AliSim applies the Juke-Cantor model.

Partition models
----------------

AliSim allows users to simulate a multi-locus alignment using a partition model specified in a NEXUS file as described in
the [partition model tutorial](Complex-Models#partition-models). An example partition file may look like:

    #nexus
	begin sets;
	    charset gene_1 = DNA, 1-846;
	    charset gene_2 = DNA, 847-1368;
	    charset gene_3 = DNA, 1369-2040;
	    charset gene_4 = DNA, 2041-2772;
	    charset gene_5 = DNA, 2773-3738;
	    charpartition mine = HKY{2}+F{0.2/0.3/0.1/0.4}:gene_1, 
	        GTR{1.2/0.8/0.5/1.7/1.5}+F{0.1/0.2/0.3/0.4}+G{0.5}:gene_2, 
	        JC:gene_3, 
	        HKY{1.5}+I{0.2}:gene_4, 
	        K80{2.5}:gene_5;
	end;

This means that we define an alignment with 5 genes (partitions). The gene positions are described in `charset` command 
and the models for each gene are specified in `charpartition` command. Moreover, we use the [HKY model](https://dx.doi.org/10.1007%2FBF02101694) for gene_1 with
transition-transversion ratio of 2 and nucleotide frequencies of 0.2, 0.3, 0.1, 0.4 for A, C, G and T, respectively.
See also the [custom model section](#specifying-model-parameters) for how to specify model parameters.

Assuming we name this partition file `multi_genes.nex`. Then, you can simulate an alignment consisting of these five genes by

	iqtree3 --alisim partition_multi_genes  -q multi_genes.nex -t tree.nwk

That simulation outputs the new alignment into a single file named `partition_multi_genes.phy`.

In the following we will describe scenarios for more complex partition models.

### Edge-proportional partition model

The above example simulates a concatenated alignment under edge-equal partition model, i.e., all partitions share the same tree with the same branch lengths. This is not realistic as different genes might have different evolutionary rates. Therefore, users can specify gene-specific tree lengths directly in the `charpartition` command as follows:

    #nexus
	begin sets;
	    charset gene_1 = DNA, 1-846;
	    charset gene_2 = DNA, 847-1368;
	    charset gene_3 = DNA, 1369-2040;
	    charset gene_4 = DNA, 2041-2772;
	    charset gene_5 = DNA, 2773-3738;
	    charpartition mine = HKY{2}+F{0.2/0.3/0.1/0.4}:gene_1{0.26019}, 
	        GTR{1.2/0.8/0.5/1.7/1.5}+F{0.1/0.2/0.3/0.4}+G{0.5}:gene_2{1.51542}, 
	        JC:gene_3{1.03066}, 
	        HKY{1.5}+I{0.2}:gene_4{0.489315}, 
	        K80{2.5}:gene_5{0.680204};
	end;

Meaning that gene_1 will rescale the branch lengths such that the total tree length becomes 0.26019. Note that `<tree_length>` of a partition is equal to the length of the input tree times the `partition_rate` of that partition. For example, assuming the length of the input tree `tree.nwk` is 0.8673, then the rate of gene_1 is 0.26019/0.8673 = 0.3.

After changing the `multi_genes.nex` file, one could start the simulation by:

    iqtree3 --alisim partition -p multi_genes.nex -t tree.nwk

Note that we use `-p` option here instead of `-q` option like above. If users still used `-q` option, the partition-specific rates will be ignored, i.e., AliSim will use edge-equal partition model.


### Topology-unlinked partition model

AliSim supports topology-unlinked partition models, which allow each partition to have its own tree topology and branch lengths.
The partition trees can have non-overlapping taxon sets. To do so, users need to prepare a tree file containing multiple NEWICK strings, one for each partition, for example:

	(A:0.1,(B:0.26,C:0.15):0.1,D:0.05);
	(A:0.2,B:0.1,C:0.3);
	(A:0.05,B:0.03,(C:0.21,D:0.22):0.21);
	((A:0.24,B:0.14):0.19,C:0.07,D:0.1);
	((A:0.1,C:0.1):0.04,B:0.4,D:0.5);

Note that the 2nd tree does not contain all taxa.

Assuming that this file is named `multi_trees.nwk`, you can simulate an alignment consisting of these five genes from multiple gene trees by

	iqtree3 --alisim multi_alignment  -Q multi_genes.nex -t multi_trees.nwk

That simulation outputs the new alignment containing all four taxa A, B, C, D into a single file named `multi_alignment.phy`.
AliSim will add a stretch of gaps corresponding to the missing taxon D in partition `gene_2`.

**NOTE**: We use `-Q` option here to specify topology-unlinked model. If users specify `-q` option, the behaviour will be completely different: AliSim will only load the first tree in `multi_trees.nwk` and simulate an alignment under this one tree.

### Mixing different datatypes

AliSim allows users to simulate mixed data  (e.g., DNA, Protein, and MORPH) in a single simulation, in which each kind of data is exported into a different alignment file. Here is an example for mixing DNA, protein, and morphological data. Firstly, users need to specify partitions in an input partition file as following.

    #nexus
	begin sets;
	    charset part1 = DNA, 1-200\2 201-300;
	    charset part2 = DNA, 2-200\2;
	    charset part3 = MORPH{6}, 1-300;
	    charset part4 = AA, 1-200;
	    charset part5 = MORPH{30}, 1-200\2;
	    charset part6 = MORPH{30}, 2-200\2;
	    charset part7 = DNA, 301-500;
	    charpartition mine = HKY{2.0}:part1, JC+G{0.5}:part2, MK:part3, Dayhoff:part4, MK:part5, ORDERED:part6, F81+F{0.1/0.2/0.3/0.4}:part7;
	end;

Here,  `part1`,  `part2`, and `part7` contain three DNA sub-alignments, whereas `part3`,  `part5`, and `part6` contain sub-alignments for morphological data. Besides, `part4` contains an amino-acid alignment with 200 sites. 

Assuming that the above partition file is named `example_mix.nex` and one would like to simulate alignments from a single tree in `tree.nwk`, one could start the simulation with the following command:

    iqtree3 --alisim partition_mix -q example_mix.nex -t tree.nwk

At the end of the run, AliSim writes out the simulated alignments into four output files. The first file named `partition_mix_DNA.phy` stores the merged 400-site DNA alignment from `part1`, `part2`, and `part7`. Although `part3`, `part5`, and `part6` contain morphological data, `part3` simulates a morphological alignment with 6 states while `part5` and `part6` have 30 states. Thus, AliSim outputs the alignment of `part3` into `partition_mix_MORPH6.phy`, whereas `partition_mix_MORPH30.phy` stores the  alignment merging `part5` and `part6`. Lastly, `partition_mix_AA.phy` stores the simulated amino-acid alignment of `part4`.


Mixture models
--------------

AliSim allows users to simulate alignments under [protein mixture models](Substitution-Models#protein-mixture-models) for example:

    iqtree3 --alisim alignment_mix_C10 -m "C10" -t tree.nwk

to simulate a new alignment under the [C10 mixture model](Complex-Models#mixture-models).

Besides, users can simulate alignments from user-defined mixture model via `MIX{<model_1>,...,<model_n>}` as described in [Mixture models](Complex-Models#mixture-models). The following example simulates an alignment under a mixture model contains 2 model components (JC, and HKY) with rate heterogeneity across sites based on discrete Gamma distribution.

    iqtree3 --alisim alignment_mix_JC_HKY_G -m "MIX{JC,HKY{2.0}+F{0.2/0.4/0.1/0.3}}+G4" -t tree.nwk

To simulate alignments with more complex mixture models, users can define a new mixture via a model definition file and supply it to AliSim via `-mdef <model_file>`. For more detail about how to define a mixture model, please have a look at [Profile Mixture Models](Complex-Models#profile-mixture-models).


Heterotachy GHOST model
----------------------------

If one wants to simulate sequences based on a [GHOST model](https://doi.org/10.1093/sysbio/syz051) with 4 categories in conjunction with the `GTR` model of DNA evolution, one should first specify a multi-length tree as follows.

    (A[0.067/0.151/0.562/1.269],(B[0.001/0.078/0.319/1.724],C[0.076/0.101/0.002/1.061])[0.043/0.086/0.003/0.002],D[0.002/0.136/0.002/0.001]);

In the above file, each branch should have 4 lengths (corresponding to 4 categories of the GHOST model), which are specified in a pair of square brackets `[...]`, and separated by a slash `/`. 

Assuming that the above tree file is named `ghost_tree.nwk`,  one can simulate an alignment under GHOST model with:

    iqtree3 --alisim alignment_ghost -m "GTR{2/3/4/5/6}+F{0.2/0.3/0.1/0.4}+H4{0.15/0.2/0.35/0.3}" -t ghost_tree.nwk

Here, AliSim applies the GHOST model with the weights of 0.15, 0.2, 0.35, 0.3 for the four categories, respectively. If the weights are ignored, AliSim will assume uniform weight distribution.

If you want to unlink GTR parameters so that AliSim could use a GTR model (with specific substitution rates) for each category, you can use `MIX{...}*H4` and specify the model parameters for each categories inside `MIX{...}` as follow: 

    iqtree3 --alisim alignment_ghost_unlink -m "MIX{GTR{2/3/4/5/6},GTR{3/4/5/6/7},GTR{4/5/6/7/8},GTR{5/6/7/8/9}}+F{0.2/0.3/0.1/0.4}*H4{0.15/0.2/0.35/0.3}" -t ghost_tree.nwk

You can also specify a different set of state frequencies for each model component as follow:  

    iqtree3 --alisim alignment_ghost_unlink_freqs -m "MIX{GTR{2/3/4/5/6}+F{0.2/0.3/0.4/0.1},GTR{3/4/5/6/7}+F{0.3/0.2/0.4/0.1},GTR{4/5/6/7/8}+F{0.4/0.2/0.3/0.1},GTR{5/6/7/8/9}+F{0.1/0.2/0.4/0.3}}*H4{0.15/0.2/0.35/0.3}" -t ghost_tree.nwk

Besides, assuming that we have an input alignment `example.phy` evolving under the GHOST model with 4 categories in conjunction with the `GTR` model. If one wants to simulate an alignment that mimics that input alignment, one should use the following command:

    iqtree3 --alisim alignment_ghost_mimick -m "GTR+H4" -s example.phy
	
or using 	`GTR*H4` instead of `GTR+H4`, if you want to unlink GTR parameters:
	
    iqtree3 --alisim alignment_ghost_unlink_mimick -m "GTR*H4" -s example.phy

or using 	`GTR+FO*H4` to unlink GTR parameters and state frequencies:
	
    iqtree3 --alisim alignment_ghost_unlink_freqs_mimick -m "GTR+FO*H4" -s example.phy


Functional divergence model
----------------------------

AliSim supports the [FunDi model](https://doi.org/10.1093/bioinformatics/btr470), which allows a proportion number of sites (`<RHO>`) in the sequence of each taxon in a given list (`<TAXON_1>,...,<TAXON_N>`), could be permuted with each other. To simulate new alignments under the FunDi model, one could use `--fundi` option:

    iqtree3 --alisim alignment_fundi -t tree.nwk -m "JC" --fundi A,C,0.1

This example simulates a new alignment under the Juke-Cantor model from the input tree `tree.nwk` with the default sequence length of 1,000 sites. Since the user specifies FunDi model with `<RHO>` = 0.1, thus, in the sequences of Taxon A, and C, 100 random sites (sequence length * `<RHO>` = 1,000 * 0.1) are permuted with each other.

Pre-define mutations
----------------------------

Starting from IQ-TREE v2.2.3, AliSim allows users to enfore pre-defined mutations that must occur at some specific nodes of the tree. Those mutations could be, for example, generated by running [VGsim](https://github.com/genomics-HSE/vgsim) with the option `-writeMutations`.


Given a tree file `tree_example.nwk`
     
    (T1:0.2,(T2:0.3,T4:0.1)Node5:0.4,T3:0.1);

and a mutations file `mutations.txt` like below:

    Node5	C39G,T17A,G25C
    T2		C25A,A5G

Each line starts with a taxon name or an internal node name, followed by whitespace(s), and a comma-separated list of mutations. Each mutation is denoted
by a character state at the parent node, followed by a position number 
**starting from index 0** and
the character state to be fixed at the current node. For the above example,

* AliSim will enforce the 40th, 18th, and 26th positions of
the sequence at internal node `Node5` to be `G`, `A` and `C`.
* The 26th and 6th positions of
the sequence at the taxon `T2` to be `A` and `G`, respectively.

> NOTE: Site index starts from 0 to make AliSim compatible with VGsim output). If you want to start from 1, use the option `--index-from-one`.


The following command
    
    iqtree3 --alisim example_mutations  -t tree_example.nwk -m "JC" --mutation mutations.txt
    
 will simulate an alignment with 4 sequences (i.e., T1, T2, T3, and T4) under the [Jukes-Cantor model](http://doi.org/10.1016/B978-1-4832-3211-9.50009-7) 
 and the above mutation rule.


Parallel sequence simulations
----------------------------
AliSim supports simulating many large alignments in parallel with OpenMP and/or MPI. To simulate large alignment(s) with OpenMP, one can use `-nt` option to specify the number of threads:

    iqtree3 --alisim large_alignment -t tree.nwk --length 1000000 -m "JC" -nt 4
      
This example simulates a new alignment under the Juke-Cantor model from the input tree `tree.nwk` with the sequence length of 1,000,0000 sites using 4 threads. For multithreading simulations, AliSim supports two algorithms AliSim-OpenMP-IM (default) and AliSim-OpenMP-EM (please see [AliSim-HPC](#)). Users can specify `--openmp-alg EM` if they want to employ the AliSim-OpenMP-EM algorithm.

**NOTES**: 

- The performance of AliSim-OpenMP-IM is affected by a memory limit factor (=0.2 (by default) and can be set in the range (0 to 1]): a small factor will potentially increase the runtime; a large factor will increase the memory consumption. To specify this memory limit factor, one can use `--mem-limit <FACTOR>` option.
- If using AliSim-OpenMP-EM algorithm, the simulated sequences will be written in an arbitrary order to the alignment (which is not a matter in most phylogenetic software). However, if users want to maintain the sequence order (based on the preorder traversal of the tree), they can use `--keep-seq-order` option, but it will sacrifice a certain runtime.
- If using AliSim-OpenMP-EM algorithm, one can use `--no-merge` to skip the concatenation step to save the runtime. Note that, when simulating an alignment of length L with K threads, AliSim will output the alignment as K sub-alignment files of L/K sites. 

To simulate many alignments, one can use the MPI version of AliSim:

    mpirun -np 10 iqtree3-mpi --alisim many_alignment -t tree.nwk -m "JC" --num-alignments 100
    
This example uses 10 MPI processes to simulate 100 alignments under the Juke-Cantor model from the input tree `tree.nwk` with the default sequence length of 1,000 sites. Note that AliSim-MPI version can run on a distributed-memory system with many nodes and multiple CPUs per node. To maximize the parallel efficiency, we recommend users specify the number of processes as a divisor of the number of alignments.

To simulate many large alignments, users can employ both MPI and OpenMP on a high-performance computing system:

    mpirun -np 10 --map-by node:PE=4 --rank-by core iqtree3-mpi --alisim many_large_alignment -t tree.nwk --length 1000000 -m "JC" --num-alignments 100 -nt 4
   
This example uses 10 MPI processes, each having 4 threads (i.e. a total of 40 threads will be run) to simulate 100 large alignments under the Juke-Cantor model from the input tree `tree.nwk` with the sequence length of 1,000,000 sites. 

**NOTES**: Our MPI implementation supports Indels as the original version of AliSim, while the OpenMP algorithm does not. Therefore, one can employ only MPI to simulate many alignments with Indels.  

All AliSim options
------------------

All the options available in AliSim are shown below:

| Option | Usage and meaning |
|--------------|------------------------------------------------------------------------------|
|`--alisim <OUTPUT_ALIGNMENT>`| Activate AliSim and specify the output alignment filename. |
| `-t <TREE_FILE>`   | Set the input tree file name. |
| `--seqtype <SEQUENCE_TYPE>`  | Specify the sequence type (BIN, DNA, AA, CODON, MORPH{`NUMBER_STATES`}, where `NUMBER_STATES` is the number of states for morphological model). <br>*By default, Alisim automatically detects the sequence type from the model name*. |
| `-m <MODEL>`   | Specify the model name. See [Substitution Models](Substitution-Models) and [Complex Models](Complex-Models) for the list of supported models.|
| `-mdef <MODEL_FILE>`  | Name of a NEXUS model file to [define new models](Complex-models#nexus-model-file), which can be used with `-m` option. |
| `--fundi <TAXON_1>,...,<TAXON_N>,<RHO>`   | Specify the FunDi model ([Gaston et al. 2011]). The last number `RHO` in this list is the proportion of sites, that will be randomly permuted in the sequences of the given taxa. The same permutation is applied to the sequences. |
| `--indel <INS>,<DEL>`  | Set the insertion and deletion rate of the indel model, relative to the substitution rate. |
| `--indel-size <INS_DIS>,<DEL_DIS>`  | Set the [insertion and deletion size distributions](#insertion-and-deletion-models). By default, AliSim uses `POW{1.7/100}` for a power-law (Zipfian) distribution with parameter `a` of 1.7 and maximum indel size of 100.|
| `--no-unaligned` | Do not output a file of unaligned sequences when using indel models. Default: a file `.unaligned.fa` containing unaligned sequences is written. |
| `-q <PARTITION>` or <br>`-p <PARTITION>` or <br>`-Q <PARTITION>` | Specify different types of [Partition models](#partition-models), i.e., edge-equal (-q), edge-proportional (-p), edge-unlinked (-Q)|
| `--distribution <FILE>` | Supply a definition file of distributions, which could be used to generate random model parameters (see [Using user-defined parameter distributions](#using-user-defined-parameter-distributions)). |
| `--branch-distribution <DISTRIBUTION>` | Specify a distribution, from which branch lengths of the input trees are randomly generated and overridden.|
| `--branch-scale <SCALE>` | Specify a value to scale all branch lengths of the input tree.|
| `--length <LENGTH>` | Set the root sequence length.<br>*Default: 1,000* |
| `--num-alignments <NUMBER>` | Set the number of output datasets.<br>*Default: 1* |
| `--root-seq <ALN_FILE>,<SEQ_NAME>`   | Specify the root sequence from an alignment.<br>AliSim automatically sets the output sequence length (`--length`) equally to the length of the root sequence. |
|  `-t RANDOM{<MODEL>/<NUM_TAXA>}` | Specify the model and the number of taxa to generate a random tree (see [Simulating along a random tree](#simulating-along-a-random-tree)). |
|  `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`  | Specify three numbers: minimum, mean and maximum branch lengths when generating a random tree with `-t RANDOM{<MODEL>/<NUM_TAXA>}`. <br>*Default: -rlen 0.001 0.1 0.999.* |
| `-s <ALIGNMENT>` | Specify an input alignment file in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format.|
| `--no-copy-gaps` | Disable copying gaps from the input alignment.|
| `--site-freq <OPTION>` | Specify the option (`MEAN` *(default)*, or `SAMPLING`, or `MODEL`) to mimic the site-frequencies for mixture models from the input alignment (see [Mimicking a real alignment](#mimicking-a-real-alignment)). |
| `--site-rate <OPTION>` | Specify the option (`MEAN` *(default)*, or `SAMPLING`, or `MODEL`) to mimic the discrete rate heterogeneity from the input alignment (see [Mimicking a real alignment](#mimicking-a-real-alignment)).|
| `-nt <NUM_THREADS>` | Specify the number of threads for simulating large alignment(s) with OpenMP.|
| `--openmp-alg <ALG>` | Specify the multithreading algorithm (`IM` or `EM` for AliSim-OpenMP-IM or AliSim-OpenMP-EM, respectively).<br>*Default: IM*|
| `--mem-limit <FACTOR>` | Specify the memory limit factor for the AliSim-OpenMP-IM algorithm: 0 < `<FACTOR>` <=  1.<br>*Default: 0.2*|
| `--keep-seq-order` | Output the sequences (simulated by the AliSim-OpenMP-EM algorithm) following the visiting order of tips (based on the preorder traversal).|
| `--no-merge` | Skip the concatenation step in the AliSim-OpenMP-EM algorithm, output alignment in multiple sub-alignment files.|
| `--single-output` | Output all alignments into a single file. |
| `--write-all` | Enable outputting internal sequences. |
| `-seed <NUMBER>` | Specify the seed number. <br>*Default: the clock of the PC*. <br>Be careful! To make the AliSim reproducible, users should specify the seed number. |
| `-gz` | Enable output compression. It may take a longer running time.<br>*By default, output compression is disabled*. |
| `--out-format <FORMAT>` | Set the output format (`fasta`, `phy`, or `maple` for FASTA, PHYLIP, or [MAPLE](https://www.nature.com/articles/s41588-023-01368-0) format, respectively).<br>*Default: phy* |


[Gaston et al. 2011]: https://doi.org/10.1093/bioinformatics/btr470


