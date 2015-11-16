---
layout: userdoc
title: "Complex Models"
author: minh
date:   2015-11-15
categories:
- doc
docid: 11
doctype: manual
tags:
- manual
sections:
- name: Partition models
  url: partition-models
- name: Mixture models
  url: mixture-models
---
Partition and mixture models and usages.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Partition models](#partition-models)
    - [Partition file format](#partition-file-format)
    - [Partitioned analysis](#partitioned-analysis)
- [Mixture models](#mixture-models)
    - [What is the difference between partition and mixture models?](#what-is-the-difference-between-partition-and-mixture-models)
    - [Defining mixture models](#defining-mixture-models)
    - [Profile mixture models](#profile-mixture-models)
    - [NEXUS model file](#nexus-model-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


This document gives detailed descriptions of complex maximum-likelihood models available in IQ-TREE. It is assumed that you know the [basic substitution models](../Substitution-Models) already.


Partition models
----------------

Partition models are intended for phylogenomic (e.g., multi-gene) alignments, which allow each partition to have its own substitution models and evolutionary rates. IQ-TREE supports three types of partition models:

1. *Edge-equal* partition model with equal branch lengths: All partitions share the same set of branch lengths.
2. *Edge-proportional* partition model with proportional branch lengths: Like above but each partition has its own partition specific rate, that rescales all its branch lengths. This model accomodates different evolutionary rates between partitions (e.g. between 1st, 2nd, and 3rd codon positions).
3. *Edge-unlinked* partition model: Each partition has its own set of branch lengths. This is the most parameter-rich partition model, that accounts for e.g., *heterotachy* ([Lopez et al., 2002]).

>**NOTICE**: The edge-equal partition model is typically unrealistic as it does not account for different evolutionary speeds between partitions, whereas the edge-unlinked partition model can be overfitting if there are many short partitions. Therefore, the edge-proportional partition model is recommended for a typical analysis. 

#### Partition file format

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

If you want to specify codon model for a partition, use the `CODON` keyword (otherwise, the partition may be detected as DNA):

    #nexus
    begin sets;
        charset part1 = aln1.phy:CODON, 1-300;
        charset part2 = aln1.phy: 301-400;
        charset part3 = aln2.phy: *;
        charpartition mine = GY:part1, GTR+G:part2, WAG+I+G:part3;
    end;

Note that this assumes `part1` has standard genetic code. If not, append `CODON` with [the right genetic code ID](../Substitution-Models#codon-models).


#### Partitioned analysis

Having prepared a partition file, one is ready to start a partitioned analysis with `-q` (edge-equal), `-spp` (edge-proportional) or `-sp` (edge-unlinked) option. See [this tutorial](../Tutorial#partitioned-analysis-for-multi-gene-alignments) for more details.


Mixture models
--------------

#### What is the difference between partition and mixture models?

Mixture models,  like partition models, allow more than one substitution model along the sequences. However, while a partition model assigns each alignment site a given specific model, mixture models do not have this information: each site has a probability of belonging to each of the mixture components (also called categories or classes). In other words, the *site-to-model assignment is unknown*.

For example, the [discrete Gamma rate heterogeneity](../Substitution-Models#rate-heterogeneity-across-sites) is the simplest type of mixture model, where there are several rate categories and each site belongs to a rate category with a probability. The likelihood of a site under a mixture model is computed as the weighted average of the site-likelihood under each mixture category.


#### Defining mixture models

IQ-TREE supports a number of [predefined protein mixture models](../Substitution-Models#protein-models). Here, we give more details how to define new mixture models in IQ-TREE. To start with, the following command:

    iqtree -s example.phy -m "MIX{JC,HKY}"

is a valid analysis. Here, we specify a mixture model (via `MIX` keyword in the model string) with two components (`JC` and `HKY` model) given in curly bracket and comma separator. IQ-TREE will then estimate the parameters of both mixture components as well as their weights: the proportion of sites belonging to each component. 

>**NOTICE**: Do not forget the double-quotes around model string! Otherwise, the Terminal might not recognize the model string properly.

Mixture models can be combined with rate heterogeneity, e.g.:

    iqtree -s example.phy -m "MIX{JC,HKY}+G4"

Here, we specify two models and four Gamma rate categories. Effectively it means that there are 8 mixture components! Each site has a probability belonging to either `JC` or `HKY` and to one of the four rate categories.


#### Profile mixture models

Sometimes one only wants to model the changes in nucleotide or amino-acid frequencies along the sequences while keeping the substitution rate matrix the same. This can be specified in IQ-TREE via `FMIX{...}` model syntax. For convenience the mixture components can be defined in a NEXUS file like this (example corresponds to [the CF4 model](../Substitution-Models#protein-models) of ([Wang et al., 2008])): 

    #nexus
    begin models;
        frequency Fclass1 = 0.02549352 0.01296012 0.005545202 0.006005566 0.01002193 0.01112289 0.008811948 0.001796161 0.004312188 0.2108274 0.2730413 0.01335451 0.07862202 0.03859909 0.005058205 0.008209453 0.03210019 0.002668138 0.01379098 0.2376598;
        frequency Fclass2 = 0.09596966 0.008786096 0.02805857 0.01880183 0.005026264 0.006454635 0.01582725 0.7215719 0.003379354 0.002257725 0.003013483 0.01343441 0.001511657 0.002107865 0.006751404 0.04798539 0.01141559 0.000523736 0.002188483 0.004934972;
        frequency Fclass3 = 0.01726065 0.005467988 0.01092937 0.3627871 0.001046402 0.01984758 0.5149206 0.004145081 0.002563289 0.002955213 0.005286931 0.01558693 0.002693098 0.002075771 0.003006167 0.01263069 0.01082144 0.000253451 0.001144787 0.004573568;
        frequency Fclass4 = 0.1263139 0.09564027 0.07050061 0.03316681 0.02095119 0.05473468 0.02790523 0.009007538 0.03441334 0.005855319 0.008061884 0.1078084 0.009019514 0.05018693 0.07948 0.09447839 0.09258897 0.01390669 0.05367769 0.01230413;

        frequency CF4model = FMIX{empirical,Fclass1,Fclass2,Fclass3,Fclass4};
    end;

Here, the NEXUS file contains a `models` block to define new models. More explicitly, we define four AA profiles `Fclass1` to `Fclass4` (each containing 20 AA frequencies). Then, the frequency mixture is defined with

    FMIX{empirical,Fclass1,Fclass2,Fclass3,Fclass4}

That means, we have five components: the first corresponds to empirical AA frequencies to be inferred from the  data and the remaining four components are specified in this NEXUS file. Please save this to a file, say, `mymodels.nex`. One can now start the analysis with:

    iqtree -s some_protein.aln -mdef mymodels.nex -m JTT+CF4model+G

The `-mdef` option specifies the NEXUS file containing user-defined models. Here, the `JTT` matrix is applied for all alignment sites and one varies the AA profiles along the alignment. One can use the NEXUS syntax to define all other profile mixture models such as `C10` to `C60`.


#### NEXUS model file

In fact, IQ-TREE uses this NEXUS model file internally to define all [protein mixture models](../Substitution-Models#protein-models). In addition to defining state frequencies, one can specify the entire model with rate matrix and state frequencies together. For example, the LG4M model ([Le et al., 2012]) can be defined by:

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

Here, we first define the four matrices `LG4M1`, `LG4M2`, `LG4M3` and `LG4M4` in PAML format (see [protein models](../Substitution-Models#protein-models)). Then `LG4M` is defined as mixture model with these four components *fused* with Gamma rate heterogeneity (via `*G4` syntax instead of `+G4`). This means that, in total, we have 4 mixture components instead of 16. The first component `LG4M1` is rescaled by the rate of the lowest Gamma rate category. The fourth component `LG4M4` corresponds to the highest rate.

Note that both `frequency` and `model` commands can be embedded into a single model file.



[Le et al., 2012]: http://dx.doi.org/10.1093/molbev/mss112
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Wang et al., 2008]: http://dx.doi.org/10.1186/1471-2148-8-331


