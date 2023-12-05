#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4
#$ -t 1-12 #1-28
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.5
export bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_bedpostx

#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/radboud_ids.txt
file=/mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_bedpostx/umcu_redo_ids.txt 
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ

export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX

mkdir -p ${bedpost_subject_dir}/xtract
export outdir=${bedpost_subject_dir}/xtract


xtract -bpx ${bedpost_subject_dir} -out ${outdir} -species HUMAN -stdwarp ${bedpost_subject_dir}/xfms/standard2diff.nii.gz ${bedpost_subject_dir}/xfms/diff2standard.nii.gz -native