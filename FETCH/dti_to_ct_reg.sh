#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4
#$ -t 1-41
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.4


#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/radboud_ids.txt
file=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx_october/radboudumc_ids.txt 
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ
export bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx_october/fetch_radboudumc_bedpostx
export prequal_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx_october/fetch_radboudumc_bedpostx/${INSUBJ}
export ct_dir=/mnt/iusers01/ct01/p09383om/scratch/selected_ct_radboudumc/${INSUBJ}
export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
export tract_l=/mnt/iusers01/ct01/p09383om/scratch/xtract_output_radboudumc/$INSUBJ/xtract/tracts/cst_l
export tract_r=/mnt/iusers01/ct01/p09383om/scratch/xtract_output_radboudumc/$INSUBJ/xtract/tracts/cst_r

flirt -in ${prequal_dir}/dwmri.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${bedpost_subject_dir}/xfms/DTItoCT -omat ${bedpost_subject_dir}/xfms/DTItoCT.mat -bins 256 -cost normmi -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in ${tract_l}/densityNorm.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${tract_l}/densityNormCTspace.nii.gz -init ${bedpost_subject_dir}/xfms/DTItoCT.mat -applyxfm
flirt -in ${tract_r}/densityNorm.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${tract_r}/densityNormCTspace.nii.gz -init ${bedpost_subject_dir}/xfms/DTItoCT.mat -applyxfm
#bet ${CT_dir}/ct_scan.nii.gz ${bedpost_dir}/${INSUBJ}/CT_bet.nii.gz
#export CT_bet_dir=${bedpost_dir}/${INSUBJ}/CT_bet.nii.gz

#flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -in ${t1_bet_dir} -omat ${transforms_dir}/my_affine_transf.mat
#fnirt --in=${t1_dir} --aff=${transforms_dir}/my_affine_transf.mat --cout=${transforms_dir}/t12mni.nii.gz --config=T1_2_MNI152_2mm
#epi_reg  --epi=${prequal_dir}/dwmri.nii.gz --t1=${t1_dir} --t1brain=${t1_bet_dir} --out=${transforms_dir}/dti2t1_epi