#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 01:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_megahit_metagenomics"

#load modules
module load megahit

# activate conda env with fasp

# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:
for i in $(ls *R1.fq.gz)
do
        i_sub=$(echo $i | cut -c1-12)
        for j in $(ls *R2.fq.gz)
        do
                j_sub=$(echo $j | cut -c1-12)
                if [[ $i_sub == $j_sub ]]
                then
			merged=${i_sub}_fastp_out_merged.fq.gz
			unp1=${i_sub}_fastp_out_unpaired1.fq.gz
                        unp2=${i_sub}_fastp_out_unpaired2.fq.gz
			megahit -1 ${i} -2 ${j} -m 0.9 -t 12 -r ${merged},${unp1},${unp2} -o megahit_${i_sub}
                fi

        done

done

