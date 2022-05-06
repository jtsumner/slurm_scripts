#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 13
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="tg_ABBL18TSB_S75_R1_001_kneaddata.fastq"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE

module purge

module load fastqc
module load bowtie2/2.4.1
module load anaconda3

source activate trim_galore

cd /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/kneaddata_out/

trim_galore -q 20 --phred33 --fastqc --gzip ABBL18TSB_S75_R1_001_kneaddata.fastq -j 12 --output_dir /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/trim_galore_out/

