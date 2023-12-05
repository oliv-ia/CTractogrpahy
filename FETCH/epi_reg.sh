#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 8
#$ -l nvidia_v100=1
#$ -t 1-41
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.4
export SGE_ROOT=''
export bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx_october/fetch_radboudumc_bedpostx
#file=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/radboud_ids.txt
file=/mnt/iusers01/ct01/p09383om/scratch/fetch_radboudumc_bedpostx_october/radboudumc_ids.txt
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ

export bedpost_subject_dir=${bedpost_dir}/${INSUBJ}.bedpostX

#export prequal_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_radboudumc/${INSUBJ}/PreQual
#export t1_dir=${prequal_dir}/t1.nii.gz
export t1_dir=${bedpost_dir}/${INSUBJ}/t1.nii.gz

export dti_dir=${bedpost_dir}/${INSUBJ}/dwmri.nii.gz

#mkdir -p ${bedpost_subject_dir}/xfms

export transforms_dir=${bedpost_subject_dir}/xfms

mkdir -p xtract_output_radboudumc/${INSUBJ}/xtract
export xtract_output=xtract_output_radboudumc/${INSUBJ}/xtract
#flirt -in $bedpost_subject_dir/nodif_brain_mask.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -omat $bedpost_subject_dir/xfms/diff2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12
#convert_xfm -omat $bedpost_subject_dir/xfms/standard2diff.mat -inverse $bedpost_subject_dir/xfms/diff2standard.mat

#convertwarp -r $FSLDIR/data/standard/MNI152_T1_2mm_brain -m $bedpost_subject_dir/xfms/diff2standard.mat -o $bedpost_subject_dir/xfms/diff2standard.nii.gz
#
#invwarp --ref=$bedpost_subject_dir/nodif_brain_mask.nii.gz --warp=$bedpost_subject_dir/xfms/diff2standard.nii.gz --out=$bedpost_subject_dir/xfms/standard2diff.nii.gz
bet ${t1_dir} ${bedpost_dir}/${INSUBJ}/t1_bet.nii.gz
export t1_bet_dir=${bedpost_dir}/${INSUBJ}/t1_bet.nii.gz

flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -in ${t1_bet_dir} -omat ${transforms_dir}/my_affine_transf.mat
fnirt --in=${t1_dir} --aff=${transforms_dir}/my_affine_transf.mat --cout=${transforms_dir}/t12mni.nii.gz --config=T1_2_MNI152_2mm
epi_reg  --epi=${dti_dir} --t1=${t1_dir} --t1brain=${t1_bet_dir} --out=${transforms_dir}/dti2t1_epi
#epi_reg  --epi=${bedpost_subject_dir} --t1=${t1_dir} --t1brain=${t1_bet_dir} --out=${transforms_dir}/dti2t1_epi
#convertwarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --premat=${transforms_dir}/dti2t1.mat --warp1=${transforms_dir}/t12mni.nii.gz --out=${transforms_dir}/dti2mni.nii.gz
convertwarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --premat=${transforms_dir}/dti2t1_epi.mat --warp1=${transforms_dir}/t12mni.nii.gz --out=${transforms_dir}/dti2mni_epi.nii.gz
#invwarp --warp=${transforms_dir}/dti2mni.nii.gz --ref=${dti_dir} --out=${transforms_dir}/mni2dti.nii.gz
invwarp --warp=${transforms_dir}/dti2mni_epi.nii.gz --ref=${dti_dir} --out=${transforms_dir}/mni2dti_epi.nii.gz
#applywarp --ref=${dti_dir} --in=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --warp=${transforms_dir}/mni2dti.nii.gz --out=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/mni_in_dif_space.nii.gz
#applywarp --ref=${dti_dir} --in=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --warp=${transforms_dir}/mni2dti_epi.nii.gz --out=/Users/oliviamurray/Documents/FETCH/xtract_experiment/2-18-002/mni_in_dif_space_epi.nii.gz
xtract -bpx ${bedpost_subject_dir} -out ${xtract_output} -species HUMAN -stdwarp ${bedpost_subject_dir}/xfms/mni2dti_epi.nii.gz ${bedpost_subject_dir}/xfms/dti2mni_epi.nii.gz -native -gpu