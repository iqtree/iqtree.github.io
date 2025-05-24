---
layout: workshop
title: "IQ-TREE Workshop Tutorial"
author: Minh Bui (updated with mixture models by Hanon Solomon McShea)
date:    2025-05-24
docid: 100
tags:
- workshop
---

IQ-TREE 3 Tutorial (Workshop on Molecular Evolution, Woods Hole 2025)
=========================

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [1) Input data](#1-input-data)
- [2) Inferring the first phylogeny](#2-inferring-the-first-phylogeny)
- [3) Applying partition model](#3-applying-partition-model)
- [4) Choosing the best partitioning scheme](#4-choosing-the-best-partitioning-scheme)
- [5) Tree topology tests](#5-tree-topology-tests)
- [6) Tree mixture model](#6-tree-mixture-model) (NEW THIS YEAR)
- [7) Identifying most influential genes](#7-identifying-most-influential-genes)
- [8) Removing influential genes](#8-removing-influential-genes)
- [9) Concordance factors](#9-concordance-factors)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<!--more-->

In the virtual machine established by the organizers you can run IQ-TREE version 3.0.1 
from the command line:

	iqtree3
	
which should display something like this to the screen:

	IQ-TREE multicore version 3.0.1 for Linux x86 64-bit built May 5 2025
	Developed by Bui Quang Minh, Thomas Wong, Nhan Ly-trong, Huaiyan Ren
	Contributed by Lam-Tung Nguyen, Dominik Schrempf, Chris Bielow, Olga Chernomor, Michael Woodhams, Diep Thi Hoang, Heiko Schmidt 
	...

If you instead want to run it on your computer, [download version 3.0.1](https://iqtree.github.io/#download) 
and [install](../doc/Quickstart) the binary for your platform. 
For the next steps, the folder containing your `iqtree3` executable should be added to 
your PATH enviroment variable so that IQ-TREE can be invoked by simply entering `iqtree3` 
at the command-line. Alternatively, you can also copy `iqtree3` binary into your system 
search. Note that this does not apply if you are using the virtual machines.


1) Input data
-------------
<div class="hline"></div>

We will use a Turtle data set to demonstrate the use of IQ-TREE throughout this workshop 
tutorial. We try to resolve a once hotly debated phylogenetic position of Turtles, 
relative to Crocodiles and Birds. There are three possible relationships between them 
and we want to know which one is the true one:

![Three possible trees of Turtles, Crocodiles and Birds](data/turtle.png)

(Picture courtesy of Jeremy Brown)

If you are logged into the virtual machine, you can copy the data from 
`moledata/iqtreelab/` folder:

	cd
	cp -r moledata/iqtreelab .
	cd iqtreelab

This folder contains two input files (which can also be downloaded from the following link):

* [turtle.fa](data/turtle.fa): The DNA alignment (in FASTA format), which is a subset 
  of the original Turtle data set used to assess the phylogenetic position of Turtle 
  relative to Crocodile and Bird ([Chiari et al., 2012]).
* [turtle.nex](data/turtle.nex): The partition file (in NEXUS format) defining 29 genes, 
  which are a subset of the published 248 genes ([Chiari et al., 2012]).

> **QUESTIONS:**
> 
> * View the alignment in Jalview or your favourite alignment viewer.
> 
> * Can you identify the gene boundary from the viewer? Does it roughly match the partition file?
> 
> * Is there missing data? Do you think if missing data can be problematic?
{: .tip}


2) Inferring the first phylogeny
--------------------------------
<div class="hline"></div>
 
You can now start to reconstruct a maximum-likelihood (ML) tree
for the Turtle data set (assuming that you are in the same folder where the alignment is 
stored).

> What is the command line to run `iqtree3` that takes 
> the alignment file `turtle.fa` as input, performs 1000 ultrafast bootstrap replicates,
> and automatically determines the best number of cores to use (`-T AUTO` option)?

<script type="text/javascript">
function myFunction(buttonid, commandid) {
  var x = document.getElementById(commandid);
  var y = document.getElementById(buttonid);
  if (x.style.display === "none") {
    x.style.display = "block";
    y.innerText = "Hide the command line";
  } else {
    x.style.display = "none";
    y.innerText = "Show me the command line";
  }
}
</script>

<button type="button" class="btn btn-primary" id="button2" onclick="myFunction('button2','command2')">
Show me the command line</button>
<div id="command2" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -B 1000 -T AUTO</code></pre>

Options explained:
<ul>
<li>`-s turtle.fa` to specify the input alignment as `turtle.fa`.</li>
<li>`-B 1000` to specify 1000 replicates for the ultrafast bootstrap ([Minh et al., 2013]).</li>
<li>`-T AUTO` to determine the best number of CPU cores to speed up the analysis.</li>
</ul>

This simple command will perform three important steps in one go:

<ol>
<li>Select best-fit model using ModelFinder ([Kalyaanamoorthy et al., 2017]).</li>
<li>Reconstruct the ML tree using the IQ-TREE search algorithm ([Nguyen et al., 2015]).</li>
<li>Assess branch supports using the ultrafast bootstrap - UFBoot ([Minh et al., 2013]).</li>
</ol>

</div>

Once the run is done, IQ-TREE will write several output files including:

* `turtle.fa.iqtree`: the main report file that is self-readable. You
  should look at this file to see the computational results. It also contains 
  a textual representation of the final tree.
* `turtle.fa.treefile`: the ML tree in NEWICK format, which can be visualized in 
  FigTree or any other tree viewer program.
* `turtle.fa.log`: log file of the entire run (also printed on the screen).
* `turtle.fa.ckp.gz`: checkpoint file used to resume an interrupted analysis.
* And a few other files.

> **QUESTIONS:**
> 
> * Look at the report file `turtle.fa.iqtree`. 
> 
> * What is the best-fit model name? What do you know about this model? (see [substitution models](../doc/Substitution-Models) available in IQ-TREE)
> 
> * What are the AIC/AICc/BIC scores of this model and tree?
> 
> * Look at the tree in `turtle.fa.iqtree` or visualise the tree `turtle.fa.treefile` in a tree viewer software like FigTree. What relationship among [three trees](#1-input-data) does this tree support?
> 
> * What is the ultrafast bootstrap support (%) for the relevant clade?
> 
> * Does this tree agree with the published tree ([Chiari et al., 2012])?
{: .tip}


3) Applying partition model
---------------------------
<div class="hline"></div>


We now perform a partition model analysis ([Chernomor et al., 2016]), where one allows 
each partition to have its own model. 

> What is the command line to run `iqtree3` that takes `turtle.fa` as input alignment,
> `turtle.nex` as input partition file, performs 1000 ultrafast bootstrap replicates,
> and automatically determines the best number of cores?

<button type="button" class="btn btn-primary" id="button3" onclick="myFunction('button3','command3')">
Show me the command line</button>
<div id="command3" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -p turtle.nex -B 1000 -T AUTO</code></pre>

Options explained:

<ul>
<li>`-p turtle.nex` to specify an *edge-linked proportional* partition model 
  ([Chernomor et al., 2016]). That means, there is one set of branch lengths. 
  But each partition can have proportionally shorter or longer tree length, 
  representing slow or fast evolutionary rate, respectively.</li>
</ul>

</div>


> **QUESTIONS:**
> 
> * Look at the report file `turtle.nex.iqtree`. What are the AIC/AICc/BIC scores of 
>   partition model? Is it better than the previous model?
> 
> * Look at the tree in `turtle.nex.iqtree` or visualize `turtle.nex.treefile` 
>   in FigTree. What relationship among [three trees](#1-input-data) does this tree support? 
> 
> * What is the ultrafast bootstrap support (%) for the relevant clade?
> 
> * Does this tree agree with the published tree ([Chiari et al., 2012])?
{: .tip}


4) Choosing the best partitioning scheme
----------------------------------------
<div class="hline"></div>

We now perform the PartitionFinder algorithm ([Lanfear et al., 2012]) that tries to 
merge partitions to reduce the potential over-parameterization.

> What is the command line to run `iqtree3` that takes `turtle.fa` as input alignment,
> `turtle.nex` as input partition file, performs 1000 ultrafast bootstrap replicates,
> merges the partitions with relaxed clustering algorithm,
> and automatically determines the best number of cores?

* Please use `--prefix turtle.merge` to set the prefix for all output files as `turtle.merge.*`. 
  This is to avoid overwriting outputs from the previous analysis.


<button type="button" class="btn btn-primary" id="button4" onclick="myFunction('button4','command4')">
Show me the command line</button>
<div id="command4" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -p turtle.nex -B 1000 -T AUTO -m MFP+MERGE -rcluster 10 --prefix turtle.merge</code></pre>

Options explained:

<ul>
<li>`-m MFP+MERGE` to perform PartitionFinder followed by tree reconstruction.</li>
<li>`-rcluster 10` to reduce computations by only examining the top 10% partitioning 
  schemes using the *relaxed clustering algorithm* ([Lanfear et al., 2014]). </li>
</ul>

</div>

> **QUESTIONS:**
> 
> * Look at the report file `turtle.merge.iqtree`. How many partitions do we have now?
> 
> * Look at the AIC/AICc/BIC scores. Compared with two previous models, is this model better or worse?
> 
> * Look at the tree in `turtle.merge.iqtree` or visualize `turtle.merge.treefile` 
>   in FigTree. What relationship among [three trees](#1-input-data) does this tree support? 
> 
> * What is the ultrafast bootstrap support (%) for the relevant clade?
> 
> * Does this tree agree with the published tree ([Chiari et al., 2012])?
{: .tip}


5) Tree topology tests
----------
<div class="hline"></div>

We now want to know whether the trees inferred for the Turtle data set have 
significantly different log-likelihoods or not. This can be conducted with 
the SH test ([Shimodaira and Hasegawa, 1999]), or expected likelihood weights 
([Strimmer and Rambaut, 2002]).

First, concatenate the trees constructed by single and partition models into one file:

For Linux/MacOS:

	cat turtle.fa.treefile turtle.nex.treefile >turtle.trees

For Windows:

	type turtle.fa.treefile turtle.nex.treefile >turtle.trees
	
Now you can pass this file into IQ-TREE via `-z` option.

> What is the command line to run `iqtree3` that takes `turtle.fa` as input alignment,
> `turtle.merge.best_scheme.nex` as input partition file, 
> `turtle.trees` as input trees file, performs topology tests with 10,000 replicates,
> performs the approximately unbiased (AU) test,
> and no tree search to save time?

* Please use `--prefix turtle.test` to set the prefix for all output files as `turtle.test.*`. 

<button type="button" class="btn btn-primary" id="button5" onclick="myFunction('button5','command5')">
Show me the command line</button>
<div id="command5" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -p turtle.merge.best_scheme.nex -z turtle.trees -zb 10000 -au -n 0 --prefix turtle.test</code></pre>

Options explained:

<ul>
<li>`-p turtle.merge.best_scheme.nex` to provide the best partitioning scheme found 
  previously to avoid running ModelFinder again.</li>
<li>`-z turtle.trees` to input a set of trees.</li>
<li>`-zb 10000` to specify 10000 replicates for *approximate* boostrap for tree topology tests.</li>
<li>`-au` is to perform the Approximately Unbiased test.</li>
<li>`-n 0` to avoid tree search and just perform tree topology tests.</li>
</ul>

</div>

> **QUESTIONS:**
> 
> * Look at the `USER TREES` section in the report file `turtle.test.iqtree`. Which
> tree has worse log-likelihood?
> 
> * Can you reject this tree according to the Shimodaira Hasegawa test, assuming a 
>   p-value cutoff of 0.05?
>  
> * Can you reject this tree according to the Approximately Unbiased test,
>   assuming a p-value cutoff of 0.05?
{: .tip}


**HINTS**:

 - The KH, SH and AU tests return p-values, thus a tree is rejected if its p-value < 0.05 
   (marked with a `-` sign).
 - bp-RELL and c-ELW return posterior weights which are **not** p-value. The weights 
   sum up to 1 across the trees tested.

6) Tree mixture model
---------------------

Another way to analyze different topologies is to use the mixture across sites and trees
(MAST) model. MAST relaxes the assumption of a single bifurcating tree on the data. 
MAST assumes that there is a collection of trees, where each site of the alignment
can have a certain probability of having evolved under each of the trees. Each tree
has its own topology and branch lengths, and optionally different substitution rates, 
different nucleotide/amino acid frequencies, and even different rate heterogeneities
across sites. The MAST model will estimate all these parameters, and additionally a 
**weight** for each tree, roughly representing the proportion of sites evolving
under that tree. Unlike partition models, tree mixture model does not need to a 
partition file, and thus is actually simpler to run.

Your task is now to apply the MAST model to the Turtle data. To use this model, you
will need to use the option `-m` to specify the model, and adding "+T" to the model name.
For example, you can use `-m GTR+T`, but this model is a bit too simple. The better way is
to look again the best model found in step 2, and add "+T" to that model name.

> What is the command line to run `iqtree3` that takes `turtle.fa` as input alignment,
> `turtle.trees` as input trees file, applies the MAST model combined with the best
> model found in step 2?

* Please use `--prefix turtle.mix` to set the prefix for all output files as `turtle.mix.*`. 

<button type="button" class="btn btn-primary" id="button6" onclick="myFunction('button6','command6')">
Show me the command line</button>
<div id="command6" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -m BEST_MODEL_NAME+T -te turtle.trees --prefix turtle.mix
</code></pre>
	
Options explained:	

<ul>	
<li>`BEST_MODEL_NAME` is the model string found in step 2, that you need to replace with for
  this command line to run properly.</li>
<li>`-te` is to specify a file containing the set of trees for the MAST model. 
  Currently, MAST only accepts a set of fixed tree topologies provided by the users. 
  It doesn't yet have the ability to automatically find the optimal trees.</li>
</ul>

</div>

> **QUESTIONS:**
> 
> * Look at `turtle.mix.iqtree` for the line printing the tree weights. Which tree has a higher weight? 
> * Is it the tree having higher likelihood found in step 5?
{: .tip}

7) Identifying most influential genes
-------------------------------------
<div class="hline"></div>


Now we want to investigate the cause for such topological difference between trees 
inferred by single and partition model. One way is to identify genes contributing 
most phylogenetic signal towards one tree but not the other. 

How can one do this? We can look at the gene-wise log-likelihood (logL) differences 
between the two given trees T1 and T2. Those genes having the largest logL(T1)-logL(T2) 
will be in favor of T1. Whereas genes showing the largest logL(T2)-logL(T1) are favoring T2.

To compute gen-wise log-likelihoods for the two trees, you can use the `-wpl` option 
(for writing partition log-likelihoods): 

	iqtree3 -s turtle.fa -p turtle.nex.best_scheme.nex -z turtle.trees -n 0 -wpl --prefix turtle.wpl

will write a file `turtle.wpl.partlh`, that contains log-likelihoods for all partitions 
in the original partition file. We use `-p turtle.nex.best_scheme.nex` here 
(instead of `-p turtle.nex`) to avoid doing model selection again.

Import `turtle.wpl.partlh` into MS Excel, Libre Office Calc, or any other spreadsheet 
software. You will need to tell the software to treat spaces as delimiters, so that 
the values are imported into different columns for easy processing (e.g., doing 
log-likelikehood subtraction as pointed out above).

> **QUESTIONS:**
>
> * Compute the gene-wise log-likelihood differences between two trees. 
> 
> * What is the name of the gene showing the largest log-likelihood difference between two trees?
> 
> * What is the name of the gene showing the second largest log-likelihood difference between two trees?
> 
> * Were these two genes identified in ([Brown and Thomson, 2016])?
> 
> * Briefly describe what is the problem of these two genes?
{: .tip}

8) Removing influential genes
-----------------------------

We now try to construct a tree without these "influential" genes. 
To do so, copy the partition file `turtle.nex` to a new file and 
remove the lines defining the `charset` of these genes, and then
repeat the IQ-TREE run with a partition model (see section 4).
You will need to figure out a command line to run IQ-TREE yourself here.

> **QUESTIONS:**
> 
> * Document which command line did you use to run IQ-TREE?
> 
> * What tree topology do you get now? 
> 
> * What is the ultrafast bootstrap support (%) for the relevant clade?
> 
> * Does this tree agree with the published tree ([Chiari et al., 2012])?
{: .tip}

9) Concordance factors
----------------------
<div class="hline"></div>

> This task is optional

So far we have assumed that gene trees and species tree are equal. However, it is 
well known that gene trees might be discordant. Therefore, we now want to quantify 
the agreement between gene trees and species tree in a so-called *concordance factor* 
([Minh et al., 2020]).

You first need to compute the gene trees, one for each partition separately:

	iqtree3 -s turtle.fa -S turtle.nex --prefix turtle.loci -T 2
	
Options explained:

* `-S turtle.nex` to tell IQ-TREE to infer separate trees for every partition in 
  `turtle.nex`. All output files are similar to a partition analysis, except that 
  the tree `turtle.loci.treefile` now contains a set of gene trees.

> __Definitions:__
>
> * __Gene concordance factor (gCF)__ is the percentage of *decisive* gene trees 
>   concordant with a particular branch of the species tree (0% <= gCF(b) <= 100%). 
>   gCF=0% means that branch *b* does not occur in any gene trees, whereas gCF=100% 
>   means that branch *b* occurs in every gene tree.
> 
> * __Site concordance factor (sCF)__ is the percentage of *decisive* (parsimony 
>   informative) alignment sites supporting a particular branch of the species tree 
>   (~33% <= sCF(b) <= 100%). sCF<33% means that another discordant branch *b'* is 
>   more supported, whereas sCF=100% means that branch *b* is supported by all sites.
> 
> * __CAUTION__ when gCF ~ 0% or sCF < 33%, even if boostrap supports are ~100%!
> 
> * __GREAT__ when gCF and sCF > 50% (i.e., branch is supported by a majority of genes and sites).

You can now compute gCF and sCF for the tree inferred under the partition model:

	iqtree3 -t turtle.nex.treefile --gcf turtle.loci.treefile -s turtle.fa --scf 100
	
Options explained:

* `-t turtle.nex.treefile` to specify a species tree. We use tree under the 
  partitioned model here, but you can of course use the other tree.
* `--gcf turtle.loci.treefile` to specify a gene-trees file.
* `--scf 100` to draw 100 random quartets when computing sCF.

Once finished this run will write several files:

* `turtle.nex.treefile.cf.tree`: tree file where branches are annotated with bootstrap/gCF/sCF values.
* `turtle.nex.treefile.cf.stat`: a table file with various statistics for every branch of the tree.

Similarly, you can compute gCF and sCF for the tree under unpartitioned model:

	iqtree3 -t turtle.fa.treefile --gcf turtle.loci.treefile -s turtle.fa --scf 100


> **QUESTIONS:**
> 
> * Visualise `turtle.nex.treefile.cf.tree.nex` in FigTree. 
> 
> * Explore gene concordance factor (gCF), gene discordance factors (gDF1, gDF2, gDFP), 
>   site concordance factor (sCF) and site discordance factors (sDF1, sDF2).
> 
> * How do gCF and sCF values look compared with bootstrap supports?
> 
> * Visualise `turtle.fa.treefile.cf.tree`. How do these values look like now on the 
>   contradicting branch?
{: .tip}


10) Applying a mixture model
---------------------------
<div class="hline"></div>


We now perform a mixture model analysis ([Ren et al., 2025]), where 
each site is described as a mixture of models. For this exercise we will use a slightly different model, GTR+FO+I+R3, which is the best fit to the entire turtle dataset. 

Estimate a phylogeny under this model as a baseline:

	iqtree3 -s turtle.fa -m GTR+FO+I+R3 -B 1000 -T AUTO --prefix turtlebest

> What is the command line to run `iqtree3` that takes `turtle.fa` as input alignment and 
> estimates the phylogeny under GTR+FO+I+R3, but now as mixture model with two separate classes?
> This command should also perform 1000 ultrafast bootstrap replicates and automatically determine the best number of cores.

<button type="button" class="btn btn-primary" id="buttonX" onclick="myFunction('buttonX','commandX')">
Show me the command line</button>
<div id="commandX" style="display: none; border:1px solid gray;">

<pre><code>iqtree3 -s turtle.fa -m MIX"{GTR+FO,GTR+FO}"+I+R3 -B 1000 -T AUTO --prefix turtle2</code></pre>

Options explained:

<ul>
<li>`-m MIX"{GTR+FO,GTR+FO}"+I+R3` to specify a mixture model with two separate GTR models ([Ren et al., 2025]) with optimized nucleotide frequencies as well as invariant sites and 3 freerate categories. The quotes aroung the curly braces are important, otherwise bash will try to do variable expansion. </li>
<li>`--prefix turtle2` to keep file names informative and tidy. </li>
</ul>

> Now use the same command structure to try a mixture model with 4 classes, and another one with 6 classes! These will take some time to run, more as the number of classes increases. In the meantime, check out  [Ren et al., 2025], which performed a similar analysis of mixture models with different numbers of model classes - on a larger turtles dataset.

</div>


> **QUESTIONS:**
> 
> * Look at the report files `turtlebest.iqtree`, `turtle2.iqtree`, `turtle4.iqtree`, and `turtle6.iqtree`. What are the  BIC scores of the various mixture models? Which is best?
> 
> * Look at the tree in `turtle2.iqtree` or visualize `turtle2.treefile` 
>   in FigTree. What relationship among [three trees](#1-input-data) does this tree support? What about for the 4- and 6-class models?
> 
> * What is the ultrafast bootstrap support (%) for the relevant clade under each model?
> 
> * Which of these trees agree with the published tree ([Chiari et al., 2012])? Do the relationships or ultrafast bootstrap values change with model complexity?
> * [Ren et al., 2025] performed a similar analysis of the effect of number of model classes on the relationships between turtle, bird, and crocodile. What relationship among [three trees](#1-input-data) do these authors find supported by a 1-class model? What about a 6-class model? Do our results agree?
{: .tip}


> **FINAL QUESTIONS:**
> 
> * Given all analyses you have done in this tutorial, which relationship between 
>   Turtle, Crocodile and Bird is true in your opinion?



[Adachi and Hasegawa, 1996]: http://www.is.titech.ac.jp/~shimo/class/doc/csm96.pdf
[Anisimova et al., 2011]: https://doi.org/10.1093/sysbio/syr041
[Brinkmann et al., 2005]: https://doi.org/10.1080/10635150500234609
[Brown and Thomson, 2016]: https://doi.org/10.1093/sysbio/syw101
[Chernomor et al., 2016]: https://doi.org/10.1093/sysbio/syw037
[Chiari et al., 2012]: https://doi.org/10.1186/1741-7007-10-65
[Gadagkar et al., 2005]: https://doi.org/10.1002/jez.b.21026
[Guindon et al., 2010]: https://doi.org/10.1093/sysbio/syq010
[Hoang et al., 2018]: https://doi.org/10.1093/molbev/msx281
[Kalyaanamoorthy et al., 2017]: https://doi.org/10.1038/nmeth.4285
[Kishino et al., 1990]: https://doi.org/10.1007/BF02109483
[Kishino and Hasegawa, 1989]: https://doi.org/10.1007/BF02100115
[Lanfear et al., 2012]: https://doi.org/10.1093/molbev/mss020
[Lanfear et al., 2014]: https://doi.org/10.1186/1471-2148-14-82
[Le et al., 2008a]: https://doi.org/10.1093/bioinformatics/btn445
[Lewis, 2001]: https://doi.org/10.1080/106351501753462876
[Lopez et al., 2002]: http://mbe.oxfordjournals.org/content/19/1/1.full
[Mayrose et al., 2004]: https://doi.org/10.1093/molbev/msh194
[Minh et al., 2013]: https://doi.org/10.1093/molbev/mst024
[Minh et al., 2020]: https://doi.org/10.1093/molbev/msaa106
[Nei et al., 2001]: https://doi.org/10.1073/pnas.051611498
[Nguyen et al., 2015]: https://doi.org/10.1093/molbev/msu300
[Ren et al., 2025]: https://doi.org/10.1093/molbev/msae264
[Shimodaira and Hasegawa, 1999]: https://doi.org/10.1093/oxfordjournals.molbev.a026201
[Shimodaira, 2002]: https://doi.org/10.1080/10635150290069913
[Strimmer and Rambaut, 2002]: https://doi.org/10.1098/rspb.2001.1862
[Wang et al., 2018]: https://doi.org/10.1093/sysbio/syx068
[Yang, 1994]: https://doi.org/10.1007/BF00160154
[Yang, 1995]: http://www.genetics.org/content/139/2/993.abstract

