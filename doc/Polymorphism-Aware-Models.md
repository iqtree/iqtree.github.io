---
layout: userdoc
title: "Polymorphism-Aware Models"
author: _AUTHOR_
date: _DATE_
docid: 13
icon: book
doctype: manual
tags:
- manual
description: Improve inferences using population data.
sections:
- name: Counts files
  url: counts-files
- name: First example
  url: first-running-example
- name: Substitution models
  url: substitution-models
- name: Virtual population size
  url: virtual-population-size
- name: Sampling method
  url: sampling-method
- name: Bootstrap branch support
  url: bootstrap-branch-support
- name: Interpretation of branch lengths
  url: interpretation-of-branch-lengths
---

Polymorphism-aware models
=========================

Improve inferences using population data.
<!--more-->

**Po**lymorphism-aware phylogenetic **Mo**dels (PoMo) improve
phylogenetic inference using population data (site frequency data).
Thereby they builds on top of DNA substitution models and naturally
account for incomplete lineage sorting.  In order to run PoMo, you
need more sequences per species/population (ideally ten or more
chromosomes) so that information about the site frequency spectrum is
available.

The latest
[releases of IQ-TREE](https://github.com/Cibiv/IQ-TREE/releases)
include PoMo, e.g.,
[v1.6.beta](https://github.com/Cibiv/IQ-TREE/tree/v1.6.beta)

>**TIP**: For a quick overview of all PoMo related options in IQ-TREE,
>run the command `iqtree -h` and scroll to the heading `POLYMORPHISM AWARE MODELS (PoMo)`.
{: .tip}

If you use PoMo, please cite [Schrempf et al., 2016]:

    Dominik Schrempf, Bui Quang Minh, Nicola De Maio, Arndt von
    Haeseler, and Carolin Kosiol (2016) Reversible polymorphism-aware
    phylogenetic models and their application to tree inference.
    J. Theor. Biol., 407, 362–370.
    http://doi.org/10.1016/j.jtbi.2016.07.042.

Counts files
------------
<div class="hline"></div>

The input of PoMo is allele frequency data.  Especially, when populations
have many individuals it is preferable to count the number of bases at
each position.  This decreases file size and speeds up the parser.

Counts files contain:

- One headerline that specifies the file as counts file and states the
  number of populations as well as the number of sites (separated by
  white space).

- A second headerline with white space separated headers: CRHOM
  (chromosome), POS (position) and sequence names.
   
- Many lines with counts of A, C, G and T bases and their respective
  positions.

Comments:

- Lines starting with # before the first headerline are treated as
  comments.

A toy example:

    COUNTSFILE  NPOP 5   NSITES N
    CHROM  POS  Sheep    BlackSheep  RedSheep  Wolf     RedWolf
    1      1    0,0,1,0  0,0,1,0     0,0,1,0   0,0,5,0  0,0,0,1
    1      2    0,0,0,1  0,0,0,1     0,0,0,1   0,0,0,5  0,0,0,1
    .
    .
    .
    9      8373 0,0,0,1  1,0,0,0     0,1,0,0   0,1,4,0  0,0,1,0
    .
    .
    .
    Y      9999 0,0,0,1  0,1,0,0     0,1,0,0   0,5,0,0  0,0,1,0

The download also includes an example counts file called
[`example.cf`](https://github.com/Cibiv/IQ-TREE/blob/PoMo/example/example.cf).
This file is a subset of the
[great ape data](https://github.com/pomo-dev/data/tree/master/SystBiol2015)
that has been analyzed in one of our publications. It includes twelve
great ape population with one to 23 inividuals each (two to 56
chromosomes).

### Conversion scripts

If you do not want to create counts files with your own scripts, you
can use one of the scripts that we provide.  For detailed
instructions, please refer to the
[GitHub repository of the counts file library `cflib`](https://github.com/pomo-dev/cflib).

First running example
---------------------
<div class="hline"></div>

You can now start to reconstruct a maximum-likelihood tree from this
alignment by entering (assuming that `example.cf` is in the same
folder):

    iqtree -s example.cf -m HKY+P

or, e.g.,

    iqtree -nt 4 -s example.cf -m HKY+P

if you use the multicore version.  `-s` allows specification of the
alignment file; `-m` specifies the model (HKY substitution model with
PoMo).  At the end of the run IQ-TREE writes the same output files as
in the standard version (see [tutorial](Tutorial)).

* `example.cf.iqtree`: the main report file that is self-readable.
You should look at this file to see the computational results.  It
also contains a textual representation of the final tree.
* `example.cf.treefile`: the ML tree in NEWICK format, which can be
visualized by any supported tree viewer programs like FigTree or iTOL.
* `example.cf.log`: log file of the entire run (also printed on the
screen).  To report bugs, please send this log file and the original
alignment file to the authors.

The default prefix of all output files is the alignment file
name.  However, you can always change the prefix using the `-pre`
option, e.g.:

    iqtree -s example.cf -pre myprefix

This prevents output files to be overwritten when you perform multiple
analyses on the same alignment within the same folder.

Substitution models
-------------------
<div class="hline"></div>

Different DNA substitution models can be selected with the `-m`
option.  E.g., to select the GTR model, run IQ-TREE with:

    iqtree -s example.cf -m GTR+P

>**TIP**: For a quick overview of all available models in IQ-TREE, run
>the command `iqtree -h` and scroll to the heading `POLYMORPHISM AWARE MODELS (PoMo)`.
{: .tip}

Virtual population size
-----------------------
<div class="hline"></div>

PoMo describes the evolution of populations along a phylogeny by means
of a virtual population of constant size N, which defaults to 9 (for
details, see [Schrempf et al., 2016]).  This is a good and stable
default value.  If only very few chromosomes have been sequenced per
population (e.g., two to four), N should be lowered to the average
number of chromosomes per population.  If enough data is available and
calculations are not too time consuming, we advise to increase N up to
a maximum of 19.  You can choose odd values from three to 19 as well
as 2 and 10.  E.g., to set N to 19:

    iqtree -s example.cf -m HKY+P+N19

Odd values of N allow the usage of the fast AVX instruction set.  This
results in a considerable decrease of runtime.

Level of polymorphism
-----------------------
<div class="hline"></div>

As of version `1.6`, IQ-TREE with PoMo also allows fixation of the
level of polymorphism which is usually referred to as /theta/,
/Watterson's theta/ or /4Nu/.  When analyzing population data, the
amount of polymorphism is inferred during maximization of the
likelihood.  However, in some situations it may be useful to set the
level of polymorphism to the observed value in the data (empirical
value):

    iqtree -s example.cf -m HKY+P{EMP}

or to set the level of polymorphism by hand, e.g.,:

    iqtree -s example.cf -m HKY+P{0.0025}
    
Together with the ability to set model parameters, the model can be
fully specified, e.g.:

    iqtree -s example.cf -m HKY{6.0}+P{0.0025}
    
This sets the transition to transversion ratio to a value of `6.0` and
the level of polymorphism to a value of `0.0025`.  In this case,
IQ-TREE only performs a tree search because the model is fully
specified.

Sampling method
---------------
<div class="hline"></div>

For advanced users.  PoMo offers two different methods to read in the
data ([Schrempf et al., 2016]).  Briefly, each population and site are
treated as follows

1. *Weighted* (default): assign the likelihood of each PoMo state to
its probability of leading to the observed data, assuming it is
binomially sampled.

2. *Sampled*: randomly draw N samples with replacement from the given
data.  The N picked samples constitute a PoMo state which will be
assigned a likelihood of 1.  All other PoMo states have likelihood 0.

- To use the *weighted* input method (default behavior):

        iqtree -s example.cf -m HKY+P+W

- To use the *sampled* input method:

        iqtree -s example.cf -m HKY+P+S

State frequency type
--------------------
<div class="hline"></div>

Similar to standard models, the state frequency type can be selected
with `+F` model string modifiers.  The default is to set the state
frequencies (i.e., the frequencies of the nucleotides A, C, G and T)
to the observed values in the data (empirical value).  To estimate the
allele frequencies together with the rate parameters during
maximization of the likelihood, use:

    iqtree -s example.cf -m GTR+P+FO

Rate heterogeneity
------------------
<div class="hline"></div>

Recently, PoMo allows inference with different rate categories.  As of
version `1.6`, only discrete Gamma rate heterogeneity is supported.
Please be aware, that for mathematical reasons, the runtime scales
linearly with the number of rate categories.  In the future, we plan
to decrease runtimes as well as implement more rate heterogeneity
types.  To use a discrete Gamma model with 4 rate categories, use:

    iqtree -s example.cf -m HKY+P+G4

Bootstrap branch support
------------------------
<div class="hline"></div>

Bootstrapping works as expected with PoMo.  The standard
non-parametric bootstrap is invoked by the `-b` option, e.g., for 100
replicates:

    iqtree -s example.cf -m HKY+P -b 100

To overcome the computational burden required by the non-parametric
bootstrap, IQ-TREE introduces an ultra fast bootstrap approximation
(UFBoot) that is orders of magnitude faster than the standard
procedure and provides relatively unbiased branch support values. To
run UFBoot, use the option `-bb`, e.g., for 1000 replicates:

    iqtree -s example.cf -m HKY+P -bb 1000

For a detailed description, please refer to the [bootstrap tutorial](Tutorial#assessing-branch-supports-with-ultrafast-bootstrap-approximation).

Interpretation of branch lengths
--------------------------------
<div class="hline"></div>

PoMo estimates the branch length in number of mutations and frequency
shifts (drift) per site.  The number of drift events compared to the
number of mutations becomes higher if
the [virtual population size](#virtual-population-size) is increased.
To get the branch length measured in number of substitutions per site
which enables a comparison to the branch length estimated by standard
DNA substitution models, it has to be divided by `N^2`.  PoMo also
outputs the total tree length measured in number of substitutions per
site in `example.cf.iqtree`.  An example of the relevant section:

    NOTE: The branch lengths of PoMo measure mutations and frequency shifts.
    To compare PoMo branch lengths to DNA substitution models use the tree length
    measured in substitutions per site.

    Total tree length (sum of branch lengths)
     - measured in number of mutations and frequency shifts per site: 0.71200751
     - measured in number of substitutions per site (divided by N^2): 0.00879022
    Sum of internal branch lengths
    - measured in mutations and frequency shifts per site: 0.01767814 (2.48285810% of tree length)
    - measured in substitutions per site: 0.01767814 (2.48285810% of tree length)

[Schrempf et al., 2016]: http://dx.doi.org/10.1016/j.jtbi.2016.07.042

