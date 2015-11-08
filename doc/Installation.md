## Binary release
The easiest way to install IQ-TREE is: 
* Download the precompiled executables (available for Windows, Mac OS X, and Linux) from the release page <https://github.com/Cibiv/IQTree/releases>. 
    - `iqtree-X.Y.Z-OS` is the sequential 64-bit version, where `X.Y.Z` is the version number and OS is the operating system name.
    - `iqtree-omp-X.Y.Z-OS` is the parallel multicore 64-bit version, which reduces computation time for long alignments. 
    - `iqtree32-X.Y.Z-OS` is the sequential 32-bit version.
    - `iqtree32-omp-X.Y.Z-OS` is the parallel multicore 32-bit version.
* Extract the files to create a directory `iqtree-X.Y.Z-OS` or `iqtree-omp-X.Y.Z-OS`.
* You will find the executable in the `bin` sub-folder. It is named `iqtree` or `iqtree-omp` (multicore version) (`iqtree.exe` or `iqtree-omp.exe` under Windows). 
* Open a Terminal (or Console) to run IQ-TREE as it is a command-line program.

The executable (together with the `.dll` files for Windows version) can be copied to your system search path such that you can run `iqtree` command from the Terminal.

### For Windows users

Please read the quickstart guide how to run IQ-TREE from Command Prompt: 

<https://github.com/Cibiv/IQTree/wiki/Quickstart>

## Compiling source code

**General requirements:**

* Make sure that a C++ compiler was installed. IQ-TREE was successfully built with GCC, Clang, and Intel C++ compiler. 
* Make sure that [CMake](http://www.cmake.org) was installed in your system. 
* If you want to compile the multicore version, make sure that the compiler supports [OpenMP](http://openmp.org/) and the OpenMP library was installed.
* Download source code from <https://github.com/Cibiv/IQTree/wiki/Download>. Extract it to create a folder `iqtree-X.Y.Z-Source`.

The compilation guides for Linux, Mac OS X, and Windows are given in the next sections.

### Compiling under Linux
1. Open a Terminal.
2. Change to the source code folder `iqtree-X.Y.Z-Source`:

        cd PATH_TO_EXTRACTED_SOURCE_CODE/iqtree-X.Y.Z-Source`

3. Create a subfolder, say, `build` and go into this subfolder:

        mkdir build
        cd build

4. Configure source code with CMake:

        cmake ..

    To build the multicore version please add `-DIQTREE_FLAGS=omp` to the cmake command:

        cmake -DIQTREE_FLAGS=omp ..

5. Compile source code with `make`:

        make

This creates an executable `iqtree` or `iqtree-omp` (`iqtree.exe` or `iqtree-omp.exe` under Windows). It can be copied to system search path so that IQ-TREE can be called from the Terminal simply with the command line `iqtree`.

### Compiling under Mac OS X

* Make sure that `clang` compiler is installed, which is typically the case if you installed Xcode and the associated command line tools.
* Find the path to the CMake executable, which is typically `/Applications/CMake.app/Contents/bin/cmake`.

The steps to compile IQ-TREE is similar to Linux (see above), except that step 4 has to be changed to:

Configure source code with CMake (please change `cmake` to absolute path like `/Applications/CMake.app/Contents/bin/cmake`):

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..

Unfortunately, the default clang does not support OpenMP (which might change in the near future). However, you can obtain OpenMP/Clang from <https://clang-omp.github.io> and the OpenMP library from <http://openmp.llvm.org>. After that you can run cmake with (assuming that `clang-omp` points to the installed OpenMP/Clang):

    cmake -DCMAKE_C_COMPILER=clang-omp -DCMAKE_CXX_COMPILER=clang-omp++ -DIQTREE_FLAGS=omp ..

### Compiling under Windows

The sequential IQ-TREE version was successfully compiled with TDM-GCC from <http://tdm-gcc.tdragon.net>. Since TDM-GCC is essentially a GCC version for Windows, the compiling steps are like under Linux, except that for step 1, you need to open the Terminal called `TDM-GCC-64`, which can be assessed from the Start menu.

To build multicore version, please switch to MS Visual Studio and Intel C++ compiler because somehow TDM-GCC caused downgraded performance under our test. Assuming that you have installed MS Visual Studio 2013 and Intel Parallel Studio XE 2015. Then change the CMake step to:

    cmake -G "Visual Studio 12 Win64" -T "Intel C++ Compiler XE 15.0" -DIQTREE_FLAGS=omp ..

This will create solution and projects files for MS Visual Studio inside the build folder. Now exit the command prompt, open Windows explorer and navigate into this build folder. Double-click file `iqtree.sln` (so-called Visual Studio solution file). This will open MS Visual Studio and load IQ-TREE projects. Build the solution (Menu BUILD -> Build solution or press F7). This creates an executable Release\iqtree.exe. This executable can be copied to
your system search path such that it is found by your system.

### Compiling 32-bit version

The compilation guides above will generate 64-bit binaries. To compile 32-bit version instead, simply add `m32` into `IQTREE_FLAGS` of the cmake command. That means, `-DIQTREE_FLAGS=m32` to build 32-bit sequential version and `-DIQTREE_FLAGS="omp m32"` to build 32-bit multicore version.