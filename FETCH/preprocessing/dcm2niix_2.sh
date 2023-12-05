#!/bin/bash
# script to iterate through fetch dataset and create new folder in which to store nifti conversions, preserving patient file structure 

cd /Users/oliviamurray/Documents/FETCH/3T_UMCU_2
for patient in *
do 
    
  
    export patient_id=$patient
  
    #mkdir -p /Users/oliviamurray/Documents/FETCH/dti_umcu_3_nifti_c/${patient_id}
    #cd /Users/oliviamurray/Documents/FETCH/3T_UMCU_2/${patient_id}/
    #for id in *
    #do
    #    export ids=$id
    echo ${patient_id}
    #/Users/oliviamurray/Downloads/dcm2niix -f "%f_%z_%d" -p y -z y -m y  -o /Users/oliviamurray/Documents/FETCH/dti_umcu_3_nifti_c/${patient_id}  /Users/oliviamurray/Documents/FETCH/3T_UMCU_3/${patient_id}/
    #done
done