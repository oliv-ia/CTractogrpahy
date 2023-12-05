#!/bin/bash --login
#$ -cwd
#$ -l nvidia_a100            # Can instead use 'nvidia_a100' for the A100 GPUs (if permitted!)

#$ -pe smp.pe 8              # 6 CPU cores 
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/anaconda3/2022.10
source activate test_env
module load libs/gcc/8.2.0 
module load libs/cuda
module load apps/binapps/anaconda3/2022.10

export nnUNet_raw='/mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data'
export nnUNet_preprocessed='/mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_preprocessed'
export nnUNet_results='/mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_trained_models'

nnUNetv2_find_best_configuration DATASET_NAME_OR_ID -c CONFIGURATIONS 

