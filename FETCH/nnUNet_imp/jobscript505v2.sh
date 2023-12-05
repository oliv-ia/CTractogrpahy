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
#nnUNetv2_convert_old_nnUNet_dataset /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Task505_CT_CST_tractography Dataset505_CST_TRACTOGRAPHY

#nnUNetv2_plan_and_preprocess -d 505 --verify_dataset_integrity
#OMP_NUM_THREADS=1 nnUNetv2_train 505 3d_fullres 1
#OMP_NUM_THREADS=1 nnUNetv2_train 505 3d_fullres 2
#OMP_NUM_THREADS=1 nnUNetv2_train 505 3d_fullres 3
#OMP_NUM_THREADS=1 nnUNetv2_train 505 3d_fullres 4
#nnUNetv2_find_best_configuration 505 -c 3d_fullres 


nnUNetv2_predict -d Dataset505_CST_TRACTOGRAPHY -i /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/imagesTs -o /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/test_results -f  0 1 2 3 4 -tr nnUNetTrainer -c 3d_fullres -p nnUNetPlans

nnUNetv2_apply_postprocessing -i /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/test_results -o /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Dataset505_CST_TRACTOGRAPHY/test_results_pp -pp_pkl_file /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_trained_models/Dataset505_CST_TRACTOGRAPHY/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/postprocessing.pkl -np 8 -plans_json /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_trained_models/Dataset505_CST_TRACTOGRAPHY/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/plans.json
source deactivate