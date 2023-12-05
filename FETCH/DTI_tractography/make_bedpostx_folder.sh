
#!/bin/bash --login
#$ -pe smp.pe 8
#$ -cwd    
                                                ## SGE flag: Run this job 
                                                              #in the current working directory (cwd)
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.5	

cd /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc
for patient in *
do 
    
    echo $patient
    export patient_id=$patient
  
    mkdir -p /mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/${patient_id}

    export bedpostx_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/${patient_id}
    cp  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc/${patient_id}/PreQual/output/PREPROCESSED/dwmri.bval  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc/${patient_id}/PreQual/output/PREPROCESSED/dwmri.bvec  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc/${patient_id}/PreQual/output/PREPROCESSED/dwmri.nii.gz  /mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc/${patient_id}/PreQual/output/PREPROCESSED/mask.nii.gz /mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/${patient_id}
    cp ${bedpostx_dir}/dwmri.bval ${bedpostx_dir}/bvals
    cp ${bedpostx_dir}/dwmri.bvec ${bedpostx_dir}/bvecs
    cp ${bedpostx_dir}/dwmri.nii.gz ${bedpostx_dir}/data.nii.gz
    cp ${bedpostx_dir}/mask.nii.gz ${bedpostx_dir}/nodif_brain_mask.nii.gz
done

export subjectsfile=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_lumc/lumc_ids_2.txt 
export subjectsno=$(grep -c . $subjectsfile)                 ## Compute number of lines in "subjectsfile" and assign to bash
                                                              # variable "subjectsno", which is equivalent to number of subjects 

echo There are ${subjectsno} subjects listed in ${subjectsfile}
                                                             ## Print to output log

#$ -t 1-43                                                ## SGE flag: Run as a jobarray with "tasks" (t) running
                                                              # sequentially from 1 to "subjectsno" (currently 1, which 
                                                              # needs to be manually entered here)

export subjectid=`awk "NR==$SGE_TASK_ID" ${subjectsfile}` 