#!/bin/bash --login
#$ -cwd
#$ -l nvidia_v100            # Can instead use 'nvidia_a100' for the A100 GPUs (if permitted!)

#$ -pe smp.pe 6              # 6 CPU cores 

export OMP_NUM_THREADS=$NSLOTS


# Process the data with a GPU app, from within the local NVMe storage area

module load libs/gcc/8.2.0 
module load libs/cuda
module load apps/binapps/anaconda3/2021.11
source activate test_env
#cd /mnt/iusers01/ct01/p09383om/scratch/selected_ct_lumc/


export nnUNet_raw_data_base='/mnt/iusers01/ct01/p09383om/scratch/nnUNet_raw_data_base'
export nnUNet_preprocessed='/mnt/iusers01/ct01/p09383om/scratch/nnUNet_preprocessed'
export RESULTS_FOLDER='/mnt/iusers01/ct01/p09383om/scratch/nnUNet_trained_models'
#mv /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/2-18-004/CT.nii.gz /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/2-18-004/CT_0000.nii.gz

    #cd /Users/oliviamurray/Documents/test/

    #mv /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${patient_id}/CT.nii.gz /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${patient_id}/CT_0000.nii.gz 
    #mkdir -p /mnt/iusers01/ct01/p09383om/scratch/lumc_haematoma_segs/${patient_id}
    #cd /Users/oliviamurray/Documents/FETCH/3T_UMCU/${patient_id}/
    #for id in *
    #do
    #     export ids=$id
    #/Users/oliviamurray/Downloads/dcm2niix_24-Jul-2017_mac/dcm2niix -f "%f_%z_%d" -p y -z y -o /Users/oliviamurray/Documents/FETCH/ct_radboudumc_3_nifti/${patient_id}  /Users/oliviamurray/Documents/FETCH/CT_Radboudumc_3/${patient_id}
    #done

    #nnUNet_predict -i /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${patient_id} -o /Users/oliviamurray/Documents/FETCH/lumc_haematoma_segs/${patient_id} -tr nnUNetTrainerV2 -ctr nnUNetTrainerV2CascadeFullRes -m 3d_fullres -p nnUNetPlansv2.1 -t Task501_Haemorrhage
nnUNet_predict -i /mnt/iusers01/ct01/p09383om/scratch/MISTIE_inference/images -o /mnt/iusers01/ct01/p09383om/scratch/MISTIE_inference/predictions -tr nnUNetTrainerV2  -m 3d_fullres -p nnUNetPlansv2.1 -t Task501_Haemorrhage


