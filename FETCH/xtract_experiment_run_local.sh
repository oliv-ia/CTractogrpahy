#!/bin/bash 


export patient=2-18-002
export t1_dir=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/2-18-002_3D_T1.nii.gz
export t1_bet_dir=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/2-18-002_3D_T1_bet.nii.gz
export dti_dir=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002.bedpostX/nodif_brain.nii.gz
export transforms_dir=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002.bedpostX/xfms
bedpost_dir=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002.bedpostX
mkdir -p /Users/oliviamurray/Documents/FETCH/xtract_experiment/outputs


#xtract -bpx ${bedpost_dir} -out /Users/oliviamurray/Documents/FETCH/xtract_experiment/outputs -species CUSTOM -p /Users/oliviamurray/Documents/FETCH/protocol -str /Users/oliviamurray/Documents/FETCH/protocol/structureslist.txt -stdref $FSLDIR/data/standard/MNI152_T1_2mm_brain -stdwarp ${bedpost_dir}/xfms/standard2diff_warp.nii.gz ${bedpost_dir}/xfms/diff2standard_warp.nii.gz 
#applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${bedpost_dir}/nodif_brain.nii.gz  --warp=${bedpost_dir}/xfms/diff2standard_warp.nii.gz  --premat=${bedpost_dir}/xfms/diff2standard.mat  --out=${bedpost_dir}/dif_in_standard.nii.gz
#applywarp --ref=${bedpost_dir}/nodif_brain.nii.gz --in=${FSLDIR}/data/standard/MNI152_T1_2mm --warp=${bedpost_dir}/xfms/standard2diff_warp.nii.gz --premat=${bedpost_dir}/xfms/standard2diff.mat --out=/Users/oliviamurray/Documents/FETCH/protocol/cst_r/mni_in_diff.nii.gz


#bet ${t1_dir} ${t1_bet_dir} 
#flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -in ${t1_bet_dir} -omat ${transforms_dir}/my_affine_transf.mat
#fnirt --in=${t1_dir} --aff=${transforms_dir}/my_affine_transf.mat --cout=${transforms_dir}/t12mni.nii.gz --config=T1_2_MNI152_2mm
#flirt -ref ${dti_dir} -in ${t1_dir}  -omat ${transforms_dir}/dti2t1.mat
#epi_reg  --epi=${dti_dir} --t1=${t1_dir} --t1brain=${t1_bet_dir} --out=${transforms_dir}/dti2t1_epi

#convertwarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --premat=${transforms_dir}/dti2t1.mat --warp1=${transforms_dir}/t12mni.nii.gz --out=${transforms_dir}/dti2mni.nii.gz
#convertwarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --premat=${transforms_dir}/dti2t1_epi.mat --warp1=${transforms_dir}/t12mni.nii.gz --out=${transforms_dir}/dti2mni_epi.nii.gz
#invwarp --warp=${transforms_dir}/dti2mni.nii.gz --ref=${dti_dir} --out=${transforms_dir}/mni2dti.nii.gz
#invwarp --warp=${transforms_dir}/dti2mni_epi.nii.gz --ref=${dti_dir} --out=${transforms_dir}/mni2dti_epi.nii.gz
#applywarp --ref=${dti_dir} --in=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --warp=${transforms_dir}/mni2dti.nii.gz --out=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/mni_in_dif_space.nii.gz
#applywarp --ref=${dti_dir} --in=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --warp=${transforms_dir}/mni2dti_epi.nii.gz --out=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/mni_in_dif_space_epi.nii.gz
xtract -bpx ${bedpost_dir} -out /Users/oliviamurray/Documents/FETCH/xtract_experiment/outputs -species CUSTOM -p /Users/oliviamurray/Documents/FETCH/protocol -str /Users/oliviamurray/Documents/FETCH/protocol/structureslist.txt -stdref $FSLDIR/data/standard/MNI152_T1_2mm_brain -stdwarp ${bedpost_dir}/xfms/mni2dti_epi.nii.gz ${bedpost_dir}/xfms/dti2mni_epi.nii.gz -native