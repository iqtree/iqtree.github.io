<!--jekyll 
docid: 12
icon: book
doctype: manual
tags:
- manual
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
jekyll-->

**Po**lymorphism-aware phylogenetic **Mo**dels (PoMo) related documentation.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Counts files](#counts-files)
- [First running example](#first-running-example)
- [Substitution models](#substitution-models)
- [Virtual population size](#virtual-population-size)
- [Sampling method](#sampling-method)
- [Bootstrap branch support](#bootstrap-branch-support)
- [Interpretation of branch lengths](#interpretation-of-branch-lengths)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

The **Po**lymorphism-aware phylogenetic **Mo**del (PoMo) tries to use
population data (site frequency data) to improve phylogenetic
inference.  Thereby it builds on top of DNA substitution models and
naturally accounts for incomplete lineage sorting.  In order to run
PoMo, you need more sequences per species (ideally about ten
chromosomes) so that information about the site frequency spectrum is
available.

The binary of IQ-TREE with PoMo can be
[downloaded](https://github.com/Cibiv/IQ-TREE/releases/tag/v1.4.3-pomo)
or
[built from source](https://github.com/Cibiv/IQ-TREE/tree/v1.4.3-pomo).
Please confirm that your version of IQ-TREE supports PoMo.

    iqtree
    
    >> IQ-TREE PoMo version 1.4.3-pomo for Linux 64-bit built Jul  6 2016
    >> ...

>**TIP**: For a quick overview of all PoMo related options in IQ-TREE,
>run the command `iqtree -h` and scroll to the heading `POLYMORPHISM
>AWARE MODELS (PoMo)`.

If you use PoMo, please cite [Schrempf et al., 2016]:

    Dominik Schrempf, Bui Quang Minh, Nicola De Maio, Arndt von
    Haeseler, and Carolin Kosiol (2016) Reversible polymorphism-aware
    phylogenetic models and their application to tree inference.
    J. Theor. Biol., 407, 362–370.
    http://doi.org/10.1016/j.jtbi.2016.07.042.

Counts files
------------

The input of PoMo is allele frequency data.  Especially, when
populations have many individuals it is preferable to count the
number of bases at each position.  This decreases file size and speeds
up the parser.

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

You can now start to reconstruct a maximum-likelihood tree from this
alignment by entering (assuming that you are now in the same folder
with `example.cf`):

    iqtree -s example.cf

`-s` is the option to specify the name of the alignment file.  At the
end of the run IQ-TREE writes the same output files as in the standard
version (see [tutorial](Tutorial)).

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

By default, PoMo runs with the HKY model.  Different DNA substitution
models can be selected with the `-m` option.  E.g., to select the GTR
model, run IQ-TREE with:

    iqtree -s example.cf -m GTR

If a counts file is given as input file, the PoMo model will be
automatically chosen.  You can also explicitly specify to run the
(reversible) PoMo model with:

    iqtree -s example.cf -m GTR+rP


The frequency type can also be selected With `-m`.  The default is to
empirically estimate allele frequencies.  To estimate the allele
frequencies together with the rate parameters, use:

    iqtree -s example.cf -m GTR+rP+FO

>**TIP**: For a quick overview of all available models in IQ-TREE, run
>the command `iqtree -h` and scroll to the heading `POLYMORPHISM AWARE
>MODELS (PoMo)`.

Virtual population size
-----------------------

PoMo models the evolution of populations by means of a virtual
population of constant size N, which defaults to nine (for details,
see [Schrempf et al., 2016]).  The optimal choice of N depends on the
data.  If only very few chromosomes have been sequenced per population
(e.g., two to four), N should be lowered to five.  If enough data is
available and calculations are not too time consuming, we advise to
increase N up to a maximum of 19.  This can be done with the sequence
type option `-st`.  You can choose odd values from three to 19 as well
as two and ten.  E.g., to set N to 19:

    iqtree -s example.cf -st CF19

Odd values of N allows the usage of the fast AVX instruction set.
This results in a considerable decrease of runtime.

Sampling method
---------------

For advanced users.  PoMo offers two different methods to read in the
data ([Schrempf et al., 2016]). Briefly, each species and site are
treated as follows

1. *Weighted* (default): assign the likelihood of each PoMo state to
its probability of leading to the observed data, assuming it is
binomially sampled.

2. *Sampled*: randomly draw N samples with replacement from the given
data and set the PoMo state to the chosen one;

Again, the sequence type option `-st` can be used to change the input
method.

- To use the *sampled* input method (`R` for random):

        iqtree -s example.cf -st CR
        
- To use the *weighted* input method (default behavior; `CF` for
  counts file):

        iqtree -s example.cf -st CF
        
Bootstrap branch support
------------------------

To overcome the computational burden required by the non-parametric
bootstrap, IQ-TREE introduces an ultra fast bootstrap approximation
(UFBoot) that is orders of magnitude faster than the standard
procedure and provides relatively unbiased branch support values. To
run UFBoot, use the option `-bb`, e.g., for 1000 replicates:

    iqtree -s example.cf -bb 1000

The standard non-parametric bootstrap is invoked by the `-b` option,
e.g., for 100 replicates:

    iqtree -s example.cf -b 100

For a detailed description, please refer to the [bootstrap tutorial](Tutorial#assessing-branch-supports-with-ultrafast-bootstrap-approximation).

Interpretation of branch lengths
--------------------------------

PoMo estimates the branch length in number of mutations and frequency
shifts (drift) per site.  The number of drift events compared to the
number of mutations becomes higher if the
[virtual population size](#virtual-population-size) is increased.  To
get the branch length measured in number of substitutions per site which
enables a comparison to the branch length estimated by standard DNA
substitution models, it has to be divided by N^2.  PoMo also outputs
the total tree length measured in number of substitution per site in
`example.cf.iqtree`.  An example of the relevant section:

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
