#!/bin/bash
#SBATCH --job-name=1Pip3GS.%j
#SBATCH --mail-type=END
#SBATCH --mail-user=deamorimpeixotom@ufl.edu
#SBATCH --account=mresende
#SBATCH --qos=mresende-b
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10GB
#SBATCH --time=12:00:00
#SBATCH --output=1.tmp/alphasim.%a.array.%A.out
#SBATCH --error=2.error/alphasim.%a.array.%A.err
#SBATCH --array=1-1000

module purge; module load R

INPUT=$(head -n $SLURM_ARRAY_TASK_ID INPUT.FILE.txt | tail -n 1)

echo $INPUT
Rscript RUNME.R $INPUT ${rep} ${VarGE} ${VarE} ${Par}
