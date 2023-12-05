#!/bin/bash
# script to iterate through fetch dataset and create new folder in which to store nifti conversions, preserving patient file structure 
export datadir=/Users/oliviamurray/Documents/FETCH/fetch_copy/3T_LUMC/
cd /Users/oliviamurray/Documents/FETCH/CT_Radboudumc_4
export niftidir=/Users/oliviamurray/Documents/FETCH/fetch_dti_t1_prequal/
for patient in *
do 
    #cd /Users/oliviamurray/Documents/test/
  
    export patient_id=$patient
  
    mkdir -p /Users/oliviamurray/Documents/FETCH/selected_ct_radboudumc_4/${patient_id}
    #cd /Users/oliviamurray/Documents/FETCH/3T_UMCU_2/${patient_id}/
    #for id in *
    #do
    #    export ids=$id

    /Users/oliviamurray/Downloads/dcm2niix -f "%f_%z_%d" -p y -z y -m y  -o /Users/oliviamurray/Documents/FETCH/selected_ct_radboudumc_4/${patient_id}  /Users/oliviamurray/Documents/FETCH/CT_Radboudumc_4/${patient_id}/
    #done
done
