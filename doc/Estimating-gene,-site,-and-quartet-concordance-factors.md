# Intro

This recipe provides a worked example of estimating gene, site, and quartet concordance factors using IQ-TREE2 and ASTRAL-III. 

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

* Finally, you need the data. The data for this recipe is 500 randomly-selected alignments of intergenic regions from the paper ["Complexity of avian evolution revealed by family-level genomes" by Stiller et al. in 2024](https://doi.org/10.1038/s41586-024-07323-1). You can download these from here: [bird_500.tar.gz](https://github.com/user-attachments/files/15894214/bird_500.tar.gz). You will need to decompress this data using the following command

```bash
tar -xzf bird_500.tar.gz
```

For the sake of reproducibility, you can also create your own set of 500 randomly-selected loci from the intergenic regions sequenced for this paper using the following commands:

```bash
# Get the data from the paper's supplementary data repository
wget https://erda.ku.dk/archives/341f72708302f1d0c461ad616e783b86/B10K/data_upload/01_alignments_and_gene_trees/intergenic_regions/63430.alns.tar.gz

# decompress it
tar -xvzf 63430.alns.tar.gz

# select 500 random loci, then compress them
mkdir -p bird_500
find 63k_alns/ -type f | shuf -n 500 | xargs -I {} mv {} bird_500/
tar -czf bird_500.tar.gz -C bird_500 .
```