# verda_intern
Hi my name is Verda Agan and I'm a Data Science intern with Decode Health. This repository exists to provide the code, documentation, and scripts for my ongoing projects. 

# NOISeq Tutorial
**NOISeq package consists of three modules:**

**1. Quality control of count data**

**2. Normalization, low-count filtering and Batch effect correction**

**3. Differential expression analysis**

The ``NOIseq_Tutorial.Rmd`` will walk you through each module. First, we describe the input data format. NOIseq requires two pieces of information to start: the expression data (data) and the factors defining the experimental groups to be studied or compared (factors). Next, we explore the quality of the count data with exploratory plots that describe what kind of features are being detected in our samples, their sequencing depth, any sequencing bias (e.g., length, GC conent, RNA composition), and batch effects, if any. After running QC, we normalize our counts matrix, filter out low-count features, and correct for any batch effects. Prior to performing differential expression, it is essential to normalize the data in order make the samples comparable and remove the effects of technical biases.

**It's important to note that NOISeq can remove low-count features, normalize counts, and run differential expression all in one step with the *noiseqbio* wrapper function if working with biological replicates *noiseq* function is for tech replicates). However, NOISeq has separate functions for removing low-count features and normalizing the expression data if you would like to perform each of these steps seperately and create intermediate objects. Also, if there are batch effects (as determined by PCA), you must correct for them BEFORE inputting into the *noiseqbio* wrapper function. This function specifically does not have an argument that implements batch effect correction.**

The normalization techniques provided by NOISeq are RPKM, Upper Quartile, and TMM. NOIseq can, however, accept data normalized with any other method (e.g., DESEQ2's median of ratios) as well as data previously transformed to remove batch effecs and/or any other sources of unwanted variation. NOIseq uses three methods to filter out features with low counts: (1) CPM (2) Wilcoxon test or (3) Proportion test. Finally, we can run differential expression analysis. NOISeq can work with biological replicates, technical replicates, or no replicaes at all. If the goal is to make any inferences about a population, then it is recommended that you use biological replicates. Again, it's important to note that normalization, low-count filtering and diffrential expression can be run all in one step with the wrapper functions, *noiseqbio* or *noiseq*.

Once we have run differential expression, we can select for differentially expressed features with a given threshold for FDR, plot their expression values and look at how they compare across the factor of interest, and finally run gene set enrichment analysis.

# NOISeq for MS/NMO samples
Please see the ``MN_NN_NOIseq.Rmd`` for a detailed walk-through comparing MS and NMO RNA-seq samples and identifying differentially expressed features between these conditions.
