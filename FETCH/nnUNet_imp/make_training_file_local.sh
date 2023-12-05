#!/bin/bash
#mkdir -p /Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/labelsTr
#mkdir -p /Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/imagesTr
training_dir=/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/labelsTr

for patient in /Users/oliviamurray/Documents/FETCH/xtract_output_radboudumc/xtract_output_radboudumc/*; do
export INSUBJ=$patient
INSUBJ=$( basename $patient )
ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_radboudumc/$INSUBJ
echo $INSUBJ
tract_dir=$patient/xtract/tracts
fslmaths ${tract_dir}/cst_l/densityNormCTspace.nii.gz -add ${tract_dir}/cst_r/densityNormCTspace.nii.gz ${training_dir}/${INSUBJ}_radboudumc.nii.gz
if [ -f ${tract_dir}/cst_l/densityNormCTspace.nii.gz ]; then
    if [ -f $ct_dir/ct_scan.nii.gz ]; then
        cp ${ct_dir}/ct_scan.nii.gz /Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/imagesTr/${INSUBJ}_radboudumc_0000.nii.gz
    fi
fi
done