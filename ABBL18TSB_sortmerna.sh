#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="smrna_ABBL18TSB_S75_R1_001_kneaddata_trimmed.fq.gz"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE

module purge

module load fastqc
module load bowtie2/2.4.1
module load anaconda3

source activate sortmerna

cd /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/trim_galore_out/


sortmerna -ref /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/sortmerna_database/rRNA_databases/silva-bac-16s-id90.fasta \
	-ref /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/sortmerna_database/rRNA_databases/silva-bac-23s-id98.fasta \
	-reads ./ABBL18TSB_S75_R1_001_kneaddata_trimmed.fq.gz \
	--threads 12 \
	--fastx -workdir /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/sortmerna_out/ABBL18TSB/ \
	--other ABBL18TSB_nonrna \
	--aligned ABBL18TSB_rna

