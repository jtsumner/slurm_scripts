#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="samtools_ABBL18TSB_hisat-ABBL.sam"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE

module purge

module load hisat2/2.1.0
module load samtools


cd /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/hisat_out/



samtools view -@ 24 -bS ABBL18TSB_hisat-ABBL.sam | samtools sort -@ 24 -o ABBL18TSB_hisat-ABBL.bam


