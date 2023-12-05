#!/bin/bash --login
#$ -pe smp.pe 8
#$ -cwd    
                                                ## SGE flag: Run this job 
                                                              #in the current working directory (cwd)
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.5			     ## loads FSL module 

# making bedpostx dir


                                                             ## Assign full path of your data directory to bash variable "datadir"

export subjectsfile=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final/umcu_2_ids.txt              ## Assign full path and name of your subjects list file to bash 
                                                              # variable "subjectsfile"

export subjectsno=$(grep -c . $subjectsfile)                 ## Compute number of lines in "subjectsfile" and assign to bash
                                                              # variable "subjectsno", which is equivalent to number of subjects 

echo There are ${subjectsno} subjects listed in ${subjectsfile}
                                                             ## Print to output log

#$ -t 1-36                                               ## SGE flag: Run as a jobarray with "tasks" (t) running
                                                              # sequentially from 1 to "subjectsno" (currently 1, which 
                                                              # needs to be manually entered here)

export subjectid=`awk "NR==$SGE_TASK_ID" ${subjectsfile}`    ## Read nth line in "subjectsfile", where n is the current task number,
                                                              # and assign to bash variable "subjectid" 

echo Running on subject ${subjectid}, which is jobarray task $SGE_TASK_ID of $SGE_TASK_LAST

# making bedpostx dir


mkdir -p /mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_2_bedpostx/${subjectid}

export bedpostx_dir_make=/mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_2_bedpostx/${subjectid}
cp  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final/${subjectid}/PreQual/output/PREPROCESSED/dwmri.bval  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final/${subjectid}/PreQual/output/PREPROCESSED/dwmri.bvec  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final/${subjectid}/PreQual/output/PREPROCESSED/dwmri.nii.gz  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final/${subjectid}/PreQual/output/PREPROCESSED/mask.nii.gz /mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_2_bedpostx/${subjectid}
cp ${bedpostx_dir_make}/dwmri.bval ${bedpostx_dir_make}/bvals
cp ${bedpostx_dir_make}/dwmri.bvec ${bedpostx_dir_make}/bvecs
cp ${bedpostx_dir_make}/dwmri.nii.gz ${bedpostx_dir_make}/data.nii.gz
cp ${bedpostx_dir_make}/mask.nii.gz ${bedpostx_dir_make}/nodif_brain_mask.nii.gz
export datadir=/mnt/iusers01/ct01/p09383om/scratch/fetch_umcu_2_bedpostx
export subjectdir=${datadir}/${subjectid}
export subjectdwidir=${datadir}/${subjectid}
export bedpostx_dir=${datadir}/${subjectid}

                                  ## Make the "bedpostx_dir"

export subjectpqdir=${bedpostx_dir}     ## 

cp ${subjectpqdir}/dwmri.bval ${bedpostx_dir}/bvals			    ## move and rename bval file to bedpostx_dir
cp ${subjectpqdir}/dwmri.bvec ${bedpostx_dir}/bvecs                         ## move and rename bvec file to bedpostx_dir
cp ${subjectpqdir}/mask.nii.gz ${bedpostx_dir}/nodif_brain_mask.nii.gz		    ## move and remanme brainmask.mgz file to bedpostx_dir
cp ${subjectpqdir}/dwmri.nii.gz ${bedpostx_dir}/data.nii.gz		    ## move and reame dwmri.nii.gz file to bedpostx_dir

cd ${bedpostx_dir}

bedpostx ${bedpostx_dir} 

#export bedpost_subject_dir=${bedpostx_dir}.bedpostX
#flirt -in $bedpost_subject_dir/nodif_brain_mask.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -omat $bedpost_subject_dir/xfms/diff2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12
#convert_xfm -omat $bedpost_subject_dir/xfms/standard2diff.mat -inverse $bedpost_subject_dir/xfms/diff2standard.mat

#convertwarp -r $FSLDIR/data/standard/MNI152_T1_2mm_brain -m $bedpost_subject_dir/xfms/diff2standard.mat -o $bedpost_subject_dir/xfms/diff2standard.nii.gz
#invwarp --ref=$bedpost_subject_dir/nodif_brain_mask.nii.gz --warp=$bedpost_subject_dir/xfms/diff2standard.nii.gz --out=$bedpost_subject_dir/xfms/standard2diff.nii.gz

#mkdir -p ${bedpost_subject_dir}/xtract
#export outdir=${bedpost_subject_dir}/xtract


#xtract -bpx ${bedpost_subject_dir} -out ${outdir} -species HUMAN -stdwarp ${bedpost_subject_dir}/xfms/standard2diff.nii.gz ${bedpost_subject_dir}/xfms/diff2standard.nii.gz -native