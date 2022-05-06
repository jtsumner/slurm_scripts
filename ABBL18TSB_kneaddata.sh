#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 03:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="kd_ABBL18TSB_S75_R1_001.fastq.gz"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE

module purge

module load fastqc
module load bowtie2/2.4.1
module load anaconda3

source activate kneaddata_probiotic
cd /projects/b1042/HartmannLab/probiotic_competition_2021/raw_data/


kneaddata -v -i ./ABBL18TSB_S75_R1_001.fastq.gz --max-memory 700000m \
	-db /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/kneaddata_human/ \
	-db /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/kneaddata_neg/ \
	--output /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/kneaddata_out/ \
	--threads 24 \
	--bowtie2 /software/bowtie2/2.4.1/ \
	--fastqc /software/fastqc/0.11.5/ \
	--run-fastqc-end \
	--run-fastqc-start \
	--remove-intermediate-output \
	--sequencer-source TruSeq3

