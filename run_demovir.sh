#!/bin/sh
#SBATCH -A p31288
#SBATCH -p short
#SBATCH -n 20
#SBATCH -t 04:00:00
#SBATCH --mem=40gb
#SBATCH --job-name="demovir_on_contigs"

#load modules
module load anaconda3

source activate run_demovir

module load prodigal
module load R
# activate conda denv with fasp

# Set working directory
cd $SLURM_SUBMIT_DIR

for i in $(ls *.fna)
do
	/projects/p31288/Demovir/demovir.sh ${i} 20

done

source deactivate


