#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 40
#SBATCH -t 04:00:00
#SBATCH --mem=100gb
#SBATCH --job-name="run_fastp_metagenomics"

#load modules
module load anaconda3
module load fastqc
module load multiqc
module load spades

# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:

# For timestamp logs
timestamp=$(date +%d_%m_%Y_%H_%M_%S)


############################
### PART 1: FASTP, QUAST ###
############################


# For fastp qc analysis
for dire in $(ls -d */)
do
	cd ${SLURM_SUBMIT_DIR}/${dire}
	source activate seq_processing

	for i in $(ls *R1_001.fastq.gz)
	do
		i_sub=$(echo $i | cut -c1-12)
		for j in $(ls *R2_001.fastq.gz)
		do
			j_sub=$(echo $j | cut -c1-12)
			if [[ $i_sub == $j_sub ]]
			then
				fastp -i ${i} -I ${j} --out1 ${i_sub}_fastp_out.R1.fq.gz --out2 ${j_sub}_fastp_out.R2.fq.gz --detect_adapter_for_pe --thread 16 --length_required 50

			fi

		done

	done

	source deactivate

	# To move FASTP outputs into new directory

	trim_dir="./trimmed_fastp_merged_${timestamp}"
	if [ -d $trim_dir ]
	then
		echo "Directory ${trim_dir} exists" 
	else
		mkdir ${trim_dir} 
		echo "Directory ${trim_dir} now exists"
	fi

	mv *fastp_out* ${trim_dir}/
	mv fastp.html fastp.json ${trim_dir}/

	cd ${trim_dir}/

	# For fastqc analysis
	fastqc -t 12 *fq.gz

	# To move fastqc data
	fastqc_dir=./fastqc_${timestamp}
	if [ -d ${fastqc_dir} ]
	then
		echo "Directory ${fastqc_dir} exists" 
	else
		mkdir ${fastqc_dir}
		echo "Directory ${fastqc_dir} now exists"
	fi

	mv *fastqc.html ${fastqc_dir}
	mv *fastqc.zip ${fastqc_dir}

	cd ${fastqc_dir}
	multiqc .
	cd $SLURM_SUBMIT_DIR

done

#######################
### PART 2: SPADES  ###
#######################


cd $SLURM_SUBMIT_DIR

# To find redundant set of sample and sequencing IDs (i.e., NTM0000_S00) from first round reads
first_round=""
for file_path in $(ls ${SLURM_SUBMIT_DIR}/first_round/trimmed_fastp_merged_${timestamp})
do

	base=$(basename ${file_path})
	base_sub=$(echo $base | cut -c1-3)
	if [[ $base_sub == "NTM" ]]
	then 

		sample_id=$(echo ${base} | cut -c1-12)
		first_round="${first_round} ${sample_id}"

	fi

done

# To find redundant set of sample and sequencing IDs (i.e., NTM0000_S00) from second round reads
second_round=""
for file_path in $(ls ${SLURM_SUBMIT_DIR}/second_round/trimmed_fastp_merged_${timestamp})
do

        base=$(basename ${file_path})
        base_sub=$(echo $base | cut -c1-3) 
        if [[ $base_sub == "NTM" ]]
        then

                sample_id=$(echo ${base} | cut -c1-12)
                second_round="${second_round} ${sample_id}"

        fi

done

# Reduce sample sets to be  nonredunant (string seperated by white space -> by newline -> unique sort)
first_round=$(echo -e "${first_round// /\\n}" | sort -u)
second_round=$(echo -e "${second_round// /\\n}" | sort -u)

# To assign paths/to/trimmed-reads
first_path="${SLURM_SUBMIT_DIR}/first_round/trimmed_fastp_merged_${timestamp}/"
second_path="${SLURM_SUBMIT_DIR}/second_round/trimmed_fastp_merged_${timestamp}/"


# To make a directory for concatenated reads from samples
concat_reads_dir=./concat_trimmed_reads_${timestamp}
if [ -d ${concat_reads_dir} ]
then
	echo "Directory ${concat_reads_dir} exists" 
else
	mkdir ${concat_reads_dir}
        echo "Directory ${concat_reads_dir} now exists"
fi

# To match sequnce ids between rounds and run megahit on paired and merged reads


echo ${SLURM_SUBMIT_DIR}
for trim_i in ${first_round}
do
	trim_i_sub=$(echo ${trim_i} | cut -c1-8)
	for trim_j in ${second_round}
	do
		trim_j_sub=$(echo ${trim_j} | cut -c1-8)
		if [[ ${trim_i_sub} == ${trim_j_sub} ]]
		then
			
			# To concatenate paired reads from rounds 
			
			r1_i=${first_path}${trim_i}_fastp_out.R1.fq.gz
			r2_i=${first_path}${trim_i}_fastp_out.R2.fq.gz
			
			r1_j=${second_path}${trim_j}_fastp_out.R1.fq.gz
			r2_j=${second_path}${trim_j}_fastp_out.R2.fq.gz

			
			r1_cat=${concat_reads_dir}/${trim_i_sub}_trimmed_concat.R1.fq.gz
			r2_cat=${concat_reads_dir}/${trim_i_sub}_trimmed_concat.R2.fq.gz
			cat ${r1_i} ${r1_j} > ${r1_cat}
			cat ${r2_i} ${r2_j} > ${r2_cat}

			spades.py -1 ${r1_cat} -2 ${r2_cat} -o spades_${trim_i_sub} -t 40 -m 100 --meta

		fi

	done

done

