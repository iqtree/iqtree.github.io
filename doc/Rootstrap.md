IQ-TREE provides an option to calculate the rootstrap support values (Naser-Khdour et al 2021) for rooted and unrooted trees.

1.Using non-reversible models:

If you are using partitioned analysis, you first find the best partitioning scheme using the reversible model:

`iqtree2 –s example.phy –p example.nex --prefix UNROOTED`

This will infer the ML unrooted tree and print the result into `UNROOTED.treefile` and the best partitioning scheme 
and print the reult into`UNROOTED.best_scheme.nex.` . If you used the UFBoot option too, then the bootstrap trees will
be printed into `UNROOTED.ufboot` file 

You then can use the best partitioning scheme to find the ML rooted tree with the non-reversible model

For DNA, use the UNREST model:

`iqtree2 –s example.phy –p UNROOTED.best_scheme.nex –t UNROOTED.treefile -m UNREST -B 1000 --prefix ROOTED`

For amino acid, use the NONREV model:

`iqtree2 –s example.phy –p UNROOTED.best_scheme.nex –t UNROOTED.treefile -m NONREV -B 1000 --prefix ROOTED`

This will print the ML rooted tree with the rootstrap support values into the `ROOTED.rootstrap.nex` file. 
The tree file in Nexus format will look like this:

`
#NEXUS
[ This file is best viewed in FigTree. ]
begin trees;
  tree tree_1 = ((BOS_MUT:0.0035185508[&id="2",rootstrap="0"],BOS_TAU:0.0060681062[&id="3",rootstrap="0"]):0.0306288620[&id="1",rootstrap="23.8"],((CAPRA_HIR:0.0092827982[&id="6",rootstrap="0"],OVIS_ARI:0.0104285307[&id="7",rootstrap="0"]):0.0052665552[&id="5",rootstrap="33.5"],PANTH_HOD:0.0113457232[&id="8",rootstrap="42.7"]):0.0000022608[&id="4",rootstrap="23.8"]):0.0000000000[&id="0",rootstrap="23.8"];
end;
`

Note: If you are not using a partitioned analysis remove the `-p UNROOTED.best_scheme.nex –t UNROOTED.treefile` option.

Note: It is recommended to compare AIC/BIC values of the reversible and the non-reversible models before making any conclusions about the root placement.


2.Using reversible models with outgroup:

First find the unrooted ML tree and the unrooted bootstrap trees and print them to files `UNROOTED.treefile` and 
`UNROOTED.ufboot` respectively:

`iqtree2 –s example.phy –p example.nex –wbt -B 1000 --prefix UNROOTED`

You then can use the `-o` option to root the ML tree and the bootstrap trees with outgroup taxons (e.g. taxon1,taxon2,taxon3)
and use `--rootstrap` option to calculate the rootstrap support values

`iqtree2 –t UNROOTED.treefile –-rootstrap UNROOTED.ufboot -o taxon1,taxon2,taxon3 --prefix ROOTED`

This will print the ML rooted tree with the rootstrap support values into the `ROOTED.rootstrap.nex` file. and will print the topology test
on rooting positions across all branches to the `ROOTED.roottest.csv`. 

3.Perform topology tests on rooting positions across all branches

To perform topology tests on rooting positions across all branches use `--root-test –zb 1000 -au` option. This option will re-root the ML tree on all branches (including tips)
and will print the topology test table into `ROOTED.roottest.csv` that looks like this:

`
ID,logL,deltaL,bp-RELL,p-KH,p-SH,c-ELW,p-AU
1,-1412910.023,0,0.251,0.695,1,0.3333548982,0.7135619126
8,-1412910.023,3.927876242e-05,0.338,0.305,0.837,0.3333420861,0.4428443979
5,-1412910.023,0.0001593173947,0.411,0.111,0.811,0.3333030158,0.1048951504
7,-1413575.029,665.0064102,0,0,0,3.129908119e-223,2.688384524e-44
6,-1413575.029,665.0064236,0,0,0,3.130318178e-223,2.809697961e-44
3,-1417753.19,4843.167287,0,0,0,0,0.0002968435628
2,-1417753.191,4843.167847,0,0,0,0,0.000296849965
`

The "id" columns in the `ROOTED.roottest.csv` are identical to the "id" labels in the `ROOTED.rootstrap.nex` file. 

Note: This option can be combined with any of the options above to calculate the rootstrap support values and the AU test (and other topology tests) in one analysis.

