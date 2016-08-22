<!--jekyll 
docid: 13
icon: book
doctype: manual
tags:
- manual
sections:
- name: What is heterotachy model?
  url: what-is-heterotachy-model
- name: Download
  url: download
- name: Quick usage
  url: quick-usage
jekyll-->

Heterotachy mixture models documentation.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [What is heterotachy model?](#what-is-heterotachy-model)
- [Download](#download)
- [Quick usage](#quick-usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

What is heterotachy model?
--------------------------

Heterotachy (or Single Topology Heterotachy - STH) model is a mixture model composing of several site-classes, each having a separate set of branch lengths and model parameters. Thus, it is a complex model naturally accounting for heterotachous evolution ([Lopez, Casane, and Philippe, 2002](http://mbe.oxfordjournals.org/content/19/1/1.full)), which was shown to mislead conventional maximum likelihood and Bayesian inference ([Kolaczkowski and Thornton, 2004](http://dx.doi.org/10.1038/nature02917)). Our extensive simulations showed that an implementation of heterotachy models in IQ-TREE obtained almost 100% accuracy for heterotachously evolved sequences.

One can think of the heterotachy model as an *edge-unlinked mixture model*, which will infer the probabilities of each alignment site belonging to each mixture class. This is in contrast to an [edge-unlinkeed partition model](Complex-Models/#partition-models), which requires the appropriate partitioning of the data in advance, an ambitious assumption and a potential source of error for biological datasets in practice. 


Download
--------

IQ-TREE Heterotachy binaries are available for Windows, Mac OS X, and Linux:

<https://github.com/Cibiv/IQ-TREE/releases/tag/v1.4.3-heterotachy>

Source code is also downloadable from the above link.


Quick usage
-----------

The STH model with `k` mixture classes is executed by adding `+Hk` to the model option (`-m`). For example if one wants to fit a STH4 model in conjunction with the `GTR` model of DNA evolution to sequences contained in `data.fst`, one would use the following command:

    iqtree -s data.fst -m GTR+H4

By default the above command will infer one set of empirical base frequencies and apply those to all classes. If one wishes to infer separate base frequencies for each class then the `+FO` option is required:

    iqtree -s data.fst -m GTR+FO+H4

The `-wspm` option will generate a `.siteprob` output file. This contains the probability of each site belonging to each class:

    iqtree -s data.fst -m GTR+FO+H4 -wspm

The `-nni-eval` option controls the level to which IQ-TREE optimizes branch lengths when evaluating alternative topologies. A low value saves computation time but increases the probability of not finding the best topology. Higher values evaluate alternate tree topologies more thoroughly at the cost of extra computation time:

    iqtree -s data.fst -m GTR+FO+H4 -wspm -nni-eval 20



