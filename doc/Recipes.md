# Recipes

This is a collection of one-off examples of analyses in IQ-TREE. One might call them 'infrequently asked questions'. The idea is a searchable and reproducible database of analyses to help the community do what they need to with IQ-TREE.

If you'd like to request a recipe, please head over to the issues page and use the 'recipe wanted' label.

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
