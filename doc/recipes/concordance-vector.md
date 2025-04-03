---
layout: workshop
title: "Estimating gene, site, and quartet concordance vectors"
author: Minh Bui
date:    2024-08-02
docid: 100
---

# Estimating gene, site, and quartet concordance vectors


## Introduction

This recipe provides a worked example of estimating gene, site, and quartet concordance vectors using IQ-TREE2 and ASTRAL-III, beginning with a set of individual locus alignments. A concordance vector consists of four numbers, which include the concordance factor and three other numbers describing all the discordant trees:

* &#936;<sub>1</sub> (the concordance factor for the branch of interest in the species tree)
* &#936;<sub>2</sub> (the largest of the two discordance factors from a single NNI rearrangement of the branch of interest)
* &#936;<sub>3</sub> (the smallest of the two discordance factors from a single NNI rearrangement of the branch of interest)
* &#936;<sub>4</sub> (the sum of the discordance factors that do not make up &#936;<sub>2</sub> and &#936;<sub>3</sub>; note that site and quartet concordance factors always assume that this number is zero)

> Citation: this recipe accompanies the paper "[The meaning and measure of concordance factors in phylogenomics](https://doi.org/10.32942/X27617)" by Rob Lanfear and Matt Hahn. Please cite that paper if you use this recipe. This article also describes concordance vectors in a lot more detail.

## What you need

### Software

First you need the following software:

* The latest stable version of IQ-TREE2 for your system: http://www.iqtree.org/
* ASTRAL-III: https://github.com/smirarab/ASTRAL/releases/latest
* R, and the `tidyverse` and `boot` packages
* A few R scripts to process lots of output files and produce concordance vectors, tree files, and tables from: [https://github.com/roblanf/concordance_vectors](https://github.com/roblanf/concordance_vectors)

I use conda to install all of these, and suggest you do too. If you want to do that, here's one way to do it:

```bash
# set up a fresh environment and activate it
conda create --name concordance
conda activate concordance

# install what we need for this recipe
conda install -c bioconda iqtree astral-tree
conda install -c conda-forge r-base r-tidyverse r-boot r-ape r-ggtext

# get the R script
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/concordance_vector.R
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/concordance_table.R
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/change_labels.R

```

After installation, double check that you have the latest versions of both pieces of software. You will need IQ-TREE version 2.3 or above for this. 

> Note that the R script is itself on GitHub here: [https://github.com/roblanf/concordance_vectors/blob/main/concordance_vector.R](https://github.com/roblanf/concordance_vectors/blob/main/concordance_vector.R)

### Data

Next you need the data. The data for this recipe is 400 randomly selected alignments of intergenic regions from the paper ["Complexity of avian evolution revealed by family-level genomes" by Stiller et al. in 2024](https://doi.org/10.1038/s41586-024-07323-1). Each locus has up to  363 species represented from across the diversity of birds, and to the best of the author's ability to carefully sequence and filter the data, each locus is also a single-copy orthologue. This means that we can go ahead and use these alignments to estimate gene trees, species trees, and concordance vectors. 

You can download these 400 alignments from here: [bird_400.tar.gz](https://github.com/user-attachments/files/15894364/bird_400.tar.gz). You will need to decompress this data using the following command

```bash
tar -xzf bird_400.tar.gz
```

For the sake of reproducibility, you can also create your own set of 400 randomly selected loci from the intergenic regions sequenced for this paper using the following commands:

```bash
# Get the data from the paper's supplementary data repository
wget https://erda.ku.dk/archives/341f72708302f1d0c461ad616e783b86/B10K/data_upload/01_alignments_and_gene_trees/intergenic_regions/63430.alns.tar.gz

# decompress it
tar -xvzf 63430.alns.tar.gz

# select 400 random loci, then compress them
mkdir -p bird_400
find 63k_alns/ -type f ! -name '.*' | shuf -n 400 | xargs -I {} mv {} bird_400/ # avoid files that start with '.'
tar -czf bird_400.tar.gz -C bird_400 .
```

The last set of commands will produce a file just like the one you can download above, with 400 randomly selected loci. Note that you should expect to get a slightly different species tree and concordance factors, because there's a *lot* of discordance along the backbone of the species tree of birds, so different groups of 400 loci are highly likely to give different species trees. 

## Estimating the gene trees

To estimate the gene trees, we'll use IQ-TREE2. Just set `-T` to the highest number of threads you have available. This step might take some time (about 3.5 hours with my 128 threads). If you prefer to skip it then you can download the key output files from this analysis here: 
[loci.zip](https://github.com/user-attachments/files/15907618/loci.zip)

```bash
iqtree2 -S bird_400 --prefix loci -T 128
```

This analysis will produce output files with lots of information, these include (all in the zip file `loci.zip` linked above):

* `loci.best_model.nex`: the substitution models in nexus format - these have every parameter value for every estimated model, e.g. for one locus, the GTR+F+R5 model has the following entry:
`GTR{1.07109,5.24905,0.776093,1.28398,3.93731}+F{0.212586,0.260909,0.256934,0.269571}+R5{0.0670095,0.202443,0.44871,0.605428,0.379555,1.13675,0.0791399,2.21831,0.0255857,4.21162}: chr10_1260000_1270000.1k.start299.fasta{17.1377}`
* `loci.iqtree`: a summary file of the entire analysis with tons of useful information neatly summarised
* `loci.log`: the full log file from the run (i.e. everything that was printed to the screen during the run)
* `loci.treefile`: the Maximum Likelihood single-locus trees estimated using the best-fit models (these trees are what we really want)

## Estimating the species tree

You should estimate your species tree using whatever the best approach is for your data, for example a joint Bayesian analysis using BEAST or *BEAST, a two-step analysis e.g. using ASTRAL, or a concatentated analysis using IQ-TREE or RAxML. You may also have a species tree that has already been estimated elsewhere, and just want to map the concordance vectors onto that. In that case, you can skip this step. 

For the purposes of this tutorial, we'll follow the original paper on bird phylogenomics and use ASTRAL to estimate the species tree from the gene trees we just estimated. Note that in the original paper they collapse some branches in the single-locus trees that have low aLRT (approximate Likelihood Ratio Test: a way of asking whether a branch has a length that differs significantly from zero) scores, but we skip that here for simplicity. This analysis will take just a few minutes.

> Here we just calculate the species tree, we'll calculate concordance vectors and branch support values later

```bash
astral -i loci.treefile -o astral_species.tree 2> astral_species.log
```

This analysis will produce two files. For convenience you can download these here: 
[astral.zip](https://github.com/user-attachments/files/15907833/astral.zip)


* `astral_species.tree`: the species tree estimated from ASTRAL (this might be quite different to the tree in the paper, because we used only 400 genes, not the full set of more than 63000!)
* `astral_species.log`: the log file from ASTRAL

## Estimating concordance vectors and support values

Now we want to calculate gene, site, and quartet concordance vectors, and posterior probabilities (support values calculated by ASTRAL) for every branch in our species tree. To do that, we need our species tree (of course); our gene trees (gene and quartet concordance vectors are calculated from these); our alignments (site concordance vectors are calculated from these).

> Note that concordance factors and support values apply to *branches* in trees, not nodes. 

### Estimate the support and quartet concordance vectors in ASTRAL

We use ASTRAL to calculate quartet concordance vectors and posterior support values (which are calculated from the quartet support values, see below for an explanation of both). 

* `-q` tells ASTRAL to use a fixed tree topology, we use the species tree we calculated above
* `-t 2` tells ASTRAL to calculate all of the things we need and annotate the tree with them

```bash
astral -q astral_species.tree -i loci.treefile -t 2 -o astral_species_annotated.tree 2> astral_species_annotated.log
```

There are two output files here, which you can download here: 
[astral_annotated.zip](https://github.com/user-attachments/files/15908295/astral_annotated.zip)


* `astral_species_annotated.tree`: the species tree with annotations on every branch 
* `astral_species_annotated.log`: the log file for ASTRAL

The annotated tree contains a lot of extra information on every branch, e.g.:

```
[q1=0.9130236794171221;q2=0.04753773093937029;q3=0.03943858964350768;f1=334.1666666666667;f2=17.398809523809526;f3=14.43452380952381;pp1
=1.0;pp2=0.0;pp3=0.0;QC=200178;EN=366.0]
```

These are explained in detail in the [ASTRAL tutorial](https://github.com/smirarab/ASTRAL/blob/master/astral-tutorial.md), but for our purposes we are interested in:

* `q1`, `q2`, and `q3`: form the quartet concordance vector (ASTRAL calls these 'quartet frequencies', 'normalised quartet frequencies', and sometimes 'quartet support values'; we argue in our paper that they are very much *not* support values)
* `pp1`: the ASTRAL posterior probability for a branch (roughly, the probability that `q1` is the highest of the three q values)

### Estimate the gene and site concordance vectors in IQ-TREE

We use IQ-TREE to calculate gene and site concordance vectors (for more details see the [concordance factor page](http://www.iqtree.org/doc/Concordance-Factor)).

In the following command lines:

* `-te` tells IQ-TREE to use a fixed input tree (note that the tree we pass with `-te` differs in the two commands: the latter command uses the tree output by the former command, which sequentially adds to the labels on the tree for convenience)
* `--gcf` is the command to calculate the gCF using the gene trees we estimated above
* `-prefix` is the prefix for the output files
* `-T` is the number of threads (change this to suit your machine)
* `--scfl 100` is the command to calculate the likelihood-based sCF with 100 replicates
* `-p loci.best_model.nex` tells IQ-TREE to use the loci from `bird_400` and the models we estimated previously when calculating the gene trees (this saves a huge amount of time)

```bash
# first calculate the site concordance vectors
iqtree2 -te astral_species_annotated.tree -p loci.best_model.nex --scfl 100 --prefix scfl -T 128

# next calculate the gene concordance vectors
iqtree2 -te scfl.cf.tree --gcf loci.treefile --prefix gcf -T 128

# finally we do a dummy analysis in IQ-TREE. The only point of this is to get the branch lengths in coalescent units 
# from the ASTRAL analysis, in a format that is output by IQ-TREE in a convenient table with IQ-TREE branch ID's 
# note the -blfix option, which keeps the original branch lengths - this makes the scfs meaningless, but is here 
# simply to allow us to extract branch lengths in coalescent units frmo the ASTRAL tree in a convenient table
# we set scfl to 1, which saves time given the scfs are already meaningless, never use the sCFs from this analysis!!!
iqtree2 -te astral_species_annotated.tree -blfix -p loci.best_model.nex --scfl 1 --prefix coalescent_bl -T 128
```

These three command lines will produce a lot of output files, but the key files are:

* `gcf.cf.stat`: a table with the gCF values, as well as gDF1, gDF2, gDFP, and many other things (including all the ASTRAL labels)
* `scfl.cf.stat`: the equivalent table for scfl values (including all the ASTRAL labels)
* `coalescent_bl.cf.stat`: the dummy table from which we'll get our coalescent branch lengths
* `gcf.cf.tree`: the tree file with lots of annotations about concordance factors (plus all the ASTRAL annotations) 
* `gcf.cf.branch`: the tree file annotated with branch IDs that match those in the `.stat` files

You can download these files here: 
[stat_and_tree_files.zip](https://github.com/user-attachments/files/15949173/stat_and_tree_files.zip)

Each internal branch in `gcf.cf.tree` will be annotated like this:

`'[q1=0.570241231975882;q2=0.17602481596980715;q3=0.25373395205431093;f1=207.567808439221;f2=64.0730330130098;f3=92.3591585477691
7;pp1=1.0;pp2=1.575119358351017E-20;pp3=2.952157354351003E-20;QC=8496;EN=364.0]'/25.4/47.0:0.0055956557`

This doesn't contain all the information for the concordance vectors (see below for that) but it's still very useful:

* `q1=0.570241231975882`: this is the quartet concordance factor
* `25.4`: this is the site concordance factor
* `47.0`: this is the gene concordance factor
* `0.0055956557` this is the branch length in **substitutions per site** calculated when we calculated the site concordance factors

### View the tree file

One useful thing to do is to look at these labels in the context of your species tree. To do this, you can open the file `gcf.cf.tree` in a tree viewer like [DendroScope](https://github.com/husonlab/dendroscope3/releases/latest). Just load the tree in Dendroscope, specify that the labels are edge labels when you are asked, and that's it. You can then re-root the tree, change the layout, and zoom in and out to see the edge labels you are interested in. However, the edge labels so far don't contain the full concordance vectors, so we'll get those next. 

## Generate the concordance vectors for each branch

The final step of this tutorial is to get the full gene, site, and quartet concordance vectors. 

The information we need to calculate these is in two files: `gcf.cf.stat` and `scfl.cf.stat`. These are described above, and you can download them above or here: [stat_and_tree_files.zip](https://github.com/user-attachments/files/15949173/stat_and_tree_files.zip)

We'll use the R script you downloaded to organise these files into concordance vectors:

```bash
Rscript concordance_vector.R
```

This will produce a file called `concordance_vectors.csv` (you can download a copy here: [concordance_vectors.csv](https://github.com/user-attachments/files/15949742/concordance_vectors.csv)), which has gene, site, and quartet concordance vectors, along with branch lengths in units of substitutions per site and coalescent units, and branch IDs which correspond to the `gcf.cf.branch` tree file.

The first five rows of your csv file should look something like this:

| ID  | gene_psi1 | gene_psi2 | gene_psi3 | gene_psi4 | gene_psi1_N | gene_psi2_N | gene_psi3_N | gene_psi4_N | gene_N | site_psi1 | site_psi2 | site_psi3 | site_psi4 | site_psi1_N | site_psi2_N | site_psi3_N | site_psi4_N | site_N  | quartet_psi1 | quartet_psi2 | quartet_psi3 | quartet_psi1_N | quartet_psi2_N | quartet_psi3_N | quartet_N | quartet_psi1_pp | quartet_psi2_pp | quartet_psi3_pp | length_subs_per_site | length_coalescent |
|-----|-----------|-----------|-----------|-----------|-------------|-------------|-------------|-------------|--------|-----------|-----------|-----------|-----------|-------------|-------------|-------------|-------------|---------|--------------|--------------|--------------|----------------|----------------|----------------|------------|------------------|------------------|------------------|---------------------|-------------------|
| 364 | 83        | 8.5       | 7.37      | 1.13      | 293         | 30          | 26          | 4           | 353    | 51.51     | 24.77     | 23.72     | 0         | 1867.35     | 898         | 859.86      | 0           | 3625.21 | 0.84         | 0.09         | 0.07         | 296.48         | 30.25          | 26.27          | 353        | 1                | 0                | 0                | 0.0137341            | 0.0531013         |
| 365 | 99.46     | 0         | 0         | 0.54      | 370         | 0           | 0           | 2           | 372    | 42.53     | 33.62     | 23.85     | 0         | 445.8       | 352.46      | 250         | 0           | 1048.26 | 1            | 0            | 0            | 371.99         | 0.01           | 0              | 372        | 1                | 0                | 0                | 0.0376558            | 0.201927          |
| 366 | 79.03     | 10.22     | 6.99      | 3.76      | 294         | 38          | 26          | 14          | 372    | 18.07     | 67.17     | 14.77     | 0         | 103.48      | 384.96      | 84.53       | 0           | 572.97  | 0.81         | 0.11         | 0.08         | 300.86         | 41.51          | 29.63          | 372        | 1                | 0                | 0                | 0.0100011            | 0.0460157         |
| 367 | 97.59     | 0.27      | 0         | 2.14      | 364         | 1           | 0           | 8           | 373    | 37.86     | 42.92     | 19.22     | 0         | 280.21      | 317.69      | 142.28      | 0           | 740.18  | 0.99         | 0.01         | 0.01         | 368.14         | 2.74           | 2.11           | 373        | 1                | 0                | 0                | 0.0230637            | 0.138847          |
| 368 | 83.87     | 1.88      | 1.34      | 12.9      | 312         | 7           | 5           | 48          | 372    | 30.61     | 43.46     | 25.94     | 0         | 227.76      | 323.6       | 193.02      | 0           | 744.38  | 0.89         | 0.06         | 0.05         | 332.72         | 21.04          | 18.23          | 372        | 1                | 0                | 0                | 0.0116769            | 0.0672212         |


This table has a lot of columns. For easy reference, here's a description of every column:

| Column                 | Description | Calculated from                                                                       |
|------------------------|-------------|---------------------------------------------------------------------------------------|
| ID                     | Branch ID   								  						| `ID` `gcf.cf.branch` file                                                     		|
| gene_psi1              | &#936;<sub>1</sub> for genes (%) 		  						| `gCF` from `gcf.cf.stat`       														|
| gene_psi2              | &#936;<sub>2</sub> for genes (%)           						| Larger `gDF1` and `gDF2` from `gcf.cf.stat`                                		|
| gene_psi3              | &#936;<sub>3</sub> for genes (%)           						| Smaller `gDF1` and `gDF2` from `gcf.cf.stat`                               			|
| gene_psi4              | &#936;<sub>4</sub> for genes (%)           						| `gDFP` from `gcf.cf.stat`                                             				|
| gene_psi1_N            | &#936;<sub>1</sub> for genes (count)       						| `gCF_N` from `gcf.cf.stat`       										                |
| gene_psi2_N            | &#936;<sub>2</sub> for genes (count)       						| Larger `gDF1_N` and `gDF2_N` from `gcf.cf.stat`						                |
| gene_psi3_N            | &#936;<sub>3</sub> for genes (count)       						| Smaller `gDF1_N` and `gDF2_N` from `gcf.cf.stat`						                |
| gene_psi4_N            | &#936;<sub>4</sub> for genes (count)       						| `gDFP_N` from `gcf.cf.stat`                     						                |
| gene_N                 | Number of decisive gene trees              						| `gN` from `gcf.cf.stat`                                             |
| site_psi1              | &#936;<sub>1</sub> for sites (%) 		  						| `sCF` from `scfl.cf.stat`       														|
| site_psi2              | &#936;<sub>2</sub> for sites (%)           						| Larger `sDF1` and `sDF2` from `scfl.cf.stat`                                		|
| site_psi3              | &#936;<sub>3</sub> for sites (%)           						| Smaller `sDF1` and `sDF2` from `scfl.cf.stat`                               			|
| site_psi4              | &#936;<sub>4</sub> for sites (%)           						| Always zero by assumption                                              				|
| site_psi1_N            | &#936;<sub>1</sub> for sites (count)       						| `sCF_N` from `scfl.cf.stat`       										                |
| site_psi2_N            | &#936;<sub>2</sub> for sites (count)       						| Larger `sDF1_N` and `sDF2_N` from `scfl.cf.stat`						                |
| site_psi3_N            | &#936;<sub>3</sub> for sites (count)       						| Smaller `sDF1_N` and `sDF2_N` from `scfl.cf.stat`						                |
| site_psi4_N            | &#936;<sub>4</sub> for sites (count)       						| Always zero by assumption                     						                |
| site_N                 | Number of decisive sites 	              						| `sN` from `scfl.cf.stat`                                             |
| quartet_psi1           | &#936;<sub>1</sub> for quartets (%) 		     					| `q1` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)       														|
| quartet_psi2           | &#936;<sub>2</sub> for quartets (%)           					| Larger `q2` and `q3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                               		|
| quartet_psi3           | &#936;<sub>3</sub> for quartets (%)           					| Smaller `q2` and `q3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                              			|
| quartet_psi4           | &#936;<sub>4</sub> for quartets (%)           					| Always zero by assumption                                              				|
| quartet_psi1_N         | &#936;<sub>1</sub> for quartets (count)       					| `f1` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)       										                |
| quartet_psi2_N         | &#936;<sub>2</sub> for quartets (count)       					| Larger `f2` and `f3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)						                |
| quartet_psi3_N         | &#936;<sub>3</sub> for quartets (count)       					| Smaller `f2` and `f3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)						                |
| quartet_psi4_N         | &#936;<sub>4</sub> for quartets (count)       					| Always zero by assumption                     						                |
| quartet_N              | Effective number of gene trees                					| `EN` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                                              |
| quartet_psi1_pp        | ASTRAL posterior probability for &#936;<sub>1</sub>              | `pp1` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                                                   |
| quartet_psi2_pp        | ASTRAL posterior probability for &#936;<sub>2</sub>              | Larger `pp2` and `pp3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                     |
| quartet_psi3_pp        | ASTRAL posterior probability for &#936;<sub>3</sub>              | Smaller `pp2` and `pp3` from `scfl.cf.stat` 'Label' column (calculated in ASTRAL)                    |
| length_subs_per_site   | branch length in substitutions per site             				| Calculated in IQ-TREE using a concatenated analysis                                                     |
| length_coalescent      | branch length in coalescent units            					| Calcualted in ASTRAL from the quartet concordance vector                                                             |


## Put concordance factors (or other numbers!) on a tree

A common aim is to annotate your tree with the statistics you are interested in. The output tree above has rather unwieldy labels on each branch like this:

`'[q1=0.570241231975882;q2=0.17602481596980715;q3=0.25373395205431093;f1=207.567808439221;f2=64.0730330130098;f3=92.3591585477691 7;pp1=1.0;pp2=1.575119358351017E-20;pp3=2.952157354351003E-20;QC=8496;EN=364.0]'/25.4/47.0:0.0055956557`

But we can use the tree with branch IDs to put any label on a tree. An example is in the `change_labels.R` script. As written, this script just updates the branch ID labels in the `gcf.cf.branch` tree to show the ID and the three concordance factors (the &#936;<sub>1</sub> values), each labelled with the first letter of the input data (i.e. `g` for genes, `s` for sites, and `q` for quartets). You can run this script like so:

```
Rscript change_labels.R
```

This will output a nexus-formatted tree file called `id_gcf_scf_qcf.nex`. Each branch on this tree is labelled as follows:

`391-g98.54-s84.09-q98.54`

The first number is the branch ID, and the next three are the three concordance factors. This can be useful for exploring your data. For example, if you look at the part of the species tree we inferred in this recipe that groups the kiwis (genus *Apteryx*), you can see that there is a lot of concordance in this part of the tree:

![kiwis](https://github.com/iqtree/iqtree2/assets/895251/e3ab2493-4105-4099-b822-5ddc4b5583aa)

The concordance factors tell you a certain amount, but to understand things better, you really need to examine the concordance vectors. 

> If you want to put different labels on your tree, that is relatively simple to do by editing the `change_labels.R` script, which you can get from GitHub here: [https://github.com/roblanf/concordance_vectors/blob/main/change_labels.R](https://github.com/roblanf/concordance_vectors/blob/main/change_labels.R)

## Generate concordance tables for branches of interest

A concordance table is just a table of the three concordance vectors, as shown in the Lanfear and Hahn paper. The `concordance_table.R` script lets you generate a concordance table for any branch, based on the branch ID. Here we'll do that for two branches that were recovered in the original Nature paper, discussed in Lanfear and Hahn, and also recovered in the ASTRAL tree we estimated here from 400 loci (I found the branch IDs for these branches by studying the tree labelled with branch IDs that I made above):

* **Branch 598**: the Palaeognathae (kiwis and other cool birds)
* **Branch 545**: the Telluraves (passerines and other closely related groups)

The `concordance_table.R` script takes two input variables:

* the `concordance_vectors.csv` file we generated above
* the branch ID

So to get the tables for our two branches, we run it once for each as follows:

```
Rscript concordance_table.R concordance_vectors.csv 598
Rscript concordance_table.R concordance_vectors.csv 545
```

The output includes 2 files for each run:

* a PDF of the table, e.g. `concordance_table_598.pdf`
* a CSV file of the table, e.g. `concordance_table_598.csv`

The CSV looks like this (using Telluraves as an example):

| type | psi | value | lower_CI | upper_CI |
|------|-----|-------|----------|----------|
| gene | 1   | 5.60  | 3.562341 | 7.888041 |
| gene | 2   | 0.25  | 0.000000 | 0.769720 |
| gene | 3   | 0.00  | 0.000000 | 0.000000 |
| gene | 4   | 94.15 | 91.857506 | 96.183206 |
| site | 1   | 45.63 | 42.518891 | 48.434787 |
| site | 2   | 18.70 | 16.490210 | 20.934787 |
| site | 3   | 16.00 | 13.710630 | 18.320910 |
| site | 4   | 19.67 | 17.383025 | 21.849787 |
| site | 5   | 0.00  | 0.000000 | 0.000000 |
| site | 6   | 0.00  | 0.000000 | 0.000000 |
| site | 7   | 0.00  | 0.000000 | 0.000000 |
| site | 8   | 0.00  | 0.000000 | 0.000000 |
| site | 9   | 0.00  | 0.000000 | 0.000000 |
| site | 10  | 0.00  | 0.000000 | 0.000000 |

And the PDF looks like this:

![concordance_table_545_telluraves](https://github.com/iqtree/iqtree2/assets/895251/ec7c1b35-0441-4e18-85cc-8a543fda4155)

Clearly there is substantial discordance around this branch! Compare this to the palaeognathae, which have far less discordance:

![concordance_table_598_palaeognathae](https://github.com/iqtree/iqtree2/assets/895251/5cf10aae-6c7c-4850-bdbb-90c5c0219c46)

These tables allow you to quickly dig into the concordance vectors on any given branch in your tree. 

### Confidence intervals on the concordance vectors

You'll notice that the tables include 95% confidence intervals for the concordance and discordance factors. These are calculated using 1000 bootstraps of the count data, and provide useful context for interpreting the values, and particularly for interpreting potential *differences* in the values.

These bootstrap confidence intervals are calculated by resampling from the counts for each concordance vector. The total sample size for each category (genes, sites, and quartets) is shown on the table underneath the y axis label. Note that for sites and quartets, the counts are not always whole numbers because of how they are calculated. This can also mean that the bootstrap confidence intervals can be a little off for very low counts, because the numbers have to be rounded to integers in order to calculate them.  

