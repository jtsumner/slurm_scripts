#! /bin/bash
#SBATCH -A p31288
#SBATCH -p short
#SBATCH --job-name="A"
#SBATCH -t 01:00:00
#SBATCH -n 5
#SBATCH --mem-per-cpu=3gb


# Load modules
module load anaconda3

# Optional - Load conda envs
source activate gtdbtk

# Run download-db.sh if GTDBTK_DATA_PATH (path to database) cannot be found

# Go to submit directory
cd $SLURM_SUBMIT_DIR

# Execute code

# Path/to/fasta/files in a directory
IN_DIR="./"

 # Path/to/output
OUT_DIR="./gtdbtk_classify_wf_out"


gtdbtk classify_wf --genome_dir ${IN_DIR} --out_dir ${OUT_DIR} --cpus 5 -x 'fa'

source deactivate

