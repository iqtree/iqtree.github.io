Binary release
--------------

The easiest way to install IQ-TREE is: 
* Download the precompiled executables (available for Windows, Mac OS X, and Linux) from the [release page](../releases). 
    - `iqtree-X.Y.Z-OS` is the sequential 64-bit version, where `X.Y.Z` is the version number and OS is the operating system name.
    - `iqtree-omp-X.Y.Z-OS` is the parallel multicore 64-bit version, which reduces computation time for long alignments. 
    - `iqtree32-X.Y.Z-OS` is the sequential 32-bit version.
    - `iqtree32-omp-X.Y.Z-OS` is the parallel multicore 32-bit version.
* Extract the files to create a directory `iqtree-X.Y.Z-OS` or `iqtree-omp-X.Y.Z-OS`.
* You will find the executable in the `bin` sub-folder. It is named `iqtree` or `iqtree-omp` (multicore version) (`iqtree.exe` or `iqtree-omp.exe` under Windows). Moreover, an example alignment file `example.phy` and a partition file `example.nex` are also included.

* Open a Terminal (or Console) to run IQ-TREE as it is a command-line program.

The executable (together with the `.dll` files for Windows version) can be copied to your system search path such that you can run `iqtree` command from the Terminal.


#### For Window users

IQ-TREE is a command-line program, i.e., clicking on `iqtree.exe` will not work. You have to open a command prompt for all analyses. As an example, if you download `iqtree-1.3.10-Windows.zip` into your `Downloads` folder, then extract it into the same folder and do the following steps:

1. Click on "Start" menu (below left corner of Windows screen).
2. Type in "cmd" and press "Enter". It will open the Command Prompt window (see Figure below).
3. Go into IQ-TREE folder by entering: 

        cd Downloads\iqtree-1.3.10-Windows

4. Now you can try an example run by entering:

        bin\iqtree -s example.phy

5. After a few seconds, IQ-TREE finishes and you may see something like this:

    [[images/win-cmd2.png]]

Congratulations ;-) You have finished the first IQ-TREE analysis.


#### For Mac OS X users

IQ-TREE is a command-line program. You have to open a "Terminal" for all analyses. As an example, if you download `iqtree-1.3.10-MacOSX.zip` into your `Downloads` folder, then extract it into the same folder and do the following steps:

1. Open the "Terminal", e.g., by clicking on the Spotlight icon (top-right corner), typing "terminal" and press "Enter".
2. Go into IQ-TREE folder by entering:

        cd Downloads/iqtree-1.2.0-MacOSX

3. Now you can try an example run by entering 

        bin/iqtree -s example.phy

4. After a few seconds, IQ-TREE finishes and you may see something like this:

    [[images/mac-cmd2.png]]

Congratulations ;-) You have finished the first IQ-TREE analysis.

