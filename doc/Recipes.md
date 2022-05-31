# Recipes

This is a collection of one-off examples of analyses in IQ-TREE. One might call them 'infrequently asked questions'. The idea is a searchable and reproducible database of analyses to help the community do what they need to with IQ-TREE.

If you'd like to request a recipe, please head over to the issues page and use the 'recipe wanted' label.

## Perform a Goldman-Cox test (a type of parametric bootstrap)

### What's a parametric bootstrap

A parametric bootstrap is a _really_ useful way to ask questions in phylogenetics. The absolute classic paper on this is from [Goldman, Anderson, and Rodrigo in 2000](https://academic.oup.com/sysbio/article/49/4/652/1678908). You should read this first. There are many flavours of parametric bootsrap in phylogenetics, but they all follow the same pattern:

1. Do an analysis on your focal dataset (probably your empirical dataset), and measure the thing you're interested in
2. Use the model you estimated on your empirical dataset to simulate a lot of new datasets
3. Measure the thing you are interested in on each of the simulated datasets
4. Ask if your observed value (from step 1) is surprising given the list of simulated values (from step 3)

### What's the Goldman-Cox test

Nick Goldman explains the Goldman-Cox (GC) test in [this paper](https://link.springer.com/article/10.1007/BF00166252)

The basic idea is that we are asking whether the _full_ model (i.e. the tree, branch lenghts, model parameters, _everything_ we estimate from the data) are an adequate description of the data. We do this by calcualting the _cost_ of the model, which is just: the maximum liklelihood of the data under the model, minus the _unconstrained_ likelihood. We'll call this _delta_. You can read Nick's paper for a full description of this, but he puts it rather nicely on page 184:

```
[delta] can be considered the "cost" of using [our model assumptions] to make inferences about phylogeny. A low cost indicates that [our model] is adequate; a high cost indicates that [our model] is performing badly and should be rejected.
```

Of course, the issue with the GC test is it can't tell us which aspect(s) of the model is(are) performing poorly. Perhaps it's the assumption of a binary tree? Or a reversible model? Or stationarity? Still, it's a really good start, because it's a very general test of model adequacy.

### Doing a Goldman-Cox test with IQ-TREE

According to my four step process above, we need to do the following four things:

1. Analyse an empirical dataset, and calculate delta
2. Simulate 999 new datasets under the model we estimated for our empirical data
3. Calculate delta for each of our 999 simulations
4. Figure out the position of our observed delta in a ranked list of our simulated deltas

In step 4, if you're a biologist and you like working with an alpha value of 5%, you might consider that if your observed delta is in the highest 5% of the simualted deltas, you would reject your model under the GC test. I.e. you'd conclude that there is some aspect of your model which does not adequately represent your data. 

For this recipe I'll use data from the Bovidae family with five taxa (Yak, Cow, Goat, Sheep and Tibetan antelope) and 10,000 sites. This is a (very) small subset of the amazing [Wu et al 2018](https://doi.org/10.1016/j.dib.2018.04.094) dataset. I keep the file to 10K sites because that helps keep the file sizes manageable and analyses fast for a demonstration.



#### Input files

* [bovidae_10K.phy](http://www.iqtree.org/doc/data/bovidae.phy), our input alignment of 5 taxa and 86187 sites.

#### Command lines

##### 1. Analyse the original data and calculate delta

First we analyse our dataset:

```
iqtree -s bovidae_10K.phy
```

This is a standard analysis. We let IQ-TREE find the best model, and optimise the tree, branch lengths, and model parameters.

The `bovidae_10K.phy.iqtree` file, gives us the information we need to calculate delta:

```
Log-likelihood of the tree: -15917.0875 (s.e. 105.6299)
Unconstrained log-likelihood (without tree): -27852.4166
```

So delta here is: `-15917.0875 - -27852.4166 = 11935.3291`

Let's write a little bash function to calculate this value - it will help us in a bit when we have to do the same for 999 simulated datasets. The first couple of lines of this function just get the two likelihood values we want. Then we take the difference to get delta. Of course, you can do this in whatever language you like. But I like bash, so here's my attempt:

```bash
get_delta () {
    # a function to get the difference bewteen lnL and unconstrained lnL from a .iqtree file
    # assumes that the only passed argument is the name of a .iqtree file

    lnL_model=$(grep "Log-likelihood of the tree: " $1 | awk '{print $5}')
    lnL_unconstrained=$(grep "Unconstrained log-likelihood" $1 | awk '{print $5}')
    delta=$(echo $lnL_unconstrained - $lnL_model | bc) 

    echo $delta
}
```

Now if you copy-paste that function into your bash terminal, then run

```
get_delta bovidae_10K.phy.iqtree 
```

You should get the output `11935.3291`.

#### 2. Simulate 999 datasets under the model we estimated from our original data

Now, we need to simulate 999 datasets using the tree and model that we estimated from the `bovidae.phy` data, so that we can find out if our observed value of `11935.3291` is surprisingly large when the model is true. 

Luckily, IQ-TREE makes simulating our datasets trivially easy with [AliSim](https://academic.oup.com/mbe/article/39/5/msac092/6577219?login=true). At the end of your console output from the previous run (also at the end of the `bovidae.phy.log` file), you'll find this line:

```
ALISIM COMMAND
--------------
--alisim simulated_MSA -t bovidae_10K.phy.treefile -m "TPM2u{0.44449,3.77042}+F{0.275799,0.244704,0.248134,0.231364}+I{0.77037}" --length 10000
``` 

That would let you simulate 1 dataset. We need 999, so we just need to add `--num-alignments 999`. 
```
iqtree --alisim simulated_MSA -t bovidae_10K.phy.treefile -m "TPM2u{0.44449,3.77042}+F{0.275799,0.244704,0.248134,0.231364}+I{0.77037}" --length 10000 --num-alignments 999
```

Your folder will now contain lots of simulated alignments like `simulated_MSA_1.phy`, `simulated_MSA_2.phy` etc.

### 3. Calculate delta from all of those alignments

Now we need to analyse those 999 alignments in the same way we did in step 1. As above, you can do this in your favourite language. For this tutorial recipe I'll stay in bash though. We could make it fancy and do things in parallel, but for now we'll keep it simple and do things one by one in a for loop:

```bash
for alignment in simulated_MSA_*.phy; do
     iqtree -s $alignment
done
```

And now we need to get all of our deltas. The for loop below just puts all the delta values in a file called simulated_delta.txt:

```bash
for iqtree_file in simulated_MSA_*.phy.iqtree; do
     get_delta $iqtree_file >> simulated_delta.txt
done
```  

### 4. Figure out the position of our observed delta in a ranked list of our simulated deltas

This example is a stark one! If you look through your list of deltas in the `simulated_delta.txt` file, you'll see they're mostly below 100, and ALL well below the huge observed delta of 11935.3291. So, if we order the list of the 999 simulated deltas and our observed delta from largest to smallest, our observed delta would be in position 1 out of 1000 in the list. So we know our p-value here would be at most `1/1000`, i.e. `p<=0.001`. In other words, we can reject the hypothesis that the full model (tree, branch lengths, substitution model etc) is an adequate description of the data...

Not all analyses will be quite this obvious, so here's a little R script that you could use to calculate the p-value:

```R
# reads the simulated deltas into a data frame
simulated_deltas = read.delim("~/Desktop/test/simulated_delta.txt", header=F)

# the p-value is just the position of the observed value in the ranked list,
# divided by the list length
observed = 11935.3291

# the position is just the length of the list if you'd added the observed value (1000 in our case)
# minus how many of the simulated values are smaller than the observed value
position = (nrow(simulated_deltas) + 1) - sum(observed>simulated_deltas$V1)

# the p-value is just the position divided by teh length of the list if you'd added the observed value
p_value = position / (nrow(simulated_deltas) + 1)

p_value
```

In this case, you'd get the answer 0.001. Since we're at the very extreme of the distribution here, we can go one better than saying that the p-value _equals_ 0.001, and say that it is _at most_ 0.001, i.e. p<=0.001.

## Add sequences to an existing tree

### The general problem

This recipe shows you how to add new sequences to an existing tree, then to optionally perform a global re-optimisation of that tree.

Sometimes you have an existing phylogeny, and you'd like to add new sequences it without altering the existing relationships. This is increasingly common in what's called 'online' phylogenetics, for example when building phylogenies to track outbreaks where new data arrive every day. To read more about online phylogenetics you could read [this preprint](https://www.biorxiv.org/content/10.1101/2021.12.02.471004v2), which compares lots of approaches.

> If you have VERY large datasets, i.e. more than many tens of thousands of sequences, you should consider using [UShER & matOptimize](https://usher-wiki.readthedocs.io/en/latest/), or [MAPLE](https://github.com/NicolaDM/MAPLE) for your online phylogenetics analyses. 

### A specific example

For this example, I'll imagine you have an existing tree and alignment of 17 sequences (`T1` to `T17`). Since estimating your tree, you've added three new sequences to your alignment (`NEW_1`, `NEW_2`, and `NEW_3`). Now you want to _add_ those new sequences to your existing tree. 

### Input files

* `sequences.fa`: Your alignment of 20 sequences (`T1` to `T17`, and `NEW_1` to `NEW_3`)
* `existing_tree.nex`: An existing tree of 17 sequences (T1 to T17)

### Command line

```
iqtree -s sequences.fa -g existing_tree.nex 
```

* `-g` sets a constraint tree with our existing 17 sequences
* `-s` passes the alignment of the existing 17 sequences and the 3 new sequences

Your output tree will now look like this:

```
 /--+ T2                                                                                                                                        
 |                                                                                                                                              
 |               /--------+ T3                                                                                                                  
 |              /+                                                                                                                              
 |              |\-------------+ NEW 2                                                                                                          
 |              |                                                                                                                               
 |    /---------+                           /--+ T9                                                                                             
 |    |         |                        /--+                                                                                                   
 |    |         \------------------------+  \--+ NEW 3                                                                                          
 +----+                                  |                                                                                                      
 |    |                                  \-------+ T11                                                                                          
 |    |                                                                                                                                         
 |    \---------------------+ T4                                                                                                                
 |                                                                                                                                              
=+                                                                                /-+ T5                                                        
 |                                                                                |                                                             
 |                                                                /---------------+                               /----------------------+ T17  
 |                                                                |               \-------------------------------+                             
 |                                         /----------------------+                                               \---+ NEW 1                   
 |                                         |                      |                                                                             
 |                                         |                      |     /------------+ T13                                                      
 |                                         |                      \-----+                                                                       
 |                                       /-+                            \--------+ T15                                                          
 |                                       | |                                                                                                    
 |                                       | |      /----+ T6                                                                                     
 |                                       | |/-----+                                                                                             
 |                                       | \+     \----+ T10                                                                                    
 \---------------------------------------+  |                                                                                                   
                                         |  \----+ T7                                                                                           
                                         |                                                                                                      
                                         |   /-----------------+ T8                                                                             
                                         |   |                                                                                                  
                                         \---+     /-------+ T12                                                                                
                                             |     |                                                                                            
                                             \-----+                        /--------------+ T14                                                
                                                   |                        |                                                                   
                                                   \------------------------+      /-+ T1                                                       
                                                                            \------+                                                            
                                                                                   \-----------+ T16                                            
                                                                                                                                                
 |---------------------------------|--------------------------------|---------------------------------|--------------------------------|--      
 0                              0.25                              0.5                              0.75                                1        
 substitutions/site                                                                                                                             
```

### Explanation 
Our sequence alignment contains 20 sequences: T1 to T17, and NEW_1 to NEW_3. The sequences T1 to T17 all appear in our tree `existing_tree.nex`. The option `-g` uses `existing_tree.nex` as a constraint tree, which means that the topology of T1 to T17 will be fixed for this analysis. The sequences `NEW_1`, `NEW_2`, and `NEW_3` are not in the constraint tree. So, IQ-TREE will initially place these sequences onto the constraint tree using Maximum Parsimony, and then it will do standard ML optimisation of the tree without altering the underlying constraint tree. In other words, it will use the standard IQ-TREE search algorithm to try moving `NEW_1`, `NEW_2`, and `NEW_3` around on the constraint tree, and will keep these changes if they improve the likelihood. This optimisation helps for two reasons. First, placing sequences with sequential parsimony placement doesn't always give you the best parsimony placement, and second, even the best parsimony placement can differ from the best placement under a full Likelihood model. 


### Adding global optimisation

In some cases, e.g. if you've added a lot of new sequences to an existing tree, you might want to then re-optimise the tree _without_ the constraints. This is typically what we do for most online phylogenetics applications, for example. To do this, you would use the following options:

* `-t` to set the starting tree
* `-s` to pass the alignment

i.e.

```
iqtree -s sequences.fa -t sequences.treefile -pre reoptimised
```

This commandline simply uses the tree output from the first commandline (`sequences.treefile`) as the starting tree for a new analysis. That way you start from the best estimate of the tree you have, and IQ-TREE will then try to further optimise it in the absence of constraints.

### How to build this example yourself

Here's some code to build this example yourself from scratch. Note that this assumes you're working on Unix, and you'll need [`newick_utils`](https://anaconda.org/bioconda/newick_utils) for this to work. 

```
# simulate an alignment of 20 sequences (set the seed for reproducibility only)
iqtree2 --alisim sequences -t RANDOM{yh/20} -seed 438579088 -af fasta -m JC

# check the names
grep '>' sequences.fa

# replace names of 3 of them to be 'NEW_N'
sed -i -e 's/T18/NEW_1/g' sequences.fa
sed -i -e 's/T19/NEW_2/g' sequences.fa
sed -i -e 's/T20/NEW_3/g' sequences.fa

# check the names again
grep '>' sequences.fa

# prune the NEW_N sequences from the tree using newick_utils
nw_prune sequences.treefile T18 T19 T20 > existing_tree.nex

# check that you have the files you need
ls -lh

# run IQ-TREE to add NEW_N seqs back
iqtree -g existing_tree.nex -s sequences.fa -pre seqs_added -seed 438579088

# optional: do a global re-optimisation of the tree, using previous tree as start
iqtree -s sequences.fa -t seqs_added.treefile -pre re_optimised -seed 438579088
```

### IQ-TREE version
Last tested with IQ-TREE 2.2.0.3
