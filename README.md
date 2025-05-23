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

First, you should clone the repo to your local machine using git via the command
line:

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
site, optionally with modifications to your pull request. Occasionally, the
IQ-TREE member may ask you to revise your pull request, before making decision.

Updating a workshop
-------------------

The workshop materials are in the [workshop](workshop/) subfolder. There are already
some past workshops that you can have a look. If you are teaching a new workshop,
you can copy and reuse past ones, e.g.,

```
# copy file under Linux or Mac, assuming your current directory is workshop/
cp molevol2023.md myworkshop.md
```

Then you can change `myworkshop.md` and add it to git:

```
git add myworkshop.md
```

Moreover, you may want to change `index.md` file ([link](workshop/index.md)) to
add yours to the list of workshops showing at
<https://iqtree.github.io/workshop/>.

And make sure that you also update the header fields `author` and `date` as
shown in the [previous section](#updating-iq-tree-documentation). Once you are
satisfied with the changes you can then commit it:

```
git commit -am "Message about this commit"
```

Please make the message concise but informative about what you did. Then you
can make a pull request to ask us to update the main repo. An IQ-TREE team
member will review your pull request before deciding to merge it into the main
site, optionally with modifications to your pull request. Occasionally, the
IQ-TREE member may ask you to revise your pull request, before making decision.

Creating a local website for double-checking
--------------------------------------------

Before making a pull request, you can optionally create the website locally on
your own machine using the [jekyll](https://jekyllrb.com) tool (in fact, GitHub
also uses `jekyll` to auto-create the website). That way, you can check yourself
whether the changes will display as what you intended.

You need to first have `jekyll` installed. On a MacOS, if you have Homebrew installed,
you can install `jekyll` via a simple command:

```
brew install jekyll
```

If not, check the [jekyll](https://jekyllrb.com) website for an installation guide.

Then in the `iqtree.github.io` folder, please run the command line:

```
jekyll serve
```

This will create a virtual website at http://127.0.0.1:4000/. You can go to this address
on a web browser to see how it looks like.

