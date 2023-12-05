#!/bin/bash 
cd /Users/oliviamurray/Documents/FETCH/selected_ct_lumc
for patient in *
do 
    #cd /Users/oliviamurray/Documents/test/
    export INSUBJ=$patient
    
    export t1_dir=/Users/oliviamurray/Documents/FETCH/t1_lumc/${INSUBJ}
    export ct_dir=/Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${INSUBJ}
    mkdir -p ${t1_dir}/xfms


    flirt -in ${t1_dir}/${INSUBJ}_3D_T1.nii.gz -ref ${ct_dir}/CT.nii.gz -out ${t1_dir}/xfms/DTItoCT -omat ${t1_dir}/xfms/DTItoCT.mat -bins 256 -cost normmi -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
done