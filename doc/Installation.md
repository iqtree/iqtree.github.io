## Binary release
The easiest way to install IQ-TREE is: 
* Download the precompiled executables (available for Windows, Mac OS X, and Linux) from the Download page <https://github.com/Cibiv/IQTree/wiki/Download>. 
* Extract the files to create a directory `iqtree-X.Y.Z-OS`, where `X.Y.Z` is the version number and `OS` is the operating system name. Note that the multicore version is named `iqtree-omp-X.Y.Z-OS`.
* You will find the executable in the `bin` sub-folder. It is named `iqtree` or `iqtree-omp` (multicore version) (`iqtree.exe` or `iqtree-omp.exe` under Windows). 

## Compiling source code

To compile the IQ-TREE source code: 
* Make sure that a C++ compiler was installed. IQ-TREE was successfully built with gcc, clang, and Intel C++ compiler. 
* Make sure that [CMake](http://www.cmake.org) was installed in your system. 
* If you want to compile the multicore version, make sure that the compiler supports [OpenMP](http://openmp.org/) and the OpenMP library was installed.
* Download source code from <https://github.com/Cibiv/IQTree/wiki/Download>. Extract it to create a folder `iqtree-X.Y.Z-Source`.

Following is detailed compiling guide for Linux, Mac OS X, and Windows.

### Compiling under Linux
1. Open a Terminal.
2. Change to the source code folder `iqtree-X.Y.Z-Source`:

    `cd PATH_TO_EXTRACTED_SOURCE_CODE/iqtree-X.Y.Z-Source`

3. Create a subfolder, say, `build` and go into this subfolder:

      `mkdir build`

      `cd build`

4. Configure source code with CMake:

    `cmake ..`   (to build sequential version)

    `cmake -DIQTREE_FLAGS=omp ..` (to build multicore version)

5. Compile source code with `make`:

    `make`

This creates an executable `iqtree` or `iqtree-omp` (`iqtree.exe` or `iqtree-omp.exe` under Windows). It can be copied to system search path so that IQ-TREE can be called from the Terminal simply with the command line `iqtree`.

### Compiling under Mac OS X

* Make sure that `clang` compiler is installed, which is typically the case if you installed Xcode and the associated command line tools.
* Find the path to the CMake executable, which is typically `/Applications/CMake.app/Contents/bin/cmake`.

The steps to compile IQ-TREE is similar to Linux (see above), except that step 4 has to be changed to:

Configure source code with CMake (please change `cmake` to absolute path like `/Applications/CMake.app/Contents/bin/cmake`):

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..

or for multicore version:

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DIQTREE_FLAGS=omp ..
