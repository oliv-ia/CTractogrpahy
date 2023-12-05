#!/bin/bash






export t1_dir="/Users/oliviamurray/Documents/FETCH/t1_lumc"
cd ${t1_dir}
for patient in *
do
    bet ${t1_dir}/$patient/${patient}_3D_T1.nii.gz ${t1_dir}/$patient/${patient}_3D_T1_bet.nii.gz -R
    fast -t 1 ${t1_dir}/$patient/${patient}_3D_T1_bet.nii.gz

done
