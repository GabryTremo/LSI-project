# LSI-project
Comparison between different PSVD updating methods in LSI

This project is dedicated to the implementation of the methods presented in the article "Updating the Partial Singular Value Decomposition in Latent Semantic Indexing" (J. E. Tougas et al, 2006). The methods are described there in a quick way, and there isn't an immediate way to try to reproduce the results, other than just program the whole thing from scratch, by yourself. That is indeed what I have done as part of my Scientific Computing exam (actually, what was required for the exam is much less than this, but I got carried away).

Latent Semantic Indexing (LSI) is a technique in Information Retrieval (IR) based on a vector space model, where the documents of a dataset are represented as vectors of said space, and compared with the queries (e.g. strings in a search engine), which also are represented as vectors. The objective is to extablish which documents of the dataset are more relevant to the query. Unlike, for example, boolean methods, LSI tries to put more emphasis on the latent patterns that indicate semantic similarities among terms.
For example, if a polisemantic term is present in the query (that is, a term that has more than one possible meaning) an analysis that doesn't take latent semantic patterns into account could find irrelevant documents, where the term is used with another meaning than the intended one. Similarly, if in the query apears a term that is a synonim with another term appearing in a relevant document, that document could get wrongly ignored.

The way LSI tries to solve these problems is by using Partial Singular Value Decomposition (PSVD). For the mathematical details one should check the article, but the idea is simply that taking the SVD of the term-document matrix (a matrix whose element (i,j) represents, with a certain weight, the frequency of the term i in the document j) gives a way to define new terms (pseudo-terms) as linear combinations of the actual terms, and they are given in order, from the most important to the least important (where importance is given by the associated singular value). This way, terms that often appear in the same sentence or in the same context are put together, and we can obtain a more meaningful analysis by ranking documents according to these pseudo-terms. Taking the PSVD instead of the SVD just means that we are taking only the most important among these pseudo-terms, usually between 100 and 300.

The construction of the PSVD of the term-document matrix is a computationally expensive procedure, especially in realistic databases. On the other hand, the term-document matrix is updated every time a new document gets added to the database. Recomputing the PSVD after every update would be the most accurate way of dealing with this, however is is indeed too costly. Therefore, some alternatives are proposed in the article: "folding-in", "updating" and "folding-up". The first one is a quick alternative, which however makes accuracy deteriorate very quickly. The second one is the most accurate alternative to recomputing, and it exploits mathematical properties of the SVD in order to avoid recomputation from scratch. The third one is an hybrid version of the first two algorithms, alternating updates and folding-in at appropiate rates.

The four methods (recomputing, folding-in, updating, folding-up) are compared in terms of average precision, CPU times, and statistical similarity with the recomputing method. The analysed database consists of 1400 documents and 225 queries, that have been preprocessed by removing anything that is not a word, and also removing words shorter than 3 letters, which we deemed to be semantically irrelevant.

Similarly to the article, after creating the term-document matrix from these documents, with a tf-idf weighting, we start from the sub-matrix containing half of the documents, and simulate the adding of new documents by gradually adding the rest of the matrix. In this specific case, this is done by adding 14 or 28 documents per step.

The matrices can be obtained from the programs and the text files, but you can also just start from the workspace, which contains them already. Note that the truth matix is simply a matrix whose entry (i,j) is 1 iff the document i is relevant to the query j according to the file "truths.txt".

The code is commented in Italian.
