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
CHECKPOINT=$2

srun python -u tools/test.py $BASE_DIR/$CONFIG $BASE_DIR/$CHECKPOINT --work-dir=$BASE_DIR/test_logs/$(basename "$(dirname "$CHECKPOINT")") --launcher='slurm' ${@:3} --eval bbox --out $BASE_DIR/test_logs/$SLURM_JOB_ID-$(basename "$(dirname "$CHECKPOINT")").pkl