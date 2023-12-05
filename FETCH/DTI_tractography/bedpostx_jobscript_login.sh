#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4

module load apps/binapps/fsl/6.0.4 

export data_prequal_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc
cd /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc
mkdir /mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx
for patient in *
do 
    #cd /Users/oliviamurray/Documents/test/
  
    export patient_id=$patient
    mkdir /mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx/${patient_id}

    export bedpost_patient_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx/${patient_id}
    cp ${bedpost_patient_dir}/dwmri.bval ${bedpost_patient_dir}/bvals
    cp ${bedpost_patient_dir}/dwmri.bvec ${bedpost_patient_dir}/bvecs
    cp ${bedpost_patient_dir}/mask.nii.gz ${bedpost_patient_dir}/nodif_brain_mask.nii.gz
    cp ${bedpost_patient_dir}/dwmri.nii.gz ${bedpost_patient_dir}/data.nii.gz

    #bedpostx ${bedpost_patient_dir} -n 1 -w 1 -b 1000 -c
done
