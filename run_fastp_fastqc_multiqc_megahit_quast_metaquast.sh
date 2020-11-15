#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 02:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_fastp_metagenomics"

#load modules
module load anaconda3
module load fastqc
module load multiqc
module load megahit
# activate conda env with fasp

# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:

# For timestamp logs
timestamp=$(date +%d_%m_%Y_%H_%M_%S)


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
				fastp -i ${i} -I ${j} --merged_out ${i_sub}_fastp_out_merged.fq.gz --out1 ${i_sub}_fastp_out.R1.fq.gz --out2 ${j_sub}_fastp_out.R2.fq.gz --unpaired1 ${i_sub}_fastp_out_unpaired1.fq.gz --unpaired2 ${i_sub}_fastp_out_unpaired2.fq.gz --merge --detect_adapter_for_pe --thread 12 --length_required 50
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

first_round=$(ls ${SLURM_SUBMIT_DIR}/first_round/trimmed_fastp_merged_${timestamp}/NTM* | cut -c55-67 | uniq)
second_round=$(ls ${SLURM_SUBMIT_DIR}/second_round/trimmed_fastp_merged_${timestamp}/NTM* | cut -c56-68 | uniq)

first_path="${SLURM_SUBMIT_DIR}/first_round/trimmed_fastp_merged_${timestamp}/"
second_path="${SLURM_SUBMIT_DIR}/second_round/trimmed_fastp_merged_${timestamp}/"
echo $first_path
echo ${SLURM_SUBMIT_DIR}
for trim_i in ${first_round}
do
	trim_i_sub=$(${trim_i} | cut -c1-8)
	for trim_j in ${second_round}
	do
		trim_j_sub=$(${trim_j} | cut -c1-8)
		if [[ ${trim_i_sub} == ${trim_j_sub} ]]
		then
			merged_i=${first_path}${trim_i}_fastp_out_merged.fq.gz
			r1_i=${first_path}${trim_i}_fastp_out.R1.fq.gz
			r2_i=${first_path}${trim_i}_fastp_out.R2.fq.gz
			merged_j=${second_path}${trim_j}_fastp_out_merged.fq.gz
			r1_j=${second_path}${trim_j}_fastp_out.R1.fq.gz
			r2_j=${second_path}${trim_j}_fastp_out.R2.fq.gz
			megahit -1 ${r1_i},${r1_j} -2 ${r2_i},${r2_j} -r ${merged_i},${merged_j} -m 0.9 -t 12 -o megahit_${trim_i_sub}

		fi

	done

done

