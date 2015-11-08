
## For Window users

IQ-TREE is a command-line program, i.e., clicking on `iqtree.exe` will not work. You have to open a command prompt for all analyses. As an example, if you download `iqtree-1.3.10-Windows.zip` into your `Downloads` folder, then extract it into the same folder and do the following steps:

1. Click on "Start" menu (below left corner of Windows screen).
2. Type in "cmd" and press "Enter". It will open the Command Prompt window (see Figure below).
3. Type in `cd Downloads\iqtree-1.3.10-Windows` and press "Enter" to go into IQ-TREE folder.
4. Optionally, type in `dir` to display folder content, which may look like this:

    [[images/win-cmd.png]]

    You see that there is a `bin` folder (that contains the executable `iqtree.exe`), an example alignment file `example.phy`, and a manual pdf file.

5. Now you can try an example run by entering `bin\iqtree -s example.phy`.
6. After a few seconds, IQ-TREE finishes and you may see something like this:

[[images/win-cmd2.png]]

Congratulations ;-) You have finished the first IQ-TREE analysis.

## Minimal command-line examples

Please replace `iqtree` with actual path to executable:

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

        iqtree -s example.phy -sp example.nex -m TESTMERGEONLY

6. Use 4 CPU cores to speed up computation: use `iqtree-omp` and add `-nt 4` option, e.g.:

        iqtree-omp -s example.phy -m TEST -alrt 1000 -bb 1000 -nt 4

7. Show all available options: 

        iqtree -h