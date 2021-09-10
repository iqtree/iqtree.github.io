Introduction
============

Sequence simulations play an important role in phylogenetics. However, existing tools are either based on simplistic models of evolution or too slow to generate large datasets, or both. Therefore, we introduce AliSim, a new tool that can efficiently simulate realistic biological alignments under [complex evolutionary models](Complex-Models). AliSim takes only an hour and approximately 1GB RAM to generate alignments with millions of sequences or sites, while popular software Seq-Gen, Dawg, and Indelible require many hours and tens to hundreds GB of RAM. We provide AliSim as an extension of the IQ-TREE software version 2.2, freely available at www.iqtree.org. 


If you use AliSim in a publication please cite:

* __L.T. Nhan, B.Q. Minh__ (2021) AliSim: Ultrafast Sequence Alignment  Simulator, ... <https://doi.org/...>

In the following we provide a short tutorial how to use AliSim.


Simulating alignments from a tree and model
-------------------------------------------

Similar to other software, AliSim can simulate a multiple sequence alignment for a given tree with branch lengths and a model with:

    iqtree2 --alisim <OUTPUT_PREFIX> -m <MODEL> -t <TREEFILE>

The `-m` option is to specify a model name and `-t` option specifies a tree file in the standard [newick format](https://evolution.genetics.washington.edu/phylip/doc/main.html#treefile). This will print the output alignment into `OUTPUT_PREFIX.phy` file in Phylip format.

For example, if you want to simulate a DNA alignment under the [Jukes-Cantor model](LINK) for the following tree `tree.nwk`:

    (A:0.3544240993,(B:0.1905941554,C:0.1328977434):0.0998619427,D:0.0898418080);

You can run IQ-TREE with:

	program -i input -o output_file

    iqtree2 --alisim alignment -m JC -t tree.nwk

will print the simulated alignment to `alignment_0.phy`. 


The output MSA should contain 4 sequences of 1000 sites, each, for example:

    4 1000
    A       AAATTTGGTCCTGTGATTCAGCAGTGAT...
    B       CTTCCACACCCCAGGACTCAGCAGTGAT...
    C       CTACCACACCCCAGGACTCAGCAGTAAT...
    D       CTACCACACCCCAGGAAACAGCAGTGAT...


Importantly, we note that AliSim will use a random number seed corresponding to the current CPU clock of the running computer. In case you run two AliSim commands at the same time, it may generate two identical alignments, which may not be the desired outcome. In that case, you can use -seed option to specify the random number seed:

    iqtree2 --alisim alignment_123 -m JC -t tree.nwk -seed 123

`-seed` option has another advantage of reproducing an exact same alignment when IQ-TREE running again.

Customizing output alignments
-----------------------------

Users can use `--length` option to change the length of the output alignment, e.g.:

    iqtree2 --alisim alignment_5000 -m JC -t tree.nwk --length 5000

Users could also output the alignment in FASTA format with `-af` option:

    iqtree2 --alisim alignment -m JC -t tree.nwk -af fasta
    
will print the alignment to `alignment_0.fa` file.

Write abouit this option:    
    --num-alignments 3
    
    * `--num-alignments 3` is the option to specify the number of output MSAs is 3. 


Compressing -> gz option pls

Simulating insertions and deletions
-----------------------------------
    
Alisim can also simulate insertions and deletions, for example:

    iqtree2 --alisim alignment_indel -m JC -t tree.nwk --indel 0.1,0.05
    
`--indel` option specifies the insertion and deletion rates (separated by a comma) relative to the substitution rates. Here, it means that on average we have 10 insertion and 5 deletion events per every 100 substitution events. By default AliSim assumes that the size of indels follow a gemeometric distribution with mean of XXX and variance of +-YYY. If you want to change this distribution you can use `--indel-size` option:

    iqtree2 --alisim alignment_indel_size -m JC -t tree.nwk --indel 0.1,0.05 --indel-size GEO{5,3},GEO{4,2}

It means that the insertion size follows a geometric distribution with mean 5 and variance 3, whereas deletion size also follows the geometric distribution but with mean 4 and variance 2. Apart from this distribution, AliSim also supports negative binomial distribution, blabla. Give example running usage for all these distributions.

      

Simulating with custom models
-----------------------------

Apart from the simple Juke-Cantor models above AliSim also support all other more complex models available in IQ-TREE. For example:


     iqtree2 --alisim alignment_HKY -t tree.nwk -m HKY{2.0}+F{0.2/0.3/0.1/0.4}

simulate under [HKY model](...) with transition/transversion ratio of 2 and nucleotide frequences of 0.2, 0.3, 0.1, 0.4 for A, C, G, T, respectively.

AliSim also supports all [rate heterogeneity across sites](...) such as:

     iqtree2 --alisim alignment_HKY_G -t tree.nwk -m HKY{2.0}+F{0.2/0.3/0.1/0.4}+G{0.5}

By default, if nucleotide frequencies are neither specified nor possible to be inferred from a user-provided MSA, AliSim will randomly generate these frequencies from empirical distributions as the following example. 

     iqtree2 --alisim JC_1000 -t example.phy.treefile -m JC

    
In this case, AliSim would simulate an MSA based on the JC model. The frequencies of base A, C, G, and T, will be randomly generated from empirical distributions, namely, Generalized-logistic, Exponential-normal, Power-log-normal, Exponential-Weibull. In fact, these distributions and their parameters were estimated from a large collection of empirical datasets [REF](http://google.com). 
    
    
In addition to five built-in distributions, namely *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*, users could define their own lists of numbers, then generate other model parameters from these lists by following these steps. Note that user-defined lists of numbers could be generated from different distributions.

Firstly, generating a set of random numbers for each list, then defining the new lists in a file named `custom_distributions.txt` as the following example

    F_A 0.363799 0.313203 0.277533 0.242350 ...
    F_B 0.268955 0.278675 0.290531 0.237410 ...
    F_C 0.320556 0.440894 0.332368 0.227977 ...
    F_D 0.234732 0.309629 0.353117 0.414357 ...
    R_A 2.306336 4.359459 0.249315 0.388073 ...
    R_B 1.257679 0.417313 3.290922 2.301826 ...
    R_C 0.200087 1.336534 3.337547 2.325379 ...
    R_D 0.321134 0.299891 1.315519 0.269172 ...

Each list should be defined in a single line, starting with the list name, followed by random numbers. These numbers should be separated by space. The given file `custom_distributions.txt` defines 8 new lists. Each list could have a different number of random elements.

Secondly, loading these lists and generating MSA with random parameters with

     iqtree2 --alisim GTR_1000 -t example.phy.treefile -m GTR{1.5,R_A,R_B,0.5,R_C}+F{Generalized_logistic,0.3,F_A,0.2}+I{F_D}+G{F_C} --distribution custom_distributions.txt

In this example, 3 evolutionary rates of GTR models are randomly drawn from the lists `R_A,R_B,R_C` while other rates are specified by the user. Similarly, the frequencies of base A and G are generated from the lists `Generalized_logistic`, and `F_A` whereas the relative frequencies of base C and T are 0.3 and 0.2. These state frequencies are automatically normalized so that they sum to 1. Furthermore, the Invariant Proportion and the Gamma Shape would also be drawn from the appropriate lists named `F_D`, and `F_C`, respectively. 

This feature is not limited to DNA models, users could also use user-defined lists to randomly generate parameters (e.g., evolutionary rates, state frequencies, nonsynonymous/synonymous rate ratio, transition rate, transversion rate, category weight/proportion) for other kinds of models/data (e.g., Protein, Codon, Binary, Morph, Lie Markov, Heterotachy, and Mixture). 

    
Simulating alignments that mimic a real alignment
-------------------------------------
<div class="hline"></div>

AliSim allows users to simulate MSAs that mimic the evolutionary history of a given MSA as the below example:
        
      iqtree2 --alisim my_example -s example.phy 

* `-s example.phy` is the option to supply the input alignment. 

In this example, AliSim will first run IQ-TREE to a phylogenetic tree and the best-fit substitution model (using ModelFinder) with its parameters from the input alignment `example.phy`. After that, AliSim will generate an alignment based on the inferred tree and the best substitution model. Moreover, AliSim will copy the gap patterns from the input alignment `example.phy` to the output alignment `my_example_0.phy`. To disable this feature, users could add the option `--no-copy-gaps` to the command line.

Simulating alignments from a random tree
------------------
<div class="hline"></div>

AliSim supports users to produce alignments from a random tree generated by common models (such as Yule-Harding, Uniform, Birth-Death process). As an example:

     iqtree2 --alisim alignment_yh -t RANDOM{yh/1000}

* `-t RANDOM{yh,1000}` tells AliSim to generate a random tree with 1000 taxa under Yule-Harding model, with brach lengths following a exponential distribution with mean of 0.1.

Here AliSim generates `alignment_yh_0.phy` under Jukes-Cantor model. If you want to change the model, use -m option as [described above](SECTION)

For the distribution of branch lengths users could adjust the minimum, the maximum, and the mean of the exponential distribution via the option `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`.

Moreover, AliSim also supports user-defined distributions of branch lengths by specifying a file with a list of numbers in the following format:

--branch-distribution ...



Furthermore, users can also randomly generate branch lengths of the phylogenetic tree from a user-defined list with the option `--branch-distribution DISTRIBUTION_NAME` as below

    iqtree2 --alisim JC_1000 -t RANDOM{bd{0.8/0.2}/1000} -m JC --branch-distribution F_A --distribution custom_distributions.txt

In this example, AliSim simulates an MSA from the `JC` model and a random tree generated from the Birth-Death model with the birth rate, and death rate are 0.8, and 0.2, respectively. The branch lengths of the random tree are randomly drawn from the user-defined list `F_A`. In this example, if the user supplies a tree file (instead of a random tree), the branch lengths of the user-provided tree will be overridden by the random lengths from the list `F_A`.

Command reference
=================

All the options available in AliSim are shown below:

| Option | Usage and meaning |
|--------------|------------------------------------------------------------------------------|
|`--alisim <OUTPUT_FILENAME>`| Activate the simulator and specify the prefix for the output filename. |
| `-t <TREE_FILEPATH>`   | Set the path to the input tree. |
| `--seqtype <SEQUENCE_TYPE>`  | Specify the sequence type (BIN, DNA, AA, CODON, MORPH{`<NUMBER_STATES>`}) of the output *(optional)*. `<NUMBER_STATES>` is the number of states to simulate morphological data. <br>*By default, Alisim automatically detects the sequence_type from the model name*. |
| `-m <MODEL>`   | Specify the model name [and its parameters (optional)]. <br> See [Substitution Models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models) and [Complex Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models) for the list of supported models, how to use complex models (mixture, partition, rate heterogeneity across sites, heterotachy, Ascertainment Bias Correction, etc.), and syntax to specify model parameters (rates, base frequencies, omega, kappa, kappa2, etc.) or define new models.|
| `-mdef <MODEL_FILE>`  | Define new models by their parameters. |
| `--fundi <TAXON_1>,...,<TAXON_N>,<RHO>`   | Specifying parameters for the [FunDi model](https://doi.org/10.1093/bioinformatics/btr470), which allows a proportion number of sites (`<RHO>`) in the sequence of each taxon in the given list (`<TAXON_1>,...,<TAXON_N>`), could be permuted with each other. |
| `--indel <INS>,<DEL>`  | Activate Indels (insertion/deletion events) and specify the insertion/deletion rate relative to the substitution rate of 1. |
| `--indel-size <INS_DIS>,<DEL_DIS>`  | Specify the indel-size distributions. Notes: <INS_DIS>,<DEL_DIS> could be names of user-defined distributions, or NB{<int_r>,<double_q>}, POW{<double_a>[,<int_max>]}, LAV{<double_a>,<int_max>}, GEO{<double_p>}, which specifies Negative Binomial, Zipfian, Lavalette, and Geometric distribution, respectively. By default, the Geometric distribution with p of 0.5 is used.|
| `-q <PARTITION_FILE>` or <br>`-p <PARTITION_FILE>` or <br>`-Q <PARTITION_FILE>` | `-q <PARTITION_FILE>`: Edge-equal partition model with equal branch lengths: All partitions share the same set of branch lengths. <br>`-p <PARTITION_FILE>`: Edge-proportional partition model with proportional branch lengths: Like above, but each partition has its own partition specific rate, which rescales all its branch lengths. This model accommodates different evolutionary rates between partitions.<br>`-Q <PARTITION_FILE>`: Edge-unlinked partition model: Each partition has its own set of branch lengths. <br>`<PARTITION_FILE>` could be specified by a RAXML or NEXUS file as described in [https://github.com/iqtree/iqtree2/wiki/Complex-Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models)<br>These options could work well with the **Inference Mode**.<br>In cases **without the Inference Mode**, users must supply a tree-file (with a single tree) when using `-q` or `-p`. While using `-Q`, AliSim requires a multiple-tree file that specifies a supertree (combining all taxa in all partitions) in the first line. Following that, each tree for each partition should be specified in a single line one by one in the input multiple-tree file. Noting that each partition could have a different tree topology. |
| `--distribution FILE` | Supply the distribution definition file, which specifies multiple lists of numbers. These lists could be used to generate random parameters by specifying list names (instead of specific numbers) for model parameters. |
| `--branch-distribution DISTRIBUTION_NAME` |                  Specify a distribution, from which branch lengths of phylogenetic trees will be randomly generated.|
| `--only-unroot-tree` | Only unroot a rooted tree and terminate |
| `--length <SEQUENCE_LENGTH>` | Set the length of the simulated sequences.<br>If an MSA is supplied as input and this option is not set, then AliSim will use the length of the sequences in the input alignment.<br>*Default: 1,000* |
| `--num-alignments <NUMBER_OF_DATASETS>` | Set the number of output datasets.<br>*Default: 1* |
| `--root-seq <ALN_FILE>,<SEQ_NAME>`   | Supply a sequence as the ancestral sequence at the root.<br>AliSim automatically sets the length of the output sequences equally to the length of the ancestral sequence. |
| `--no-copy-gaps` | Disable copying gaps from the input sequences.<br>*Default: FALSE* |
|  `-t RANDOM{<MODEL>,<NUM_TAXA>}` | Specify a `<MODEL>` (yh, u, cat, bal, or bd{`<birth_rate>`,`<death_rate>`} for Yule-Harding, Uniform, Caterpillar, Balanced, or Birth-Death model respectively) and the number of taxa `<NUM_TAXA>` to generate a random tree. specified by the users. The number of taxa could be a fixed number, a list (`<NUM_1>,<NUM_2>,...,<NUM_N>`), or a Uniform distribution `U(<LOWER_BOUND>,<UPPER_BOUND>)`. Note that `<NUM_TAXA>` is only required if an alignment is not provided by `-s <ALIGNMENT_FILE>`. |
|  `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`  | Specify the minimum, the mean, and the maximum length of branches when generating a random tree. |
| `-s <SEQUENCE_ALIGNMENT>` | Specify an input MSA. AliSim will simulate MSAs that mimic that user-provided MSA **(Inference mode)**.<br>Firstly, IQTree infers a phylogenetic tree and a model with its parameters from the input data. Then, AliSim simulates MSA from that tree and the model. |
| `--write-all` | Enable writing internal sequences. |
| `-nt <NUM>` | Set the number of threads to run the simulation. |
| `-seed <NUMBER>` | Specify the seed number. <br>*Default: the clock of the PC*. <br>Be careful! To make the AliSim reproducible, users should specify the seed number. |
| `-gz` | Enable output compression, but it could take a longer running time.<br>*By default, output compression is disabled*. |
| `-af phy|fasta` | Set the format for the output file(s). <br>*Default: phy (PHYLIP format)* |




