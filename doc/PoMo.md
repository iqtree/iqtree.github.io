<!--jekyll 
docid: 40
icon: info-circle
doctype: manual
tags:
- manual
sections:
- name: Counts files
  url: counts-files
- name: First example
  url: first-running-example
- name: Tree length
  url: three-length
- name: Substitution models
  url: substitution-models
- name: Virtual population size
  url: virtual-population-size
- name: Sampling method
  url: sampling-method
- name: Bootstrap branch support
  url: bootstrap-branch-support
jekyll-->

**Po**lymoprhism-aware phylogenetic **Mo**dels (PoMo) related documentation.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Counts files](#counts-files)
- [First running example](#first-running-example)
- [Tree length](#tree-length)
- [Substitution models](#substitution-models)
- [Virtual population size](#virtual-population-size)
- [Sampling method](#sampling-method)
- [Bootstrap branch support](#bootstrap-branch-support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<!-- TODO link to PoMo executable. -->
Please confirm that your version of IQ-TREE supports PoMo.

    iqtree
    
    >> IQ-TREE PoMo version 1.5.0 for Linux 64-bit built Jul  6 2016
    >> ...

>**TIP**: For a quick overview of all PoMo related options in IQ-TREE,
>run the command `iqtree -h` and scroll to the heading `POLYMORPHISM
>AWARE MODELS (PoMo)`.

If you use PoMo, please cite

    Dominik Schrempf, Bui Quang Minh, Nicola De Maio, Arndt von Haeseler,
    and Carolin Kosiol (2016) Reversible polymorphism-aware phylogenetic
    models and their application to tree inference. J. Theor. Biol., in
    press.
    
A preprint is available on bioRxiv: [Schrempf et al., 2016].

Counts files
------------

The input of PoMo is allele frequency data.  Especially, when
populations have many individuals it is preferrable to count the
number of bases at each position.  This decreases file size and speeds
up the parser.

Counts files contain:

- One headerline that specifies the file as counts file and states the
  number of populations as well as the number of sites (tab
  separated).

- A second headerline with tab separated headers: CRHOM (chromosome),
  POS (position) and sequence names.
   
- Many lines with counts of A, C, G and T bases and their respective
  positions.

Comments:

- Lines starting with # before the first headerline are treated as
  comments.

An example:

    COUNTSFILE   \t NPOP 5  \t NSITES N
    CHROM \t POS \t Sheep   \t BlackSheep \t RedSheep \t Wolf    \t RedWolf
    1  \t s      \t 0,0,1,0 \t 0,0,1,0    \t 0,0,1,0  \t 0,0,5,0 \t 0,0,0,1
    1  \t s + 1  \t 0,0,0,1 \t 0,0,0,1    \t 0,0,0,1  \t 0,0,0,5 \t 0,0,0,1
    .
    .
    .
    9  \t 8373   \t 0,0,0,1 \t 1,0,0,0    \t 0,1,0,0  \t 0,1,4,0 \t 0,0,1,0
    .
    .
    .
    Y  \t end    \t 0,0,0,1 \t 0,1,0,0    \t 0,1,0,0  \t 0,5,0,0 \t 0,0,1,0

First running example
---------------------

The download includes an example alignment called `example.cf` in
counts file format (so far, PoMo only supports counts files).  You can
now start to reconstruct a maximum-likelihood tree from this alignment
by entering (assuming that you are now in the same folder with
`example.cf`):

    iqtree -s example.cf

`-s` is the option to specify the name of the alignment file.  At the
end of the run IQ-TREE writes several output files.  Among others:

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

Tree length
-----------

PoMo estimates the tree length in number of mutations and frequency
shifts (drift) per site.  Number number of drift events compared to
the number of mutations becomes higher if the
[virtual population size](#virtual-population-size) is increased.  To
get the tree length measured in number of substitutions per site which
enables a comparison to the tree length estimated by standard DNA
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


Substitution models
-------------------

By default, PoMo runs with the HKY model.  Different DNA substitution
models can be selected with the `-m` option.  E.g., to select the GTR
model, run IQ-TREE with:

    iqtree -s example.cf -m GTR

If a counts file is given as input file, the PoMo model will be
automatically chosen.  You can also explicitely specify to run the
(reversible) PoMo model with:

    iqtree -s example.cf -m GTR+rP


The frequency tupe can also be selected With `-m`.  The default is to
empirically estimate allele frequencies.  To estimate the allele
frequencies together with the rate parameters, use:

    iqtree -s example.cf -m GTR+rP+FO

>**TIP**: For a quick overview of all available models in IQ-TREE, run
>the command `iqtree -h` and scroll to the heading `POLYMORPHISM AWARE
>MODELS (PoMo)`.

Virtual population size
-----------------------

The default virtual population size (which will be denoted N) is nine.
The optimal N depends on the data.  If only very few chromosomes have
been sequenced per population (e.g., two to four), N should be lowered
to five.  If enough data is available and calculations are not too
time consuming, we advise to increase N up to a maximum of 19.  This
can be done with the sequence type option `-st`.  You can choose odd
values from three to 19 as well as two and ten.  E.g., to set N to 19:

    iqtree -s example.cf -st CF19

Odd values of N ensure that the number of states is divisible by four
which allows usage of the fast AVX instruction set.  This results in a
considerable decrease of runtime.

Sampling method
---------------

For advanced users.  PoMo offers two different methods to read in the
data.  For a detailed description, please refer to
[Schrempf et al., 2016].  Again, the sequence type option `-st` can be
used to change the input method.

- To use the *sampled* input method (`R` for random):

        iqtree -s example.cf -st CR
        
- To use the *weighted* input method (default behavior; `CF` for
  counts file):

        iqtree -s example.cf -st CF
        

Bootstrap branch support
------------------------

To overcome the computational burden required by the nonparametric
bootstrap, IQ-TREE introduces an ultrafast bootstrap approximation
(UFBoot) that is orders of magnitude faster than the standard
procedure and provides relatively unbiased branch support values. To
run UFBoot, use the option `-bb`, e.g., for 1000 replicates:

    iqtree -s example.cf -bb 1000

The standard nonparametric bootstrap is invoked by the `-b` option,
e.g., for 100 replicates:

    iqtree -s example.cf -b 100

For a detailed description, please refer to the [bootstrap tutorial].


[bootstrap tutorial]: Tutorial#assessing-branch-supports-with-ultrafast-bootstrap-approximation
[Schrempf et al., 2016]: http://dx.doi.org/10.1101/048496
