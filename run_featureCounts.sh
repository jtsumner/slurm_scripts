#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 15
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="featurecounts_ABBL18TSB_hisat-BG.sam"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE



module load anaconda3

source activate prokka

# ABBL
featureCounts -T 15 --verbose -a /projects/p31414/hisat/ABBL18/PROKKA_06012021.gtf -t CDS -o ../featureCounts_out/featureCounts-ABBL.txt *hisat-ABBL.bam -F GTF -g gene_id


# BG
featureCounts -T 15 --verbose -a /projects/p31414/hisat/BG/PROKKA_06022021.gtf -t CDS -o ../featureCounts_out/featureCounts-BG.txt *hisat-BG.bam -F GTF -g gene_id


# CRE
featureCounts -T 15 --verbose -a /projects/b1042/HartmannLab/probiotic_competition_2021/Annotation/prokka_1_14_6/CRE231_scaffolds.gtf -t CDS -o ../featureCounts_out/featureCounts-CRE.txt *hisat-CRE.bam -F GTF -g gene_id

