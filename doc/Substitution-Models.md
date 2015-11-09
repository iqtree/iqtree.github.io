
IQ-TREE supports a wide range of substitution models, including advanced partition and mixture models. This guide gives a detailed information of all available models.

DNA models
----------

IQ-TREE includes all common DNA models (ordered by complexity):

* `JC` or `JC69`: equal rates and equal base frequencies ([Jukes and Cantor, 1969]).
* `F81`: equal rates but unequal base freq. ([Felsenstein, 1981]).
* `K80` or `K2P`: unequal transition/transversion rates and equal base freq. ([Kimura, 1980]).
* `HKY` or `HKY85`: Like `K80` but unequal base freq. ([Hasegawa, Kishino and Yano, 1985]).
* `TN` or `TN93`: Like `HKY` but unequal purine/pyrimidine rates ([Tamura and Nei, 1993]).
* `TNe`: Like `TN` but equal base freq.
* `K81` or `K3P`: three substitution types model and equal base freq. ([Kimura, 1981]).
* `K81u`: Like `K81` but unequal base freq.
* `TPM2`: AC=AT, AG=CT, CG=GT and equal base freq.
* `TPM2u`: Like `TPM2` but unequal base freq.
* `TPM3`: AC=CG, AG=CT, AT=GT and equal base freq.
* `TPM3u`: Like `TPM3` but unequal base freq.
* `TIM`: transition model, AC=GT, AT=CG and unequal base freq.
* `TIMe`: Like `TIM` but equal base freq.
* `TIM2`: AC=AT, CG=GT and unequal base freq.
* `TIM2e`: Like `TIM2` but equal base freq.
* `TIM3`: AC=CG, AT=GT and unequal base freq.
* `TIM3e`: Like `TIM3` but equal base freq.
* `TVM`: transversion model, AG=CT and unequal base freq.
* `TVMe`: Like `TVM` but equal base freq.
* `SYM`: Symmetric model with unequal rates and equal base freq. ([Zharkihk, 1994]).
* `GTR`: General time reversible model with unequal rates and unequal base freq. ([Tavare, 1986]).

Moreover, IQ-TREE supports arbitrarily restricted DNA model via a 6-digit code. The 6 digits define the equality for 6 nucleotide substitution types: A-C, A-G, A-T, C-G, C-T and G-T. `010010` means that A-G rate is equal to C-T rate and the remaining four substitution rates are equal. Thus, `010010` is equivalent to K80 or HKY model (depending on whether base frequencies are equal or not). `123450` is equivalent to GTR or SYM model as there is no restriction defined by such 6-digit code.

If users want to fix model parameters, append the model name with a curly bracket `{`, followed by the comma-separated rate parameters, and a closing curly bracket `}`. For example, `GTR{1.0,2.0,1.5,3.7,2.8,1.0}` is a valid model.


Users can also specify three different kinds of base frequencies:

* `+F`: empirical base frequencies. This is the default if model has unequal base freq.
* `+FQ`: equal base frequencies.
* `+FO`: optimized base frequencies by maximum-likelihood.

For example, `GTR+FO` optimizes base frequencies by ML whereas `GTR+F` (default) counts base frequencies from directly the alignment.

Finally, users can fix base frequencies with e.g. `GTR+F{0.1,0.2,0.3,0.4}` to fix the corresponding frequencies of A, C, G and T (must sum up to 1.0).



Protein models
--------------

IQ-TREE supports all common empirical amino-acid exchange rate matrices:

* `Blosum62`: BLOcks SUbstitution Matrix ([Henikoff and Henikoff, 1992]), although not recommended.
* `cpREV`: chloroplast matrix ([Adachi et al., 2000])
* `Dayhoff`: ([Dayhoff et al., 1978]).
* `DCMut`: ([Kosiol and Goldman, 2005]).
* `FLU`: ([Dang et al., 2010]).
* `HIVb`: ([Dang et al., 2010]).
* `HIVw`: ([Dang et al., 2010]).
* `JTT`: ([Jones et al., 1992]).
* `JTTDCMut`:
* `LG`: ([Le and Gascuel, 2008]).
* `mtART`: ([Abascal et al., 2007]).
* `mtMAM`: ([Yang et al., 1998]).
* `mtREV`: ([Adachi and Hasegawa, 1996]).
* `mtZOA`: ([Rota-Stabelli et al., 2009]).
* `PMB`: ([Veerassamy et al., 2004]).
* `rtREV`: ([Dimmic et al., 2002]).
* `VT`: ([Mueller and Vingron, 2000]).
* `WAG`: ([Whelan and Goldman, 2001]).
        
Codon models
------------

"MG", "MGK", "GY", "KOSI07", "SCHN05"

Binary and morphological models
-------------------------------

"JC2", "GTR2"
{"MK", "ORDERED"}


Ascertainment bias correction
-----------------------------


Rate heterogeneity across sites
-------------------------------



Partition models
----------------


Mixture models
--------------


Customized models
-----------------


[Abascal et al., 2007]: http://dx.doi.org/10.1093/molbev/msl136
[Adachi and Hasegawa, 1996]: http://dx.doi.org/10.1007/BF02498640
[Adachi et al., 2000]: http://dx.doi.org/10.1007/s002399910038
[Dang et al., 2010]: 10.1186/1471-2148-10-99
[Dayhoff et al., 1978]:
[Dimmic et al., 2002]: http://dx.doi.org/10.1007/s00239-001-2304-y
[Felsenstein, 1981]: https://dx.doi.org/10.1007%2FBF01734359
[Hasegawa, Kishino and Yano, 1985]: https://dx.doi.org/10.1007%2FBF02101694
[Henikoff and Henikoff, 1992]: https://dx.doi.org/10.1073%2Fpnas.89.22.10915
[Jones et al., 1992]: https://dx.doi.org/10.1093%2Fbioinformatics%2F8.3.275
[Jukes and Cantor, 1969]: https://books.google.at/books?hl=en&lr=&id=FDHLBAAAQBAJ&oi=fnd&pg=PA21&ots=bkfqSDR2jB&sig=zxqY3TXK5UuKVU2ndxjm_VnD4B0&redir_esc=y#v=onepage&q&f=false
[Kimura, 1980]: http://dx.doi.org/10.1007%2FBF01731581
[Kimura, 1981]: http://dx.doi.org/10.1073/pnas.78.1.454
[Kosiol and Goldman, 2005]: http://dx.doi.org/10.1093/molbev/msi005
[Le and Gascuel, 2008]: http://dx.doi.org/10.1093/molbev/msn067
[Mueller and Vingron, 2000]: http://dx.doi.org/10.1089/10665270050514918
[Rota-Stabelli et al., 2009]: http://dx.doi.org/10.1016/j.ympev.2009.01.011
[Tamura and Nei, 1993]: http://mbe.oxfordjournals.org/cgi/content/abstract/10/3/512
[Tavare, 1986]: http://www.damtp.cam.ac.uk/user/st321/CV_&_Publications_files/STpapers-pdf/T86.pdf
[Veerassamy et al., 2004]: http://dx.doi.org/10.1089/106652703322756195
[Whelan and Goldman, 2001]: http://dx.doi.org/10.1093/oxfordjournals.molbev.a003851
[Yang et al., 1998]: http://mbe.oxfordjournals.org/content/15/12/1600.abstract
[Zharkihk, 1994]: http://dx.doi.org/10.1007/BF00160155


