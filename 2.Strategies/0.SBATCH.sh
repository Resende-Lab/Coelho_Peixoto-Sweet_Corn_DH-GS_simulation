#!/bin/bash
#SBATCH --job-name=Str--30.%j
#SBATCH --mail-type=END
#SBATCH --mail-user=deamorimpeixotom@ufl.edu
#SBATCH --account=mresende
#SBATCH --qos=mresende-b
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4GB
#SBATCH --time=05:00:00
#SBATCH --output=1.tmp/Str--30.%a.array.%A.out
#SBATCH --error=2.error/Str--30.%a.array.%A.err
#SBATCH --array=1-100

module purge; module load R/4.1

INPUT=$(head -n $SLURM_ARRAY_TASK_ID INPUT.FILE.txt | tail -n 1)

echo $INPUT
Rscript RUNME.R $INPUT ${rep} ${VarGE} 
