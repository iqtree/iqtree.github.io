---
layout: workshop
title: "Simulating concatenated alignments with multiple trees"
author: Minh Bui
date:    2025-04-03
docid: 100
---


There is now a much simpler way. Please read:

[Topology-unlinked partition model](../AliSim#topology-unlinked-partition-model)

# Introduction

This recipe explains how to simulate an alignment which comes from multiple
trees.

For this example, we'll start by simulate a 5000bp alignment where the first
3500bp comes from one tree, and the remaining 1500bp comes from another tree.
Then we'll do something with a *lot* more trees.

Hopefully the combination of these two recipes will give you a good idea of how
to do many other simulations...

# What you need

* IQ-TREE 2.2 or above to simulate alignments using AliSim: http://www.iqtree.org/ 
* AMAS: https://github.com/marekborowiec/AMAS

I use conda to install both of these, and suggest you do to. If you want to do
that, here's one way to do it:

```bash
# set up a fresh environment and activate it
conda create --name simaln conda activate simaln

# install what we need for this recipe
conda install -c bioconda iqtree amas ```

# Simulating a two-tree alignment

First let's simulate our two separate alignments. The commandlines below each
simulate an alignment using a randomly generated 20 taxon Yule tree and a
GTR+I+R8 model with random parameters. You can change all of this of course -
for that just head over to the AliSim page and look at the various simulation
options. Here the options we specify are:

* `--alism [NAME]` to specify that we want to simulate an alignment and call it
`NAME` 
* `-t RANDOM{yh/20}` to specify that we want a randomly-generated Yule
tree of 20 taxa 
* `-m GTR+I+R8` to specify the model of sequence evolution 
* `--length [NUMBER]` to specify the length of each alignment

``` 
iqtree3 --alisim part1 -t RANDOM{yh/20} -m GTR+I+R8 --length 9000 
iqtree3 --alisim part2 -t RANDOM{yh/20} -m GTR+I+R8 --length 1000 
```

Now you'll see that you have `part1.phy` and `part2.phy`. Next we concatenate
these two alignments with AMAS, like this:

``` 
AMAS.py concat -i part1.phy part2.phy -f phylip -u phylip -t part1_part2_concat.phy -d dna 
```

With AMAS, we just specify:

* `-i [INPUT FILES]` the input files in the order we want to concatenate them 
* `-f [INPUT FORMAT]` input format of the alignments (phylip for us) 
* `-u [OUTPUT FORMAT]` output format of the concatenated alignment 
* `-t [OUTPUT FILENAME]` name of the output alignment 
* `-d [TYPE]` whether the input is `dna` or `aa`

That's it! Your final alignmnet is in the file `part1_part2_concat.phy`

# Generalising to any number of trees

With a few tricks from bash, we can easily generalise the above into a method of
creating concatenated alignments with any number of trees and any combination of
lengths. Of course there are *lots* of ways to do this, but here's one.

Here's the script, with comments to help decipher it. I'm not all that flash
with bash, so there are likely simpler ways to do some of this. But it will get
the job done.

```bash
#!/bin/bash

# set the lengths as a list
lengths=( 1000 1000 2000 5 3000 )

# get the number of alignments you want from the length of that list
N=$(wc -w <<< "${lengths[*]}")

# use a for loop to build the alignments one by one with IQ-TREE we'll also
# collect up the files to concatenate in this empty list
to_concat=( )

for (( i=0; i<$N; i++ )); do len=${lengths[$i]}

  # print to show what we're doing
  echo "index: $i, length: $len" iqtree3 --alisim $i -t RANDOM{yh/20} -m
  GTR+I+R8 --length $len

  # add the filename to the list of things to concatenate
  to_concat+=( $i".phy" )

done

# check the list of files we're going to concatenate
echo ${to_concat[*]}

# concatenate them all with AMAS
AMAS.py concat -i ${to_concat[*]} -f phylip -u phylip -t $N"_concat.phy" -d dna
```

# A few thoughts on that approach.

First, it should work fine for reasonably sized sets of alignments (e.g. up to a
thousand or so). But if you're looking to do millions then you'll probably want
to do a few things much smarter, like parallelise the simulation steps, and
maybe think about better ways to concatenate them (I have no idea how well AMAS
scales to really huge jobs).

Second, there's no guarantee that the trees will differ - these are random trees
after all. So if you really care then it would be a good idea to double check
that first, e.g. by simulating a set of trees that meet your requirments before
running IQ-TREE at all (you can pass individual trees to AliSim no problem).

Third, if AliSim fails to simulate an alignment for whatever reason, this script
will fall over, because AMAS will be trying to concatenate an alignment that
doesn't exist. So if you want to use this for research you should certainly add
in some basic error checking, e.g. that the length of the final alignment
matches the sum of the lengths of the inputs, that each file exists before you
try to concatenate it, etc.

Finally, it may be useful to make the script take some parameters as input -
like the list of lengths, or the model, number of taxa, or whatever. All this is
pretty simple, and you can find out how with google and Stack Overflow!

Still, I hope this is helpful and gives you some ways of getting started.


