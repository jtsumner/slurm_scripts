#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 01:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_megahit_metagenomics"

#load modules
module load anaconda3

# activate conda env with fasp
source activate genome_qc

# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:
for i in $(ls *.fa)
do
	quast.py --threads 12 ${i}

done
source deactivate
