#!/bin/bash --login
#$ -cwd
#$ -pe smp.pe 4
#$ -t 1-36 #1-28    

# export OMP_NUM_THREADS=1

export prequal_code_dir=/mnt/bmh01-rds/Hamied_Haroon_doc/tools/PreQual/

export data_scratch_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_dti_prequal_umcu_2_final


file=${data_scratch_dir}/umcu_2_ids.txt
INSUBJ=$(awk "NR==$SGE_TASK_ID"  $file)
echo $INSUBJ

export dwi_dir=${data_scratch_dir}/${INSUBJ}
export t1_dir=${data_scratch_dir}/${INSUBJ}

mkdir -p ${data_scratch_dir}/${INSUBJ}/PreQual
export prequal_output_dir=${data_scratch_dir}/${INSUBJ}/PreQual
mkdir -p ${prequal_output_dir}/output
mkdir -p ${prequal_output_dir}/tmp

cd ${prequal_output_dir}



#DTI64_b=${dwi_dir}/DICOM__DTI_high_iso45dir_noDynStab.nii.gz
#if test -f "$DTI64_b"; then
#    cp ${dwi_dir}/DICOM__DTI_high_iso45dir_noDynStab.nii.gz   	${prequal_output_dir}/dti1.nii.gz
#    # cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.json     	${prequal_output_dir}/dti1.json
#    cp ${dwi_dir}/DICOM__DTI_high_iso45dir_noDynStab.bval	${prequal_output_dir}/dti1.bval
#    cp ${dwi_dir}/DICOM__DTI_high_iso45dir_noDynStab.bvec	${prequal_output_dir}/dti1.bvec
#    printf "dti1,-,0.01\n" > dtiQA_config.csv
#fi
DTI64=${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.nii.gz
if test -f "$DTI64"
    then
        cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.nii.gz   	${prequal_output_dir}/dti1.nii.gz
        # cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.json     	${prequal_output_dir}/dti1.json
        cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.bval	${prequal_output_dir}/dti1.bval
        cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.bvec	${prequal_output_dir}/dti1.bvec
        printf "dti1,-,0.01\n" > dtiQA_config.csv
    else
         cp ${dwi_dir}/${INSUBJ}_Reg_-_WIP_DTI_high_iso45dir_noDynStab_SENSE.nii.gz   	${prequal_output_dir}/dti1.nii.gz
        # cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.json     	${prequal_output_dir}/dti1.json
        cp ${dwi_dir}/${INSUBJ}_Reg_-_WIP_DTI_high_iso45dir_noDynStab_SENSE.bval	${prequal_output_dir}/dti1.bval
        cp ${dwi_dir}/${INSUBJ}_Reg_-_WIP_DTI_high_iso45dir_noDynStab_SENSE.bvec	${prequal_output_dir}/dti1.bvec
        printf "dti1,-,0.01\n" > dtiQA_config.csv
     
fi

#DTI30=${dwi_dir}/${INSUBJ}_ep_b0_ep2d_MDDW30_DTI_iso.nii.gz
#if test -f "$DTI64"; then
#    cp ${dwi_dir}/${INSUBJ}_ep_b0_ep2d_MDDW30_DTI_iso.nii.gz   	${prequal_output_dir}/dti1.nii.gz
#     cp ${dwi_dir}/${INSUBJ}_DTI_high_iso45dir_noDynStab.json     	${prequal_output_dir}/dti1.json
#    cp ${dwi_dir}/${INSUBJ}_ep_b0_ep2d_MDDW30_DTI_iso.bval	${prequal_output_dir}/dti1.bval
#    cp ${dwi_dir}/${INSUBJ}_ep_b0_ep2d_MDDW30_DTI_iso.bvec	${prequal_output_dir}/dti1.bvec
#    printf "dti1,-,0.0990603\n" > dtiQA_config.csv
#fi

T1=${t1_dir}/DICOM_s_T1W_3D_TFE.nii.gz
if test -f "$T1"
 then
    cp ${t1_dir}/DICOM_s_T1W_3D_TFE.nii.gz	${prequal_output_dir}/t1.nii.gz
 else  
    T1W=${t1_dir}/${INSUBJ}_s_T1W_3D_TFE.nii.gz
    cp ${t1_dir}/${INSUBJ}_s_T1W_3D_TFE.nii.gz	${prequal_output_dir}/t1.nii.gz
fi



# https://github.com/MASILab/PreQual
# module load apps/gcc/singularity/2.6.0

module load apps/binapps/freesurfer/7.1.1
singularity run \
-e \
--contain \
-B ${prequal_output_dir}:/INPUTS \
-B ${prequal_output_dir}/output:/OUTPUTS \
-B ${prequal_output_dir}/tmp:/tmp \
-B ${prequal_code_dir}/src/APPS/freesurfer/license.txt:/APPS/freesurfer/license.txt \
${prequal_code_dir}/prequal_105_modified.simg \
j \
--num_threads 4 \
--topup_first_b0s_only

