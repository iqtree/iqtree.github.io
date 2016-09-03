---
layout: post
title: "Parallel IQ-TREE MPI pre-release"
author: Admin
categories: 
- news 
tags:
- announcement
---

We would like to announce a new [MPI parallel version of IQ-TREE](https://github.com/Cibiv/IQ-TREE/releases/tag/v1.4.4-mpi) for use in computer cluster. In addition to the existing OpenMP parallelization that distributes the tree likelihood computation among CPU cores, IQ-TREE now can employ MPI to distribute the tree search among different computing nodes. 

The MPI version of IQ-TREE provides better parallel efficiency than OpenMP and can also be used within a multi-core PC (only Linux and Mac OS X are supported). Note that the memory requirement of the MPI version is proportional to the number of processes. Thus, to avoid excessive memory consumption one can also combine OpenMP and MPI in IQ-TREE (this is called hybrid parallelization). 

Information about how to compile and run the program can be found in [our documentation page](http://www.iqtree.org/doc/Compilation-Guide/#compiling-mpi-version). 


<!--more-->

