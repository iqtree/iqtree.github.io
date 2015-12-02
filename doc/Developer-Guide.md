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

This guide gives developers an overview of IQ-TREE software design, data structure and discusses possibility of implementing new models into IQ-TREE code.
<!--more-->

To achieve both high performance and flexibility, IQ-TREE software has been entirely written in object oriented C++. Thus, it faciliates extending with new sequence data types or new models. IQ-TREE code consists of C++ *classes*, most of which inherits from three basal classes: `Alignment`, `ModelSubst` and `PhyloTree` to handle sequence alignments, models of substitution and phylogenetic trees, respectively. In the following we introduce these basal classes.

>**TIP**: IQ-TREE extensively uses *Standard Template Library (STL)* in C++. Thus, be first familiar with STL and fundamental STL data structures like `string`, `vector`, `set` and `map`.

Alignment
---------

The `Alignment` class stores the data as a `vector` of `Pattern`. Each `Pattern` is in turn a `string` representing the characters across the sequences at an alignment site, with a `frequency` of occurrences in the `Alignment` (from header file [`pattern.h`](https://github.com/Cibiv/IQ-TREE/blob/master/pattern.h)):

```C++
/**
	Site-patterns in a multiple sequence alignment
*/
class Pattern : public string {
public:
	...

	/**
		frequency appearance of the pattern
	*/
	int frequency;
};
```

The rationale for storing the data this way (instead of storing a set of sequences) is that most computations are carried out along the site-patterns of the `Alignment`. Thus, it makes all operations more convenient and faster.

As noted above, the `Alignment` class is defined as (from header file [alignment.h](https://github.com/Cibiv/IQ-TREE/blob/master/alignment.h)): 

```C++
/**
    Multiple Sequence Alignment. Stored by a vector of site-patterns
*/
class Alignment : public vector<Pattern> {
public:
    /**
            constructor
            @param filename file name
            @param sequence_type type of the sequence, either "BIN", "DNA", "AA", or NULL
            @param intype (OUT) input format of the file
     */
    Alignment(char *filename, char *sequence_type, InputType &intype);

    ...
};
```

>**NOTICE**: Please follow the commenting style of the code when declaring new components (classes, functions or variables). The comments should start with `/**`, followed by a concise description of the new component, and ended with `*/`. If component is a function, explain the purpose of each parameter with `@param` keyword, followed by the parameter name and a short description. If the function returns a parameter as output, append `(OUT)` right after the parameter name. If the function returns a value, add `@return` followed by a short description of the returned value meaning. That way, the source code documentation can be generated with tools like [Doxygen](http://doxygen.org/). See [Doxygen commenting manual](http://www.stack.nl/~dimitri/doxygen/manual/docblocks.html) for more details.