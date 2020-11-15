#!/bin/sh
#SBATCH -A p31288
#SBATCH -p short
#SBATCH -n 40
#SBATCH -t 03:00:00
#SBATCH --mem=40gb
#SBATCH --job-name="vibrant_on_contigs"

#load modules
module load anaconda3
# activate conda denv with fasp
source activate run_vibrant_v3
# Set working directory
cd $SLURM_SUBMIT_DIR

vibrant_file="/projects/p31288/VIBRANT/VIBRANT_run.py"
dbs="/projects/p31288/VIBRANT/databases"
fileend="_greater-1kb.fa"

for i in $(ls -d megahit*)
do
	sample=$(echo $i | cut -d "_" -f 2)
	contigs=${sample}${fileend}
	echo starting analysis on ${i}/${contigs}
	python3 ${vibrant_file} -i ${i}/${contigs} -d ${dbs} -t 40

done
source deactivate

