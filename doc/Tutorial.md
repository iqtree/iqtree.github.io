This tutorial gives users a quick starting guide. You can either download the binary
for your platform from the IQ-TREE website or the source code. In the latter case,
you will need to compile the source code (see [[Installation]]). For the next steps, the folder containing your  `iqtree` executable should added to your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree` at the command-line. Instructions for how to set the PATH variable in a specific operating system can be easily found on the Internet. For quick overview of all supported options in IQ-TREE, run the command  `iqtree -h`. 


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

