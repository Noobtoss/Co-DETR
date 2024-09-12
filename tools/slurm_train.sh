#!/bin/bash
#
#SBATCH --job-name=Co-DETR
#SBATCH --output=R-%j.out
#SBATCH --mail-user=thomas.schmitt@th-nuernberg.de
#SBATCH --mail-type=ALL
#
#SBATCH --partition=p2
#SBATCH --qos=gpuultimate
#SBATCH --gres=gpu:1
#SBATCH --nodes=1                # Anzahl Knoten
#SBATCH --ntasks=1               # Gesamtzahl der Tasks über alle Knoten hinweg
#SBATCH --cpus-per-task=4        # CPU Kerne pro Task (>1 für multi-threaded Tasks)
#SBATCH --mem=64G                # RAM pro CPU Kern #20G #32G #64G

module purge
module load python/anaconda3
eval "$(conda shell.bash hook)"
export PYTHONPATH=/nfs/scratch/staff/schmittth/sync/Co-DETR:$PYTHONPATH

conda activate Co_DETR

BASE_DIR=/nfs/scratch/staff/schmittth/sync/Co-DETR
CONFIG=$1

echo $CONFIG
srun python -u tools/train.py $BASE_DIR/$CONFIG --work-dir=$BASE_DIR/train_logs/$SLURM_JOB_ID --launcher='slurm' ${@:3}
