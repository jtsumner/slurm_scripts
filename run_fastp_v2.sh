#!/bin/sh
#SBATCH -A e31265
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 01:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_fastp_metagenomics"

#load modules
module load anaconda3
module load fastqc
module load multiqc

# activate conda env with fasp
source activate seq_processing

# Set working directory
#cd $SLURM_SUBMIT_DIR

# The command to execute:

# For fastp qc analysis
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
timestamp=$(date +%d_%m_%Y_%H_%M_%S)

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
