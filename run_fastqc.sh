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
module load multiqc

for i in $(ls -1 *.fq) ; do fastqc -t 10 $i ; done

multiqc ./
