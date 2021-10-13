Introduction
============

Sequence simulations play an important role in phylogenetics. However, existing tools are either based on simplistic models of evolution or too slow to generate large datasets or both. Therefore, we introduce AliSim, a new tool that can efficiently simulate realistic biological alignments under [complex evolutionary models](Complex-Models). AliSim takes only an hour and approximately 1GB RAM to generate alignments with millions of sequences or sites, while popular software Seq-Gen, Dawg, and Indelible require many hours and tens to hundreds GB of RAM. We provide AliSim as an extension of the IQ-TREE software version 2.2, freely available at www.iqtree.org. 


If you use AliSim in a publication, please cite:

* __L.T. Nhan, B.Q. Minh__ (2021) AliSim: Ultrafast and Realistic Phylogenetic Sequence Simulator in the Genomic Era, ... <https://doi.org/...>

In the following, we provide a short tutorial on how to use AliSim.


Simulating alignments from a tree and model
-------------------------------------------

Similar to other software, AliSim can simulate a multiple sequence alignment from a given tree with branch lengths and a model with:

    iqtree2 --alisim <OUTPUT_PREFIX> -m <MODEL> -t <TREEFILE>

The `-m` option specifies a model name, and `-t` option specifies a tree file in the standard [Newick format](https://evolution.genetics.washington.edu/phylip/doc/main.html#treefile). This will print the output alignment into `OUTPUT_PREFIX.phy` file in Phylip format.

For example, if you want to simulate a DNA alignment under the [Jukes-Cantor model](http://doi.org/10.1016/B978-1-4832-3211-9.50009-7) for the following tree `tree.nwk`:

    (A:0.3544240993,(B:0.1905941554,C:0.1328977434):0.0998619427,D:0.0898418080);

You can run IQ-TREE with:

    iqtree2 --alisim alignment -m JC -t tree.nwk

will print the simulated alignment to `alignment.phy`. 


The output MSA should contain 4 sequences of 1000 sites, each, for example:

    4 1000
    A       AAATTTGGTCCTGTGATTCAGCAGTGAT...
    B       CTTCCACACCCCAGGACTCAGCAGTGAT...
    C       CTACCACACCCCAGGACTCAGCAGTAAT...
    D       CTACCACACCCCAGGAAACAGCAGTGAT...


Importantly, we note that AliSim uses a random number seed corresponding to the current CPU clock of the running computer. If you run two AliSim commands at the same time, it may generate two identical alignments, which may not be the desired outcome. In that case, you can use -seed option to specify the random number seed:

    iqtree2 --alisim alignment_123 -m JC -t tree.nwk -seed 123

`-seed` option has another advantage of reproducing the same alignment when rerunning IQ-TREE.

Customizing output alignments
-----------------------------

Users can use `--length` option to change the length of the output alignment, e.g.:

    iqtree2 --alisim alignment_5000 -m JC -t tree.nwk --length 5000

Users could also output the alignment in FASTA format with `-af` option:

    iqtree2 --alisim alignment -m JC -t tree.nwk -af fasta
    
will print the alignment to `alignment.fa` file.

To generate multiple alignments, users could use `--num-alignments` option:    

    iqtree2 --alisim alignment -m JC -t tree.nwk --num-alignments 3

This will output three alignments into `alignment_0.phy`, `alignment_1.phy`, and `alignment_2.phy`, respectively. 

If users want to compress the output file, they could try `-gz` option:

    iqtree2 --alisim alignment -m JC -t tree.nwk -gz

This will compress the output file, but it could take a longer running time.

Simulating insertions and deletions (Indels)
-----------------------------------
    
AliSim can also simulate insertions and deletions, for example:

    iqtree2 --alisim alignment_indel -m JC -t tree.nwk --indel 0.1,0.05
    
`--indel` option specifies the insertion and deletion rates (separated by a comma) relative to the substitution rates. Here, it means that, on average, we have 10 insertion and 5 deletion events per every 100 substitution events. Apart from the normal output file `alignment_indel.phy`, AliSim also exports an additional file `alignment_indel_withoutgaps.fa` containing sequences without gaps. If not needing the additional output file, one could disable that feature by `--no-export-sequence-wo-gaps`. By default, AliSim assumes that the size of indels follows a geometric distribution with a mean of 2 and a variance of ±2. If wanting to change this distribution, one can use `--indel-size` option:

    iqtree2 --alisim alignment_indel_size -m JC -t tree.nwk --indel 0.1,0.05 --indel-size GEO{5},GEO{4}

It means that the insertion size follows a Geometric distribution with mean of 5 and variance of 20, whereas deletion size also follows the Geometric distribution but with mean of 4 and variance of 12. *Note that the variance is computed from mean*. Apart from this distribution, AliSim also supports [Negative Binomial distribution, Zipfian distribution, and Lavalette distribution](https://doi.org/10.1093/molbev/msp098) as following examples:

    iqtree2 --alisim alignment_indel_size -m JC -t tree.nwk --indel 0.1,0.05 --indel-size NB{5/20},POW{1.5}

To specify a Negative Binomial distribution (with mean of 5 and variance of 20) and a Zipfian distribution (with parameter `a` of 1.5) for the insertion size, and deletion size, respectively. Or to specify Lavalette distribution (with parameter `a` of 1.5 and `max` of 10) for both insertion and deletion size, users could use:

    iqtree2 --alisim alignment_indel_size -m JC -t tree.nwk --indel 0.1,0.05 --indel-size LAV{1.5/10},LAV{1.5/10}

Simulating alignments with custom models
-----------------------------

Apart from the simple Juke-Cantor models above, AliSim also supports all other more complex models available in IQ-TREE. For example:

     iqtree2 --alisim alignment_HKY -t tree.nwk -m HKY{2.0}+F{0.2/0.3/0.1/0.4}

This simulates a new alignment under the [HKY model](https://dx.doi.org/10.1007%2FBF02101694) with a transition/transversion ratio of 2 and nucleotide frequencies of 0.2, 0.3, 0.1, 0.4 for A, C, G, T, respectively.

Besides, AliSim allows users to simulate alignnments with DNA error model by adding `+E{<Error_Probability>}` into the `<model>` when specifying the model with `-m <model>`. For example:

     iqtree2 --alisim alignment_HKY_error -t tree.nwk -m HKY{2.0}+F{0.2/0.3/0.1/0.4}+E{0.01}
   
This simulates a new alignment under the HKY model as the above example, but with a sequencing error probability of 0.01. That means the nucleotide of 1% sites of the simulated sequences is randomly changed to another nucleotide. 

AliSim also supports all [rate heterogeneity across sites](...) such as:

     iqtree2 --alisim alignment_HKY_G -t tree.nwk -m HKY{2.0}+F{0.2/0.3/0.1/0.4}+G{0.5}

By default, if nucleotide frequencies are neither specified nor possible to be inferred from a user-provided alignment, AliSim will randomly generate these frequencies from empirical distributions as the following example. 

     iqtree2 --alisim alignment_HKY -t tree.nwk -m HKY{2.0}

In this case, AliSim would simulate an alignment from the HKY model. The frequencies of base A, C, G, and T, will be randomly generated from empirical distributions, namely, Generalized-logistic, Exponential-normal, Power-log-normal, Exponential-Weibull. These distributions and their parameters were estimated from a large collection of empirical datasets [REF](http://google.com). 
    
In addition to five built-in distributions, namely *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*, users could define their own lists of numbers, then generate other model parameters from these lists by following these steps. Note that user-defined lists of numbers could be generated from different distributions.

Firstly, generating a set of random numbers for each list, then defining the new lists in a new file (e.g.,`custom_distributions.txt`) as the following example.

    F_A 0.363799 0.313203 0.277533 0.242350 ...
    F_B 0.268955 0.278675 0.290531 0.237410 ...
    F_C 0.320556 0.440894 0.332368 0.227977 ...
    F_D 0.234732 0.309629 0.353117 0.414357 ...
    R_A 2.306336 4.359459 0.249315 0.388073 ...
    R_B 1.257679 0.417313 3.290922 2.301826 ...
    R_C 0.200087 1.336534 3.337547 2.325379 ...
    R_D 0.321134 0.299891 1.315519 0.269172 ...

Each list should be defined in a single line, starting with the list name, followed by random numbers. These numbers should be separated by space. The given file `custom_distributions.txt` defines 8 new lists. Each list could have a different number of random elements.

Secondly, loading these lists and generating a new alignment with random parameters with

     iqtree2 --alisim alignment_GTR_custom -t tree.nwk -m GTR{1.5/R_A/R_B/0.5/R_C}+F{Generalized_logistic/0.3/F_A/0.2}+I{F_D}+G{F_C} --distribution custom_distributions.txt

In this example, 3 substitution rates of GTR models are randomly drawn from the `R_A,R_B,R_C` lists while the user specifies other rates. Similarly, the frequencies of base A and G are generated from `Generalized_logistic` distribution and the list `F_A` whereas the relative frequencies of base C and T are 0.3 and 0.2. These state frequencies are automatically normalized so that they sum to 1. Furthermore, the Invariant Proportion and the Gamma Shape are drawn from the appropriate lists named `F_D`, and `F_C`, respectively. 

Users could also use user-defined lists to randomly generate other parameters (e.g., substitution rates, state frequencies, nonsynonymous/synonymous rate ratio, transition rate, transversion rate, category weight/proportion) for other kinds of models/data (e.g., Protein, Codon, Binary, Morph, Lie Markov, Heterotachy, and Mixture). 

Simulating alignments that mimic a real alignment
-------------------------------------
<div class="hline"></div>

AliSim allows users to simulate alignments that mimic the evolutionary history of a given alignment as the below example:
        
      iqtree2 --alisim alignment_mimic -s example.phy 

* `-s example.phy` is the option to supply the input alignment. 

In this example, AliSim first runs IQ-TREE to a phylogenetic tree and the best-fit substitution model (using ModelFinder) with its parameters from the input alignment `example.phy`. After that, AliSim generates an alignment based on the inferred tree and the best-fit substitution model. Moreover, AliSim also copies the gap patterns from the input alignment `example.phy` to the output alignment `alignment_mimic.phy`. To disable this feature, users could add the option `--no-copy-gaps` to the command line.

Simulating alignments from a random tree
------------------
<div class="hline"></div>

AliSim supports users in producing alignments from a random tree generated by biologically plausible models (such as Yule-Harding, Uniform, and Birth-Death processes). As an example:

     iqtree2 --alisim alignment_yh -t RANDOM{yh/1000}

* `-t RANDOM{yh/1000}` tells AliSim to generate a random tree with 1000 taxa under the Yule-Harding model, with branch lengths following a exponential distribution with a mean of 0.1.

Here AliSim generates `alignment_yh.phy` under the Jukes-Cantor model. If you want to change the model, use -m option as [described above](#simulating-alignments-with-custom-models)

For the distribution of branch lengths, users could adjust the minimum, the maximum, and the mean of the exponential distribution via the option `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`.

Furthermore, users can also randomly generate branch lengths of the phylogenetic tree from a user-defined list (or a built-in distribution, such as *uniform, Generalized_logistic, Exponential_normal, Power_log_normal, and Exponential_Weibull*) with `--branch-distribution` option:

    iqtree2 --alisim alignment_yh_custom_branch -t RANDOM{yh/1000} --branch-distribution F_A --distribution custom_distributions.txt

In this example, the branch lengths of the random tree are randomly drawn from the user-defined list `F_A`. Besides, if the user supplies a tree file (instead of a random tree), the branch lengths of the user-provided tree will be overridden by the random lengths from the list `F_A`.

Simulating alignments with functional divergence (FunDi ) model
----------------------------

AliSim supports the [FunDi model](https://doi.org/10.1093/bioinformatics/btr470), which allows a proportion number of sites (`<RHO>`) in the sequence of each taxon in a given list (`<TAXON_1>,...,<TAXON_N>`), could be permuted with each other. To simulate new alignments under the FunDi model, one could use `--fundi` option:

      iqtree2 --alisim alignment_fundi -t tree.nwk -m JC --fundi A,C,0.1

This example simulates a new alignment under the Juke-Cantor model from the input tree `tree.nwk` with the default sequence length of 1000 sites. Since the user specifies FunDi model with `<RHO>` = 0.1, thus, in the sequences of Taxon A, and C, 100 random sites (sequence length * `<RHO>` = 1,000 * 0.1) are permuted with each other.

Simulating alignments with branch-specific models
----------------------------

AliSim supports branch-specific models, which assign different evolutionary models to individual branches of a tree.

To use branch-specific models, users should specify the models for individual branches with the syntax `[&model=<model>]` in the input tree file. The model parameters should be separated by a forward slash `/` if the user wants to specify them. 

**Example 1**: assuming the input tree file `input_tree.nwk` is described as following 

	(A:0.1,(B:0.1,C:0.2[&model=HKY]),(D:0.3,E:0.1[&model=GTR{0.5/1.7/3.4/2.3/1.9}+F{0.2/0.3/0.4/0.1}+I{0.2}+G{0.5}]):0.2);

Then, simulate an alignment by

      iqtree2 --alisim alignment_example_1 -t input_tree.nwk -m JC
    
In this example, AliSim uses the Juke-Cantor model to simulate an alignment along the input tree. However, at the branch connecting taxon C to its ancestral, the `HKY` with random parameters is used to simulate the sequence of taxon C. Similarly, the `GTR` model with the parameters specified above is used to generate the sequence of taxon E.
  
To apply [Heterotachy (GHOST) model](Heterotachy-models) for an individual branch, in addition to the model name, users must also supply a set of branch-lengths containing `n` lengths corresponding to `n` categories of the model via `lengths=<length_0>,...,<length_n>` as the example 2. 

**Example 2**: assuming the tree file `input_tree.nwk` is described as following

	(A:0.1,(B:0.1,C:0.2[&model=HKY{2.0}*H4,lengths=0.1/0.2/0.15/0.3]),(D:0.3,E:0.1):0.2);

Then, simulate an alignment by

      iqtree2 --alisim alignment_example_2 -t input_tree.nwk -m JC
    
In this example, AliSim simulates a new alignment using the Juke-Cantor model. However, at the branch connecting taxon C to its ancestral, the GHOST model with 4 categories is used with 4 branch lengths 0.1, 0.2, 0.15, and 0.3 to generate the sequence of taxon C.

Additionally, in a rooted tree, users may want to generate the root sequence with particular state frequencies and then simulate new sequences from that root sequence based on a specific model. To do so, one should supply a rooted tree, then specify a model and state frequencies  (with `[&model=<model>,freqs=<freq_0,...,<freq_n>]`) as example 3.

**Example 3**: assuming the tree file `input_tree.nwk` is described as following

	(A:0.1,(B:0.1,C:0.2),(D:0.3,E:0.1):0.2):0.3[&model=GTR,freqs=0.2/0.3/0.1/0.4];

Then, simulate an alignment by

      iqtree2 --alisim alignment_example_3 -t input_tree.nwk -m JC
    
In this example, AliSim first generates a random sequence at the root based on the user-specified frequencies (`0.2/0.3/0.1/0.4`). Then, it uses the `GTR` model with random parameters to simulate a sequence for the child node of the root. Finally, AliSim traverses the tree and uses the Juke-Cantor model to simulate sequences for the other nodes of the tree.

Simulating alignments with [Partition models](Complex-Models#partition-models)
----------------------------

**Example 1**: Simulating mixed data with an ***Edge-equal* partition model**

AliSim allows users to simulate mixed data  (e.g., DNA, Protein, and MORPH) in a single simulation, in which each kind of data is exported into a different alignment file. Here is an example for mixing DNA, protein, and morphological data. Firstly, users need to specify partitions in an input partition file as following.

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

Assuming that the above partition file is named `example_mix.nex` and one would like to simulate alignments from a single tree in `tree.nwk`, one could start the simulation with the following command:

    iqtree2 --alisim partition_mix -q example_mix.nex -t tree.nwk

At the end of the run, AliSim writes out the simulated alignments into four output files. The first file named `partition_mix_part1_part2_part7.phy` stores the merged 400-site DNA alignment from `part1`, `part2`, and `part7`. Although `part3`, `part5`, and `part6` contain morphological data, `part3` simulates a morphological alignment with 32 states while `part5` and `part6` have 30 states. Thus, AliSim outputs the alignment of `part3` into `partition_mix_part3.phy`, whereas `partition_mix_part5_part6.phy` stores the  alignment merging `part5` and `part6`. Lastly, `partition_mix_part4.phy` stores the simulated amino-acid alignment of `part4`.

**Example 2**: Simulating mixed data with an ***Edge-proportional* partition model**

Unlike ***Edge-equal***, the ***Edge-proportional*** partition requires each partition to have its own partition specific rate, which rescales all its branch lengths. One could specify the partition-specific rates by specifying the tree length for each partition in the NEXUS file via `partX{<tree_length>}` as in the following example. Note that `<tree_length>` of a partition is equal to the length of the common tree times the `partition_rate` of that partition. For example, assuming the length of the common tree is 2.61045, the partition-specific rate of partition 1 is 0.3, then the `<tree_length>` of `part1` should be 0.783135 (=2.61045 * 0.3):

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

    iqtree2 --alisim partition_mix_edge_proportition -p example_mix_edge_proportion.nex -t tree.nwk
    
**Example 3**: Simulating mixed data with ***Edge-unlinked* partition model**

AliSim supports tree-mixture models, which allow each partition has its own tree topology with even different sets of taxa as long as the supertree contains all of the taxa in all partitions. 

In this example, we re-use the `example_mix.nex` file to define seven partitions with DNA, amino-acid, and morphological data.

Then, we need to prepare a multiple-tree file. In an ***Edge-unlinked*** partition, AliSim requires a multiple-tree file that specifies a supertree (combining all taxa in all partitions) in the first line. Following that, each tree for each partition should be specified in a single line one by one in the input multiple-tree file as the following `example_mix_unlinked_partitions.parttrees` file:

	(T0:0.0181521877,(((T5:0.1771956842,(T6:0.0614336000,T7:0.2002480501)23:0.1532476871)18:0.0332679438,(T8:0.0677273831,T9:0.0305167387)19:0.1180907531)16:0.0365283318,(T3:0.0681218610,T4:0.0527632742)17:0.1350927217)8:0.0393042588,(T1:0.1523260216,T2:0.0214431611)9:0.0733969175);
	(((T4:0.0843970070,T5:0.0286349627)4:0.1220779923,T2:0.0146182510)1:0.2353878387,(T1:0.0238257189,((T6:0.0106472245,T7:0.2282782466)12:0.0946749939,(T8:0.1456716825,T9:0.2407945609)13:0.3296837366)9:0.0160168752)2:0.0450985623,T0:0.0596020470);
	(T0:0.0671385689,T1:0.5298317367,((T4:0.0064005330,(T5:0.2918771232,T6:0.0059750004)11:0.1537117251)4:0.1158362293,(T2:0.0349557476,(T3:0.1152013065,(T7:0.2847312268,T8:0.0349557476)9:0.0062939800)7:0.0725670372)5:0.0689155159)3:0.0318828801);
	(((T1:0.1313043899,T2:0.0011060947)4:0.2128631786,((T6:0.1987774353,T7:0.1127011763)8:0.0673344553,T3:0.0980829253)5:0.0470003629)1:0.1532476871,((T4:0.0994252273,T5:0.1532476871)10:0.2162823151,(T8:0.0139262067,T9:0.1241328591)11:0.0110931561)2:0.0362405619,T0:0.0297059234);
	(T0:0.0277071893,((T2:0.1845160246,T3:0.1448169765)12:0.0055512710,((T8:0.0401971219,T9:0.0016129382)14:0.0176737179,(T6:0.1461017907,T7:0.0972861083)15:0.1624551550)13:0.0079043207)4:0.0484508315,(T1:0.0908818717,(T4:0.0382725621,T5:0.0047091608)11:0.1870802677)5:0.1645065090);
	(T0:0.0574475651,T1:0.0081210055,(((T4:0.0832409248,((T8:0.1614450454,T9:0.3540459449)22:0.0964955904,T5:0.0291690094)21:0.0949330586)16:0.0034591445,(T6:0.0339677368,T7:0.0038740828)17:0.0388607991)14:0.0303811454,(T3:0.0703197516,T2:0.0345311185)11:0.1061316504)3:0.0872273846);
	(T0:0.0205794913,(((T2:0.1093624747,((T8:0.2017406151,T9:0.0650087691)14:0.0695149183,T7:0.4135166557)9:0.2234926445)6:0.1924148657,T1:0.0614336000)4:0.0287682072,(T5:0.1010601411,T6:0.3194183212)5:0.0385662481)2:0.1671313316,(T3:0.1546463113,T4:0.1139434283)3:0.0321583624);
	((((T8:0.0306525160,T9:0.0125563223)16:0.1546463113,T7:0.0102032726)1:0.2501036032,(T1:0.0616186139,(T2:0.1565421027,(T5:0.0018470000,T6:0.0594207233)11:0.0505838082)9:0.0027371197)6:0.1443923474)0:0.4710530702,(T3:0.0372514008,T4:0.0322963887)4:0.0491022996,T0:0.0669430654); 

The above tree file contains 8 lines, in which the first line specifies the supertree (consisting of 10 taxa of all partitions), and the 7 remaining lines are the trees corresponding to 7 partitions. Note that taxon 3 (T3) is missing in the tree of `part1`, taxon 9 (T9) is missing in the tree of `part2`.

Now, one could simulate alignments using the following command:
	
	iqtree2 --alisim partition_mix_unlinked  -Q example_mix.nex -t example_mix_unlinked_partitions.parttrees

At the end of the run, AliSim writes out the simulated alignments into four output files, as seen in the previous example with the ***Edge-equal*** partition model. However, when you check the merged alignment in `partition_mix_unlinked_part1_part2_part7.phy`, you should see several gaps `-` in the sequences of taxon 3 (T3) and taxon 9 (T9) as these taxa are missing in the input trees of `part1` and `part2`.

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

**Example 4**: Simulating multi-gene alignments
 
To simulate an alignment consisting of multiple genes, where each gene evolves under a different substitution model, one should first define those genes (each gene as a partition) and specify the corresponding model for each gene. Assuming we have `multi_genes.nex` file as following
 
    #nexus
	begin sets;
	    charset gene_1 = DNA, 1-846;
	    charset gene_2 = DNA, 847-1368;
	    charset gene_3 = DNA, 1369-2040;
	    charset gene_4 = DNA, 2041-2772;
	    charset gene_5 = DNA, 2773-3738;
	    charpartition mine = HKY{2}+F{0.2/0.3/0.1/0.4}:gene_1, GTR{1.2/0.8/0.5/1.7/1.5}+F{0.1/0.2/0.3/0.4}+G{0.5}:gene_2, JC:gene_3, HKY{1.5}+I{0.2}:gene_4, K80{2.5}:gene_5;
	end;

The above file defines five genes, each of them has a different length, which sums to 3738 sites. These genes evolved independently under HKY, GTR (with discrete Gamma rate variance), JC, HKY (with a proportion of invariant sites), and K80 model, respectively.

Then, you can simulate an alignment consisting of these five genes by

	iqtree2 --alisim partition_multi_genes  -q multi_genes.nex -t tree.nwk

That simulation outputs the new alignment into a single file named `partition_multi_genes.phy`.

**Example 5**: Simulating multi-gene alignments from multiple gene trees
 
Similar to example 4 but each gene can evolve from a different gene tree. Assuming we have `multi_genes.nex` file as in example 4, we then need to specify a multiple gene trees (in `multi_trees.nwk` as following.

	(A:0.1,(B:0.2,C:0.15):0.1,D:0.05);
	(A:0.1,(B:0.2,C:0.15):0.1,D:0.05);
	(A:0.1,B:0.2,(C:0.15,D:0.05):0.1);
	((A:0.1,B:0.2):0.1,C:0.15,D:0.05);
	((A:0.1,C:0.15):0.1,B:0.2,D:0.05);
	(A:0.1,C:0.15,(B:0.2,D:0.05):0.1);

The first line specify the supertree, containing all taxa in all other tree. The remaining line specify the corresponding tree for 6 gene trees.

Then, you can simulate an alignment consisting of these five genes from multiple gene trees by

	iqtree2 --alisim partition_multi_genes_trees  -Q multi_genes.nex -t multi_trees.nwk

That simulation outputs the new alignment into a single file named `partition_multi_genes_trees.phy`.


Simulating alignments with [Mixture models](Complex-Models#mixture-models)
----------------------------

AliSim supports a series of [protein mixture models](Substitution-Models#protein-mixture-models). Users can easily simulate alignments from a protein mixture model as following.

    iqtree2 --alisim alignment_mix_EX2 -m EX2 -t tree.nwk

This simulates a new alignment under the EX2 model (Two-matrix model for exposed/buried AA sites [Le et al., 2008b](https://doi.org/10.1098/rstb.2008.0180)).

Besides, users can simulate alignments from user-defined mixture model via `MIX{<model_1>,...,<model_n>}` as described in [Mixture models](Complex-Models#mixture-models). The following example simulates an alignment under a mixture model contains 2 model components (JC, and HKY) with rate heterogeneity across sites based on discrete Gamma distribution.

    iqtree2 --alisim alignment_mix_JC_HKY_G -m "MIX{JC,HKY}+G4" -t tree.nwk

To simulate alignments with more complex mixture models, users can define a new mixture via a model definition file and supply it to AliSim via `-mdef <model_file>`. For more detail about how to define a mixture model, please have a look at [Profile Mixture Models](Complex-Models#profile-mixture-models).


Simulating alignments with Heterotachy [(GHOST model)](Complex-Models#heterotachy-models)
----------------------------

If one wants to simulate sequences based on a GHOST model with 4 classes in conjunction with the `GTR` model of DNA evolution, one should use the following command:

    iqtree2 --alisim GTR_plus_H4 -m GTR+H4 -t tree.nwk

Assuming that we have an input alignment `example.phy` evolving under the GHOST model with 4 classes in conjunction with the `GTR` model. If one wants to simulate an alignment that mimics that input alignment, one should use the following command:

    iqtree2 --alisim GTR_plus_H4_inference -m GTR+H4 -s example.phy

If you want to unlink GTR parameters so that AliSim could use them separately for each class, replace `+H4` by `*H4`: 

    iqtree2 --alisim GTR_time_H4_inference -m GTR*H4 -s example.phy

If one wishes to use separate base frequencies for each class, then the `+FO` option is required:

    iqtree2 --alisim GTR_FO_time_H4_inference -m GTR+FO*H4 -s example.phy

Command reference
=================

All the options available in AliSim are shown below:

| Option | Usage and meaning |
|--------------|------------------------------------------------------------------------------|
|`--alisim <OUTPUT_FILENAME>`| Activate AliSim and specify the prefix for the output filename. |
| `-t <TREE_FILEPATH>`   | Set the path to the input tree. |
| `--seqtype <SEQUENCE_TYPE>`  | Specify the sequence type (BIN, DNA, AA, CODON, MORPH{`<NUMBER_STATES>`}) of the output *(optional)*. `<NUMBER_STATES>` is the number of states to simulate morphological data. <br>*By default, Alisim automatically detects the sequence type from the model name*. |
| `-m <MODEL>`   | Specify the model name [and its parameters (optional)]. <br> See [Substitution Models](https://github.com/iqtree/iqtree2/wiki/Substitution-Models) and [Complex Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models) for the list of supported models, how to use complex models (mixture, partition, rate heterogeneity across sites, heterotachy, Ascertainment Bias Correction, etc.), and syntax to specify model parameters (rates, base frequencies, omega, kappa, kappa2, etc.) or define new models.|
| `-mdef <MODEL_FILE>`  | Define new models by their parameters. |
| `--fundi <TAXON_1>,...,<TAXON_N>,<RHO>`   | Specifying parameters for the [FunDi model](https://doi.org/10.1093/bioinformatics/btr470), which allows a proportion number of sites (`<RHO>`) in the sequence of each taxon in the given list (`<TAXON_1>,...,<TAXON_N>`), could be permuted with each other. |
| `--indel <INS>,<DEL>`  | Activate Indels (insertion/deletion events) and specify the insertion/deletion rate relative to the substitution rate of 1. |
| `--indel-size <INS_DIS>,<DEL_DIS>`  | Specify the indel-size distributions. Notes: `<INS_DIS>,<DEL_DIS>` could be names of user-defined distributions, or GEO{<double_mean>}, NB{<double_mean>[/<double_variance>]}, POW{<double_a>[/<int_max>]}, LAV{<double_a>/<int_max>}, which specifies Geometric, [Negative Binomial, Zipfian, and Lavalette distribution](https://doi.org/10.1093/molbev/msp098) , respectively. By default, AliSim uses a Zipfian distribution with an empirical parameter `<double_a>` of 1.7, and a maximum size `<int_max>` of 100 for Indels-size.|
| `--sub-level-mixture`  | Enable the feature to simulate substitution-level mixture model, which allows AliSim to select a model component of the mixture according to the weight vector for each substitution/mutation occurs during the simulation.|
| `--no-export-sequence-wo-gaps`  | Disable writing an additional output file of sequences without gaps (when using Indels).|
| `-q <PARTITION_FILE>` or <br>`-p <PARTITION_FILE>` or <br>`-Q <PARTITION_FILE>` | `-q <PARTITION_FILE>`: Edge-equal partition model with equal branch lengths: All partitions share the same set of branch lengths. <br>`-p <PARTITION_FILE>`: Edge-proportional partition model with proportional branch lengths: Like above, but each partition has its own partition specific rate, which rescales all its branch lengths. This model accommodates different evolutionary rates between partitions.<br>`-Q <PARTITION_FILE>`: Edge-unlinked partition model: Each partition has its own set of branch lengths. <br>`<PARTITION_FILE>` could be specified by a RAXML or NEXUS file as described in [Complex Models](https://github.com/iqtree/iqtree2/wiki/Complex-Models)<br>These options work well with [an input alignment](#simulating-alignments-that-mimic-a-real-alignment).<br>In normal cases without an input alignment, users must supply a tree-file (with a single tree) when using `-q` or `-p`. While using `-Q`, AliSim requires a multiple-tree file that specifies a supertree (combining all taxa in all partitions) in the first line. Following that, each tree for each partition should be specified in a single line one by one in the input multiple-tree file. Noting that each partition could have a different tree topology. |
| `--distribution FILE` | Supply the distribution definition file, which specifies multiple lists of numbers. These lists could be used to generate random parameters by specifying list names (instead of specific numbers) for model parameters. |
| `--branch-distribution DISTRIBUTION_NAME` |                  Specify a distribution, from which branch lengths of the phylogenetic trees are randomly generated.|
| `--only-unroot-tree` | Only unroot a rooted tree and terminate. |
| `--length <SEQUENCE_LENGTH>` | Set the length of the simulated sequences.<br>If users supply an alignment and don't set this option, then AliSim sets the output sequence length equally to length of the input sequences.<br>*Default: 1,000* |
| `--num-alignments <NUMBER_OF_DATASETS>` | Set the number of output datasets.<br>*Default: 1* |
| `--root-seq <ALN_FILE>,<SEQ_NAME>`   | Supply a sequence as the ancestral sequence at the root.<br>AliSim automatically sets the output sequence length equally to the length of the ancestral sequence. |
| `--no-copy-gaps` | Disable copying gaps from the input sequences.<br>*Default: FALSE* |
|  `-t RANDOM{<MODEL>/<NUM_TAXA>}` | Specify a `<MODEL>` (yh, u, cat, bal, or bd{`<birth_rate>`/`<death_rate>`} for Yule-Harding, Uniform, Caterpillar, Balanced, or Birth-Death model, respectively), and the number of taxa `<NUM_TAXA>` to generate a random tree. The number of taxa could be a fixed number, a list `{<NUM_1>/<NUM_2>/.../<NUM_N>}`, or a Uniform distribution `U{<LOWER_BOUND>/<UPPER_BOUND>}`. Note that `<NUM_TAXA>` is only required if users don't supply an input alignment. |
|  `-rlen <MIN_LEN> <MEAN_LEN> <MAX_LEN>`  | Specify the minimum, the mean, and the maximum length of branches when generating a random tree. |
| `-s <SEQUENCE_ALIGNMENT>` | Specify an input alignment.<br>Firstly, IQTree infers a phylogenetic tree and a model with its parameters from the input data. Then, AliSim simulates alignments from that tree and the model. |
| `--write-all` | Enable writing internal sequences. |
| `-seed <NUMBER>` | Specify the seed number. <br>*Default: the clock of the PC*. <br>Be careful! To make the AliSim reproducible, users should specify the seed number. |
| `-gz` | Enable output compression. It may take a longer running time.<br>*By default, output compression is disabled*. |
| `-af phy|fasta` | Set the format for the output file(s). <br>*Default: phy (PHYLIP format)* |




