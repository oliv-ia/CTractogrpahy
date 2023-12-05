import os
import numpy as np
import shutil
niftidir = "/Users/oliviamurray/Documents/FETCH/dti_umcu_2_nifti_c"
dtidir = "/Users/oliviamurray/Documents/FETCH/fetch_dti_prequal_umcu_2_final"
import pathlib

paths = os.listdir(niftidir)
for patient in paths:
    
    
    if patient != ".DS_Store":
        
     
        patient_path = os.path.join(niftidir,patient)
        dti_path = os.path.join(dtidir, patient)
        scans = os.listdir(patient_path)
        for scan in scans:
            """
            string = "MDDW30_DTI"
            #if pathlib.Path(scan).stem == string:
            if string in scan:
                print("scan",scan ,"string: ", string,"stem: ", pathlib.Path(scan).stem)
                scan_path = os.path.join(patient_path,scan)
                print(dti_path)
                print(scan_path)
                shutil.copy2(scan_path, dti_path)
                print(patient, " copied")
            """
            
        
        
            if "_s_T1W_3D_TFE." in scan or "_DTI_high_iso45dir_noDynStab" in scan:
                
                scan_path = os.path.join(patient_path,scan)
                
                shutil.copy2(scan_path, dti_path)
            else:
                print(patient, " not in list")

            


             
   