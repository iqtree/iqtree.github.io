---
layout: userdoc
title: "Substitution Models"
author: Hector Banos, Cuong Cao Dang, Heiko Schmidt, Jana Trifinopoulos, Minh Bui, Nhan Ly-Trong, Hiroaki Sato
date:    2024-05-26
docid: 10
icon: book
doctype: manual
tags:
- manual
description: All common substitution models and usages.
sections:
- name: DNA models
  url: dna-models
- name: Protein models
  url: protein-models
- name: Codon models
  url: codon-models
- name: Binary, morphological models
  url: binary-and-morphological-models
- name: Ascertainment bias correction
  url: ascertainment-bias-correction
- name: Rate heterogeneity across sites
  url: rate-heterogeneity-across-sites
---

Substitution models
===================

All common substitution models and usages.
<!--more-->


IQ-TREE supports a wide range of substitution models, including advanced partition and mixture models. This guide gives a detailed information of all available models.

>**TIP**: If you do not know which model to use, simply run IQ-TREE with the standard model selection (`-m TEST` option) or the new ModelFinder (`-m MFP`). It automatically determines best-fit model for your data.
{: .tip}


DNA models
----------
<div class="hline"></div>

### Base substitution rates

IQ-TREE includes all common DNA models (ordered by complexity):

| Model        | df | Explanation | Code |
|--------------|----|---------------------------------------------------------------|--------|
| JC or JC69   | 0 | Equal substitution rates and equal base frequencies ([Jukes and Cantor, 1969]). | 000000 |
| F81          | 3 | Equal rates but unequal base freq. ([Felsenstein, 1981]). | 000000 |
| K80 or K2P   | 1 | Unequal transition/transversion rates and equal base freq. ([Kimura, 1980]). | 010010 |
| HKY or HKY85 | 4 | Unequal transition/transversion rates and unequal base freq. ([Hasegawa, Kishino and Yano, 1985]). | 010010 |
| TN or TN93   | 5 | Like `HKY` but unequal purine/pyrimidine rates ([Tamura and Nei, 1993]). | 010020 |
| TNe          | 2 | Like `TN` but equal base freq. | 010020 |
| K81 or K3P   | 2 | Three substitution types model and equal base freq. ([Kimura, 1981]). | 012210 |
| K81u         | 5 | Like `K81` but unequal base freq. | 012210 |
| TPM2         | 2 | AC=AT, AG=CT, CG=GT and equal base freq. | 010212 |
| TPM2u        | 5 | Like `TPM2` but unequal base freq. | 010212 |
| TPM3         | 2 | AC=CG, AG=CT, AT=GT and equal base freq. | 012012 |
| TPM3u        | 5 | Like `TPM3` but unequal base freq. | 012012 |
| TIM          | 6 | Transition model, AC=GT, AT=CG and unequal base freq. | 012230 |
| TIMe         | 3 | Like `TIM` but equal base freq. | 012230 |
| TIM2         | 6 | AC=AT, CG=GT and unequal base freq. | 010232 |
| TIM2e        | 3 | Like `TIM2` but equal base freq. | 010232 |
| TIM3         | 6 | AC=CG, AT=GT and unequal base freq. | 012032 |
| TIM3e        | 3 | Like `TIM3` but equal base freq. | 012032 |
| TVM          | 7 | Transversion model, AG=CT and unequal base freq. | 012314 |
| TVMe         | 4 | Like `TVM` but equal base freq. | 012314 |
| SYM          | 5 | Symmetric model with unequal rates but equal base freq. ([Zharkikh, 1994]). | 012345 |
| GTR          | 8 | General time reversible model with unequal rates and unequal base freq. ([Tavare, 1986]). | 012345 |

The last column `Code` is a 6-digit code defining the equality constraints for 6 *relative* substitution rates: A-C, A-G, A-T, C-G, C-T and G-T. `010010` means that A-G rate is equal to C-T rate (corresponding to `1` in the code) and the remaining four substitution rates are equal (corresponding to `0` in the code). Thus, `010010` is equivalent to K80 or HKY model (depending on whether base frequencies are equal or not). `012345` is equivalent to GTR or SYM model as there is no restriction defined by such 6-digit code.

Moreover, IQ-TREE supports arbitrarily restricted DNA model via a 6-digit code, e.g. with option `-m 012012+G`.

>**NOTE**: The digits in the codes do not necessarily have to have the same order as above. That means '101101' describes the same matrix as '010010'. The last rate, which corresponds to G-T, (and all rates with the same digit) is always set equal to 1.0 for convenience because the rates are relative.

If users want to fix model parameters, append the model name with a curly bracket `{`, followed by the comma-separated rate parameters, and a closing curly bracket `}`. For example, `GTR{1.0,2.0,1.5,3.7,2.8}` specifies 6 substitution rates A-C=1.0, A-G=2.0, A-T=1.5, C-G=3.7, C-T=2.8 and G-T=1.0. 

Another example is for model `TIM2` that has the 6-digit code `010232`. Thus, `TIM2{4.39,5.30,12.1}` means that A-C=A-T=4.39 (coded `0`), A-G=5.30 (coded `1`), C-T=12.1 (coded `3`) and C-G=G-T=1.0 (coded `2`). This is, in turn, equivalent to specifying `GTR{4.39,5.30,4.39,1.0,12.1}`.


### Base frequencies

Users can specify three different kinds of base frequencies:

| FreqType | Explanation |
|----------|------------------------------------------------------------------------|
| +F  | Empirical base frequencies. This is the default if the model has unequal base freq. In AliSim, if users neither specify base frequencies nor supply an input alignment, AliSim will generate base frequencies from empirical distributions. |
| +FQ | Equal base frequencies.|
| +FO |  Optimized base frequencies by maximum-likelihood.|

For example, `GTR+FO` optimizes base frequencies by ML whereas `GTR+F` (default) counts base frequencies directly from the alignment.

Finally, users can fix base frequencies with e.g. `GTR+F{0.1,0.2,0.3,0.4}` to fix the corresponding frequencies of A, C, G and T (must sum up to 1.0).


### Lie Markov models

Starting with version 1.6, IQ-TREE supports a series of Lie Markov models ([Woodhams et al., 2015]), many of which are non-reversible models. Lie Markov models have a consistent property, which is lacking in other common models such as GTR. The following table shows the list of all Lie Markov models (the number before `.` in the name shows the number of parameters of the model):

| Model  | Rev? | Freq | Note |
|--------|------|------|--------------------------------------|
| 1.1    | Yes  | 0    | equiv. to JC  |
| 2.2b   | Yes  | 0    | equiv. to K2P |
| 3.3a   | Yes  | 0    | equiv. to K3P |
| 3.3b   | No   | 0    |  |
| 3.3c   | Yes  | 0    | equiv. to TNe |
| 3.4    | Yes  | 1    |  |
| 4.4a   | Yes  | 3    | equiv. to F81 |
| 4.4b   | Yes  | 1    |  |
| 4.5a   | No   | 1    |  |
| 4.5b   | No   | 1    |  |
| 5.6a   | No   | 0    |  | 
| 5.6b   | No   | 3    |  |
| 5.7a   | No   | 2    |  |
| 5.7b   | No   | 0    |  |
| 5.7c   | No   | 0    |  |
| 5.11a  | No   | 2    |  |
| 5.11b  | No   | 0    |  |
| 5.11c  | No   | 0    |  |
| 5.16   | No   | 1    |  |
| 6.6    | No   | 1    | equiv. to STRSYM for strand-symmetric model ([Bielawski and Gold, 2002]) |
| 6.7a   | No   | 3    | F81+K3P |
| 6.7b   | No   | 3    |  |
| 6.8a   | No   | 3    |  |
| 6.8b   | No   | 1    |  |
| 6.17a  | No   | 1    |  |
| 6.17b  | No   | 1    |  |
| 8.8    | No   | 3    |  |
| 8.10a  | No   | 3    |  |
| 8.10b  | No   | 1    |  |
| 8.16   | No   | 3    |  |
| 8.17   | No   | 3    |  |
| 8.18   | No   | 3    |  |
| 9.20a  | No   | 2    |  |
| 9.20b  | No   | 0    | Doubly stochastic |
| 10.12  | No   | 3    |  |
| 10.34  | No   | 3    |  |
| 12.12  | No   | 3    | equiv. to UNREST (unrestricted model) |

Column __Rev?__ shows whether the model is reversible or not. Column __Freq__ shows the number of free base frequencies. 0 means equal base frequency; 1 means f(A)=f(G) and f(C)=f(T); 2 means f(A)+f(G)=0.5=f(C)+f(T); 3 means unconstrained frequencies.

All Lie Markov models can have one of the following prefices:

| Prefix | Meaning |
|--------|-------------------------------------|
| RY     | purine-pyrimidine pairing (default) |
| WS     | weak-strong pairing |
| MK     | aMino-Keto pairing |


Protein models
--------------
<div class="hline"></div>

### Amino-acid exchange rate matrices

IQ-TREE supports all common empirical amino-acid exchange rate matrices (alphabetical order):

| Model | Region | Explanation |
|-------|--------|---------------------------------------------------------------|
| Blosum62 | nuclear | BLOcks SUbstitution Matrix ([Henikoff and Henikoff, 1992]). Note that `BLOSUM62` is not recommended for phylogenetic analysis as it was designed mainly for sequence alignments. |
| cpREV    | chloroplast |chloroplast matrix ([Adachi et al., 2000]). |
| Dayhoff  | nuclear | General matrix ([Dayhoff et al., 1978]). |
| DCMut    | nuclear | Revised `Dayhoff` matrix ([Kosiol and Goldman, 2005]). |
| EAL      | nuclear | General matrix. To be used with profile mixture models (for eg. EAL+C60) for reconstructing relationships between eukaryotes and Archaea ([Banos et al., 2024]). |
| ELM      | nuclear | General matrix. To be used with profile mixture models (for eg. ELM+C60) for phylogenetic analysis of proteins encoded by nuclear genomes of eukaryotes ([Banos et al., 2024]).|
| FLAVI    | viral | Flavivirus ([Le and Vinh, 2020]). | 
| FLU      | viral | Influenza virus ([Dang et al., 2010]). |
| GTR20    | general | General time reversible models with 190 rate parameters. *WARNING: Be careful when using this parameter-rich model as parameter estimates might not be stable, especially when not having enough phylogenetic information (e.g. not long enough alignments).* |
| HIVb     | viral | HIV between-patient matrix HIV-B<sub>m</sub> ([Nickle et al., 2007]). |
| HIVw     | viral | HIV within-patient matrix HIV-W<sub>m</sub> ([Nickle et al., 2007]). |
| JTT      | nuclear | General matrix ([Jones et al., 1992]). |
| JTTDCMut | nuclear | Revised `JTT` matrix ([Kosiol and Goldman, 2005]). |
| LG       | nuclear | General matrix ([Le and Gascuel, 2008]). |
| mtART    | mitochondrial | Mitochondrial Arthropoda ([Abascal et al., 2007]). |
| mtMAM    | mitochondrial | Mitochondrial Mammalia ([Yang et al., 1998]). |
| mtREV    | mitochondrial | Mitochondrial Vertebrate ([Adachi and Hasegawa, 1996]). |
| mtZOA    | mitochondrial | Mitochondrial Metazoa (Animals) ([Rota-Stabelli et al., 2009]). |
| mtMet    | mitochondrial | Mitochondrial Metazoa ([Vinh et al., 2017]). |
| mtVer    | mitochondrial | Mitochondrial Vertebrate ([Vinh et al., 2017]). |
| mtInv    | mitochondrial | Mitochondrial Inverterbrate ([Vinh et al., 2017]). |
| NQ.bird   | nuclear | Non-reversible Q matrix ([Dang et al., 2022]) estimated for birds ([Jarvis et al., 2015]). | 
| NQ.insect | nuclear | Non-reversible Q matrix ([Dang et al., 2022]) estimated for insects ([Misof et al., 2014]). | 
| NQ.mammal | nuclear | Non-reversible Q matrix ([Dang et al., 2022]) estimated for mammals ([Wu et al., 2018]). | 
| NQ.pfam   | nuclear | General non-reversible Q matrix ([Dang et al., 2022]) estimated from Pfam version 31 database ([El-Gebali et al., 2018]). | 
| NQ.plant  | nuclear | Non-reversible Q matrix ([Dang et al., 2022]) estimated for plants ([Ran et al., 2018]). | 
| NQ.yeast  | nuclear | Non-reversible Q matrix ([Dang et al., 2022]) estimated for yeasts ([Shen et al., 2018]). | 
| Poisson  | none | Equal amino-acid exchange rates and frequencies. |
| PMB      | nuclear | Probability Matrix from Blocks, revised `BLOSUM` matrix ([Veerassamy et al., 2004]). |
| Q.bird   | nuclear | Q matrix ([Minh et al., 2021]) estimated for birds ([Jarvis et al., 2015]). | 
| Q.insect | nuclear | Q matrix ([Minh et al., 2021]) estimated for insects ([Misof et al., 2014]). | 
| Q.mammal | nuclear | Q matrix ([Minh et al., 2021]) estimated for mammals ([Wu et al., 2018]). | 
| Q.pfam   | nuclear | General Q matrix ([Minh et al., 2021]) estimated from Pfam version 31 database ([El-Gebali et al., 2018]). | 
| Q.plant  | nuclear | Q matrix ([Minh et al., 2021]) estimated for plants ([Ran et al., 2018]). | 
| Q.yeast  | nuclear | Q matrix ([Minh et al., 2021]) estimated for yeasts ([Shen et al., 2018]). | 
| rtREV    | viral | Retrovirus ([Dimmic et al., 2002]). |
| VT       | nuclear | General 'Variable Time' matrix ([Mueller and Vingron, 2000]). |
| WAG      | nuclear | General matrix ([Whelan and Goldman, 2001]). |

### Protein mixture models

IQ-TREE also supports a series of protein mixture models:

| Model | Explanation |
|------------|------------------------------------------------------------------------|
| C10 to C60 | 10, 20, 30, 40, 50, 60-profile mixture models ([Le et al., 2008a]) as variants of the CAT model ([Lartillot and Philippe, 2004]) for ML. Note that these models assume `Poisson` AA replacement and implicitly include a [Gamma rate heterogeneity among sites](#rate-heterogeneity-across-sites).
| EX2        | Two-matrix model for exposed/buried AA sites ([Le et al., 2008b]).
| EX3        | Three-matrix model for highly exposed/intermediate/buried AA sites ([Le et al., 2008b]).
| EHO        | Three-matrix model for extended/helix/other sites ([Le et al., 2008b]).
| UL2, UL3   | Unsupervised-learning variants of `EX2` and `EX3`, respectively.
| EX_EHO     | Six-matrix model combining `EX2` and `EHO` ([Le and Gascuel, 2010]).
| LG4M       | Four-matrix model fused with [Gamma rate heterogeneity](#rate-heterogeneity-across-sites) ([Le et al., 2012]).
| LG4X       | Four-matrix model fused with [FreeRate heterogeneity](#rate-heterogeneity-across-sites) ([Le et al., 2012]).
| CF4        | Five-profile mixture model ([Wang et al., 2008]).

One can even combine a protein matrix with a profile mixture model like:

* `LG+C20`: Applying `LG` matrix instead of `Poisson` for all 20 classes of AA profiles and a Gamma rate heterogeneity.
* `LG+C20+F`: Applying `LG` matrix for 20 classes plus the 21th class of empirical AA profile (counted from the current data) and Gamma rate heterogeneity.
* `JTT+CF4+G`: Applying `JTT` matrix for all 5 classes of AA profiles and Gamma rate heteorogeneity.

Moreover, one can override the Gamma rate by FreeRate heterogeneity:

* `LG+C20+R4`: Like `LG+C20` but replace Gamma by FreeRate heterogeneity.

### User-defined empirical protein models

If the matrix name does not match any of the above listed models, IQ-TREE assumes that it is a file containing AA exchange rates and frequencies in PAML format. It contains the lower diagonal part of the matrix and 20 AA frequencies, e.g.:

    0.425093 
    0.276818 0.751878 
    0.395144 0.123954 5.076149 
    2.489084 0.534551 0.528768 0.062556 
    0.969894 2.807908 1.695752 0.523386 0.084808 
    1.038545 0.363970 0.541712 5.243870 0.003499 4.128591 
    2.066040 0.390192 1.437645 0.844926 0.569265 0.267959 0.348847 
    0.358858 2.426601 4.509238 0.927114 0.640543 4.813505 0.423881 0.311484 
    0.149830 0.126991 0.191503 0.010690 0.320627 0.072854 0.044265 0.008705 0.108882 
    0.395337 0.301848 0.068427 0.015076 0.594007 0.582457 0.069673 0.044261 0.366317 4.145067 
    0.536518 6.326067 2.145078 0.282959 0.013266 3.234294 1.807177 0.296636 0.697264 0.159069 0.137500 
    1.124035 0.484133 0.371004 0.025548 0.893680 1.672569 0.173735 0.139538 0.442472 4.273607 6.312358 0.656604 
    0.253701 0.052722 0.089525 0.017416 1.105251 0.035855 0.018811 0.089586 0.682139 1.112727 2.592692 0.023918 1.798853 
    1.177651 0.332533 0.161787 0.394456 0.075382 0.624294 0.419409 0.196961 0.508851 0.078281 0.249060 0.390322 0.099849 0.094464 
    4.727182 0.858151 4.008358 1.240275 2.784478 1.223828 0.611973 1.739990 0.990012 0.064105 0.182287 0.748683 0.346960 0.361819 1.338132 
    2.139501 0.578987 2.000679 0.425860 1.143480 1.080136 0.604545 0.129836 0.584262 1.033739 0.302936 1.136863 2.020366 0.165001 0.571468 6.472279 
    0.180717 0.593607 0.045376 0.029890 0.670128 0.236199 0.077852 0.268491 0.597054 0.111660 0.619632 0.049906 0.696175 2.457121 0.095131 0.248862 0.140825 
    0.218959 0.314440 0.612025 0.135107 1.165532 0.257336 0.120037 0.054679 5.306834 0.232523 0.299648 0.131932 0.481306 7.803902 0.089613 0.400547 0.245841 3.151815 
    2.547870 0.170887 0.083688 0.037967 1.959291 0.210332 0.245034 0.076701 0.119013 10.649107 1.702745 0.185202 1.898718 0.654683 0.296501 0.098369 2.188158 0.189510 0.249313 

    0.079066 0.055941 0.041977 0.053052 0.012937 0.040767 0.071586 0.057337 0.022355 0.062157 0.099081 0.064600 0.022951 0.042302 0.044040 0.061197 0.053287 0.012066 0.034155 0.069147 

(This is an example of an LG matrix taken from [PAML package](http://abacus.gene.ucl.ac.uk/software/paml.html)).
Note that the amino-acid order in this file is:

     A   R   N   D   C   Q   E   G   H   I   L   K   M   F   P   S   T   W   Y   V
    Ala Arg Asn Asp Cys Gln Glu Gly His Ile Leu Lys Met Phe Pro Ser Thr Trp Tyr Val


### Amino-acid frequencies

By default, AA frequencies are given by the model. Users can change this with:

| FreqType | Explanation |
|----------|-------------|
| +F       | empirical AA frequencies from the data. In AliSim, if users neither specify the base frequencies nor supply an input alignment, AliSim will randomly generate the base frequencies from Uniform distribution.|
| +FO      | ML optimized AA frequencies from the data.|
| +FQ      | Equal AA frequencies.|

Users can also specify AA frequencies with, e.g.:
    
    +F{0.079066,0.055941,0.041977,0.053052,0.012937,0.040767,0.071586,0.057337,0.022355,0.062157,0.099081,0.064600,0.022951,0.042302,0.044040,0.061197,0.053287,0.012066,0.034155,0.069147}

(Example corresponds to the AA frequencies of the LG matrix).


Codon models
------------
<div class="hline"></div>

To apply a codon model one should use the option `-st CODON` to tell IQ-TREE that the alignment contains protein coding sequences (otherwise, IQ-TREE thinks that it contains DNA sequences and will apply DNA models). This implicitly applies the standard genetic code. You can change to an other genetic code by appending the appropriate ID to the `CODON` keyword:

| Code    | Genetic code meaning |
|---------|------------------------------------------------------------------------|
| CODON1  | The Standard Code (same as `-st CODON`)|
| CODON2  | The Vertebrate Mitochondrial Code |
| CODON3  | The Yeast Mitochondrial Code |
| CODON4  | The Mold, Protozoan, and Coelenterate Mitochondrial Code and the Mycoplasma/Spiroplasma Code |
| CODON5  | The Invertebrate Mitochondrial Code |
| CODON6  | The Ciliate, Dasycladacean and Hexamita Nuclear Code |
| CODON9  | The Echinoderm and Flatworm Mitochondrial Code |
| CODON10 | The Euplotid Nuclear Code |
| CODON11 | The Bacterial, Archaeal and Plant Plastid Code |
| CODON12 | The Alternative Yeast Nuclear Code |
| CODON13 | The Ascidian Mitochondrial Code |
| CODON14 | The Alternative Flatworm Mitochondrial Code |
| CODON16 | Chlorophycean Mitochondrial Code |
| CODON21 | Trematode Mitochondrial Code |
| CODON22 | Scenedesmus obliquus Mitochondrial Code |
| CODON23 | Thraustochytrium Mitochondrial Code |
| CODON24 | Pterobranchia Mitochondrial Code |
| CODON25 | Candidate Division SR1 and Gracilibacteria Code |

(The IDs follow the specification at <http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi>).

### Codon substitution rates

IQ-TREE supports several codon models:

| Model            | Explanation |
|------------------|------------------------------------------------------------------------|
| MG               | Nonsynonymous/synonymous (dn/ds) rate ratio ([Muse and Gaut, 1994]).
| MGK              | Like `MG` with additional transition/transversion (ts/tv) rate ratio.
| MG1KTS or MGKAP2 | Like `MG` with a transition rate ([Kosiol et al., 2007]).
| MG1KTV or MGKAP3 | Like `MG` with a transversion rate ([Kosiol et al., 2007]).
| MG2K or MGKAP4   | Like `MG` with a transition rate and a transversion rate ([Kosiol et al., 2007]).
| GY               | Nonsynonymous/synonymous and transition/transversion rate ratios ([Goldman and Yang, 1994]).
| GY1KTS or GYKAP2 | Like `GY` with a transition rate ([Kosiol et al., 2007]).
| GY1KTV or GYKAP3 | Like `GY` with a transversion rate ([Kosiol et al., 2007]).
| GY2K or GYKAP4   | Like `GY` with a transition rate and a transversion rate ([Kosiol et al., 2007]).
| ECMK07 or KOSI07 | Empirical codon model ([Kosiol et al., 2007]).
| ECMrest          | Restricted version of `ECMK07` that allows only one nucleotide exchange.
| ECMS05 or SCHN05 | Empirical codon model ([Schneider et al., 2005]).

Users could specify the model parameters (e.g., Nonsynonymous/synonymous (dn/ds) rate ratio, and/or transition/transversion (ts/tv) rate ratio, and/or transition rate, and/or a transversion rate) by `<Model_Name>{<omega>,[<kappa>],[<kappa2>]}`. For example, `MG2K{1.0,0.3,0.5}` specifies the nonsynonymous/synonymous (dn/ds) rate ratio, the transition rate, and the transversion rate are 1.0, 0.3, 0.5, respectively. The number of input parameters depends on the definition of each model.

The last three models (`ECMK07`, `ECMrest` or `ECMS05`) are called *empirical* codon models, whereas the others are called *mechanistic* codon models.

Moreover, IQ-TREE supports combined empirical-mechanistic codon models using an underscore separator (`_`). For example:

* `ECMK07_GY2K`: The combined `ECMK07` and `GY2K` model, with the rate entries being multiplication of the two corresponding rate matrices.

Thus, there can be many such combinations.

**Starting with version 1.5.6:** If the model name does not match any of the above listed models, IQ-TREE assumes that it is a file containing lower diagonal part of non-stop codon exchange rate matrix, non-stop codon frequencies and a list of non-stop codons. The rest of the file will be ignored. Example files (ECMrest.dat and ECMunrest.dat) can be downloaded from the supplementary material ([Kosiol et al., 2007]).


>**NOTE**: Branch lengths under codon models are interpreted as number of nucleotide substitutions per codon site. Thus, they are typically 3 times longer than under DNA models.


### Codon frequencies

IQ-TREE supports the following codon frequencies:

| FreqType | Explanation |
|----------|------------------------------------------------------------------------|
| +F       | Empirical codon frequencies counted from the data. In AliSim, if users neither specify base frequencies nor supply an input alignment, AliSim will generate base frequencies from empirical distributions.|
| +FQ      | Equal codon frequencies.|
| +F1X4    | Unequal nucleotide frequencies but equal nt frequencies over three codon positions. In AliSim, if users don't supply an input alignment, the base frequencies are randomly generated based on empirical distributions, or users could specify the frequencies via `+F1X4{<freq_0>,...,<freq_4>}`.|
| +F3X4    | Unequal nucleotide frequencies and unequal nt frequencies over three codon positions. In AliSim, if users don't supply an input alignment, the base frequencies are randomly generated based on empirical distributions, or users could specify the frequencies via  `+F3X4{<freq_0>,...,<freq_11>}`|

If not specified, the default codon frequency will be `+F3X4` for `MG`-type models, `+F` for `GY`-type models and given by the model for empirical codon models. 


Binary and morphological models
-------------------------------
<div class="hline"></div>

The binary alignments should contain state `0` and `1`, whereas for morphological data, the valid states are `0` to `9` and `A` to `Z`.

| Model      | Explanation |
|------------|------------------------------------------------------------------------|
| JC2        | Jukes-Cantor type model for binary data.|
| GTR2       | General time reversible model for binary data.|
| MK         | Jukes-Cantor type model for morphological data with equal rates.|
| GTRX (GTR) | General time reversible model for morphological (or rather, multistate; **see the warning below**) data with unequal rates.|
| ORDERED    | Allowing exchange of neighboring states only.|

Except for `GTR2` that has unequal state frequencies, all other models have equal state frequencies. Users can change how state frequencies are modeled in morphological models by appending `+FQ`, `+F`, `+F{...}`, or `+FO`.

> **WARNING**: Models with unequal rates and/or frequencies (e.g., `GTR2+FO`, `MK+FO`, `GTRX+FQ`, `GTRX+FO`) should **never** be applied to general morphological characters (transformational morphological characters; for the term, see [Sereno, 2007]) as their state labels are fundamentally arbitrary. These models are for data with non-arbitrary state labels (e.g., recoded amino acids [for practical application, see [Najle et al., 2023]; [xgrau/recoded-mixture-models]] and certain types of genomic information). For morphological data, it is the common practice to apply the `MK+FQ` model with or without rate heterogeneity across characters parameters.

> **WARNING**: If you use `GTRX` for your multistate data, because of its sometimes very great number of free parameters, please make sure your data are sufficiently large and always test for model fit.


> **TIP**: For binary morphological characters where `0`s represent ancestral conditions and `1`s represent derived conditions, mainly neomorphic (`absent`/`present`) morphological characters (for the term, see [Sereno, 2007]), applying the `GTR2` model, with unequal state frequencies, would make sense (see e.g. [Pyron, 2017]; [Sun et al., 2018]; https://ms609.github.io/hyoliths/bayesian.html). This analytical condition is called the MkA model ([Pyron, 2017]).
{: .tip}

>**TIP**: If morphological alignments do not contain constant sites (typically the case), then [an ascertainment bias correction model (`+ASC`)](#ascertainment-bias-correction) should be applied to correct the branch lengths for the absence of constant sites.
{: .tip}


Ascertainment bias correction
-----------------------------
<div class="hline"></div>

An ascertainment bias correction (`+ASC`) model ([Lewis, 2001]) should be applied if the alignment does not contain constant sites (such as morphological or SNPs data). For example:

* `MK+ASC`: For morphological data.
* `GTR+ASC`: For SNPs data.

`+ASC` will correct the likelihood conditioned on variable sites. Without `+ASC`, the branch lengths might be overestimated.


Rate heterogeneity across sites
-------------------------------
<div class="hline"></div>

IQ-TREE supports all common rate heterogeneity across sites models:

| RateType | Explanation |
|----------|------------------------------------------------------------------------|
| +I       | allowing for a proportion of invariable sites. |
| +G       | discrete Gamma model ([Yang, 1994]) with default 4 rate categories. The number of categories can be changed with e.g. `+G8`. |
| +GC       | continuous Gamma model ([Yang, 1994]) (for AliSim only). |
| +I+G     | invariable site plus discrete Gamma model ([Gu et al., 1995]). |
| +R       | FreeRate model ([Yang, 1995]; [Soubrier et al., 2012]) that generalizes the `+G` model by relaxing the assumption of Gamma-distributed rates. The number of categories can be specified with e.g. `+R6` (default 4 categories if not specified). The FreeRate model typically fits data better than the `+G` model and is recommended for analysis of large data sets. |
| +I+R     | invariable site plus FreeRate model. |

>**TIP**: The new ModelFinder (`-m MFP` option) tests the FreeRate model, whereas the standard procedure (`-m TEST`) does not.
{: .tip}

Users can fix the parameters of the model. For example, `+I{0.2}` will fix the proportion of invariable sites (pinvar) to 0.2; `+G{0.9}` will fix the Gamma shape parameter (alpha) to 0.9; `+I{0.2}+G{0.9}` will fix both pinvar and alpha. To fix the FreeRate model parameters, use the syntax `+Rk{w1,r1,...,wk,rk}` (replacing `k` with the number of categories). Here, `w1, ..., wk` are the weights and `r1, ..., rk` the rates for each category. 

>**NOTE**: For the `+G` model IQ-TREE implements the _mean_ approximation approach ([Yang, 1994]). The same is done in RAxML and PhyML. However, some programs like TREE-PUZZLE implement the _median_ approximation approach, which makes the resulting log-likelihood not comparable. IQ-TREE can change to this approach via the `-gmedian` option.



[Abascal et al., 2007]: https://doi.org/10.1093/molbev/msl136
[Adachi and Hasegawa, 1996]: https://doi.org/10.1007/BF02498640
[Adachi et al., 2000]: https://doi.org/10.1007/s002399910038
[Banos et al., 2024]: https://doi.org/10.1101/2024.03.29.587376
[Bielawski and Gold, 2002]: https://doi.org/10.1093/genetics/161.4.1589
[Dang et al., 2010]: https://doi.org/10.1186/1471-2148-10-99
[Dang et al., 2022]: https://doi.org/10.1093/sysbio/syac007
[Dayhoff et al., 1978]: http://compbio.berkeley.edu/class/c246/Reading/dayhoff-1978-apss.pdf
[Dimmic et al., 2002]: https://doi.org/10.1007/s00239-001-2304-y
[El-Gebali et al., 2018]: https://doi.org/10.1093/nar/gky995
[Felsenstein, 1981]: https://doi.org/10.1007%2FBF01734359
[Goldman and Yang, 1994]: http://mbe.oxfordjournals.org/content/11/5/725.abstract
[Gu et al., 1995]: http://mbe.oxfordjournals.org/content/12/4/546.abstract
[Hasegawa, Kishino and Yano, 1985]: https://dx.doi.org/10.1007%2FBF02101694
[Henikoff and Henikoff, 1992]: https://dx.doi.org/10.1073%2Fpnas.89.22.10915
[Jarvis et al., 2015]: https://doi.org/10.1186/s13742-014-0038-1
[Jones et al., 1992]: https://dx.doi.org/10.1093%2Fbioinformatics%2F8.3.275
[Jukes and Cantor, 1969]: http://doi.org/10.1016/B978-1-4832-3211-9.50009-7
[Kimura, 1980]: https://doi.org/10.1007%2FBF01731581
[Kimura, 1981]: https://doi.org/10.1073/pnas.78.1.454
[Kosiol and Goldman, 2005]: https://doi.org/10.1093/molbev/msi005
[Kosiol et al., 2007]: https://doi.org/10.1093/molbev/msm064
[Lartillot and Philippe, 2004]: https://doi.org/10.1093/molbev/msh112
[Le and Gascuel, 2008]: https://doi.org/10.1093/molbev/msn067
[Le and Vinh, 2020]: https://doi.org/10.1007/s00239-020-09943-3
[Le et al., 2008a]: https://doi.org/10.1093/bioinformatics/btn445
[Le et al., 2008b]: https://doi.org/10.1098/rstb.2008.0180
[Le and Gascuel, 2010]: https://doi.org/10.1093/sysbio/syq002
[Le et al., 2012]: https://doi.org/10.1093/molbev/mss112
[Lewis, 2001]: https://doi.org/10.1080/106351501753462876
[Minh et al., 2021]: https://doi.org/10.1093/sysbio/syab010
[Misof et al., 2014]: https://doi.org/10.1126/science.1257570
[Mueller and Vingron, 2000]: https://doi.org/10.1089/10665270050514918
[Muse and Gaut, 1994]: http://mbe.oxfordjournals.org/content/11/5/715.abstract
[Nickle et al., 2007]: https://dx.doi.org/10.1371/journal.pone.0000503
[Ran et al., 2018]: https://doi.org/10.1098/rspb.2018.1012
[Rota-Stabelli et al., 2009]: https://doi.org/10.1016/j.ympev.2009.01.011
[Schneider et al., 2005]: https://doi.org/10.1186/1471-2105-6-134
[Shen et al., 2018]: https://doi.org/10.1016/j.cell.2018.10.023
[Soubrier et al., 2012]: https://doi.org/10.1093/molbev/mss140
[Tamura and Nei, 1993]: http://mbe.oxfordjournals.org/cgi/content/abstract/10/3/512
[Tavare, 1986]: http://www.damtp.cam.ac.uk/user/st321/CV_&_Publications_files/STpapers-pdf/T86.pdf
[Veerassamy et al., 2004]: https://doi.org/10.1089/106652703322756195
[Vinh et al., 2017]: https://doi.org/10.1186/s12862-017-0987-y
[Wang et al., 2008]: https://doi.org/10.1186/1471-2148-8-331
[Whelan and Goldman, 2001]: https://doi.org/10.1093/oxfordjournals.molbev.a003851
[Woodhams et al., 2015]: https://doi.org/10.1093/sysbio/syv021
[Wu et al., 2018]: https://doi.org/10.1016%2Fj.dib.2018.04.094
[Yang, 1994]: https://doi.org/10.1007/BF00160154
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract
[Yang et al., 1998]: http://mbe.oxfordjournals.org/content/15/12/1600.abstract
[Zharkikh, 1994]: https://doi.org/10.1007/BF00160155
[Sereno, 2007]: https://doi.org/10.1111/j.1096-0031.2007.00161.x
[Pyron, 2017]: https://doi.org/10.1093/sysbio/syw068
[Sun et al., 2018]: https://doi.org/10.1098/rspb.2018.1780
[xgrau/recoded-mixture-models]: https://github.com/xgrau/recoded-mixture-models
[Najle et al., 2023]: https://doi.org/10.1016/j.cell.2023.08.027

