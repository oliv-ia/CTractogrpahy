#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4
#$ -t 1-28
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.4


#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/radboud_ids.txt
file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_t1_prequal/fetch_ID.txt 
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ
export bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx
export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX
export xtract_dir=${bedpost_subject_dir}/xtract
export tract_dir=${xtract_dir}/tracts
export xfms_dir=${bedpost_subject_dir}/xfms
export ct_dir=/mnt/iusers01/ct01/p09383om/scratch/selected_ct_lumc/${INSUBJ}

 
cd ${tract_dir}
for tract in *
do 
    flirt -in ${tract}/densityNorm.nii.gz -ref ${ct_dir}/ct_scan.nii.gz -out ${tract}/densityNormCTspace.nii.gz -init ${xfms_dir}/DTItoCT.mat -applyxfm
done