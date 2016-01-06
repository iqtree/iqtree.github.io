<!--jekyll
docid: 20
icon: book
doctype: manual
tags:
- manual
sections:
- name: General requirements
  url: general-requirements
- name: Downloading source code
  url: downloading-source-code
- name: Compiling under Linux
  url: compiling-under-linux
- name: Compiling under Mac OS X
  url: compiling-under-mac-os-x
- name: Compiling under Windows
  url: compiling-under-windows
- name: Compiling 32-bit version
  url: compiling-32-bit-version
jekyll-->
For advanced users to compile IQ-TREE source code.
<!--more-->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [General requirements](#general-requirements)
- [Downloading source code](#downloading-source-code)
- [Compiling under Linux](#compiling-under-linux)
- [Compiling under Mac OS X](#compiling-under-mac-os-x)
- [Compiling under Windows](#compiling-under-windows)
- [Compiling 32-bit version](#compiling-32-bit-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


General requirements
--------------------

* Make sure that a C++ compiler is installed. IQ-TREE was successfully built with GCC (ver. 4.6 at least), Clang, MS Visual Studio and Intel C++ compiler. 
* Install [CMake](http://www.cmake.org) if not yet available in your system. 
* *(Optional)* Install [git](https://git-scm.com) if you want to clone source code from [IQ-TREE GitHub repository](https://github.com/Cibiv/IQ-TREE).
* *(Optional)* If you want to compile the multicore version, make sure that the compiler supports [OpenMP](http://openmp.org/) and that the OpenMP library was installed.

Downloading source code
-----------------------

Download the latest source code of IQ-TREE in either `zip` or `tar.gz` from:

    https://github.com/Cibiv/IQ-TREE/releases/latest

Alternatively, you can also clone the source code from github with:

    git clone https://github.com/Cibiv/IQ-TREE.git

Please find below separate compilation guide fors [Linux](#compiling-under-linux), [Mac OS X](#compiling-under-mac-os-x), and [Windows](#compiling-under-windows) as well as for [32-bit version](#compiling-32-bit-version).

Compiling under Linux
---------------------

1. Open a Terminal.
2. Change to the source code folder:

        cd PATH_TO_EXTRACTED_SOURCE_CODE

3. Create a subfolder, say, `build` and go into this subfolder:

        mkdir build
        cd build

4. Configure source code with CMake:

        cmake ..

    To build the multicore version please add `-DIQTREE_FLAGS=omp` to the cmake command:

        cmake -DIQTREE_FLAGS=omp ..

5. Compile source code with `make`:

        make
        
    You can speed up by specifying the number of CPU cores to use with `make` by e.g.:

        make -j4

    to use 4 cores instead of the default 1 core.
    
This creates an executable `iqtree` or `iqtree-omp`. It can be copied to your system search path so that IQ-TREE can be called from the Terminal simply with the command line `iqtree`.

>**NOTICE**: The above guide typically compiles IQ-TREE with `gcc`. If you have Clang installed and want to compile with Clang, the compilation will be similar to Mac OS X like below.

Compiling under Mac OS X
------------------------

* Make sure that Clang compiler is installed, which is typically the case if you installed Xcode and the associated command line tools.
* Find the path to the CMake executable, which is typically `/Applications/CMake.app/Contents/bin/cmake`. For later convenience, please create a symbolic link `cmake` to this cmake executable, so that cmake can be invoked from the Terminal by simply entering `cmake`.

The steps to compile IQ-TREE are similar to Linux (see above), except that you need to specify `clang` as compiler when configuring source code with CMake (step 4):

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..

(please change `cmake` to absolute path like `/Applications/CMake.app/Contents/bin/cmake`).

To compile the multicore version, the default installed Clang unfortunately does not support OpenMP (which might change in the near future). However, the latest Clang 3.7 supports OpenMP, which can be downloaded from <http://clang.llvm.org>. After that you can run CMake with:

    cmake -DCMAKE_C_COMPILER=clang-omp -DCMAKE_CXX_COMPILER=clang-omp++ -DIQTREE_FLAGS=omp ..

(assuming that `clang-omp` and `clang-omp++` points to the installed Clang 3.7).


Compiling under Windows
-----------------------

* Please first install TDM-GCC (a GCC version for Windows) from <http://tdm-gcc.tdragon.net>.
* Then install Clang for Windows from <http://clang.llvm.org>.

>**NOTICE**: Although IQ-TREE can also be built with TDM-GCC, the executable does not run properly due to stack alignment issue and the `libgomp` library causes downgraded performance for the OpenMP version. Thus, it is recommended to compile IQ-TREE with Clang.

1. Open Command Prompt. 
2. Change to the source code folder:

        cd PATH_TO_EXTRACTED_SOURCE_CODE

    Please note that Windows uses back-slash (`\`) instead of slash (`/`) as path name separator.

3. Create a subfolder, say, `build` and go into this subfolder:

        mkdir build
        cd build

4. Configure source code with CMake:

        cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_MAKE_PROGRAM=mingw32-make ..

    To build the multicore version please add `-DIQTREE_FLAGS=omp` to the cmake command. Note that the make program shipped with TDM-GCC is called `mingw32-make`, thus needed to specify like above. You can also copy `mingw32-make` to `make` to simplify this step.

5. Compile source code with:

        mingw32-make
        
    or
    
        mingw32-make -j4
        
    to use 4 cores instead of only 1.


Compiling 32-bit version
------------------------

>**NOTE**: Typically a 64-bit IQ-TREE version is built and recommended! The 32-bit version has several restriction like maximal RAM usage of 2GB and no AVX support, thus not suitable to analyze large data sets.

To compile the 32-bit version instead, simply add `m32` into `IQTREE_FLAGS` of the cmake command. That means, `-DIQTREE_FLAGS=m32` to build the 32-bit sequential version and `-DIQTREE_FLAGS="omp m32"` to build the 32-bit multicore version.
