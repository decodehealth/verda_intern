
#!/bin/bash

#Author: Verda Agan 

#########PRE-PROCESSING STEPS#########


##1.1: MarkDuplicates - Identify Dup Reads##
#MarkDuplicates creates a sorted BAM file called dedup_reads.bam with the same content as the input file, except that any duplicate reads are marked as such
#The tool's main output is a new SAM or BAM file, in which duplicates have been identified in the SAM flags field for each read
#Duplicates are marked with the hexadecimal value of 0x0400, which corresponds to a decimal value of 1024

#CREATE_INDEX: when TRUE, a BAM index is created when writing a coordinate-sorted BAM file
#VALIDATION_STRINGENCY: setting stringency to SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded
#METRICS_FILE: file to write duplication metrics to
#When --REMOVE_DUPLICATES and --REMOVE_SEQUENCING_DUPLICATES are set to TRUE, duplicates are not written to the output file instead of writing them with appropriate flags set 

# echo "start MarkDuplicates"
# #print or set the system date and time 
# # start_time="$(date -u +%s.%N)"
# start_time=$(date +"%s")
# echo "${start_time}"

# /usr/lib/gatk/gatk MarkDuplicates --I /mnt/iquityazurefileshare1/Test/GATKTesting/MS1-IQ00-11000-P-NN_seq.sorted.STAR.Ev104.cufflinks.bam \
# --O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates.bam \
# --CREATE_INDEX true \
# --VALIDATION_STRINGENCY SILENT \
# --M /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_dup_metrics.txt 

# echo "done MarkDuplicates"
# # end_time="$(date -u +%s.%N)"
# end_time=$(date +"%s")

# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

# elapsed="$(bc <<< "scale=5; (${end_time} - ${start_time})/60.0")"
# echo "${elapsed}"

##1.2: SplitNCigarReads - Split'N'Trim and reassign mapping qualities##
#SplitNCigarReads splits reads into exon segments (getting rid of Ns but maintaining grouping information) and hardclip any sequences overhanging into the intronic regions
#This is accomplished by splitting reads that contain Ns in their cigar string and then creating new k+1 reads (where k is the number of N cigar elements)
#The first read includes the bases that are to the left of the first N element, while the part of the read that is to the right of the N (including the Ns) is hard clipped and so on for the rest of the new reads
#The output is a BAM file with reads split at N CIGAR elements and CIGAR strings updated

#R: reference sequence file
#I: BAM/SAM/CRAM file containing reads
#0: Write output to this BAM filename
#skip-mapping-quality-transform (or skip-mq-transform): ON by default (false); this flag turns off the mapping quality 255 -> 60 read transformer if it is set to true 

# echo "start SplitNCigarReads"
# start_time=$(date +"%s")
# echo "${start_time}"

# /usr/lib/gatk/gatk SplitNCigarReads -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -I /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates.bam \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split.bam 

# echo "done SplitNCigarReads"

# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

##1.3: AddOrReplaceReadGroups - Assign read-group tags to each read##
#AddOrReplaceReadGroups assigns each read to a single new read-group 

#RGPL(Read-Group platform): e.g., Illumina, SOLID
#RGPU(Read-Group platform unit): e.g., run barcode 
#RGLB(Read-Group library)
#RGSM(Read-Group sample name)
#RGID(Read-Group ID: default is 1 

# echo "start AddOrReplaceReadGroups"
# start_time=$(date +"%s")
# echo "${start_time}"

# /usr/lib/gatk/gatk AddOrReplaceReadGroups \
# I=/mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split.bam \
# O=/mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split_labeled.bam \
# RGPL=ILLUMINA \
# RGPU=unit1 \
# RGLB=lib1 \
# RGSM=MS1-IQ00-11000 \
# RGID=1

# echo "done AddOrReplaceReadGroups"
# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

##1.4: BaseRecalibrator - Base quality score recalibration (BQSR)##
#Generates recalibration table for Base Quality Score Recalibration (BQSR) based on various covariates (i.e., recalibrates base quality scores by building an error model using known covariates from all base calls)
#The default covariates are: read group, reported quality score, machine cycle, and nucleotide context
#GATK Report file with many tables: (1) The list of arguments, (2) The quantized qualities table, (3) The recalibration table by read group, (4) The recalibration table by quality score, and (5) The recalibration table for all the optional covariates

#known-sites: One or more databases of known polymorphic sites used to exclude regions around known polymorphisms from analysis; avoid confusing real variation with errors
#use-original-qualities: Use the base quality scores from the OQ tag; default value is false 

# echo "start BaseRecalibrator"
# start_time=$(date +"%s")
# echo "${start_time}"

# #VM .49 has v4.2.2.0 whereas VM .10 has v4.2.6.1 which has BaseRecalibratorSpark 
# /usr/lib/gatk/gatk BaseRecalibrator -I /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split_labeled.bam \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# --known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_clinically_associated.vcf \
# --known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_phenotype_associated.vcf \
# --known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_somatic_incl_consequences.vcf \
# --known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_structural_variations.vcf \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_recal_data_1.table

# echo "done BaseRecalibrator"
# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

# ##1.5: AnalyzeCovariates - Evaluate and compare base quality score recalibration (BQSR) tables
# #This function is only available with v4.2.2.0
# #Generates plots to assess the quality of a recalibration run as part of the Base Quality Score Recalibration (BQSR) procedure
# #Plot "before" (first pass) and "after" (second pass) recalibration tables to compare them

# #plots: a pdf document that encloses plots to assess the quality of the recalibration
# #Comparing the “before” (first pass) and “after” (second pass) plots allows you to check the effect of the base recalibration process before you actually apply the recalibration to your sequence data

# echo "start AnalyzeCovariates"
# start_time=$(date +"%s")
# echo "${start_time}"

# /usr/lib/gatk/gatk AnalyzeCovariates \
# -before /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_recal_data_1.table \
# -plots /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_analyze_covariates.pdf

# echo "done AnalyzeCovariates"
# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

#ApplyBQSR is not available with v4.2.6.1...only ApplyBQSRSpark 
#Use ApplyBQSR with v4.2.2.0 (.49 VM)
##1.6: ApplyBQSR - Apply the recalibration to your sequence data##
#This tool performs the second pass in a two-stage process called Base Quality Score Recalibration (BQSR)
#Specifically, it recalibrates the base qualities of the input reads based on the recalibration table produced by the BaseRecalibrator tool, and outputs a recalibrated BAM or CRAM file

echo "start ApplyBQSR"
start_time=$(date +"%s")
echo "${start_time}"

/usr/lib/gatk/gatk ApplyBQSR \
-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
-I /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split_labeled.bam \
-O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split_labeled_recal.bam \
--bqsr-recal-file /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_recal_data_1.table 

echo "done ApplyBQSR"
end_time=$(date +"%s")
difftimelps=$(($start_time-$end_time))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

# # #########VARIANT DISCOVERY#########

# # ##1.7: HaplotypeCaller: Call variants##
# # #Call germline SNPs and indels via local re-assembly of haplotypes
# # #The HaplotypeCaller is capable of calling SNPs and indels simultaneously via local de-novo assembly of haplotypes in an active region
# # #In other words, whenever the program encounters a region showing signs of variation, it discards the existing mapping information and completely reassembles the reads in that region
# # #The output is a VCF file containing all the sites that the HaplotypeCaller evaluated to be potentially variant; note that this file contains both SNPs and indels

# # ###Why was phred score lowered to 20?###

# echo "start HaplotypeCaller"
# start_time=$(date +"%s")
# echo "${start_time}"

# #L: one or more genomic intervals over which to operate
# #stand-call-conf: the minimum phred-scaled confidence threshold at which variants should be called; default is 30 
# #dont-use-soft-clipped-bases: Do not analyze soft clipped bases in the reads; default is false 
# Use HaplotypeCaller with v4.2.2.0...not available with 4.2.6.1 
/usr/lib/gatk/gatk --java-options "-Xms6000m -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10" HaplotypeCaller \
-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
-I /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_seq_marked_duplicates_split_labeled_recal.bam \
-O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_raw_variants.vcf.gz \
-L /mnt/iquityazurefileshare1/GTFs/Homo_sapiens.GRCh38.104.gtf.exons.interval_list \
-stand-call-conf 20 \ 
--dont-use-soft-clipped-bases false 

echo "done HaplotypeCaller"
end_time=$(date +"%s")
difftimelps=$(($start_time-$end_time))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

# # #########HARD FILTERING SNPs#########

# # ##1.8: Variant filtration##
# # #Filter variant calls based on INFO and/or FORMAT annotations
# # #This tool is designed for hard-filtering variant calls based on certain criteria
# # #Records are hard-filtered by changing the value in the FILTER field to something other than PASS
# # #SNPs matching any of the conditions listed below will be considered bad and filtered out, i.e., marked FILTER in the output VCF file
# # #SNPs that do not match any of these conditions will be considered good and marked PASS in the output VCF file
# # #Filtered records will be preserved in the output unless their removal is requested in the command line

# echo "start VariantFiltration"
# start_time=$(date +"%s")
# echo "${start_time}"

# #window: The window size (in bases) in which to evaluate clustered SNPs
# #cluster: the number of SNPs which make up a cluster; must be at least 2
# #filter: One or more expression used with INFO fields to filter
# #filter-name: names to use for the list of filters
# #QualByDepth (QD): 2.0; this is the variant confidence (from the QUAL field) divided by the unfiltered depth of non-reference samples
# #FisherStrand (FS): 60.0; Phred-scaled p-value using Fisher's Exact Test to detect strand bias (the variation being seen on only the forward or only the reverse strand) in the reads. More bias is indicative of false positive calls
# #Set add-output-vcf-command-line to false...the default is true 
# /usr/lib/gatk/gatk VariantFiltration \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -V /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_raw_variants.vcf.gz \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_raw_variants_filtered.vcf.gz \
# -window 35 \
# -cluster 3 \
# -filter "FS > 30.0" --filter-name "FS" \
# -filter "QD < 2.0" --filter-name "QD" \
# --add-output-vcf-command-line false 


# echo "done VariantFiltration"
# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."

# # # ################################
# # ########IMPORTANT NOTE########
# # #We have found that SNPs and indels, being different classes of variation, can have different “signatures” that indicate whether they are real or artifactual
# # #We therefore strongly recommend running the filtering process separately on SNPs and indels
# # #Unlike what we did for variant recalibration, it is not possible to apply the VariantFiltration tool selectively to only one class of variants (SNP or indel), so the first thing we have to do is split them into separate VCF files
# # #Reference: https://currentprotocols.onlinelibrary.wiley.com/doi/full/10.1002/0471250953.bi1110s43

# # #For the following steps, please proceed from the output of step 1.7 above
# # #Note: The GATK does not recommend use of compound filtering expressions, e.g. the logical || "OR", in the SelectVariants step

# echo "start SelectVariants and Variant Filtration for SNPs and indels separately"
# start_time=$(date +"%s")
# echo "${start_time}"

# ##1.8 Subset to SNPs-only callset with SelectVariants
# /usr/lib/gatk/gatk SelectVariants \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -V /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_raw_variants.vcf.gz \
# -select-type SNP \
# -O mnt/iquityazurefileshare1/Test/GATKTesting/MS1-IQ00-11000-P-NN_haplo_snps.vcf.gz

# ##1.8.1 Hard-filter SNPs on multiple expressions using VariantFiltration
# /usr/lib/gatk/gatk VariantFiltration \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -V mnt/iquityazurefileshare1/Test/GATKTesting/MS1-IQ00-11000-P-NN_haplo_snps.vcf.gz \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_snps_filtered.vcf.gz \
# -cluster 3 \
# -window 35 \
# -filter "FS > 30.0" --filter-name "FS" \
# -filter "QD < 2.0" --filter-name "QD" 

# ##1.9 Subset to indels-only callset with SelectVariants
# /usr/lib/gatk/gatk SelectVariants \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -V /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_raw_variants.vcf.gz \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_indels.vcf.gz \
# -select-type indel \


# ##1.9.1 Hard-filter indels on multiple expressions using VariantFiltration
# /usr/lib/gatk/gatk VariantFiltration \
# -R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
# -V /mnt/iquityazurefileshare1/Test/GATKTesting/temp/MS1-IQ00-11000-P-NN_haplo_indels.vcf.gz \
# -O /mnt/iquityazurefileshare1/Test/GATKTesting/temp/temp/MS1-IQ00-11000-P-NN_haplo_indels_filtered.vcf.gz \
# -cluster 3 \
# -window 35 \
# -filter "FS > 30.0" --filter-name "FS" \
# -filter "QD < 2.0" --filter-name "QD" \

# echo "done SelectVariants and Variant Filtration for SNPs and indels separately"
# end_time=$(date +"%s")
# difftimelps=$(($start_time-$end_time))
# echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed."