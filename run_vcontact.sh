#!/bin/sh
#SBATCH -A p31288
#SBATCH -p short
#SBATCH -n 80
#SBATCH -t 04:00:00
#SBATCH --mem=100gb
#SBATCH --job-name="vibrant_on_contigs"

#load modules
module load anaconda3
# activate conda denv with fasp
source activate run_vcontact2_v2
# Set working directory
cd $SLURM_SUBMIT_DIR

gene_to_genome_mapping_file=testreads_phages_combined.csv
proteins_file=testreads_phages_combined.simple.faa

vcontact2 --raw-proteins ${proteins_file} --rel-mode 'Diamond' --proteins-fp ${gene_to_genome_mapping_file} --db 'ProkaryoticViralRefSeq94-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin ~/.conda/envs/run_vcontact2_v2/bin/cluster_one-1.0.jar --output-dir ${SLURM_SUBMIT_DIR}/vcontact2_output -t 80

source deactivate

