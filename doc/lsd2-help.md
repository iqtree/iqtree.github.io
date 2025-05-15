---
layout: userdoc
title: "LSD2 commands"
author: Minh Bui
date:    2025-05-05
docid: 7.5
icon: info-circle
tags:
- tutorial
description: "All LSD2 command"
---

```
LSD: LEAST-SQUARES METHODS TO ESTIMATE RATES AND DATES - v.1.8

DESCRIPTION
	This program estimates the rate and the dates of the input phylogenies given
some temporal constraints.
	It minimizes the square errors of the branch lengths under normal
distribution model.

SYNOPSIS
	./lsd [-i inputFile] [-d inputDateFile] [-o outputFile] [-s sequenceLength]
[-g outgroupFile] [-f nbSamplings] 
OPTIONS
	-a rootDate
	   To specify the root date if there's any. If the root date is not a
number, but a string (ex: 2020-01-10, or b(2019,2020)) then it should
	   be put between the quotes.
	-b varianceParameter
	   The parameter (between 0 and 1) to compute the variances in option -v. It
is the pseudo positive constant to add to the branch lengths
	   when calculating variances, to adjust the dependency of variances to
branch lengths. By default b is the maximum between median branch length
	   and 10/seqlength; but it should be adjusted  based on how/whether the
input tree is relaxed or strict. The smaller it is the more variances
	   would be linear to branch lengths, which is relevant for strict clock.
The bigger it is the less effect of branch lengths on variances, 
	   which might be better for relaxed clock.
	-d inputDateFile
	   This options is used to read the name of the input date file which
contains temporal constraints of internal nodes
	   or tips. An internal node can be defined either by its label (given in
the input tree) or by a subset of tips that have it as 
	   the most recent common ancestor (mrca). A date could be a real or a
string or format year-month-day.
	   The first line of this file is the number of temporal constraints. A
temporal constraint can be fixed date, or a 
	   lower bound l(value), or an upper bound u(value), or an interval b(v1,v2)
	   For example, if the input tree has 4 taxa a,b,c,d, and an internal node
named n, then following is a possible date file:
	    6
	    a l(2003.12)
	    b u(2007.07)
	    c 2005
	    d b(2001.2,2007.11)
	    mrca(a,b,c,d) b(2000,2001)
	    n l(2004.3)
	   If this option is omitted, and option -a, -z are also omitted, the
program will estimate relative dates by giving T[root]=0 and T[tips]=1.
	-D outDateFormat
	    Specify output date format: 1 for real, 2 for year-month-day. By default
the program will guess the format of input dates and uses it for
	    output dates.
	-e ZscoreOutlier
	   This option is used to estimate and exclude outlier nodes before dating
process.
	   LSD2 normalize the branch residus and decide a node is outlier if its
related residus is great than the ZscoreOutlier.
	   A normal value of ZscoreOutliercould be 3, but you can adjust it
bigger/smaller depending if you want to have
	   less/more outliers. Note that for now, some functionalities could not be
combined with outliers estimation, for example 
	   estimating multiple rates, imprecise date constraints.
	-f samplingNumberCI
	   This option calculates the confidence intervals of the estimated rate and
dates. The branch lengths of the esimated
	   tree are sampled samplingNumberCI times to generate a set of simulated
trees. To generate simulated lengths
	   for each branch, we use a Poisson distribution whose mean equals to the
estimated one multiplied by the sequence length, which is 
	   1000 by default if nothing was specified via option -s. Long sequence
length tends to give small confidence intervals. To avoid 
	   over-estimate the confidence intervals in the case of very long sequence
length but not necessarily strict molecular clock, you 
	   could use a smaller sequence length than the actual ones. Confidence
intervals are written in the nexus tree with label CI_height,
	   and can be visualzed with Figtree under Node bar feature.
	-g outgroupFile
	   If your data contain outgroups, then specify the name of the outgroup
file here. The program will use the outgroups to root the trees.
	   If you use this combined with options -G, then the outgroups will be
removed. The format of this file should be:
	        n
	        OUTGROUP1
	        OUTGROUP2
	        ...
	        OUTGROUPn
	-F 
	   By default without this option, we impose the constraints that the date
of every node is equal or smaller then the
	   dates of its descendants, so the running time is quasi-linear. Using this
option we ignore this temporal constraints, and
	   the the running time becomes linear, much faster.
	-h help
	   Print this message.
	-i inputTreesFile
	   The name of the input trees file. It contains tree(s) in newick format,
each tree on one line. Note that the taxa sets of all
	   trees must be the same.
	-j
	   Verbose mode for output messages.
	-G
	   Use this option to remove the outgroups (given in option -g) in the
estimated tree. If this option is not used, the outgroups 
	   will be kept and the root position in estimated on the branch defined by
the outgroups.
	-l nullBlen
	   A branch in the input tree is considered informative if its length is
greater this value. By default it is 0.5/seq_length. Only 
	   informative branches are forced to be bigger than a minimum branch length
(see option -u for more information about this).
	-m samplingNumberOutlier
	   The number of dated nodes to be sampled when detecting outlier nodes.
This should be smaller than the number of dated nodes,
	   and is 10 by default.
	-n datasetNumber
	   The number of trees that you want to read and analyse.
	-o outputFile
	   The base name of the output files to write the results and the time-scale
trees.
	-p partitionFile
	   The file that defines the partition of branches into multiple subsets in
the case that you know each subset has a different rate.
	   In the partition file, each line contains the name of the group, the
prior proportion of the group rate compared to the main rate
	   (selecting an appropriate value for this helps to converge faster), and a
list of subtrees whose branches are supposed to have the 
	   same substitution rate. All branches that are not assigned to any subtree
form a group having another rate.
	   A subtree is defined between {}: its first node corresponds to the root
of the subtree, and the following nodes (if there any) 
	   correspond to the tips of the subtree. If the first node is a tip label
then it takes the mrca of all tips as the root of the subtree.
	   If the tips of the subtree are not defined (so there's only the defined
root), then by 
	   default this subtree is extended down to the tips of the full tree. For
example the input tree is 
	   ((A:0.12,D:0.12)n1:0.3,((B:0.3,C:0.5)n2:0.4,(E:0.5,(F:0.2,G:0.3)n3:0.33)
n4:0.22)n5:0.2)root;
	   and you have the following partition file:
	         group1 1 {n1} {n5 n4}
	         group2 1 {n3}
	   then there are 3 rates: the first one includes the branches (n1,A),
(n1,D), (n5,n4), (n5,n2), (n2,B), (n2,C); the second one 
	   includes the branches (n3,F), (n3,G), and the last one includes all the
remaining branches. If the internal nodes don't have labels,
	   then they can be defined by mrca of at least two tips, for example n1 is
mrca(A,D)
	-q standardDeviationRelaxedClock
	   This value is involved in calculating confidence intervals to simulate a
lognormal relaxed clock. We multiply the simulated branch lengths
	   with a lognormal distribution with mean 1, and standard deviation q. By
default q is 0.2. The bigger q is, the more your tree is relaxed
	   and give you bigger confidence intervals.
	-r rootingMethod
	   This option is used to specify the rooting method to estimate the
position of the root for unrooted trees, or
	   re-estimate the root for rooted trees. The principle is to search for the
position of the root that minimizes
	   the objective function.
	   Use -r l if your tree is rooted, and you want to re-estimate the root
locally around the given root.
	   Use -r a if you want to estimate the root on all branches (ignoring the
given root if the tree is rooted).
	       In this case, if the constrained mode is chosen (option -c), method
"a" first estimates the root without using the constraints.
	       After that, it uses the constrained mode to improve locally the
position of the root around this pre-estimated root.
	   Use -r as if you want to estimate to root using constrained mode on all
branches.
	   Use -r k if you want to re-estimate the root position on the same branche
of the given root.
	       If combined with option -g, the root will be estimated on the branche
defined by the outgroups.
	-R round_time
	   This value is used to round the minimum branch length of the time scaled
tree. The purpose of this is to make the minimum branch length
	   a meaningful time unit, such as day, week, year ... By default this value
is 365, so if the input dates are year, the minimum branch
	   length is rounded to day. The rounding formula is round(R*minblen)/R.
	-s sequenceLength
	   This option is used to specify the sequence length when estimating
confidence intervals (option -f). It is used to generate 
	   integer branch lengths (number of substitutions) by multiplying this with
the estimated branch lengths. By default it is 1000.
	-S minSupport
	   Together with collapsing internal short branches (see option -l), users
can also collapse internal branches having weak support values (if
	   provided in the input tree) by using this option. The program will
collapse all internal branches having support <= the specifed value.
	-t rateLowerBound
	   This option corresponds to the lower bound for the estimating rate. It is
1e-10 by default.
	-u minBlen
	   By default without this option, lsd2 forces every branch of the time
scaled tree to be greater than 1/(seq_length*rate) where rate is
	   an pre-estimated median rate. This value is rounded to the number of days
or weeks or years, depending on the rounding parameter -R.
	   By using option -u, the program will not estimate the minimum branch
length but use the specified value instead.
	-U minExBlen
	   Similar to option -u but applies for external branches if specified. If
it's not specified then the minimum branch length of external
	   branches is set the same as the one of internal branch.
	-v variance
	   Use this option to specify the way you want to apply variances for the
branch lengths. Variances are used to recompense big errors on
	   long estimated branch lengths. The variance of the branch Bi is Vi =
(Bi+b) where b is specified by option -b.
	   If variance=0, then we don't use variance. If variance=1, then LSD uses
the input branch lengths to calculate variances.
	   If variance=2, then LSD runs twice where the second time it calculates
the variances based on the estimated branch
	   lengths of the first run. By default variance=1.
	-V 
	   Get the actual version.
	-w givenRte
	   This option is used to specify the name of the file containing the
substitution rates.
	   In this case, the program will use the given rates to estimate the dates
of the nodes.
	   This file should have the following format
	        RATE1
	        RATE2
	        ...
	  where RATEi is the rate of the tree i in the inputTreesFile.
	-z tipsDate
	   To specify the tips date if they are all equal. If the tips date is not a
number, but a string (ex: 2020-01-10, or b(2019,2020))
	   then it should be put between the quotes.
```

