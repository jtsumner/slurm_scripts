#!/bin/bash
#SBATCH -A p31414
#SBATCH -p short
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --mem-per-cpu=3g 
#SBATCH --job-name="hisat2_ABBL18TSB_nonrna.fq"
#SBATCH --mail-user=jacksumner2026@u.northwestern.edu
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE

module purge

module load hisat2/2.1.0

cd /projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/sortmerna_out/norna/



#ABBL 
#hisat2 -x /projects/p31414/hisat/ABBL18/hisat2_index/hisat2_ABBL18_index_fna -p 24 -U ABBL18TSB_nonrna.fq -S '/projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/hisat_out/ABBL18TSB_hisat-ABBL.sam'

#Bacillus
hisat2 -x /projects/p31414/hisat/BG/hisat2_index/hisat2_BG_index_fna -p 24 -U ABBL18TSB_nonrna.fq -S '/projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/hisat_out/ABBL18TSB_hisat-BG.sam'

# Klebsiella
#hisat2 -x /projects/b1042/HartmannLab/probiotic_competition_2021/hisat2/CRE231 -p 24 -U ABBL18TSB_nonrna.fq -S '/projects/b1042/HartmannLab/probiotic_competition_2021/rnasesq/hisat_out/ABBL18TSB_hisat-CRE.sam'


