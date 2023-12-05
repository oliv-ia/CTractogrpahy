#!/bin/bash 

export t1_dir=/Users/oliviamurray/Documents/FETCH/t1_lumc
export ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_lumc


cd /Users/oliviamurray/Documents/FETCH/t1_lumc
for patient in *

do 
    export INSUBJ=$patient
    export t1_patient_dir=${t1_dir}/${INSUBJ}
    echo ${t1_patient_dir}
    export xfms_dir=${t1_patient_dir}/xfms
    export ct_patient_dir=${ct_dir}/${INSUBJ}
    flirt -in ${t1_patient_dir}/${INSUBJ}_3D_T1_bet_seg.nii.gz -ref ${ct_patient_dir}/CT.nii.gz -out ${t1_patient_dir}/bet_seg_CTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
done