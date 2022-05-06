#! /bin/bash
#SBATCH -A p31288
#SBATCH -p short
#SBATCH --job-name="A"
#SBATCH -t 01:00:00
#SBATCH -n 12
#SBATCH --mem-per-cpu=3gb


# Load modules
module load checkm

# Go to submit directory
cd $SLURM_SUBMIT_DIR

# Execute code
module load checkm/1.0.7
checkm lineage_wf --threads 12 --extension 'fa' ./allSamples.megahit_g1000.fa.metabat-bins20-20210901_173205 ./check_out



