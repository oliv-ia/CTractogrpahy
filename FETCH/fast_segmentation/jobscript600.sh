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

export nnUNet_raw='/mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw'
export nnUNet_preprocessed='/mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_preprocessed'
export nnUNet_results='/mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_results'
#nnUNetv2_convert_old_nnUNet_dataset /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Task505_CT_CST_tractography Dataset505_CST_TRACTOGRAPHY

#nnUNetv2_plan_and_preprocess -d 600 --verify_dataset_integrity
#OMP_NUM_THREADS=1 nnUNetv2_train 600 3d_fullres 0
#OMP_NUM_THREADS=1 nnUNetv2_train 600 3d_fullres 2
#OMP_NUM_THREADS=1 nnUNetv2_train 600 3d_fullres 3
#OMP_NUM_THREADS=1 nnUNetv2_train 600 3d_fullres 4
#nnUNetv2_find_best_configuration 600 -c 3d_fullres 

# Instructions from inference_instructions.txt


#nnUNetv2_predict -d Dataset600_FASTnoHaem -i /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/imagesTs -o /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/predictionsTs -f  0 1 2 3 4 -tr nnUNetTrainer -c 3d_fullres -p nnUNetPlans
#nnUNetv2_apply_postprocessing -i /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/predictionsTs -o /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/predictionsTs_PP -pp_pkl_file /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_results/Dataset600_FASTnoHaem/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/postprocessing.pkl -np 8 -plans_json /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_results/Dataset600_FASTnoHaem/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/plans.json
nnUNetv2_evaluate_folder -djfile /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/dataset.json -pfile /mnt/iusers01/ct01/p09383om/scratch/FETCH_nnUNet/nnUNet_results/Dataset600_FASTnoHaem/nnUNetTrainer__nnUNetPlans__3d_fullres/crossval_results_folds_0_1_2_3_4/plans.json --chill /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/labelsTs /mnt/iusers01/ct01/p09383om/scratch/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/predictionsTs_PP
source deactivate