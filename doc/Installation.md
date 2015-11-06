## Binary release
The easiest way to install IQ-TREE is: 
* Download the precompiled executables (available for Windows, Mac OS X, and Linux) from the Download page <https://github.com/Cibiv/IQTree/wiki/Download>. 
* Extract the files to create a directory `iqtree-X.Y.Z-OS`, where `X.Y.Z` is the version number and `OS` is the operating system name. Note that the multicore version is named `iqtree-omp-X.Y.Z-OS`.
* You will find the executable in the `bin` sub-folder. It is named `iqtree` or `iqtree-omp` (multicore version) or `iqtree.exe` (Windows version). 

## Compiling source code

To compile the IQ-TREE source code: 
* Make sure that a C++ compiler was installed. IQ-TREE was successfully built with gcc, clang, and Intel C++ compiler. 
* Make sure that [CMake](http://www.cmake.org) was installed in your system. 
* Download source code from <https://github.com/Cibiv/IQTree/wiki/Download>. Extract it to create a folder `iqtree-X.Y.Z-Source`.

Following is detailed compiling guide for Linux, Mac OS X, and Windows.

### Compiling for Linux
1. Open a Terminal.
2. Change to the source code folder `iqtree-X.Y.Z-Source`:

    cd ..../iqtree-X.Y.Z-Source

3. Create a subfolder, say, `build` and go into this subfolder:

      mkdir build
      cd build