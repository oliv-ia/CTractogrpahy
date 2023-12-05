#!/bin/bash --login
#$ -cwd
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

nnUNetv2_evaluate_folder -djfile /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/dataset.json -pfile /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_trained_models/Dataset505_CST_TRACTOGRAPHY/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/plans.json --chill /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/labelsTs /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/test_results_pp