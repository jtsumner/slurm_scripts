#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 01:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_fastqc_metagenomics"

#load modules and conda env with trimmomatic (v0.39) installed

# Set working directory
cd $SLURM_SUBMIT_DIR

# Trimmomatic v0.39 installed in ~/CLI_program_installs/trimmomatic_install/Trimmomatic-0.39/
## Install Source (binary): http://www.usadellab.org/cms/?page=trimmomatic
## Nextera Adapter sequence in Trimmomatic-0.39/adapters/ and copied to cd 

# The command to execute:

## Check if dir "trimmed" exists and make it if it does not
if [ -d "./trimmed" ] 
then
	echo "Directory ./trimmed exists." 
else
	mkdir trimmed
	echo "Directory ./trimmed now exists"
fi

## Nested for loop and conditionals (if statement compares seqID)  to ID matching reads
## Trimmomatic parameters informed from manual and MacManes et al Front. Genet, (2014)
trim="/home/jsj3921/CLI_program_installs/trimmomatic_install/Trimmomatic-0.39/trimmomatic-0.39.jar"
for i in $(ls *R1_001.fastq.gz)
do 
	i_sub=$(echo $i | cut -c1-12)
	for j in $(ls *R2_001.fastq.gz)
	do
		j_sub=$(echo $j | cut -c1-12)
		if [[ $i_sub == $j_sub ]]
		then
			base_out="${i_sub}_trimmed.fq.gz"
			java -jar $trim PE -threads 12 -summary sum_trim.txt -basein ${i} -baseout ${base_out} ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 SLIDINGWINDOW:4:5 MINLEN:50

		fi

	done

done

