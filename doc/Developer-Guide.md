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

To achieve both high performance and flexibility, IQ-TREE software has been entirely written in object oriented C++. Thus, it faciliates extending with new sequence data types or new models. IQ-TREE code consists of C++ *classes*, most of which inherits from three basal classes: **Alignment**, **ModelSubst** and **PhyloTree** to handle sequence alignments, models of substitution and phylogenetic trees, respectively. In the following we introduce these basal classes.

>**TIP**: IQ-TREE extensively uses *Standard Template Library (STL)* in C++. Thus, be first familiar with STL and fundamental STL data structure like *string*, *vector*, *set* and *map*.

Alignment
---------

The **Alignment** class stores the data as a *vector* of **Pattern**. Each Pattern is a *string* representing the characters across the sequences at an alignment site, with a *frequency* of occurences in the Alignment:

```C++
class Pattern : public string
{
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