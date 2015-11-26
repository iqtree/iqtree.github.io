---
layout: userdoc
title: "Compilation Guide"
author: minh
date:   2015-11-19
categories:
- doc
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
---
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

* Make sure that a C++ compiler is installed. IQ-TREE was successfully built with GCC, Clang, MS Visual Studio and Intel C++ compiler. 
* Install [CMake](http://www.cmake.org) if not yet available in your system. 
* *(Optional)* Install [git](https://git-scm.com) if you want to clone source code from [IQ-TREE GitHub repository](https://github.com/Cibiv/IQ-TREE).
* *(Optional)* If you want to compile the multicore version, make sure that the compiler supports [OpenMP](http://openmp.org/) and that the OpenMP library was installed.

Downloading source code
-----------------------

Download the latest source code of IQ-TREE release version 1.3.10 (October 16, 2015) in either `zip` or `tar.gz`:

* [iqtree-1.3.10-Source.zip](https://github.com/Cibiv/IQ-TREE/releases/download/v1.3.10/iqtree-1.3.10-Source.zip)
* [iqtree-1.3.10-Source.tar.gz](https://github.com/Cibiv/IQ-TREE/releases/download/v1.3.10/iqtree-1.3.10-Source.tar.gz)

Alternatively, you can also clone the source code from github with:

    git clone --recursive https://github.com/Cibiv/IQ-TREE.git

Please note that `--recursive` is necessary to download the submodule ([the phylogenetic likelihood library](http://www.libpll.org/)) used by IQ-TREE. If not, you have to run

    git submodule init
    git submodule update
    
inside source code folder just cloned from github to download the submodule.

Please find below separate compilation guide for [Linux](#compiling-under-linux), [Mac OS X](#compiling-under-mac-os-x), and [Windows](#compiling-under-windows) as well as for [32-bit version](#compiling-32-bit-version).

>**NOTE**: Typically a 64-bit IQ-TREE version is built and recommended! The 32-bit version has several restriction like maximal RAM usage of 2GB and no AVX support, thus not suitable to analyze large data sets.

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

This creates an executable `iqtree` or `iqtree-omp` (`iqtree.exe` or `iqtree-omp.exe` under Windows). It can be copied to your system search path so that IQ-TREE can be called from the Terminal simply with the command line `iqtree`.


Compiling under Mac OS X
------------------------

* Make sure that `clang` compiler is installed, which is typically the case if you installed Xcode and the associated command line tools.
* Find the path to the CMake executable, which is typically `/Applications/CMake.app/Contents/bin/cmake`.

The steps to compile IQ-TREE are similar to Linux (see above), except that step 4 has to be changed:

4. Configure source code with CMake (please change `cmake` to absolute path like `/Applications/CMake.app/Contents/bin/cmake`):

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..

    To compile the multicore version, the default clang unfortunately does not support OpenMP (which might change in the near future). However, you can obtain and install OpenMP/Clang from <https://clang-omp.github.io> and the OpenMP library from <http://openmp.llvm.org>. After that you can run cmake with (assuming that `clang-omp` points to the installed OpenMP/Clang):

    cmake -DCMAKE_C_COMPILER=clang-omp -DCMAKE_CXX_COMPILER=clang-omp++ -DIQTREE_FLAGS=omp ..


Compiling under Windows
-----------------------

The sequential IQ-TREE version was successfully compiled with TDM-GCC from <http://tdm-gcc.tdragon.net>. Since TDM-GCC is essentially a GCC version for Windows, the compiling steps are like under Linux, except that for step 1, you need to open the Terminal called `TDM-GCC-64`, which can be assessed from the Start menu.

To build the multicore version, please switch to MS Visual Studio and Intel C++ compiler because somehow TDM-GCC caused downgraded performance under our tests. Assuming that you have installed MS Visual Studio 2013 and Intel Parallel Studio XE 2015. Then change the CMake step to:

    cmake -G "Visual Studio 12 Win64" -T "Intel C++ Compiler XE 15.0" -DIQTREE_FLAGS=omp ..

This will create solution and projects files for MS Visual Studio inside the build folder. Now exit the command prompt, open Windows explorer and navigate into this build folder. Double-click file `iqtree.sln` (so-called Visual Studio solution file). This will open MS Visual Studio and load IQ-TREE projects. Build the solution (Menu BUILD -> Build solution or press F7). This creates an executable Release\iqtree.exe. This executable and the `.dll` files can be copied to
your system search path such that IQ-TREE can be invoked from the command line by simply entering `iqtree`.


Compiling 32-bit version
------------------------

The compilation guides above will generate 64-bit binaries. To compile the 32-bit version instead, simply add `m32` into `IQTREE_FLAGS` of the cmake command. That means, `-DIQTREE_FLAGS=m32` to build the 32-bit sequential version and `-DIQTREE_FLAGS="omp m32"` to build the 32-bit multicore version.
