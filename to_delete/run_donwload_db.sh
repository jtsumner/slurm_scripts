#!/bin/sh
#SBATCH -A p31288
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 03:00:00
#SBATCH --mem=25gb
#SBATCH --job-name="donwload_db_vibrant"

#load modules
module load anaconda3
# activate conda denv with fasp
source activate run_vibrant_v2
# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:
download-db.sh

conda deactivate

