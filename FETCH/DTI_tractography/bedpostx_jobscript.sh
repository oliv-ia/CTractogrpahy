#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4
#$ -t 1 #1-28    

# export OMP_NUM_THREADS=1

module load apps/binapps/fsl/6.0.4 

export data_prequal_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc


file=${data_prequal_dir}/lumc_ids_2.txt
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ

export bedpost_patient_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx/${INSUBJ}
cp ${bedpost_patient_dir}/dwmri.bval ${bedpost_patient_dir}/bvals
cp ${bedpost_patient_dir}/dwmri.bvec ${bedpost_patient_dir}/bvecs
cp ${bedpost_patient_dir}/mask.nii.gz ${bedpost_patient_dir}/nodif_brain_mask.nii.gz
cp ${bedpost_patient_dir}/dwmri.nii.gz ${bedpost_patient_dir}/data.nii.gz

bedpostx ${bedpost_patient_dir} -n 1 -w 1 -b 1000 -c

export bedpost_subject_dir=${bedpost_patient_dir}.bedpostX

flirt -in $bedpost_subject_dir/nodif_brain_mask.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -omat $bedpost_subject_dir/xfms/diff2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12
convert_xfm -omat $bedpost_subject_dir/xfms/standard2diff.mat -inverse $bedpost_subject_dir/xfms/diff2standard.mat

convertwarp -r $FSLDIR/data/standard/MNI152_T1_2mm_brain -m $bedpost_subject_dir/xfms/diff2standard.mat -o $bedpost_subject_dir/xfms/diff2standard.nii.gz
invwarp --ref=$bedpost_subject_dir/nodif_brain_mask.nii.gz --warp=$bedpost_subject_dir/xfms/diff2standard.nii.gz --out=$bedpost_subject_dir/xfms/standard2diff.nii.gz

mkdir -p ${bedpost_subject_dir}/xtract
export outdir=${bedpost_subject_dir}/xtract


xtract -bpx ${bedpost_subject_dir} -out ${outdir} -species HUMAN -stdwarp ${bedpost_subject_dir}/xfms/standard2diff.nii.gz ${bedpost_subject_dir}/xfms/diff2standard.nii.gz -native
