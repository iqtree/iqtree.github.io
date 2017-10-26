---
layout: userdoc
title: "Web Server Tutorial"
author: _AUTHOR_
date: _DATE_
docid: 2
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: A quick starting guide for the IQ-TREE Web Server.
sections: 
- name: Tree Inference
  url: tree-inference
- name: Model Selection
  url: model-selection
- name: Analysis Results
  url: analysis-results
---

Web server tutorial
===================

A quick starting guide for the IQ-TREE Web Server.
<!--more-->


This tutorial explains briefly how to use the IQ-TREE web server for fast online phylogenetic inference, accessible at <a target="_blank" href="http://iqtree.cibiv.univie.ac.at"> <b>iqtree.cibiv.univie.ac.at</b></a>.

There are three tabs: [Tree Inference](#tree-inference), [Model Selection](#model-selection) and [Analysis Results](#analysis-results). 


Tree Inference
------------
<div class="hline"></div>

Tree Inference provides the most frequently used features of IQ-TREE and allows users to carry out phylogenetic analysis on a multiple sequence alignment (MSA). In the most basic case, no more than an MSA file is required to submit the job. Without further input, IQ-TREE will run with the default parameters and auto-detect the sequence type as well as the best-fitting substitution model. Additionally, Ultrafast Bootstrap (<a href="https://doi.org/10.1093/molbev/msx281" target="_blank">Hoang et al., in press</a>) and the SH-aLRT branch test (<a href="https://doi.org/10.1093/sysbio/syq010" target="_blank">Guindon et al., 2010</a>) will be performed. 

You can either try out the web server with an example alignment by ticking the corresponding box or upload your own alignment file. By clicking on 'Browse' a dialog will open where you can select your MSA; the file formats Phylip, Fasta, Nexus, Clustal and MSF are supported. 

![Tree Inference Tab](images/tut1.png)

After that you can submit the job. If you provide an email address, a notification will be sent to you once the job is finished. In case you don't specify an email address, you will receive a link in the next step; you can bookmark this link to retrieve your results after the job is finished. 



Model Selection
------------
<div class="hline"></div>

IQ-TREE supports a wide range of substitution models for DNA, protein, codon, binary and morphological alignments. In case you do not know which model is appropriate for your data, IQ-TREE can automatically determine the best-fit model for your alignment. Use the Model Selection tab if you only want to find the best-fit model without doing tree reconstruction.

![Model Selection Tab](images/tut2.png)

Like with [Tree Inference](#tree-inference), the only obligatory input is a multiple sequence alignment. You can either upload your own **alignment file** or use the **example alignment** to try out the web server and then **submit the job**. 




Analysis Results
------------
<div class="hline"></div>

In the tab Analysis Results you can monitor your jobs. With our example file, a run will only take a few seconds, depending on the server load. For your own alignments the CPU time limit is 24 hours. If you provided an email address when submitting the job, you will get an email once it is finished. 

![Analysis Results](images/tut3.png)

Once a job is finished, you can select it by checking the corresponding box and then **download the selected jobs** as a zip file. This zip file will contain the results of your run, including the **Run Log** and the **Full Result** which are also accessible in the webserver. 


| Suffix | Explanation |
|-------------|------------------------------------------------------------------------------|
| `.iqtree`   | Full result of the run, this is the main report file  |
| `.log`      | Run log |
| `.treefile` | Maximum likelihood tree in NEWICK format, can be visualized with treeviewer programs |
| `.svg`      |  Graphical tree representation in SVG format, done with ete view |
| `.pdf`      |  Graphical tree representation in PDF format, done with ete view |
| `.contree`  | Consensus tree with assigned branch supports where branch lengths are optimized on the original alignment; printed if Ultrafast Bootstrap is selected |
| `.ckp.gz`   | Checkpoint file; included if a job was stopped because of RAM/CPU limits |

>**NOTE**: Jobs which require more than 24 hours or 1GB RAM will be stopped. In such a case, you can download the stopped job and resume the run from the last checkpoint on your local PC as [described here](Command-Reference#checkpointing-to-resume-stopped-run). 

