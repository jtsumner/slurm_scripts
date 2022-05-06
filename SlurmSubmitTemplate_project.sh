#! /bin/bash
#SBATCH -A p31288
#SBATCH -p short
#SBATCH --job-name="A"
#SBATCH -t 01:00:00
#SBATCH -n 5
#SBATCH --mem-per-cpu=3gb


# Load modules
module load

# Optional - Load conda envs
conda activate

# Go to submit directory
cd $SLURM_SUBMIT_DIR

# Execute code



