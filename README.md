Introduction
============

This repository stores the "source code" for the main IQ-TREE website at
<https://iqtree.github.io>. Changes to this repo will automatically show up
in the main website via GitHub pages support.

We welcome you to contribute to the website! For example, you can improve the
documentation at <https://iqtree.github.io/doc/> by updating _markdown_ files
within the [doc](doc/) folder of the repo.
[Markdown](https://en.wikipedia.org/wiki/Markdown) is a  human-readable text
file format, which is very simple and convenient to edit. If you are teaching
IQ-TREE at a workshop, you can update the markdown files in the
[workshop](workshop/) folder, which will then show up at
<https://iqtree.github.io/workshop/>. Below are the guidelines how to
contribute.

First, you should clone the repo to your local machine using git:

```
git clone https://github.com/iqtree/iqtree.github.io.git
```

This will download a local copy of the repo in the sub-folder `iqtree.github.io`
of your current folder. This step needs to be done only ONCE! You can then
follow the sections below for the two common tasks: [updating a
documentation](#updating-iq-tree-documentation) or [updating a workshop](#updating-a-workshop). 


Updating IQ-TREE documentation
------------------------------

The names of the files in [doc](doc/) folder are self-explanatory. For example,
[doc/Tutorial.md](doc/Tutorial.md) corresponds to
<https://iqtree.github.io/doc/Tutorial>. Each markdown file contains a header
and the main text. Once you update the main text, make sure that you also update
the header, especially the two fields: `author` to add your name (if it does
appear in the author list yet) and `date` to the current date. For example,

```
---
layout: userdoc
title: "Beginner's Tutorial"
author: Minh Bui, Your Name
date:   YYYY-MM-DD
...
---
```

If you add a new section in the doc, make sure that you also add
the `sections` part of the header, for example:

```
---
....
sections:
- name: Your section title
  url: your-section-title
---
```

where the `url` field should be all in lower cases and empty spaces are replaced
by a dash (`-`).

Once you are satisfied with the changes you can then commit it:

```
git commit -am "Message about this commit"
```

Please make the message concise but informative about what you did. Then you
can make a pull request to ask us to update the main repo. An IQ-TREE team
member will review your pull request before deciding to merge it into the main
site, optional modifications to your pull request. Occasionally, the
IQ-TREE member may ask you to revise your pull request, before making decision.

Updating a workshop
-------------------

The workshop materials are in the [workshop](workshop/) subfolder. There are already
some past workshops that you can have a look.


