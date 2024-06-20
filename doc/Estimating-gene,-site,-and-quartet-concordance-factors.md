# Intro

This recipe provides a worked example of estimating gene, site, and quartet concordance factors using IQ-TREE2 and ASTRAL-III, beginning with a set of individual locus alignments.

> Citation: this recipe accompanies the paper "[The meaning and measure of concordance factors in phylogenomics](https://doi.org/10.32942/X27617)" by Rob Lanfear and Matt Hahn. Please cite that paper if you use this recipe. 

# What you need

First you need these two pieces of software:

* The latest stable version of IQ-TREE2 for your system: http://www.iqtree.org/
* ASTRAL-III: https://github.com/smirarab/ASTRAL/releases/latest

I use conda to install both of these, and suggest you do too. If you want to do that, here's one way to do it:

```bash
# set up a fresh environment and activate it
conda create --name concordance
conda activate concordance

# install what we need for this recipe
conda install -c bioconda iqtree astral-tree
```

* Finally, you need the data. The data for this recipe is 400 randomly-selected alignments of intergenic regions from the paper ["Complexity of avian evolution revealed by family-level genomes" by Stiller et al. in 2024](https://doi.org/10.1038/s41586-024-07323-1). You can download these from here: [bird_400.tar.gz](https://github.com/user-attachments/files/15894364/bird_400.tar.gz). You will need to decompress this data using the following command

```bash
tar -xzf bird_400.tar.gz
```

For the sake of reproducibility, you can also create your own set of 400 randomly-selected loci from the intergenic regions sequenced for this paper using the following commands:

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

# Estimating the gene trees

To estimate the gene trees, we'll use IQ-TREE2. Just set `-T` to the highest number of threads you have available. This step might take some time (about 3.5 hours with my 128 threads). If you prefer to skip it then you can download the key output files from this analysis here: 
[loci.zip](https://github.com/user-attachments/files/15907618/loci.zip)


```bash
iqtree2 -S bird_400 --prefix loci -T 128
```

This analysis will produce output files with lots of information, for convenience you can download the key files here: [loci.zip](https://github.com/user-attachments/files/15907618/loci.zip), this zip file includes:

* `loci.best_model.nex`: the models in nexus format - these have every parameter value for every estimated model
* `loci.iqtree`: a summary file with tons of useful information neatly summarised
* `loci.log`: the full log file from the run
* `loci.treefile`: the ML trees estimated using the best-fit models (these are what we really want)

# Estimating the species tree

You should estimate your species tree using whatever the best approach is for your data, for example a joint Bayesian analysis using BEAST or *BEAST, a two-step analysis e.g. using ASTRAL, or a concatentated analysis using IQ-TREE or RAxML. You may also have a species tree that has already been estimated elsewhere, and just want to map the concordance factors onto that. In that case, you can skip this step. 

For the purposes of this tutorial, we'll follow the original paper on bird phylogenomics and use ASTRAL to estimate the species tree from the gene trees we just estimated. Note that in the original paper they collapse some branches that have low aLRT scores, but we skip that here for simplicity. This analysis will take just a few minutes.

> Here we just calculate the species tree, we'll add concordance factors and branch support values later

```bash
astral -i loci.treefile -o astral_species.tree 2> astral_species.log
```

This analysis will produce two files. For convenience you can download these here: 
[astral.zip](https://github.com/user-attachments/files/15907833/astral.zip)


* `astral_species.tree`: the species tree estimated from ASTRAL (this might be quite different to the tree in the paper, because we used only 400 genes, on 63000!)
* `astral_species.log`: the log file from ASTRAL

# Estimating concordance factors and support values

Now we want to calculate gene, site, and quartet concordance factors, and posterior probabilities (support values calculated by ASTRAL) for every branch in our species tree. To do that, we need our species tree (of course); our gene trees (gene and quartet concordance factors are calculated from these); our alignments (site concordance factors are calculated from these).

### Estimate the support and quartet concordance factors in ASTRAL

We use ASTRAL to calculate quartet concordance factors and posterior support values (which calculated from quartet support values). 

* `-q` tells ASTRAL it to use a fixed tree topology, we use the species tree we calculated above
* `-t 2` tells ASTRAL to calculate all of the things we need and annotate the tree

```bash
astral -q astral_species.tree -i loci.treefile -t 2 -o astral_species_annotated.tree 2> astral_species_annotated.log
```

There are two output files here, which you can download here: 
[astral_annotated.zip](https://github.com/user-attachments/files/15908295/astral_annotated.zip)


* `astral_species_annotated.tree`: a tree with support values in the format `[pp1=1;pp2=0;pp3=0]` on each node. (`pp1` is the support for the node in the tree, while `pp2` and `pp3` are the support for the alternative NNI resolutions of that node.
* `astral_species_annotated.log`: the log file for ASTRAL

The annotated tree contains a lot of extra information on every node, e.g.:

```
[q1=0.9130236794171221;q2=0.04753773093937029;q3=0.03943858964350768;f1=334.1666666666667;f2=17.398809523809526;f3=14.43452380952381;pp1
=1.0;pp2=0.0;pp3=0.0;QC=200178;EN=366.0]
```

These are explained in detail in the [ASTRAL tutorial](https://github.com/smirarab/ASTRAL/blob/master/astral-tutorial.md), but for our purposes we are interested in:

* `q1`: the quartet concordance factor at a node
* `pp1`: the ASTRAL posterior probability for a node (roughly, the probability that `q1` is the highest of the three q values)

### Estimate the gene and site concordance factors in IQ-TREE

We use IQ-TREE to calculate gene and site concordance factors as follows:

```bash
iqtree -te astral_species_annotated.tree --gcf loci.treefile --scfl 100 --prefix astral_gcf_scf -T 128
```

