
How do I interpret ultrafast bootstrap (UFBoot) support values?
---------------------------------------------------------------

This feature (`-bb` option) was published in  ([Minh et al., 2013]). One of the main conclusion, is that UFBoot support values are more unbiased: 95% support correspond roughly to the probability of 95% that a clade is true. So this has a different meaning than the normal bootstrap supports (where you start to believe in the clade if it has >80% BS support). For UFBoot, you should only start to believe in the clade if its support >= 95%. Thus, the interpretations are different and you should not compare BS% with UFBoot% directly. 

Moreover, it is recommended to also perform the SH-aLRT test ([Guindon et al., 2010]) by adding `-alrt 1000` into IQ-TREE command line. Each branch will then be assigned with SH-aLRT and UFBoot supports. One would typically start to rely on the clade if its SH-aLRT >= 80% and UFboot >= 95%. 


How does IQ-TREE treat gap/missing characters?
----------------------------------------------

Gaps (`-`) and missing characters (`?` or `N` for DNA alignments) are treated in the same way as `unknown` characters, which represent no information. The same treatment holds for many other ML software (e.g., RAxML, PhyML). More explicitly,
for a site (column) of an alignment containing `AC-AG-A` (i.e. A for sequence 1, C for sequence 2, `-` for sequence 3, and so on), the site-likelihood
of a tree T is equal to the site-likelihood of the subtree of T restricted to those sequences containing non-gap characters (`ACAGA`).


Can I mix DNA and protein data in a partitioned analysis?
---------------------------------------------------------

Yes, you can! In fact, you can mix any data types supported in IQ-TREE, including also codon, binary, morphological data. To do so, each partition should be in a separate alignment file. Then, prepare a NEXUS partition file which may look like:

    #nexus
    begin sets;
        charset part1=dna.phy: *;
        charset part2=protein.phy: *;
        charpartition mymodel=GTR+G: part1, LG+I+G: part2;
    end;

Here, it is assumed that `dna.phy` and `protein.phy` are DNA and protein alignment files, respectively. IQ-TREE will automatically detect the sequence types, which works correctly in 99% of the cases. If you want to explicitly specify the sequence type, the partition file may look like:

    #nexus
    begin sets;
        charset part1=dna.phy: DNA, *;
        charset part2=protein.phy: AA, *;
        charpartition mymodel=GTR+G: part1, LG+I+G: part2;
    end;
 
Finally, please note that you can also specify the site ranges within each alignment. For example:

    #nexus
    begin sets;
        charset part1=dna.phy: DNA, 1-150;
        charset part2=protein.phy: AA, 1-100 201-300;
        charset part3=protein.phy: AA, 101-200;
        charpartition mymodel=GTR+G: part1, LG+I+G: part2, WAG+I: part3;
    end;
 

[Guindon et al., 2010]: http://dx.doi.org/10.1093/sysbio/syq010
[Minh et al., 2013]: http://dx.doi.org/10.1093/molbev/mst024
