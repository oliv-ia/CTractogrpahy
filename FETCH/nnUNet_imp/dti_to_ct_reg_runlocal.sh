#!/bin/bash 

#file=/Users/oliviamurray/Documents/FETCH/fetch_radboudumc_xtract/fetch_umcu_bedpostx/umcu_ids.txt
#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_t1_prequal/fetch_ID.txt 
#INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
#echo $INSUBJ
cd /Users/oliviamurray/Documents/FETCH/selected_ct_lumc
for patient in *
do 
    #cd /Users/oliviamurray/Documents/test/
    export INSUBJ=$patient
    echo $INSUBJ
    #export bedpost_dir=/Users/oliviamurray/Documents/PhD/GitHub/Segmentation/FETCH/fetch_umcu_2_bedpostx
    export prequal_dir=/Users/oliviamurray/Documents/PhD/GitHub/Segmentation/FETCH/fetch_dti_prequal_lumc/${INSUBJ}/PreQual/output/PREPROCESSED
    export ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${INSUBJ}
    #export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
    export tract_l=/Users/oliviamurray/Documents/FETCH/xtract_output_lumc/xtract_output_lumc/${INSUBJ}/xtract/tracts/cst_l
    export tract_r=/Users/oliviamurray/Documents/FETCH/xtract_output_lumc/xtract_output_lumc/${INSUBJ}/xtract/tracts/cst_r
    if [ ! -d /Users/oliviamurray/Documents/FETCH/xtract_output_lumc/xtract_output_lumc/${INSUBJ}/xtract/xfms ]; then

        mkdir -p /Users/oliviamurray/Documents/FETCH/xtract_output_lumc/xtract_output_lumc/${INSUBJ}/xtract/xfms
    fi
    export xfms_dir=/Users/oliviamurray/Documents/FETCH/xtract_output_lumc/xtract_output_lumc/${INSUBJ}/xtract/xfms

    flirt -in ${prequal_dir}/dwmri.nii.gz -ref ${ct_dir}/CT_0000.nii.gz -out ${xfms_dir}/DTItoCT -omat ${xfms_dir}/DTItoCT.mat -bins 256 -cost normmi -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
    echo registered DTI to CT

    flirt -in ${tract_l}/densityNorm.nii.gz -ref ${ct_dir}/CT_0000.nii.gz -out ${tract}/densityNormCTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
    echo registered left tract
    flirt -in ${tract_r}/densityNorm.nii.gz -ref ${ct_dir}/CT_0000.nii.gz -out ${tract}/densityNormCTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
    echo registered right tract
done