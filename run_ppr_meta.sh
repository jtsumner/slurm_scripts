#!/bin/sh
#SBATCH -A p31288
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 27
#SBATCH -t 04:00:00
#SBATCH --mem=95gb
#SBATCH --job-name="run_ppr-meta"

#load modules
module load anaconda3
#module load matlab/r2018a

# activate conda env with fasp
source activate PPR-meta

# Set working directory
cd $SLURM_SUBMIT_DIR

# Set LD_LIBRARY_PATH to include MCR dependency
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/jsj3921/.local/MATLAB/MATLAB_Runtime/v94/runtime/glnxa64:/home/jsj3921/.local/MATLAB/MATLAB_Runtime/v94/bin/glnxa64:/home/jsj3921/.local/MATLAB/MATLAB_Runtime/v94/sys/os/glnxa64:/home/jsj3921/.local/MATLAB/MATLAB_Runtime/v94/extern/bin/glnxa64


# The command to execute:

# Run PPR Meta on NTM01067
~/CLI_program_installs/PPR-Meta/PPR_Meta /projects/p31288/reads/test_reads/megahit_assemblies_merged_paired/megahit_NTM01067/final.contigs.fa /projects/p31288/reads/test_reads/megahit_assemblies_merged_paired/testing_ppr-meta/NTM01067_output.csv -t 0.7

source deactivate
