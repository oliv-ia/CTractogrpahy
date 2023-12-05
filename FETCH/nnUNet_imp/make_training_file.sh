#!/bin/bash --login
#$ -cwd

#$ -t 1-28
export OMP_NUM_THREADS=1
module load apps/binapps/fsl/6.0.4


#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/radboud_ids.txt
file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_t1_prequal/fetch_ID.txt 
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ

# run on login node 
# script to make file of paired training data and labels 
# and add both sides of cst 
export bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx
export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
export xtract_dir=${bedpost_subject_dir}/xtract
export tract_dir=${xtract_dir}/tracts
export xfms_dir=${bedpost_subject_dir}/xfms
export ct_dir=/mnt/iusers01/ct01/p09383om/scratch/selected_ct_lumc/${INSUBJ}
export training_dir=/mnt/iusers01/ct01/p09383om/scratch/ct_cst_training_data


fslmaths ${tract_dir}/cst_l/densityNormCTspace.nii.gz -add ${tract_dir}/cst_r/densityNormCTspace.nii.gz ${training_dir}/${INSUBJ}_lumc_cst.nii.gz
cp ${ct_dir}/ct_scan.nii.gz ${training_dir}/${INSUBJ}_lumc_CT.nii.gz