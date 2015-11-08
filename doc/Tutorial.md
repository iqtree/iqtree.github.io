This tutorial gives users a quick starting guide. You can either download the binary
for your platform from the IQ-TREE website or the source code (see [[Installation]]). For the next steps, the folder containing your  `iqtree` executable should added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Instructions for how to set the PATH variable in a specific operating system can be easily found on the Internet. For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 


First running example
---------------------

From the download there is an example alignment called `example.phy`
 in PHYLIP format (IQ-TREE also supports FASTA, NEXUS, CLUSTAL and MSF files). You can now start to reconstruct a maximum-likelihood tree
from this alignment by entering (assuming that you are now in the same folder with `example.phy`):

    iqtree -s example.phy

`-s` is the option to specify the name of the alignment file that is always required by
IQ-TREE to work. At the end of the run IQ-TREE will write several output files:

* `example.phy.iqtree`: the main report file that is self-readable. You
should look at this file to see the computational results. It also contains a textual representation of the final tree. 
* `example.phy.treefile`: the ML tree in NEWICK format, which can be visualized
by any supported tree viewer programs like FigTree or  iTOL. 
* `example.phy.log`: log file of the entire run (also printed on the screen). To report
bugs, please send this log file and the original alignment file to the authors.

The default prefix of all output files is the alignment file name. However,  you can always 
change the prefix using the `-pre` option, e.g.:

    iqtree -s example.phy -pre myprefix

This prevents output files to be overwritten when you perform multiple analyses on the same alignment within the same folder. 


Choosing the right substitution model
-------------------------------------

IQ-TREE supports a wide range of substitution models for binary, DNA, protein, codon and morphological alignments. If the substitution model is not specified, IQ-TREE will use the default model (e.g. HKY for DNA, WAG for protein). In case you do not know which model is appropriate for your data,  IQ-TREE can automatically determine the best-fit model 
for your alignment using the `-m TEST` option. For example:

    iqtree -s example.phy -m TEST

`-m` is the option to specify the model name to use during the analysis. `TEST`
is a key word telling IQ-TREE to perform the model test procedure and select the best-fit model. The remaining analysis
will be done using the selected model. More specifically, IQ-TREE computes the log-likelihoods
of the initial parsimony tree for many different models and the Akaike information criterion (AIC), corrected Akaike information criterion (AICc), and the Bayesian information criterion (BIC).
Then IQ-TREE chooses the model that minimizes the BIC score (you can also change to AIC or AICc by 
adding the option `-AIC` or `-AICc`, respectively.
Here, IQ-TREE will write an additional file:

* `example.phy.model`: log-likelihoods for all models tested.

If you now look at `example.phy.iqtree` you will see that IQ-TREE selected the model `TIM`
with Invar+Gamma rate heterogeneity. So `TIM+I+G` is the best-fit model
for this example data. Thus, for additional analyses you do not have to perform the model test again and can use the selected model as follows.


    iqtree -s example.phy -m TIM+I+G

Sometimes you only want to find the best-fit model without doing tree reconstruction, then run:

    iqtree -s example.phy -m TESTONLY

Here, IQ-TREE will stop after finishing the model selection. The name of the best-fit model will be printed on the screen.
Note that if the file `*.model` exists and is correct, IQ-TREE will reuse the computed log-likelihoods  to speed up the model selection procedure. 


Codon models
------------

Since version 1.0 IQ-TREE supports basic codon models (GY, MG, and ECM). You need to input a protein-coding DNA alignment and specify codon data by option `-st CODON` (Otherwise, IQ-TREE applies DNA model because it detects that your alignment has DNA sequences):

    iqtree -s coding_gene.phy -st CODON 

If your alignment length is not divisible by 3, an error message will occur. IQ-TREE will group sites 1,2,3 into codon site 1; site 4,5,6 to codon site 2; etc. Moreover, any codon, which has at least one gap/unknown/ambiguous nucleotide, will be treated as unknown codon character.

If you are not sure which model to use, simply add `-m TEST`, which also works for codon alignments: 

    iqtree -s coding_gene.phy -st CODON -m TEST

By default IQ-TREE uses the standard genetic code.
You can change to other genetic code (see <http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi>) with following options:

| Option | Genetic code |
|--------|--------------|
|`-st CODON1` | The Standard Code (same as `-st CODON`)|
| `-st CODON2` | The Vertebrate Mitochondrial Code |
| `-st CODON3` | The Yeast Mitochondrial Code |
| `-st CODON4` | The Mold, Protozoan, and Coelenterate Mitochondrial Code and the Mycoplasma/Spiroplasma Code |
| `-st CODON5` | The Invertebrate Mitochondrial Code |
| `-st CODON6` | The Ciliate, Dasycladacean and Hexamita Nuclear Code |
| `-st CODON9` | The Echinoderm and Flatworm Mitochondrial Code |
| `-st CODON10` | The Euplotid Nuclear Code |
| `-st CODON11` | The Bacterial, Archaeal and Plant Plastid Code |
| `-st CODON12` | The Alternative Yeast Nuclear Code |
| `-st CODON13` | The Ascidian Mitochondrial Code |
| `-st CODON14` | The Alternative Flatworm Mitochondrial Code |
| `-st CODON16` | Chlorophycean Mitochondrial Code |
| `-st CODON21` | Trematode Mitochondrial Code |
| `-st CODON22` | Scenedesmus obliquus Mitochondrial Code |
| `-st CODON23` | Thraustochytrium Mitochondrial Code |
| `-st CODON24` | Pterobranchia Mitochondrial Code |
| `-st CODON25` | Candidate Division SR1 and Gracilibacteria Code |


