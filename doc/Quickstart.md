Minimal command-line examples (replace `iqtree` with actual path to executable):

1. Reconstruct maximum-likelihood tree from a sequence alignment (`example.phy`)
   with the best-fit substitution model automatically selected:

        iqtree -s example.phy -m TEST

2. Reconstruct ML tree and assess branch supports with ultrafast bootstrap
   and SH-aLRT test (1000 replicates):

        iqtree -s example.phy -m TEST -alrt 1000 -bb 1000

3. Perform partitioned analysis with partition definition file (`example.nex`)
   in Nexus or RAxML format using edge-linked model and gene-specific rates:

        iqtree -s example.phy -spp example.nex -m TEST

    (for edge-unlinked model replace `-spp` with `-sp` option)

4. Merge partitions to reduce model complexity:

        iqtree -s example.phy -sp example.nex -m TESTMERGE

5. Perform model selection only: use `-m TESTONLY` or `-m TESTMERGEONLY`

6. Use 4 CPU cores to speed up computation: use `iqtree-omp` and add `-nt 4` option

7. Show all available options: 

        iqtree -h
