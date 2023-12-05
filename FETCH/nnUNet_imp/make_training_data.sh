#!/bin/bash
export centre=umcu
cd /Users/oliviamurray/Documents/FETCH/selected_ct_${centre}
for patient in *
do  
    export INSUBJ=$patient
    
    export bedpost_dir=Users/oliviamurray/Documents/PhD/GitHub/Segmentation/FETCH/fetch_umcu_2_bedpostx
    export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
    export xtract_dir=${bedpost_subject_dir}/xtract
    export tract_dir=${xtract_dir}/tracts
    export xfms_dir=${bedpost_subject_dir}/xfms
    export ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_${centre}/${INSUBJ}
    export training_dir=/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet/nnUNet_raw/Dataset600_CST/imagesTr
    export training_l_dir=/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet/nnUNet_raw/Dataset600_CST/labelsTr
    #echo ${tract_dir}/cst_l
    if [ -f ${tract_dir}/cst_l/densityNormCTspace.nii.gz ]

        then
        echo ${patient} there
            
        fslmaths ${tract_dir}/cst_l/densityNormCTspace.nii.gz -add ${tract_dir}/cst_r/densityNormCTspace.nii.gz ${training_l_dir}/${INSUBJ}_${centre}.nii.gz
        cp ${ct_dir}/ct_scan.nii.gz ${training_dir}/${INSUBJ}_${centre}_0000.nii.gz

        else
        echo ${patient} not there

    fi

done