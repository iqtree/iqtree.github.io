---
layout: userdoc
title: "Compilation Guide"
author: Dominik Schrempf, Jana Trifinopoulos, Minh Bui
date:    2017-05-10
docid: 20
icon: book
doctype: manual
tags:
- manual
description: For advanced users to compile IQ-TREE source code.
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
- name: Compiling MPI version
  url: compiling-mpi-version
- name: Compiling Xeon Phi Knights Landing version
  url: compiling-xeon-phi-knights-landing-version
---

Compilation guide
=================

For advanced users to compile IQ-TREE source code.
<!--more-->

General requirements
--------------------
<div class="hline"></div>

* A C++ compiler such as GCC (version >= 4.8), Clang, MS Visual Studio and Intel C++ compiler. 

* [CMake](http://www.cmake.org) version >= 2.8.10.

* [Eigen3 library](https://eigen.tuxfamily.org) (for IQ-TREE version >= 1.6). By default IQ-TREE will  detect the path to the installed Eigen3 library. If this failed, you have to manually specify `-DEIGEN3_INCLUDE_DIR=<installed_eigen3_dir>` to the `cmake` command (see below).

* (_Optional_) If you want to compile the multicore version, make sure that the OpenMP library was installed. This should typically be the case with `gcc` under Linux.

* (_Optional_) Install [git](https://git-scm.com) if you want to clone source code from [IQ-TREE GitHub repository](https://github.com/Cibiv/IQ-TREE).

Downloading source code
-----------------------
<div class="hline"></div>

Choose the source code (`zip` or `tar.gz`) of the IQ-TREE release you want to use from:

<https://github.com/Cibiv/IQ-TREE/releases/>

Alternatively, if you have `git` installed, you can also clone the source code from GitHub with:

    git clone https://github.com/Cibiv/IQ-TREE.git

Please find below separate compilation guide fors [Linux](#compiling-under-linux), [Mac OS X](#compiling-under-mac-os-x), and [Windows](#compiling-under-windows) as well as for [32-bit version](#compiling-32-bit-version) or for [MPI version](#compiling-mpi-version).

Compiling under Linux
---------------------
<div class="hline"></div>

>**TIP**: Ready made IQ-TREE packages are provided for [Debian](https://packages.debian.org/unstable/science/iqtree) and [Arch Linux (AUR)](https://aur.archlinux.org/packages/iqtree-latest/).
{: .tip}

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
        
    If `cmake` failed with message about `Eigen3 not found`, then install Eigen3 library and run `cmake` again. If this still failed, you have to manually specify the downloaded directory of Eigen3 with:
    
        cmake -DEIGEN3_INCLUDE_DIR=<eigen3_dir> ..
        

5. Compile source code with `make`:

        make
        
    You can speed up the compilation by specifying the number of CPU cores to use with `make` by e.g.:

        make -j4

    to use 4 cores instead of the default 1 core.
    
This creates an executable `iqtree` or `iqtree-omp`. It can be copied to your system search path so that IQ-TREE can be called from the Terminal simply with the command line `iqtree`.

>**TIP**: The above guide typically compiles IQ-TREE with `gcc`. If you have Clang installed and want to compile with Clang, the compilation will be similar to Mac OS X like below.
{: .tip}

Compiling under Mac OS X
------------------------
<div class="hline"></div>

>**TIP**: A ready made IQ-TREE package is provided by * [Homebrew](http://braumeister.org/repos/Homebrew/homebrew-science/formula/iqtree).
{: .tip}

* Make sure that Clang compiler is installed, which is typically the case if you installed Xcode and the associated command line tools.

* Find the path to the CMake executable, which is typically `/Applications/CMake.app/Contents/bin/cmake`. For later convenience, please create a symbolic link `cmake` to this cmake executable, so that cmake can be invoked from the Terminal by simply entering `cmake`.

The steps to compile IQ-TREE are similar to Linux (see above), except that you need to specify `clang` as compiler when configuring source code with CMake (step 4):

    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..

(please change `cmake` to absolute path like `/Applications/CMake.app/Contents/bin/cmake`).

To compile the multicore version, the default installed Clang unfortunately does not support OpenMP (which might change in the near future). However, the latest Clang 3.7 supports OpenMP, which can be downloaded from <http://clang.llvm.org>. After that you can run CMake with:

    cmake -DIQTREE_FLAGS=omp -DCMAKE_C_COMPILER=clang-3.7 -DCMAKE_CXX_COMPILER=clang++-3.7 ..

(assuming that `clang-3.7` and `clang++-3.7` points to the installed Clang 3.7).


Compiling under Windows
-----------------------
<div class="hline"></div>


* Please first install TDM-GCC (a GCC version for Windows) from <http://tdm-gcc.tdragon.net>.

* Then install Clang for Windows from <http://clang.llvm.org>.

>**WARNING**: Although IQ-TREE can also be built with TDM-GCC, the executable does not run properly due to stack alignment issue and the `libgomp` library causes downgraded performance for the OpenMP version. Thus, it is recommended to compile IQ-TREE with Clang. 

1. Open Command Prompt. 
2. Change to the source code folder:

        cd PATH_TO_EXTRACTED_SOURCE_CODE

    Please note that Windows uses back-slash (`\`) instead of slash (`/`) as path name separator.

3. Create a subfolder, say, `build` and go into this subfolder:

        mkdir build
        cd build

4. Configure source code with CMake:

        cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=--target=x86_64-pc-windows-gnu -DCMAKE_CXX_FLAGS=--target=x86_64-pc-windows-gnu -DCMAKE_MAKE_PROGRAM=mingw32-make ..

    To build the multicore version please add `-DIQTREE_FLAGS=omp` to the cmake command. Note that the make program shipped with TDM-GCC is called `mingw32-make`, thus needed to specify like above. You can also copy `mingw32-make` to `make` to simplify this step.

5. Compile source code with:

        mingw32-make
        
    or
    
        mingw32-make -j4
        
    to use 4 cores for compilation instead of only 1.


Compiling 32-bit version
------------------------
<div class="hline"></div>

>**NOTE**: Typically a 64-bit IQ-TREE version is built and recommended! The 32-bit version has several restriction like maximal RAM usage of 2GB and no AVX support, thus not suitable to analyze large data sets.

To compile the 32-bit version instead, simply add `m32` into `IQTREE_FLAGS` of the cmake command:

    cmake -DIQTREE_FLAGS=m32 .. 
    
To build the 32-bit multicore version, run: 

    cmake -DIQTREE_FLAGS=omp-m32 ..

For Windows you need to change Clang target with:

    cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=--target=i686-pc-windows-gnu -DCMAKE_CXX_FLAGS=--target=i686-pc-windows-gnu -DCMAKE_MAKE_PROGRAM=mingw32-make ..


Compiling MPI version
---------------------
<div class="hline"></div>

**Requirements**:

* Download source code of IQ-TREE version 1.5.1 or later. 
* Install an MPI library (e.g., [OpenMPI](http://open-mpi.org/)) if not available in your system. For Mac OS X, the easiest is to install [Homebrew package manager](http://brew.sh), and then install OpenMPI library from the command line with:

        brew install openmpi

Then simply run `CMake` and `make` by:

    cmake -DIQTREE_FLAGS=mpi ..
    make -j4

IQ-TREE will automatically detect and setup the MPI paths and library. Alternatively, you can also use the MPI C/C++ compiler wrappers (typically named `mpicc` and `mpicxx`), for example:

    cmake -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx ..
    make -j4

The executable is named `iqtree-mpi`. One can then run `mpirun` to start the MPI version with e.g. 2 processes:

    mpirun -np 2 iqtree-mpi -s alignment ...

If you want to compile the hybrid MPI/OpenMP version, simply run:

    cmake -DIQTREE_FLAGS=omp-mpi ..
    make -j4

The resulting executable is then named `iqtree-omp-mpi`. This can be used to start an MPI run with e.g. 4 processes and 2 cores each (i.e., a total of 8 cores will be used):

    mpirun -np 4 iqtree-omp-mpi -nt 2 -s alignment ...



>**NOTE**: Please be aware that [OpenMP](http://openmp.org/) and [OpenMPI](http://open-mpi.org/) are different! OpenMP is the standard to implement shared-memory multithreading program, that we use to provide the multicore IQ-TREE version `iqtree-omp`. Whereas OpenMPI is a message passing interface (MPI) library for distributed memory parallel system, that is used to compile `iqtree-mpi`. Thus, **one cannot run `iqtree-omp` with `mpirun`!**


Compiling Xeon Phi Knights Landing version
------------------------------------------
<div class="hline"></div>

Starting with version 1.6, IQ-TREE supports Xeon Phi Knights Landing (AVX-512 instruction set). To build this version the following requirements must be met:

* A C++ compiler, which supports AVX-512 instruction set: GCC 5.1, Clang 3.7, or Intel compiler 14.0.

The compilation steps are the same except that you need to add `-DIQTREE_FLAGS=KNL` to the cmake command:  

    cmake -DIQTREE_FLAGS=KNL ..
    make -j4

The compiled `iqtree` binary will automatically choose the proper computational kernel for the running computer. Thus, it works as normal and will speed up on Knights Landing CPUs. Run `./iqtree` to make sure that the binary was compiled correctly: 

    IQ-TREE multicore Xeon Phi KNL version 1.6.beta for Linux 64-bit built May  7 2017
    

About precompiled binaries
--------------------------
<div class="hline"></div>

To provide the pre-compiled IQ-TREE binaries at <http://www.iqtree.org>, we used Clang 3.9.0 for Windows and Clang 4.0 for Linux and macOS. We recommend to use Clang instead of GCC as Clang-compiled binaries run about 5-10% faster than GCC-compiled ones.

Linux binaries were statically compiled with Ubuntu 16.4 using [libc++ library](https://libcxx.llvm.org). The static-linked binaries will thus run on most Linux distributions. The CMake command is (assuming that clang-4 and clang++-4 point to the installed Clang):

    # 64-bit version
    cmake -DIQTREE_FLAGS=static-libcxx -DCMAKE_C_COMPILER=clang-4 -DCMAKE_CXX_COMPILER=clang++-4 <source_dir>

    # 32-bit version
    cmake -DIQTREE_FLAGS=static-m32 -DCMAKE_C_COMPILER=clang-4 -DCMAKE_CXX_COMPILER=clang++-4 <source_dir>
    
macOS binaries were compiled under macOS Sierra, but the binaries are backward compatible with Mac OS X 10.7 Lion:

    cmake -DCMAKE_C_COMPILER=clang-4 -DCMAKE_CXX_COMPILER=clang++-4 <source_dir>

Windows binaries were statically compiled under Windows 7 using Clang 3.9.0 in combination with [TDM-GCC 5.1.0](http://tdm-gcc.tdragon.net), which provides the neccessary libraries for Clang. 

    # 64-bit version
    cmake -G "MinGW Makefiles" -DIQTREE_FLAGS=static -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=--target=x86_64-pc-windows-gnu -DCMAKE_CXX_FLAGS=--target=x86_64-pc-windows-gnu -DCMAKE_MAKE_PROGRAM=mingw32-make ..
    
    #32-bit version
    cmake -G "MinGW Makefiles" -DIQTREE_FLAGS=static -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=--target=i686-pc-windows-gnu -DCMAKE_CXX_FLAGS=--target=i686-pc-windows-gnu -DCMAKE_MAKE_PROGRAM=mingw32-make ..


