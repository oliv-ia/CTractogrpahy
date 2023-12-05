#!/bin/bash 

#file=/Users/oliviamurray/Documents/FETCH/fetch_radboudumc_xtract/fetch_umcu_bedpostx/umcu_ids.txt
#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_t1_prequal/fetch_ID.txt 
#INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
#echo $INSUBJ

cd /Users/oliviamurray/Documents/FETCH/selected_ct_umcu
for patient in *
do 
    #cd /Users/oliviamurray/Documents/test/
    export INSUBJ=$patient
    
    export bedpost_dir=/Users/oliviamurray/Documents/PhD/GitHub/Segmentation/FETCH/fetch_umcu_2_bedpostx
    export prequal_dir=/Users/oliviamurray/Documents/PhD/GitHub/Segmentation/FETCH/fetch_dti_prequal_umcu_2_final/${INSUBJ}/PreQual/output/PREPROCESSED
    export ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_umcu/${INSUBJ}
    export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
    
    export xtract_dir=${bedpost_subject_dir}/xtract
    export tract_dir=${xtract_dir}/tracts
    export xfms_dir=${bedpost_subject_dir}/xfms

    cd ${tract_dir}
    echo ${tract_dir}
    flirt -in ${tract_dir}/cst_r/densityNorm.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${tract_dir}/cst_r/densityNormCTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
    flirt -in ${tract_dir}/cst_l/densityNorm.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${tract_dir}/cst_l/densityNormCTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
    
   
done