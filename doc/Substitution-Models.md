
IQ-TREE supports a wide range of substitution models, including advanced partition and mixture models. This guide gives a detailed information of all available models.

DNA models
----------

IQ-TREE includes all common DNA models including (with citations):

* JC or JC69: equal rates and equal base frequencies ([Jukes and Cantor, 1969]).
* F81: equal rates but unequal base freq. ([Felsenstein, 1981]).
* K80 or K2P: unequal transition/transversion rates and equal base freq. ([Kimura, 1980]).
* HKY or HKY85: Like K80 but unequal base freq. ([Hasegawa, Kishino and Yano, 1985]).
* TN or TN93: Like HKY but unequal purine/pyrimidine rates ([Tamura and Nei, 1993]).
* TNe: Like TN model but equal base freq.
* K81 or K3P: three substitution types model and equal base freq. ([Kimura, 1981]).
* K81u: Like K81 but unequal base freq.
* TPM2: AC=AT, AG=CT, CG=GT and equal base freq.
* TPM2u: Like TPM2 but unequal base freq.
* TPM3: AC=CG, AG=CT, AT=GT and equal base freq.
* TPM3u: Like TPM3 but unequal base freq.
* TIM: AC=GT, AT=CG and unequal base freq.
* TIMe: Like TIM but equal base freq.
* TIM2: AC=AT, CG=GT and unequal base freq.
* TIM2e: Like TIM2 but equal base freq.
* TIM3: AC=CG, AT=GT and unequal base freq.
* TIM3e: Like TIM3 but equal base freq.
* TVM: AG=CT and unequal base freq.
* TVMe: Like TVM but equal base freq.
* SYM: Symmetric model with unequal rates and equal base freq. ([Zharkihk, 1994]).
* GTR: General time reversible model with unequal rates and unequal base freq. ([Tavare, 1986]).

Moreover, IQ-TREE supports arbitrarily restricted DNA model via a 6-digit code. The 6 digits define the equality for 6 nucleotide substitution types: A-C, A-G, A-T, C-G, C-T and G-T. `010010` means that A-G rate is equal to C-T rate and the remaining four substitution rates are equal. Thus, `010010` is equivalent to K80 or HKY model (depending on whether base frequencies are equal or not). `123450` is equivalent to GTR or SYM model as there is no restriction defined by such 6-digit code.

If users want to fix model parameters, append the model name with a curly bracket `{`, followed by the comma-separated rate parameters, and a close curly bracket `}`. For example, `GTR{1.0,2.0,1.5,3.7,2.8,1.0}` is a valid model.



Protein models
--------------

"Dayhoff", "mtMAM", "JTT", "WAG",
		"cpREV", "mtREV", "rtREV", "mtART", "mtZOA", "VT", "LG", "DCMut", "PMB",
		"HIVb", "HIVw", "JTTDCMut", "FLU", "Blosum62"
        
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

