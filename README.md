# verda_intern
Hi my name is Verda Agan and I'm a Data Science intern with Decode Health. This repository exists to provide the code, documentation, and scripts for my ongoing projects. 

# NOISeq 
## Main Code and Scripts: NOISeq 
NOISeq package consists of three modules: 
1. Quality control of count data 
3. Normalization, low-count filtering and Batch effect correction 
4. Differential expression analysis

**The ``NOIseq_Tutorial.Rmd``will walk you through each module. First, we describe the input data format. NOIseq requires two pieces of information to start: the expression data (data) and the factors defining the experimental groups to be studied or compared (factors). Next, we explore the quality of the count data with exploratory plots that describe what kind of features are being detected in our samples, their sequencing depth, any sequencing bias (e.g., length, GC conent, RNA composition), and batch effects, if any. After running QC, we normalize, filter out low-count features, and correct for any batch effects. Prior to performing differential expression, it is essential to normalize the data in order make the samples comparable and remove the effects of technical biases. The normalization techniques provided by NOISew are RPKM, Upper Quartile and TMM.**

