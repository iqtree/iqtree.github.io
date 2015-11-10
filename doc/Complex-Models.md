<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Partition models](#partition-models)
    - [Partition file format](#partition-file-format)
    - [Partitioned analysis](#partitioned-analysis)
- [Mixture models](#mixture-models)
- [Customized models](#customized-models)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


This document gives detailed descriptions of complex maximum-likelihood models available in IQ-TREE. It is assumed that you know the [basic substitution models](Substitution-Models) already.


Partition models
----------------

Partition models are intended for phylogenomic (e.g., multi-gene) alignments, which allow each partition to have its own substitution models and evolutionary rates. IQ-TREE supports three types of partition models:

1. *Edge-equal* partition model with equal branch lengths: All partitions share the same set of branch lengths.
2. *Edge-proportional* partition model with proportional branch lengths: Like above but each partition has its own partition specific rate, that rescale all its branch lengths. This model accomodates different evolutionary rates between partitions (e.g. between 1st, 2nd, and 3rd codon positions).
3. *Edge-unlinked* partition model: each partition has its own set of branch lengths. This is the most parameter-rich partition model, that accounts for e.g., *heterotachy* ([Lopez et al., 2002]).

>**NOTICE**: The edge-equal partition model is typically unrealistic as it does not account for different evolutionary speeds between partitions, whereas edge-unlinked partition model can be overfitting if there are many short partitions. Therefore, the edge-proportional partition model is recommended for a typical analysis. 

#### Partition file format

To apply partition models users must first prepare a partition file in RAxML-style or NEXUS format. The RAxML-style is defined by the RAxML software, which may look like:

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

The first line contains the keyword `#nexus` to indicate a NEXUS file. It has a `sets` block, which contains two character sets (`charset` command) named `part1` and `part2`. Furthermore, with `charpartition` command we set the model `HKY+G` for `part1` and `GTR+I+G` for `part2`. This is not possible with RAxML-style format (i.e., one cannot specify `+G` rate model for one partition and `+I+G` rate model for the other partition). 

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

Moreover, the NEXUS file allows each partition to come from separate alignment file (not possible under RAxML-style format) with e.g.:

    #nexus
    begin sets;
        charset part1 = aln1.phy: 1-100\3 201-300;
        charset part2 = aln1.phy: 101-200;
        charset part3 = aln2.phy: *;
        charpartition mine = HKY:part1, GTR+G:part2, WAG+I+G:part3;
    end;

Here, `part1` and `part2` correspond to sub-alignments of `aln1.phy` file and `part3` is the entire alignment file `aln2.phy`. Note that `aln2.phy` is a protein alignment in this example. In fact, **IQ-TREE fully supports mixed data types between partitions**!


If you want to specify codon model for a partition, use the `CODON` keyword (otherwise, the partition may be detected as DNA):

    #nexus
    begin sets;
        charset part1 = aln1.phy:CODON, 1-300;
        charset part2 = aln1.phy: 301-400;
        charset part3 = aln2.phy: *;
        charpartition mine = GY:part1, GTR+G:part2, WAG+I+G:part3;
    end;

Note that this assumes `part1` has standard genetic code. If not, append `CODON` with [the right genetic code ID](Substitution-Models#codon-models).


#### Partitioned analysis

Having prepared a partition file, one is ready to start a partitioned analysis with `-q` (edge-equal), `-spp` (edge-proportional) or `-sp` (edge-unlinked) option. See [this tutorial](Tutorial#partitioned-analysis-for-multi-gene-alignments) for more details.


Mixture models
--------------

Mixture models allow more than one substitution model along the sequences like partition models. However, while a partition model assigns each alignment site with a given specific model, mixture models do not have this information: each site has a probability of belonging to each of the mixture components (also called categories or classes). In other words, the *site-to-model assignment is unknown*.

For example, the [discrete Gamma rate heterogeneity](Substitution-Models#rate-heterogeneity-across-sites) is the simplest type of mixture model, where there are several rate categories and each site belongs to a rate category with a probability. The likelihood of a site under a mixture model is computed as the weighted average of the site-likelihood under each mixture category.

IQ-TREE supports a number of [predefined protein mixture models](Substitution-Models#protein-models). Here, we give more details how to define new mixture models in IQ-TREE. To start with, the following command:

    iqtree -s example.phy -m "MIX{JC,HKY}"

is a valid analysis. Here, we specify a mixture model (via `MIX` keyword in the model string) with two components (`JC` and `HKY` model) given in curly bracket and comma separator. IQ-TREE will then estimate the parameters of both mixture components as well as their weights: the proportion of sites belonging to each component. 



Customized models
-----------------



[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
