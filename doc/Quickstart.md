---
layout: userdoc
title: "Getting Started"
author: Dominik Schrempf, M Bui, Meaningseeking, Minh Bui
date:    2020-07-22
docid: 1
icon: info-circle
doctype: tutorial
tags:
- tutorial
description: Recommended for users who just downloaded IQ-TREE the first time.
sections:
- name: IQ-TREE web server
  url: iq-tree-web-server
- name: Installation
  url: installation
- name: For Windows users
  url: for-windows-users
- name: For Mac OS X users
  url: for-mac-os-x-users
- name: Minimal command-line examples
  url: minimal-command-line-examples
---

Getting started
===============

Recommended for users who just downloaded IQ-TREE the first time.
<!--more-->


IQ-TREE web server
------------------
<div class="hline"></div>

The quickest is to try out the [IQ-TREE web server](http://iqtree.cibiv.univie.ac.at), where you only need to upload an alignment, choose the options and start the analysis. There is a [web server tutorial here](Web-Server-Tutorial). 

If you want to use the command-line version, follow the instructions below.

Installation
------------
<div class="hline"></div>

For reasons of performance, IQ-TREE is a command-line program, i.e., IQ-TREE needs to be run from a terminal/console (command prompt under Windows).

### Packages and bundles

Ready made IQ-TREE packages are available for the following distributions/repositories (command to install iqtree):

* [Debian Linux](https://packages.debian.org/unstable/science/iqtree): `sudo apt-get install iqtree`
* [Arch Linux (AUR)](https://aur.archlinux.org/packages/iqtree-latest/)
* [Anaconda](https://anaconda.org/bioconda/iqtree): `conda install -c bioconda iqtree`
* [Homebrew](https://github.com/brewsci/homebrew-bio/blob/master/Formula/iqtree.rb): `brew install brewsci/bio/iqtree2`
* [FreeBSD](https://www.freshports.org/biology/iqtree/): `pkg install iqtree`

### Manual download

IQ-TREE for Windows, MacOSX and Linux can be [downloaded here](http://www.iqtree.org/#download).

* Extract the `.zip` (Windows, MacOSX) or `.tar.gz` (Linux) file to create a directory `iqtree-X.Y.Z-OS`, where `X.Y.Z` is the version number and `OS` is the operating system (Windows, MacOSX or Linux).
* You will find the executable in the `bin` sub-folder. Copy all files in `bin` folder to your system search path such that you can run IQ-TREE by entering `iqtree` from the Terminal.

Now you need to open a Terminal (or Console) to run IQ-TREE. See below the guide for [Windows users](#for-windows-users) and [Mac OS X users](#for-mac-os-x-users).

For Windows users
-----------------
<div class="hline"></div>

Since IQ-TREE is a command-line program, clicking on `iqtree.exe` will not work. You have to open a Command Prompt for all analyses:

1. Click on "Start" menu (below left corner of Windows screen).
2. Type in "cmd" and press "Enter". It will open the Command Prompt window (see Figure below).
3. Go into IQ-TREE folder you just extracted by entering e.g. (assuming you downloaded version 1.5.0):

        cd Downloads\iqtree-1.5.0-Windows
        
    (assuming that IQ-TREE was downloaded into `Downloads` folder).
4. Now you can try an example run by entering:

        bin\iqtree -s example.phy
        
    (`example.phy` is the example PHYLIP alignment file also extracted in that folder).
5. After a few seconds, IQ-TREE finishes and you may see something like this:

![Windows command prompt](images/win-cmd2.png)

Congratulations ;-) You have finished the first IQ-TREE analysis.


For Mac OS X users
------------------
<div class="hline"></div>

1. Open the "Terminal", e.g., by clicking on the Spotlight icon (top-right corner), typing "terminal" and press "Enter".
2. Go into IQ-TREE folder by entering (assuming you downloaded version 1.5.0):

        cd Downloads/iqtree-1.5.0-MacOSX

    (assuming that IQ-TREE was downloaded into `Downloads` folder).
3. Now you can try an example run by entering 

        bin/iqtree -s example.phy

    (`example.phy` is the example PHYLIP alignment file also extracted in that folder).
4. After a few seconds, IQ-TREE finishes and you may see something like this:

![Mac terminal](images/mac-cmd2.png)

Congratulations ;-) You have finished the first IQ-TREE analysis.



Minimal command-line examples
-----------------------------
<div class="hline"></div>

A few typically analyses are listed in the following. Note that it is assumed that `iqtree` executable was already copied into system search path. If not, please replace `iqtree` with actual path to executable.

* Infer maximum-likelihood tree from a sequence alignment (`example.phy`)
   with the best-fit model automatically selected by ModelFinder:

        iqtree -s example.phy

* Infer maximum-likelihood tree using `GTR+I+G` model:

        iqtree -s example.phy -m GTR+I+G

* Perform ModelFinder without subsequent tree inference:
        
        iqtree -s example.phy -m MF


* Combine ModelFinder, tree search, SH-aLRT test and ultrafast bootstrap with 1000 replicates:

        iqtree -s example.phy -B 1000 -alrt 1000
        # for version 1.x, change -B to -bb


* Perform edge-linked proportional partition model (`example.nex`):

        iqtree -s example.phy -p example.nex
        # for version 1.x change -p to -spp

* Find best partition scheme by possibly merging partitions:

        iqtree -s example.phy -p example.nex -m MF+MERGE

* Find best partition scheme followed by tree inference and ultrafast bootstrap:

        iqtree -s example.phy -p example.nex -m MFP+MERGE -B 1000
        # for version 1.x change -B to -bb

* Use 4 CPU cores to speed up computation:

        iqtree -s example.phy -T 4
        # for version 1.x change -T to -nt

* Determine the best number of cores to use under `GTR+R4` model:

        iqtree -s example.phy -m GTR+R4 -T AUTO
        # for version 1.x change -T to -nt

* Show all available options: 

        iqtree -h
        

Where to go from here?
----------------------------
<div class="hline"></div>

Please continue with the **[Beginner's tutorial](Tutorial)** for further usages.


