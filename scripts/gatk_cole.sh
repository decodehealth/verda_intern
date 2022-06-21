/usr/lib/gatk/gatk MarkDuplicates --INPUT /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.sortedByCoord.out.bam \
--OUTPUT /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.bam  \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT \
--METRICS_FILE /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_DUP.metrics

/usr/lib/gatk/gatk \
	SplitNCigarReads \
	-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	-I /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.bam  \
	-O /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.bam

	java -jar /mnt/iquityazurefileshare1/IQuity/GATK_Testing/gatk-workflows/picard.jar \
	AddOrReplaceReadGroups \
	I= /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.bam \
	O= /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.labeled.bam \
	RGPL=illumina \
	RGPU=unit1 \
	RGLB=lib1 \
	RGSM=2343-TA-1 \
	RGID=1	

	/usr/lib/gatk/gatk \
	BaseRecalibrator \
	-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	-I /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.labeled.bam \
	--use-original-qualities \
	-O /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_recal_data.csv \
	-known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_clinically_associated.vcf \
	-known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_phenotype_associated.vcf \
	-known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_somatic_incl_consequences.vcf \
	-known-sites /mnt/iquityazurefileshare1/GTFs/SNPs/homo_sapiens_structural_variations.vcf

	/usr/lib/gatk/gatk \
ApplyBQSR \
--add-output-sam-program-record \
-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
-I /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.labeled.bam \
--use-original-qualities \
-O /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.labeled.recal.bam  \
--bqsr-recal-file /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_recal_data.csv

/usr/lib/gatk/gatk --java-options "-Xms6000m -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10" \
	HaplotypeCaller \
	-R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	-I /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1_Aligned.dedupped.split.labeled.recal.bam \
	-L /mnt/iquityazurefileshare1/GTFs/Homo_sapiens.GRCh38.104.gtf.exons.interval_list \
	-O /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1.haplo.vcf.gz \
	-dont-use-soft-clipped-bases \
	--standard-min-confidence-threshold-for-calling 20 

	/usr/lib/gatk/gatk \
	VariantFiltration \
	--R /mnt/iquityazurefileshare1/GTFs/SNPs/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	--V /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1.haplo.vcf.gz \
	--window 35 \
	--cluster 3 \
	--filter-name "FS" \
	--filter "FS>30.0" \
	--filter-name "QD" \
	--filter "QD<2.0" \
	-O /mnt/iquityazurefileshare1/IQuity/GATK_Testing/210830_Testing/2343-TA-1.haplo.variant_filtered.vcf.gz