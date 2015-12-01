<!--jekyll 
docid: 02
icon: info-circle
doctype: tutorial
tags:
- tutorial
sections:
- name: Alignment
  url: alignment
jekyll-->

This guide gives developers an overview of IQ-TREE software, data structure and discusses possibility of implementing new models into IQ-TREE code.
<!--more-->

To achieve both high performance and flexibility, IQ-TREE software has been entirely written in object oriented C++. Thus, it faciliates extending with new sequence data types or new models. IQ-TREE code consists of C++ *classes*, most of which inherits from three basal classes: `Alignment`, `ModelSubst` and `PhyloTree` to handle sequence alignments, models of substitution and phylogenetic trees, respectively. In the following we introduce these basal classes.

>**TIP**: IQ-TREE extensively uses *Standard Template Library (STL)* in C++. Thus, be first familiar with STL and fundamental STL data structures like `string`, `vector`, `set` and `map`.

Alignment
---------

The `Alignment` class stores the data as a `vector` of `Pattern`. Each `Pattern` is in turn a `string` representing the characters across the sequences at an alignment site, with a `frequency` of occurrences in the `Alignment` (from header file [`pattern.h`](https://github.com/Cibiv/IQ-TREE/blob/master/pattern.h)):

```C++
class Pattern : public string {
public:
	/** 
		constructor
	*/
    Pattern();

    ...
    
	/** 
		destructor
	*/
    virtual ~Pattern();

	/**
		frequency appearance of the pattern
	*/
	int frequency;
};
```

The rationale for storing the data this way (instead of storing a set of sequences) is that most computations are carried out along the site-patterns of the `Alignment`. Thus, it makes all operations more convenient and faster.

As noted above, the `Alignment` class is defined as (from header file [alignment.h](https://github.com/Cibiv/IQ-TREE/blob/master/alignment.h)): 

```C++
class Alignment : public vector<Pattern> {
public:
    /**
            constructor
            @param filename file name
            @param sequence_type type of the sequence, either "BIN", "DNA", "AA", or NULL
            @param intype (OUT) input format of the file
     */
    Alignment(char *filename, char *sequence_type, InputType &intype);

    /**
            destructor
     */
    virtual ~Alignment();

    ...

};
```
